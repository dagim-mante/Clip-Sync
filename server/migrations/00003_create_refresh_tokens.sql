-- +goose Up
CREATE TABLE refresh_tokens (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id  uuid        NOT NULL,
    token_hash bytea       NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    expires_at timestamptz NOT NULL,
    revoked_at timestamptz,

    CONSTRAINT refresh_token_hash_length CHECK(octet_length(token_hash) = 32),
    CONSTRAINT refresh_token_device_id_fk
        FOREIGN KEY(device_id, user_id)
        REFERENCES devices(id, user_id) ON DELETE CASCADE
);

-- revoke-all-for-device (reuse detection, logout)
CREATE INDEX refresh_tokens_device_active_idx
    ON refresh_tokens (device_id) WHERE revoked_at IS NULL;
-- cleanup job
CREATE INDEX refresh_tokens_expires_at_idx ON refresh_tokens (expires_at);

-- +goose Down
DROP TABLE refresh_tokens;
