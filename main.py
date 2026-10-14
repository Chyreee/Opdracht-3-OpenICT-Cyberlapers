
import psycopg
from pwdlib import PasswordHash
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

class UserData(BaseModel):
    username: str
    password: str

app = FastAPI()

password_hash = PasswordHash.recommended()

def get_db_connection():
    return psycopg.connect(
        host="localhost",
        port=5432,
        dbname="codeshare",
        user="codeshare",
        password="codeshare_dev"
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
        cur = conn.cursor()
        cur.execute("SELECT current_database()")
        result = cur.fetchone()
        cur.close()

        return {"database": result[0]}
    finally:
        conn.close()

@app.post("/api/register")
def register_user(data: UserData):
    hashed_password = password_hash.hash(data.password)

    conn = get_db_connection()

    try:
        cur = conn.cursor()

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
        cur.close()

        return {
            "message": "User registered successfully",
            "id": user[0],
            "username": user[1]
        }

    except psycopg.errors.UniqueViolation:
        conn.rollback()
        from fastapi import HTTPException
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
        cur = conn.cursor()

        cur.execute(
            """
            SELECT id, username, password_hash
            FROM users
            WHERE username = %s
            """,
            (data.username,)
        )

        user = cur.fetchone()
        cur.close()

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

@app.get("/api/questions")
def get_questions():
    conn = get_db_connection()
    try:
        cur = conn.cursor()

        cur.execute("""
            SELECT id, title, question_text, code, author_id, study_year, beroepsrol, created_at
            FROM questions
            ORDER BY created_at DESC
        """)
        rows = cur.fetchall()
        cur.close()
        questions = []
        for row in rows:
            question = {
                "id": row[0],
                "title": row[1],
                "question_text": row[2],
                "code": row[3],
                "author_id": row[4],
                "study_year": row[5],
                "beroepsrol": row[6],
                "created_at": row[7]
            }
            questions.append(question)
        return questions
    finally:
        conn.close()