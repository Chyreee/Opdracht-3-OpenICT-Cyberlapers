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
    question_id INTEGER NOT NULL REFERENCES questions(id),
    vote_type VARCHAR(4) NOT NULL,
    UNIQUE (user_vote, question_id),
    CHECK (vote_type IN ('up', 'down'))

);