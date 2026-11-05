
from typing import Literal, Optional

import psycopg
from pwdlib import PasswordHash
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field


class UserData(BaseModel):
    username: str
    password: str


class QuestionData(BaseModel):
    title: str
    question_text: str
    code: str
    author_id: int
    study_year: int = Field(ge=1, le=4)
    beroepsrol: str


class VoteData(BaseModel):
    user_id: int = Field(gt=0)
    vote_type: Optional[Literal["up", "down"]]


class RoomReservationData(BaseModel):
    reservation_key: str = Field(min_length=1, max_length=100)
    user_id: int = Field(gt=0)
    title: str = Field(default="Studieruimte.....", max_length=100)
    description: str = Field(default="", max_length=1000)


class RoomReservationUpdateData(RoomReservationData):
    pass


class RoomReservationReleaseData(BaseModel):
    reservation_key: str = Field(min_length=1, max_length=100)
    user_id: int = Field(gt=0)


app = FastAPI()

password_hash = PasswordHash.recommended()


def get_db_connection():
    return psycopg.connect(
        host="localhost",
        port=5432,
        dbname="codeshare",
        user="codeshare",
        password="Cyberjoshua"
    )


def ensure_room_reservations_table(cur):
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS room_reservations (
            reservation_key VARCHAR(100) PRIMARY KEY,
            user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            title VARCHAR(100) NOT NULL DEFAULT 'Studieruimte.....',
            description TEXT NOT NULL DEFAULT '',
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        )
        """
    )
    cur.execute(
        "ALTER TABLE room_reservations ADD COLUMN IF NOT EXISTS description TEXT NOT NULL DEFAULT ''"
    )


@app.get("/")
def home():
    return {"message": "Hello, Code Sharing App!"}


@app.post("/api/test")
def test_api(data: UserData):
    return {"received_username": data.username}


@app.get("/api/db-test")
def test_database():
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT current_database()")
            result = cur.fetchone()

        return {"database": result[0]}
    finally:
        conn.close()


@app.post("/api/register")
def register_user(data: UserData):
    hashed_password = password_hash.hash(data.password)
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO users (username, password_hash)
                VALUES (%s, %s)
                RETURNING id, username
                """,
                (data.username, hashed_password)
            )
            user = cur.fetchone()

        conn.commit()

        return {
            "message": "User registered successfully",
            "id": user[0],
            "username": user[1]
        }

    except psycopg.errors.UniqueViolation:
        conn.rollback()
        raise HTTPException(
            status_code=409,
            detail="Username already exists"
        )
    finally:
        conn.close()


@app.post("/api/login")
def login_user(data: UserData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, username, password_hash
                FROM users
                WHERE username = %s
                """,
                (data.username,)
            )
            user = cur.fetchone()

        if user is None:
            raise HTTPException(
                status_code=401,
                detail="Invalid username or password"
            )

        if not password_hash.verify(data.password, user[2]):
            raise HTTPException(
                status_code=401,
                detail="Invalid username or password"
            )

        return {
            "message": "Login successful",
            "id": user[0],
            "username": user[1]
        }
    finally:
        conn.close()


@app.get("/api/users/{user_id}")
def get_user_profile(user_id: int):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, username, created_at
                FROM users
                WHERE id = %s
                """,
                (user_id,)
            )
            user = cur.fetchone()

        if user is None:
            raise HTTPException(
                status_code=404,
                detail="User not found"
            )

        return {
            "id": user[0],
            "username": user[1],
            "created_at": user[2].isoformat()
        }
    finally:
        conn.close()


@app.get("/api/room-reservations")
def get_room_reservations(user_id: int | None = None):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            ensure_room_reservations_table(cur)
            cur.execute(
                """
                SELECT reservation_key,
                       COALESCE(user_id = %s, FALSE) AS is_mine,
                       title,
                       description
                FROM room_reservations
                """,
                (user_id,)
            )
            rows = cur.fetchall()

        conn.commit()
        return [
            {
                "reservation_key": row[0],
                "is_mine": row[1],
                "title": row[2],
                "description": row[3]
            }
            for row in rows
        ]
    finally:
        conn.close()


@app.post("/api/room-reservations", status_code=201)
def create_room_reservation(data: RoomReservationData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            ensure_room_reservations_table(cur)
            cur.execute("SELECT id FROM users WHERE id = %s", (data.user_id,))
            if cur.fetchone() is None:
                raise HTTPException(status_code=404, detail="User not found")

            cur.execute(
                """
                INSERT INTO room_reservations (reservation_key, user_id, title, description)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (reservation_key) DO NOTHING
                RETURNING reservation_key, title, description
                """,
                (
                    data.reservation_key,
                    data.user_id,
                    data.title.strip() or "Studieruimte.....",
                    data.description.strip()
                )
            )
            reservation = cur.fetchone()

            if reservation is None:
                conn.rollback()
                raise HTTPException(
                    status_code=409,
                    detail="This room has already been reserved."
                )

        conn.commit()
        return {
            "reservation_key": reservation[0],
            "is_mine": True,
            "title": reservation[1],
            "description": reservation[2]
        }
    except HTTPException:
        conn.rollback()
        raise
    finally:
        conn.close()


@app.put("/api/room-reservations")
def update_room_reservation(data: RoomReservationUpdateData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            ensure_room_reservations_table(cur)
            cur.execute(
                """
                UPDATE room_reservations
                SET title = %s, description = %s
                WHERE reservation_key = %s AND user_id = %s
                RETURNING reservation_key, title, description
                """,
                (
                    data.title.strip() or "Studieruimte.....",
                    data.description.strip(),
                    data.reservation_key,
                    data.user_id
                )
            )
            reservation = cur.fetchone()

            if reservation is None:
                cur.execute(
                    "SELECT user_id FROM room_reservations WHERE reservation_key = %s",
                    (data.reservation_key,)
                )
                existing = cur.fetchone()
                if existing is None:
                    raise HTTPException(status_code=404, detail="This room is not reserved.")
                raise HTTPException(
                    status_code=403,
                    detail="Only the user who reserved this room can update it."
                )

        conn.commit()
        return {
            "reservation_key": reservation[0],
            "is_mine": True,
            "title": reservation[1],
            "description": reservation[2]
        }
    except HTTPException:
        conn.rollback()
        raise
    finally:
        conn.close()


@app.delete("/api/room-reservations")
def delete_room_reservation(data: RoomReservationReleaseData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            ensure_room_reservations_table(cur)
            cur.execute(
                """
                DELETE FROM room_reservations
                WHERE reservation_key = %s AND user_id = %s
                RETURNING reservation_key
                """,
                (data.reservation_key, data.user_id)
            )
            deleted = cur.fetchone()

            if deleted is None:
                cur.execute(
                    "SELECT user_id FROM room_reservations WHERE reservation_key = %s",
                    (data.reservation_key,)
                )
                existing = cur.fetchone()
                if existing is None:
                    raise HTTPException(status_code=404, detail="This room is not reserved.")
                raise HTTPException(
                    status_code=403,
                    detail="Only the user who reserved this room can cancel it."
                )

        conn.commit()
        return {"reservation_key": deleted[0], "reserved": False}
    except HTTPException:
        conn.rollback()
        raise
    finally:
        conn.close()


@app.get("/api/questions")
def get_questions(user_id: Optional[int] = None):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT q.id, q.title, q.question_text, q.code, q.author_id,
                       q.study_year, q.beroepsrol, q.created_at,
                       (SELECT COUNT(*) FROM votes v
                        WHERE v.question_id = q.id AND v.vote_type = 'up'),
                       (SELECT COUNT(*) FROM votes v
                        WHERE v.question_id = q.id AND v.vote_type = 'down'),
                       (SELECT v.vote_type FROM votes v
                        WHERE v.question_id = q.id AND v.user_vote = %s)
                FROM questions q
                ORDER BY q.created_at DESC
                """,
                (user_id,)
            )
            rows = cur.fetchall()

        questions = []

        for row in rows:
            questions.append({
                "id": row[0],
                "title": row[1],
                "question_text": row[2],
                "code": row[3],
                "author_id": row[4],
                "study_year": row[5],
                "beroepsrol": row[6],
                "created_at": row[7],
                "upvotes": row[8],
                "downvotes": row[9],
                "user_vote": row[10]
            })

        return questions
    finally:
        conn.close()


@app.post("/api/questions/{question_id}/vote")
def vote_on_question(question_id: int, data: VoteData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM users WHERE id = %s", (data.user_id,))
            if cur.fetchone() is None:
                raise HTTPException(status_code=404, detail="User not found")

            cur.execute("SELECT id FROM questions WHERE id = %s", (question_id,))
            if cur.fetchone() is None:
                raise HTTPException(status_code=404, detail="Question not found")

            if data.vote_type is None:
                cur.execute(
                    "DELETE FROM votes WHERE user_vote = %s AND question_id = %s",
                    (data.user_id, question_id)
                )
            else:
                cur.execute(
                    """
                    INSERT INTO votes (user_vote, question_id, vote_type)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (user_vote, question_id)
                    DO UPDATE SET vote_type = EXCLUDED.vote_type
                    """,
                    (data.user_id, question_id, data.vote_type)
                )

            cur.execute(
                """
                SELECT
                    (SELECT COUNT(*) FROM votes
                     WHERE question_id = %s AND vote_type = 'up'),
                    (SELECT COUNT(*) FROM votes
                     WHERE question_id = %s AND vote_type = 'down')
                """,
                (question_id, question_id)
            )
            upvotes, downvotes = cur.fetchone()

        conn.commit()
        return {
            "upvotes": upvotes,
            "downvotes": downvotes,
            "user_vote": data.vote_type
        }
    except HTTPException:
        conn.rollback()
        raise
    except Exception as error:
        conn.rollback()
        print("Error saving question vote:", repr(error))
        raise HTTPException(
            status_code=500,
            detail="Could not save vote."
        )
    finally:
        conn.close()


@app.get("/api/questions/search")
def search_questions(query: str):
    conn = get_db_connection()

    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT question_text, title
            FROM questions
            WHERE question_text ILIKE %s OR title ILIKE %s
            """,
            (f"%{query}%", f"%{query}%")
        )

        results = cur.fetchall()

@app.post("/api/questions")
def create_question(data: QuestionData):
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            # Check whether the author exists.
            cur.execute(
                "SELECT id FROM users WHERE id = %s",
                (data.author_id,)
            )

            if cur.fetchone() is None:
                raise HTTPException(
                    status_code=404,
                    detail="Author not found"
                )

            # Insert the question into the database.
            cur.execute(
                """
                INSERT INTO questions
                    (title, question_text, code, author_id,
                     study_year, beroepsrol)
                VALUES (%s, %s, %s, %s, %s, %s)
                RETURNING id, title, question_text, code,
                          author_id, study_year, beroepsrol, created_at
                """,
                (
                    data.title,
                    data.question_text,
                    data.code,
                    data.author_id,
                    data.study_year,
                    data.beroepsrol
                )
            )

            row = cur.fetchone()

        conn.commit()

        return {
            "id": row[0],
            "title": row[1],
            "question_text": row[2],
            "code": row[3],
            "author_id": row[4],
            "study_year": row[5],
            "beroepsrol": row[6],
            "created_at": row[7]
        }

    except HTTPException:
        conn.rollback()
        raise

    except Exception as error:
        conn.rollback()
        print("Error creating question:", repr(error))
        raise HTTPException(
            status_code=500,
            detail="Could not save question. Check the backend terminal."
        )

    finally:
        conn.close()
