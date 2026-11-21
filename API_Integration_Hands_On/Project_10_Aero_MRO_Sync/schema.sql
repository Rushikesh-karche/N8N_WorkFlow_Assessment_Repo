-- ==============================================================================
-- Aero-MRO-Sync Relational Database Schema Specification
-- Project Code: N8N-API-AERO-PRJ-10
-- Target Relational Engine: PostgreSQL 14+ (Supabase, Neon, Railway, Docker)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS aviation_mro_events (
  fault_id VARCHAR(64) PRIMARY KEY,
  aircraft_tail_number VARCHAR(16) NOT NULL,
  ata_chapter_code VARCHAR(16) NOT NULL,
  part_serial_number VARCHAR(64) NOT NULL,
  rul_remaining_pct NUMERIC(6, 2) NOT NULL,
  selected_spare_hub VARCHAR(8) NOT NULL,
  hub_distance_km NUMERIC(10, 2) NOT NULL,
  airworthiness_status VARCHAR(32) NOT NULL CHECK (airworthiness_status IN ('AOG_GROUNDED', 'MEL_DEFERRED', 'RELEASED_SERVICE', 'SUP_QUARANTINED')),
  inspector_phone_e164 VARCHAR(20) NOT NULL,
  inspector_email VARCHAR(128) NOT NULL,
  fault_detected_utc TIMESTAMPTZ NOT NULL,
  processed_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS mro_api_telemetry (
  telemetry_id SERIAL PRIMARY KEY,
  fault_id VARCHAR(64) NOT NULL,
  http_method VARCHAR(10) NOT NULL,
  endpoint_path VARCHAR(255) NOT NULL,
  http_status_code INT NOT NULL,
  latency_ms INT NOT NULL,
  failover_used BOOLEAN DEFAULT FALSE,
  recorded_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS mro_dead_letter_queue (
  dlq_id SERIAL PRIMARY KEY,
  fault_id VARCHAR(64),
  error_classification VARCHAR(64) NOT NULL,
  http_status_code INT,
  raw_payload JSONB NOT NULL,
  error_message TEXT NOT NULL,
  retry_attempts INT DEFAULT 0,
  quarantined_at_utc TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mro_tail ON aviation_mro_events (aircraft_tail_number);
CREATE INDEX IF NOT EXISTS idx_mro_dlq_class ON mro_dead_letter_queue (error_classification);
