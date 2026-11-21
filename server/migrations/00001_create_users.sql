-- +goose Up
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL,
    name TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT users_email_key UNIQUE(email),
    CONSTRAINT users_email_normalized CHECK(email = lower(btrim(email))),
    CONSTRAINT users_email_length CHECK(char_length(email) BETWEEN 3 AND 254)
);

-- +goose Down
DROP TABLE users;
