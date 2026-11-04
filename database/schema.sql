CREATE TABLE users (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE questions (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    question_text TEXT NOT NULL,
    code TEXT NOT NULL,
    author_id INTEGER NOT NULL REFERENCES users(id),
    study_year SMALLINT NOT NULL,
    beroepsrol VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE votes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_vote INTEGER NOT NULL REFERENCES users(id),
    question_id INTEGER NOT NULL REFERENCES questions(id),
    vote_type VARCHAR(4) NOT NULL,
    UNIQUE (user_vote, question_id),
    CHECK (vote_type IN ('up', 'down'))
);

CREATE TABLE room_reservations (
    reservation_key VARCHAR(100) PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL DEFAULT 'Studieruimte.....',
    description TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
