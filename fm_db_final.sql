CREATE TYPE task_status AS ENUM('done', 'processing', 'pending', 'reject')
CREATE TABLE "users_tasks"(
    "id" serial PRIMARY KEY,
    "body" text NOT NULL,
    "userId" INT REFERENCES "users"("id"),
    "status" task_status NOT NULL,
    "deadline" TIMESTAMP CHECK ("deadline"<=current_timestamp) DEFAULT current_timestamp
);

INSERT INTO "users_tasks"(
    "body", "userId", "status"
)
VALUES('text 1', 15, 'done'), ('text 2', 16, 'processing');

-- добавлять новые колонки
ALTER TABLE "users_tasks"
ADD COLUMN "createdAt" TIMESTAMP NOT NULL DEFAULT current_timestamp;

ALTER TABLE "users_tasks"
ADD COLUMN "marks" INT;

-- удалять новые колонки
ALTER TABLE "users_tasks"
DROP COLUMN "marks" INT;

-- удалять новые ограничения
ALTER TABLE "users_tasks"
ADD CONSTRAINT "created_at_check" CHECK ("createdAt"<=current_timestamp);

ALTER TABLE "users_tasks"
DROP CONSTRAINT "created_at_check";

ALTER TABLE "users_tasks"
ALTER COLUMN "createdAt" DROP NOT NULL;

ALTER TABLE "users_tasks"
ALTER COLUMN "createdAt" SET NOT NULL;

ALTER TABLE "users_tasks"
ALTER COLUMN "body" TYPE VARCHAR(1024);

ALTER TABLE "users_tasks"
RENAME COLUMN "body" TO "bodyTask";

ALTER TABLE "users_tasks" RENAME TO "tasks";

--SELECT * FROM "users_tasks";
SELECT * FROM "tasks";


CREATE SCHEMA training;
CREATE TABLE training."users"(
    "id" serial PRIMARY KEY,
    "login" VARCHAR(64) NOT NULL CHECK("login" != ''),
    "email" VARCHAR(128) NOT NULL CHECK("email" != ''),
    "password" VARCHAR(128)
);
CREATE TABLE training."employers"(
    "salary" numeric(10, 2) NOT NULL CHECK("salary">0)
    "department" VARCHAR(64) NOT NULL CHECK("department" != ''),
    "position" VARCHAR(64) NOT NULL CHECK("position" != ''),
    "happyDay" DATE CHECK ("deadline"<=current_date) DEFAULT current_date,
    "userId" INT PRIMARY KEY REFERENCES  training."users"("id") ON DELETE CASCADE
);

INSERT INTO training."users" ("login", "email", "passwordHash")
VALUES('ivany', 'ivany@gmail.com', '123456ivany'), ('lezedann', 'lezedann@gmail.com', '123456lezedann')

/* Добавить ограничения по уникальности для login и email. После этого изменить колонку password на passwordHash с типом text */
ALTER TABLE training."users"
ADD CONSTRAINT "uniq_login" UNIQUE("login");
ALTER TABLE training."users"
ADD CONSTRAINT "uniq_email" UNIQUE("email");

ALTER TABLE training."users"
DROP COLUMN "password";
ALTER TABLE training."users"
ADD COLUMN "passwordHash" text;
ALTER TABLE training."users"
ALTER COLUMN "passwordHash" SET NOT NULL;

ALTER TABLE "employers"
ADD COLUMN "userId" INT PRIMARY KEY REFERENCES  training."users"("id");


/* Оконные функции */
SELECT u.id, u.email, count(*)
FROM "users" AS u
    JOIN "orders" AS o ON u.id=o."userId"
    JOIN "phones_to_orders" AS pto ON o.id=rto."orderId"
    JOIN "phones" AS p ON pto."phoneId"=p."id"
GROUP BY o."userId", u.email;
-- переделываем с помощью оконной функции
SELECT u.id, u.email, 
count(o."userId") OVER (PARTITION BY o."userId" ORDER BY o.id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM "users" AS u
    JOIN "orders" AS o ON u.id=o."userId";

SELECT pto."orderId", p.*,
sum(p.price*pto.quantity) OVER (PARTITION BY pto."orderId" ORDER BY p.id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM "phones_to_orders" AS pto
    JOIN "phones" AS p ON p.id=pto."phoneId";