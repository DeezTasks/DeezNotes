-- Users

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY username;

-- name: CreateUser :one
INSERT INTO users (
  username, email, role
) VALUES (
  $1, $2, $3
)
RETURNING *;

-- name: UpdateUser :exec
UPDATE users
  set username = $2,
  email = $3,
  role = $4
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users
WHERE id = $1;


-- Tags

-- name: GetTag :one
SELECT * FROM tags
WHERE id = $1 LIMIT 1;

-- name: ListTags :many
SELECT * FROM tags
ORDER BY id;

-- name: CreateTag :one
INSERT INTO tags (
  tag
) VALUES (
  $1
)
RETURNING *;

-- name: UpdateTag :exec
UPDATE tags
  set tag = $2
WHERE id = $1
RETURNING *;

-- name: DeleteTag :exec
DELETE FROM tags
WHERE id = $1;


-- Tasks

-- name: GetTask :one
SELECT * FROM tasks
WHERE id = $1 LIMIT 1;

-- name: ListTasks :many
SELECT * FROM tasks
ORDER BY id;

-- name: CreateTask :one
INSERT INTO tasks (
  title, body, user_id, status
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateTask :exec
UPDATE tasks
  set title = $2,
  body = $3, 
  user_id = $4, 
  status = $5
WHERE id = $1
RETURNING *;

-- name: DeleteTask :exec
DELETE FROM tasks
WHERE id = $1;


-- Groups

-- name: GetGroup :one
SELECT * FROM groups
WHERE id = $1 LIMIT 1;

-- name: ListGroups :many
SELECT * FROM groups
ORDER BY id;

-- name: CreateGroup :one
INSERT INTO groups (
  name
) VALUES (
  $1
)
RETURNING *;

-- name: UpdateGroup :exec
UPDATE groups
  set name = $2
WHERE id = $1
RETURNING *;

-- name: DeleteGroup :exec
DELETE FROM groups
WHERE id = $1;
