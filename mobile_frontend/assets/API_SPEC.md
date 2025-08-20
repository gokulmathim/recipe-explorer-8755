# Backend API Contract (assumed)

Adjust paths/fields to match your backend:

- POST /auth/register
  Body: { name, email, password }
  Response: { token } or { user }

- POST /auth/login
  Body: { email, password }
  Response: { token }

- GET /recipes
  Query: ?q=term&difficulty=Easy
  Response: { data: [ { id, title, imageUrl, description, ingredients[], steps[], duration, difficulty } ] }

- GET /recipes/{id}
  Response: { data: { id, title, imageUrl, description, ingredients[], steps[], duration, difficulty } }

Set API_BASE_URL in .env accordingly.
