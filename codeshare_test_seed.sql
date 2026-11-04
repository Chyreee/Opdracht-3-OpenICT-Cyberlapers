-- Code Sharing App seed data: 107 questions + 428 comments
-- Every question and comment is authored by the existing user named 'tester'.
-- Run once on the clean test database. Running it again adds another set.
BEGIN;
DO $$
DECLARE
    tester_id INTEGER;
    question_id INTEGER;
    q RECORD;
    comment_text TEXT;
    comment_index INTEGER;
BEGIN
    SELECT id INTO tester_id FROM users WHERE username = 'tester';
    IF tester_id IS NULL THEN
        RAISE EXCEPTION 'User tester was not found. Create tester through the website first.';
    END IF;
    CREATE TEMP TABLE seed_question_map (title TEXT, id INTEGER) ON COMMIT DROP;
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('HTML form submits but page refreshes', 'I am trying to handle a form with JavaScript, but the browser refreshes the page when I click submit. What am I missing?', 'const form = document.querySelector(''#signup'');
form.addEventListener(''submit'', (event) => {
  // I want to handle this with JavaScript
  console.log(''Submitted'');
});', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('HTML form submits but page refreshes', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between div and section', 'When should I use a semantic section element instead of a normal div? Does it make a practical difference for accessibility or SEO?', '<div class="profile">
  <h2>Profile</h2>
  <p>Some information</p>
</div>', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between div and section', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Image does not keep its aspect ratio', 'My image stretches when the browser window gets smaller. How can I make it responsive without distorting it?', 'img {
  width: 100%;
  height: 180px;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Image does not keep its aspect ratio', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How do I connect a label to an input?', 'I have a label and an input field. I want clicking the label to focus the input. What is the correct HTML structure?', '<label>Email</label>
<input type="email" id="email">', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How do I connect a label to an input?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Why is my CSS selector not applying?', 'The style below does not seem to affect my heading. The CSS file is loaded, so I suspect the selector is wrong. What should I check?', '<h2 class="card-title">Hello</h2>

.card title {
  color: red;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Why is my CSS selector not applying?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Flex items overflow their container', 'I have three cards in a flex container. On smaller screens they overflow instead of moving to a new row. How should I solve this?', '.container {
  display: flex;
  gap: 16px;
}
.card {
  width: 350px;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Flex items overflow their container', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Center a div vertically and horizontally', 'What is the simplest modern way to center a child element in the middle of its parent?', '.parent {
  height: 400px;
}
.child {
  margin: auto;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Center a div vertically and horizontally', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('CSS grid columns are unequal', 'I want three equal columns, but the last column is wider because of its content. How can I make all columns equal?', '.grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('CSS grid columns are unequal', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Sticky header does not stick', 'I set position: sticky on my navigation bar, but it scrolls away with the page. What could prevent sticky positioning from working?', 'nav {
  position: sticky;
  top: 0;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Sticky header does not stick', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between margin and padding', 'I keep mixing up margin and padding. Could someone explain the difference using a practical card example?', '.card {
  margin: 20px;
  padding: 20px;
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between margin and padding', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('JavaScript querySelector returns null', 'I am trying to select a button, but querySelector returns null even though the button exists in my HTML. What could cause this?', 'const button = document.querySelector(''#save'');
button.addEventListener(''click'', save);', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('JavaScript querySelector returns null', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between let const and var', 'I understand that const cannot be reassigned, but when should I use let? Is there still a reason to use var in modern JavaScript?', 'var count = 0;
let total = 10;
const name = ''Alex'';', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between let const and var', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Array map does not change original array', 'I use map to update values in an array, but my original array stays the same. Am I misunderstanding how map works?', 'const numbers = [1, 2, 3];
numbers.map(number => number * 2);
console.log(numbers);', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Array map does not change original array', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Filter returns an empty array', 'I want to find users older than 18, but filter always returns an empty array. Is my condition incorrect?', 'const users = [{age: 20}, {age: 16}];
const adults = users.filter(user => user.age > ''18'');', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Filter returns an empty array', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Async function returns a Promise', 'My function returns Promise instead of the data I expected. How do I get the actual result from an async function?', 'async function getUser() {
  return fetch(''/api/user'');
}
const user = getUser();
console.log(user);', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Async function returns a Promise', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Fetch request gives a 404', 'My fetch request reaches the backend but returns a 404 response. How can I work out whether the URL or route is incorrect?', 'fetch(''/api/users/1'')
  .then(response => response.json())
  .then(data => console.log(data));', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Fetch request gives a 404', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Event listener fires multiple times', 'Every time I open a modal, the same click handler gets triggered again. I think I am adding duplicate event listeners. What is a good fix?', 'function openModal() {
  button.addEventListener(''click'', submitForm);
}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Event listener fires multiple times', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How does event bubbling work?', 'I have a click listener on a parent and another on a child. Both run when I click the child. Is this event bubbling?', 'parent.addEventListener(''click'', () => console.log(''parent''));
child.addEventListener(''click'', () => console.log(''child''));', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How does event bubbling work?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Sort numbers in JavaScript gives wrong order', 'The numbers 2, 10 and 1 are sorted in an unexpected order. Why does the default sort behave like this?', 'const numbers = [2, 10, 1];
numbers.sort();
console.log(numbers);', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Sort numbers in JavaScript gives wrong order', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How to remove an item from an array', 'I need to remove one item by its id without changing the original array. What is the cleanest approach?', 'const tasks = [{id: 1}, {id: 2}, {id: 3}];
const updated = tasks.splice(1, 1);', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How to remove an item from an array', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Python list changes unexpectedly', 'I pass a list into a function and change it there. The original list also changes. Why does that happen?', 'def add_item(items):
    items.append(''new'')

values = [''a'', ''b'']
add_item(values)
print(values)', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Python list changes unexpectedly', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between list and tuple', 'When should I use a tuple instead of a list in Python? Is it mainly about performance or about preventing changes?', 'items = [1, 2, 3]
coordinates = (10, 20)', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between list and tuple', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Python function returns None', 'My function prints the correct result, but when I assign it to a variable the value is None. What am I doing wrong?', 'def calculate_total(a, b):
    print(a + b)

result = calculate_total(4, 5)', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Python function returns None', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('For loop skips items when removing', 'I am removing items from a list while looping over it, but some matching items are skipped. Why does this happen?', 'numbers = [1, 2, 3, 4, 5]
for number in numbers:
    if number < 4:
        numbers.remove(number)', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('For loop skips items when removing', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Python dictionary key error', 'I get a KeyError when I access a dictionary value. How can I safely handle keys that might not exist?', 'person = {''name'': ''Sam''}
print(person[''age''])', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Python dictionary key error', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Read a CSV file in Python', 'I need to read a CSV file and calculate the average of one column. Should I use the csv module or pandas?', 'import csv

with open(''grades.csv'') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Read a CSV file in Python', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Python virtual environment not activating', 'I created a virtual environment, but the terminal still uses the system Python. How can I verify that the environment is active?', 'python -m venv .venv
source .venv/bin/activate
python --version', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Python virtual environment not activating', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between is and equals', 'I see both == and is in Python examples. When should I use each one, and why can using is for strings be unreliable?', 'a = [1, 2]
b = [1, 2]
print(a == b)
print(a is b)', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between is and equals', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Handle exceptions without hiding errors', 'I want to handle invalid input, but I do not want to hide unrelated bugs. How specific should my except clauses be?', 'try:
    age = int(input(''Age: ''))
except:
    print(''Invalid input'')', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Handle exceptions without hiding errors', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Python imports work locally but not on server', 'My application runs on my laptop but fails to import a module on the school server. What should I compare first?', 'from app.database import get_connection

# ModuleNotFoundError on server', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Python imports work locally but not on server', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('SQL JOIN duplicates rows', 'When I join questions to comments, I get multiple rows for one question. Is that expected, and how can I count comments per question?', 'SELECT questions.title, comments.comment_text
FROM questions
JOIN comments ON comments.question_id = questions.id;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('SQL JOIN duplicates rows', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('LEFT JOIN versus INNER JOIN', 'I want to show every question, including questions without comments. Should I use LEFT JOIN instead of INNER JOIN?', 'SELECT q.title, c.comment_text
FROM questions q
INNER JOIN comments c ON c.question_id = q.id;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('LEFT JOIN versus INNER JOIN', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Foreign key prevents deleting a user', 'PostgreSQL refuses to delete a user because other records reference that user. What are the options, and when is ON DELETE CASCADE appropriate?', 'DELETE FROM users
WHERE id = 5;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Foreign key prevents deleting a user', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Unique constraint for usernames', 'How can I make sure two accounts cannot register with the same username, even if both requests happen at almost the same time?', 'CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username TEXT
);', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Unique constraint for usernames', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('SQL query for most recent questions', 'I want to show the newest questions first. Is ordering by created_at enough, and should I add a second sort column?', 'SELECT * FROM questions
ORDER BY created_at;', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('SQL query for most recent questions', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Count comments per question including zero', 'I need a list of questions with their comment count. Questions with no comments should show zero instead of disappearing. How can I do that?', 'SELECT question_id, COUNT(*)
FROM comments
GROUP BY question_id;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Count comments per question including zero', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Transaction rollback explanation', 'I am inserting records into two related tables. If the second insert fails, I want the first insert to be undone as well. Is a transaction the right solution?', 'BEGIN;
INSERT INTO questions (title) VALUES (''Example'');
-- second insert fails
COMMIT;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Transaction rollback explanation', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between DELETE and TRUNCATE', 'I need to clear test data from a table but keep the table structure. What are the differences between DELETE and TRUNCATE in PostgreSQL?', 'DELETE FROM comments;
TRUNCATE TABLE comments;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between DELETE and TRUNCATE', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Index does not improve my query', 'I added an index to a column, but the query seems just as slow. How can I check whether PostgreSQL actually uses the index?', 'CREATE INDEX idx_questions_created
ON questions(created_at);

EXPLAIN ANALYZE
SELECT * FROM questions
ORDER BY created_at DESC;', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Index does not improve my query', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('REST endpoint returns 405', 'My API route exists, but sending a POST request returns 405 Method Not Allowed. How do I check which HTTP methods the endpoint supports?', '@app.get(''/api/questions'')
def get_questions():
    return []', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('REST endpoint returns 405', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between PUT and PATCH', 'I need to update a user''s profile. Should the endpoint use PUT or PATCH if the client only sends the fields that changed?', '@app.patch(''/api/users/{user_id}'')
def update_user(user_id: int, data: dict):
    return {''id'': user_id}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between PUT and PATCH', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('FastAPI request body validation', 'How can I make FastAPI reject a request when the title is empty or the study year is outside the allowed range?', 'class QuestionData(BaseModel):
    title: str
    study_year: int', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('FastAPI request body validation', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('CORS error from frontend', 'My frontend runs on a different port from FastAPI and the browser blocks the request because of CORS. What configuration is needed?', 'fetch(''http://localhost:8000/api/questions'')
  .then(response => response.json());', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('CORS error from frontend', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('API returns 500 but no useful message', 'The browser only shows Internal Server Error. Where should I look to find the actual exception in a FastAPI application?', '@app.get(''/api/example'')
def example():
    result = 10 / 0
    return {''result'': result}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('API returns 500 but no useful message', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Should API return 200 or 201 after creation?', 'When a POST request creates a new question successfully, should I return status 200 or 201 Created?', '@app.post(''/api/questions'')
def create_question():
    return {''message'': ''created''}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Should API return 200 or 201 after creation?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Pagination for a question feed', 'My feed will eventually contain many questions. How can I implement pagination without loading every record at once?', 'SELECT * FROM questions
ORDER BY created_at DESC;', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Pagination for a question feed', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Protect endpoint from missing authentication', 'How should I check whether a user is logged in before allowing them to create a question?', '@app.post(''/api/questions'')
def create_question(data: QuestionData):
    return {''ok'': True}', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Protect endpoint from missing authentication', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between path and query parameters', 'I am unsure whether a search term belongs in the URL path or as a query parameter. What is the usual REST convention?', 'GET /api/questions/python
GET /api/questions?search=python', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between path and query parameters', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('API response shape changes unexpectedly', 'My frontend expects an object with a questions property, but the backend returns a plain list. How should we agree on a consistent response format?', 'return questions
# frontend expects {"questions": questions}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('API response shape changes unexpectedly', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Password hashing in FastAPI', 'I know passwords should not be stored as plain text. What should I use to hash passwords, and why is a normal SHA256 hash not enough?', 'password_hash = hash(password)
# store password_hash in database', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Password hashing in FastAPI', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Store database credentials safely', 'I currently have database credentials directly in my Python file. How should I move them into environment variables?', 'DATABASE_URL = ''postgresql://user:password@localhost/db''', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Store database credentials safely', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Connection pool or new connection per request', 'My FastAPI application opens a new database connection for each request. At what point should I consider using a connection pool?', 'def get_connection():
    return psycopg.connect(DB_URL)', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Connection pool or new connection per request', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Database connection works in terminal only', 'I can connect to PostgreSQL with psql, but the FastAPI app gets a connection error. What configuration differences should I check?', 'psql -h localhost -U codeshare -d codeshare', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Database connection works in terminal only', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How to test an API endpoint with pytest', 'I want to write an automated test for my GET questions endpoint. How can I test the response without manually opening the browser?', 'def test_questions(client):
    response = client.get(''/api/questions'')
    assert response.status_code == 200', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How to test an API endpoint with pytest', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Mock database calls in unit tests', 'Should I connect to a real test database for every unit test, or mock the database connection? What are the trade-offs?', 'def get_question(question_id):
    return database.fetch_one(question_id)', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Mock database calls in unit tests', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Test data should not pollute production', 'How can I separate test data from real user data so that running tests does not affect the live application?', 'INSERT INTO questions (title)
VALUES (''Test question'');', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Test data should not pollute production', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Git merge conflict in same file', 'Two people changed the same section of a file and Git reports a merge conflict. How do we resolve it without losing either change?', '<<<<<<< HEAD
const title = ''Home'';
=======
const title = ''Dashboard'';
>>>>>>> feature', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Git merge conflict in same file', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between merge and rebase', 'I understand that both merge and rebase combine branches, but when should our team use one rather than the other?', 'git checkout feature
 git rebase main', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between merge and rebase', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Accidentally committed to main', 'I made a commit directly on main, but it should have been on a feature branch. How can I move it safely?', 'git log --oneline -5', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Accidentally committed to main', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Git ignores a file that should be tracked', 'I added a file to the repository, but Git does not show it in git status. How can I find out whether it is ignored?', 'git status
cat .gitignore', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Git ignores a file that should be tracked', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How to undo the last commit but keep changes', 'I want to undo my latest commit but keep the modified files so I can make a better commit. Which reset option should I use?', 'git reset --soft HEAD~1', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How to undo the last commit but keep changes', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Pull request review checklist', 'What should I check when reviewing a teammate''s pull request besides whether the code seems to work?', 'git diff main...feature', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Pull request review checklist', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Branch is behind remote', 'Git says my local branch is behind origin. What is the safest way to bring in the latest changes?', 'git status
git pull', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Branch is behind remote', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Environment file accidentally committed', 'I accidentally committed a .env file containing credentials. Is deleting it in a new commit enough to make the credentials safe?', 'git rm .env
git commit -m ''Remove env file''', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Environment file accidentally committed', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How to resolve package lock conflicts', 'Two branches changed package.json and package-lock.json. What is the best way to resolve the lockfile conflict?', 'npm install
npm ci', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How to resolve package lock conflicts', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Docker container exits immediately', 'My Docker container starts and then exits straight away. How can I inspect why the process stopped?', 'docker run my-app
docker ps -a', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Docker container exits immediately', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Difference between image and container', 'I understand that Docker images and containers are related, but what exactly is the difference between them?', 'docker build -t codeshare .
docker run codeshare', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Difference between image and container', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Docker Compose environment variables', 'I want to pass database credentials to a PostgreSQL container through Docker Compose. What is the recommended approach?', 'services:
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: codeshare', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Docker Compose environment variables', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Frontend cannot reach backend in Docker', 'My frontend container cannot reach the backend using localhost. Why does localhost behave differently inside Docker containers?', 'fetch(''http://localhost:8000/api/questions'')', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Frontend cannot reach backend in Docker', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Persist PostgreSQL data with Docker', 'If I remove my PostgreSQL container, I do not want to lose the database. How should I configure a volume?', 'services:
  db:
    image: postgres:16
    volumes:
      - db_data:/var/lib/postgresql/data', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Persist PostgreSQL data with Docker', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Docker port mapping confusion', 'I mapped port 8000, but I cannot access the application from my host machine. How do the host and container ports relate?', 'docker run -p 8000:80 my-app', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Docker port mapping confusion', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Container uses old version of code', 'I changed my source code, rebuilt the image, but the container still seems to run the old version. What should I check?', 'docker compose build
docker compose up -d', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Container uses old version of code', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('When should I use a multi-stage Docker build?', 'My Python image is quite large. Would a multi-stage build help, or is that mainly useful for compiled applications?', 'FROM python:3.12
WORKDIR /app
COPY . .', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('When should I use a multi-stage Docker build?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Docker logs show database not ready', 'The backend starts before PostgreSQL is ready and crashes because the database connection fails. How can I make startup more reliable?', 'depends_on:
  db:
    condition: service_started', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Docker logs show database not ready', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Should I run one process per container?', 'I have seen advice to keep containers focused on one service. Is it a bad idea to run FastAPI and PostgreSQL in the same container?', '# API and database started in one container', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Should I run one process per container?', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Responsive design breakpoint strategy', 'How should I choose breakpoints for mobile, tablet and desktop? Should I target specific devices or content widths?', '@media (max-width: 768px) {
  .sidebar { display: none; }
}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Responsive design breakpoint strategy', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Mobile navigation menu does not close', 'My mobile menu opens correctly, but clicking a navigation link does not close it. How should I manage the menu state?', 'menuButton.addEventListener(''click'', () => {
  menu.classList.toggle(''open'');
});', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Mobile navigation menu does not close', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Dark mode preference persistence', 'I have a dark mode toggle. How can I remember the user''s choice when they refresh the page?', 'document.body.classList.toggle(''dark'');', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Dark mode preference persistence', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Accessible colour contrast', 'Some text looks fine on my monitor but may be difficult to read for other users. How can I check whether my colour contrast is accessible?', 'color: #aaa;
background: #fff;', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Accessible colour contrast', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Keyboard users cannot open dropdown', 'My dropdown only opens on mouse hover. How can I make it usable with a keyboard as well?', '.dropdown:hover .menu {
  display: block;
}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Keyboard users cannot open dropdown', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Modal should close with Escape key', 'I have a modal window and want users to close it by pressing Escape. Where should I listen for the key event?', 'document.addEventListener(''keydown'', (event) => {
  if (event.key === ''Escape'') closeModal();
});', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Modal should close with Escape key', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Loading state for API requests', 'The feed looks empty while data is loading, which makes users think there are no questions. What is a good way to display loading feedback?', 'async function loadQuestions() {
  const response = await fetch(''/api/questions'');
  return response.json();
}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Loading state for API requests', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Prevent double form submission', 'Users can click the submit button several times while the request is processing. How can I prevent duplicate submissions?', 'form.addEventListener(''submit'', async (event) => {
  event.preventDefault();
  await saveQuestion();
});', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Prevent double form submission', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Show a useful error message to the user', 'When the API fails, I currently show the raw error in the console. What should the interface display instead?', 'try {
  await saveQuestion();
} catch (error) {
  console.error(error);
}', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Show a useful error message to the user', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('XSS risk when displaying comments', 'I currently display user comments by assigning them to innerHTML. Could this allow someone to inject HTML or JavaScript?', 'commentElement.innerHTML = comment.comment_text;', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('XSS risk when displaying comments', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Why use textContent instead of innerHTML', 'I only need to display a username and comment. Is textContent safer or better than innerHTML for this use case?', 'element.innerHTML = userComment;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Why use textContent instead of innerHTML', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('LocalStorage is not authentication', 'I store the user ID in localStorage and send it with each request. Is that enough to prove which user is logged in?', 'const userId = localStorage.getItem(''userId'');
fetch(''/api/questions'', {
  headers: { ''X-User-Id'': userId }
});', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('LocalStorage is not authentication', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Rate limiting public endpoints', 'How can I prevent someone from sending hundreds of requests to my registration or comment endpoint?', '@app.post(''/api/comments'')
def create_comment(data: CommentData):
    return {''ok'': True}', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Rate limiting public endpoints', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Validate uploaded file types', 'If we later allow users to upload code files, should we trust the file extension sent by the browser? What should the backend validate?', 'filename = upload.filename
if filename.endswith(''.py''):
    save(upload)', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Validate uploaded file types', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Logging without exposing passwords', 'I want useful backend logs when something fails, but I do not want passwords or tokens to end up in the logs. What should I avoid logging?', 'print(''Login request:'', username, password)', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Logging without exposing passwords', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Should comments be ordered oldest or newest first', 'For a question discussion, should comments be displayed oldest first or newest first? What are the usability trade-offs?', 'SELECT * FROM comments
WHERE question_id = 10
ORDER BY created_at DESC;', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Should comments be ordered oldest or newest first', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Prevent empty comments', 'The frontend has a required field, but someone could still send an empty comment directly to the API. Where should validation happen?', 'class CommentData(BaseModel):
    comment_text: str', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Prevent empty comments', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Delete question and related comments', 'When a question is deleted, I want its comments to be removed too. Should I implement that in Python or with a database foreign key?', 'FOREIGN KEY (question_id)
REFERENCES questions(id) ON DELETE CASCADE', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Delete question and related comments', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Edit comment timestamps', 'When a user edits a comment, should I overwrite created_at or add a separate updated_at column?', 'UPDATE comments
SET comment_text = ''Updated text'', created_at = NOW()
WHERE id = 3;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Edit comment timestamps', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Avoid N plus one queries in feed', 'My feed loads each question and then makes another query for its author. Is there a better way to retrieve all the data?', 'for question in questions:
    author = get_user(question.author_id)', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Avoid N plus one queries in feed', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Store code snippets with formatting', 'I want users to share code snippets and preserve line breaks and indentation. Is a TEXT column suitable for this?', 'code = ''def hello():\n    print("Hi")''', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Store code snippets with formatting', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Search questions by title and content', 'I want a search bar that finds a word in either the question title or description. How can I use ILIKE safely with parameters?', 'SELECT * FROM questions
WHERE title ILIKE ''%python%'';', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Search questions by title and content', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Filter feed by study year', 'Users should be able to filter questions by study year. Should I add the filter to the API query string?', 'GET /api/questions?study_year=2', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Filter feed by study year', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Calculate upvotes and downvotes', 'I store each vote separately. What query can calculate the score for each question by subtracting downvotes from upvotes?', 'SELECT question_id, vote_type, COUNT(*)
FROM votes
GROUP BY question_id, vote_type;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Calculate upvotes and downvotes', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Prevent users voting twice', 'I want one vote per user per question. Is checking in Python enough, or should the database also enforce uniqueness?', 'SELECT * FROM votes
WHERE user_vote = 4 AND question_id = 12;', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Prevent users voting twice', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Allow changing an existing vote', 'If a user has already upvoted a question and clicks downvote, should I update the existing vote or delete and insert a new one?', 'INSERT INTO votes (user_vote, question_id, vote_type)
VALUES (4, 12, ''down'');', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Allow changing an existing vote', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Handle dates and time zones consistently', 'The timestamps in my database look different from the time shown in the browser. Should I store UTC and convert it for display?', 'created_at TIMESTAMPTZ DEFAULT NOW()', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Handle dates and time zones consistently', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Database migration after adding a column', 'I added a new field to my Python model, but the existing database table does not have that column. How should I manage schema changes?', 'ALTER TABLE questions
ADD COLUMN category VARCHAR(30);', tester_id, 2, 'Developer') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Database migration after adding a column', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Should IDs be sequential or UUIDs', 'Our tables currently use identity integer IDs. Would UUIDs offer any real advantage for this school project?', 'id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Should IDs be sequential or UUIDs', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('Normalise repeated category values', 'I store the study role as text on every question. At what point would it make sense to create a separate roles table?', 'beroepsrol VARCHAR(20) NOT NULL', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('Normalise repeated category values', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('What belongs in a database transaction', 'I create a question and award points to the author. Both operations should succeed together. How should I structure the transaction?', 'INSERT INTO questions (...) VALUES (...);
UPDATE users SET points = points + 5 WHERE id = 1;', tester_id, 3, 'Architect') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('What belongs in a database transaction', question_id);
    INSERT INTO questions (title, question_text, code, author_id, study_year, beroepsrol) VALUES ('How to document API endpoints', 'Our team keeps forgetting what each endpoint expects and returns. Should we rely on FastAPI Swagger or write separate API documentation?', '@app.get(''/api/questions/{question_id}'')
def get_question(question_id: int):
    return {}', tester_id, 1, 'Student') RETURNING id INTO question_id;
    INSERT INTO seed_question_map (title, id) VALUES ('How to document API endpoints', question_id);
    FOR q IN SELECT title, id FROM seed_question_map ORDER BY id LOOP
        FOR comment_index IN 1..4 LOOP
            comment_text := CASE comment_index
                WHEN 1 THEN 'I ran into something similar. Have you checked the browser console or the backend logs for a more specific error?'
                WHEN 2 THEN 'One thing I would try is breaking this down into smaller steps and testing each part separately. That should help narrow down where it goes wrong.'
                WHEN 3 THEN 'Could you share what output you expected and what you actually got? That would make it easier to identify the issue.'
                ELSE 'I think the key is to check the assumptions first. Also make sure the data types and values being passed into this part are what you expect.'
            END;
            INSERT INTO comments (question_id, author_id, comment_text)
            VALUES (q.id, tester_id, comment_text);
        END LOOP;
    END LOOP;
END $$;
COMMIT;

SELECT
    (SELECT COUNT(*) FROM questions WHERE author_id = (SELECT id FROM users WHERE username = 'tester')) AS tester_questions,
    (SELECT COUNT(*) FROM comments WHERE author_id = (SELECT id FROM users WHERE username = 'tester')) AS tester_comments,
    (SELECT COUNT(*) FROM comments c JOIN questions q ON q.id = c.question_id WHERE q.author_id = (SELECT id FROM users WHERE username = 'tester')) AS comments_on_tester_questions;