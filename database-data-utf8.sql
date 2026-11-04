--
-- PostgreSQL database dump
--

\restrict 34dzN5GcBLblc7yLcb3P3XT2NUcQfKnpBAiUIpBWfJ5pGiV5Xu45ESPBHdXdISf

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (id, username, password_hash, created_at) OVERRIDING SYSTEM VALUE VALUES (1, 'testuser', 'temporary_test_hash', '2026-10-12 20:48:59.686801+00');
INSERT INTO public.users (id, username, password_hash, created_at) OVERRIDING SYSTEM VALUE VALUES (2, 'demo_user', '$argon2id$v=19$m=65536,t=3,p=4$f4zgVB0ytlOYrYNxcugTBg$T+LCVjbC5RB3CpNdK8YeCYbQA142NpR+C7tTvtcj4LI', '2026-10-14 17:16:52.980626+00');
INSERT INTO public.users (id, username, password_hash, created_at) OVERRIDING SYSTEM VALUE VALUES (3, 'joshua', '$argon2id$v=19$m=65536,t=3,p=4$2uMrlirQsO1fbw+6eFSmow$auDi1CuxOmswG4rI9T0gVMbCjO1mgGuXksI+Q0NF/dw', '2026-10-14 17:36:41.526395+00');
INSERT INTO public.users (id, username, password_hash, created_at) OVERRIDING SYSTEM VALUE VALUES (4, 'joshua 2', '$argon2id$v=19$m=65536,t=3,p=4$1YMpCrh9XyW0oCY5tf8SVQ$c9Vwa0C8sPme26Hj8qIEJH7E8/y9/+//bkYtCgyXdFI', '2026-10-14 21:42:23.45203+00');


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (1, 'Test question', 'Why does my loop not work?', 'for (int i = 0; i < 10; i++) {}', 1, 1, 'Realiseren', '2026-10-12 20:50:43.796006+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (3, 'Python lists vs tuples', 'What is the main difference between a list and a tuple in Python?', 'my_list = [1, 2, 3]\nmy_tuple = (1, 2, 3)', 3, 1, 'Software', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (4, 'Understanding API endpoints', 'What is the difference between a GET request and a POST request?', '@app.get("/api/questions")\ndef get_questions():\n    return {"questions": []}', 1, 1, 'Software', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (5, 'Database primary keys', 'Why does a database table need a primary key?', 'CREATE TABLE users (\n    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,\n    username VARCHAR(50) NOT NULL\n);', 2, 1, 'Data', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (6, 'JavaScript async and await', 'Why do we use async and await when making asynchronous requests?', 'async function loadQuestions() {\n    const response = await fetch("/api/questions");\n    const data = await response.json();\n    console.log(data);\n}', 3, 1, 'Software', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (7, 'CSS Flexbox layout', 'How can Flexbox centre an element horizontally and vertically?', '.container {\n    display: flex;\n    justify-content: center;\n    align-items: center;\n}', 1, 1, 'Software', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (8, 'SQL filtering with WHERE', 'How can you retrieve only users whose username is Joshua?', 'SELECT id, username\nFROM users\nWHERE username = ''joshua'';', 2, 1, 'Data', '2026-10-14 18:12:55.545552+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (9, 'Python functions', 'Why do we use functions instead of writing the same code multiple times?', 'def greet(name):
    return f"Hello, {name}!"', 3, 1, 'Software', '2026-10-14 18:14:01.332751+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (10, 'REST API responses', 'What does an HTTP 404 status code mean when calling an API?', 'response = requests.get("http://localhost:8000/api/questions")
print(response.status_code)', 1, 1, 'Software', '2026-10-14 18:14:01.332751+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (11, 'Database foreign keys', 'How does a foreign key connect a question to the user who created it?', 'FOREIGN KEY (author_id) REFERENCES users(id)', 2, 1, 'Data', '2026-10-14 18:14:01.332751+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (12, 'test', 'test', 'test', 1, 1, 'back-end', '2026-10-14 20:56:30.174417+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (13, 'test', 'test', 'test', 3, 1, 'back-end', '2026-10-14 21:18:52.084313+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (14, 'test 2', 'test 2', 'test 2', 3, 1, 'backend', '2026-10-14 21:19:18.810952+00');
INSERT INTO public.questions (id, title, question_text, code, author_id, study_year, beroepsrol, created_at) OVERRIDING SYSTEM VALUE VALUES (15, 'test 3', 'test 3', 'test 3', 3, 1, 'back end 3', '2026-10-14 21:40:00.694214+00');


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.votes (id, user_vote, question_id, vote_type) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, 'down');


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.votes_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 34dzN5GcBLblc7yLcb3P3XT2NUcQfKnpBAiUIpBWfJ5pGiV5Xu45ESPBHdXdISf

