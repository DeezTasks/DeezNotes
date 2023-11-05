CREATE TABLE "users" (
  "id" bigserial PRIMARY KEY,
  "username" varchar UNIQUE NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "role" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "tags" (
  "id" bigserial PRIMARY KEY,
  "tag" varchar UNIQUE NOT NULL
);

CREATE TABLE "userTags" (
  "user_id" bigserial NOT NULL,
  "tag_id" bigserial NOT NULL
);

CREATE TABLE "taskTags" (
  "tasks_id" bigserial NOT NULL,
  "tag_id" bigserial NOT NULL
);

CREATE TABLE "tasks" (
  "id" bigserial PRIMARY KEY,
  "title" varchar NOT NULL,
  "body" text NOT NULL,
  "user_id" bigserial NOT NULL,
  "status" text NOT NULL, 
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "groups" (
  "id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL
);

CREATE TABLE "userGroups" (
  "group_id" bigserial NOT NULL,
  "user_id" bigserial NOT NULL
);

CREATE TABLE "groupTags" (
  "group_id" bigserial NOT NULL,
  "tag_id" bigserial NOT NULL
);

COMMENT ON COLUMN "tasks"."body" IS 'Content of the post';

ALTER TABLE "userTags" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "userTags" ADD FOREIGN KEY ("tag_id") REFERENCES "tags" ("id");

ALTER TABLE "taskTags" ADD FOREIGN KEY ("tasks_id") REFERENCES "tasks" ("id");

ALTER TABLE "taskTags" ADD FOREIGN KEY ("tag_id") REFERENCES "tags" ("id");

ALTER TABLE "tasks" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "userGroups" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");

ALTER TABLE "userGroups" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "groupTags" ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id");

ALTER TABLE "groupTags" ADD FOREIGN KEY ("tag_id") REFERENCES "tags" ("id");

ALTER TABLE "tasks" ADD FOREIGN KEY ("id") REFERENCES "tasks" ("user_id");
