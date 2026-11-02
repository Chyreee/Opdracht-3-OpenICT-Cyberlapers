
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


@app.get("/api/questions")
def get_questions():
    conn = get_db_connection()

    try:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, title, question_text, code, author_id,
                       study_year, beroepsrol, created_at
                FROM questions
                ORDER BY created_at DESC
                """
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
                "created_at": row[7]
            })

        return questions
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

