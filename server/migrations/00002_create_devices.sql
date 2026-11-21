-- +goose Up
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    platform TEXT NOT NULL DEFAULT 'unknown',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ,
    revoked_at TIMESTAMPTZ,

    CONSTRAINT device_name_length CHECK(char_length(name) BETWEEN 1 AND 100),
    CONSTRAINT devices_id_user_key UNIQUE(id, user_id)
);

CREATE INDEX devices_user_id ON devices(user_id);

-- +goose Down
DROP TABLE devices;
