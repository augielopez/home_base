-- Create extensions, enums and tables for productivity tracking
-- Run this migration once against the project's database.

-- Enable pgcrypto for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Enums
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'session_status') THEN
        CREATE TYPE session_status AS ENUM ('not_started', 'active', 'completed', 'paused');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'task_type') THEN
        CREATE TYPE task_type AS ENUM ('parent', 'child');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'task_status') THEN
        CREATE TYPE task_status AS ENUM ('not_started', 'active', 'completed', 'skipped');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'task_event_type') THEN
        CREATE TYPE task_event_type AS ENUM (
            'imported', 'started', 'extended', 'completed_early', 'completed_on_time',
            'auto_advanced', 'skipped', 'resumed'
        );
    END IF;
END $$;

-- Table: productivity_day_sessions
CREATE TABLE IF NOT EXISTS productivity_day_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT NULL,
    session_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status session_status NOT NULL DEFAULT 'not_started',
    started_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ,
    active_task_id UUID NULL,
    total_planned_minutes INTEGER NOT NULL DEFAULT 0,
    total_actual_minutes INTEGER NOT NULL DEFAULT 0,
    total_extension_minutes INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_productivity_sessions_user_date ON productivity_day_sessions (user_id, session_date);
CREATE INDEX IF NOT EXISTS idx_productivity_sessions_status ON productivity_day_sessions (status);

-- Table: productivity_tasks
CREATE TABLE IF NOT EXISTS productivity_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES productivity_day_sessions(id) ON DELETE CASCADE,
    parent_task_id UUID NULL REFERENCES productivity_tasks(id) ON DELETE CASCADE,
    task_type task_type NOT NULL DEFAULT 'child',
    title TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    estimated_minutes INTEGER NULL,
    extension_minutes INTEGER NOT NULL DEFAULT 0,
    actual_minutes INTEGER NOT NULL DEFAULT 0,
    started_at TIMESTAMPTZ NULL,
    expected_end_at TIMESTAMPTZ NULL,
    completed_at TIMESTAMPTZ NULL,
    status task_status NOT NULL DEFAULT 'not_started',
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    auto_started BOOLEAN NOT NULL DEFAULT FALSE,
    auto_completed_on_timeout BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_productivity_tasks_session_order ON productivity_tasks (session_id, display_order);
CREATE INDEX IF NOT EXISTS idx_productivity_tasks_parent ON productivity_tasks (parent_task_id);
CREATE INDEX IF NOT EXISTS idx_productivity_tasks_status ON productivity_tasks (status);

-- Table: productivity_task_events
CREATE TABLE IF NOT EXISTS productivity_task_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES productivity_tasks(id) ON DELETE CASCADE,
    session_id UUID NOT NULL REFERENCES productivity_day_sessions(id) ON DELETE CASCADE,
    event_type task_event_type NOT NULL,
    event_minutes INTEGER NULL,
    metadata JSONB NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_task_events_task ON productivity_task_events (task_id);
CREATE INDEX IF NOT EXISTS idx_task_events_session ON productivity_task_events (session_id);
CREATE INDEX IF NOT EXISTS idx_task_events_type ON productivity_task_events (event_type);

-- Trigger helpers: keep updated_at current
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sessions_updated_at
BEFORE UPDATE ON productivity_day_sessions
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER trg_update_tasks_updated_at
BEFORE UPDATE ON productivity_tasks
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

