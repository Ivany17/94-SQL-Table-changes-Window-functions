/* BCNF (Нормальная Форма Бойса-Кодда) */
CREATE TABLE "restaurants"(
    id serial PRIMARY KEY,
    "adress" jsonb);
INSERT INTO "restaurants"("adress")
VALUES ('{"country":"USA", "state":{"Illinoys":"Chicago", "California":"Los Angeles"}}')
CREATE TABLE "deliveries"(id serial PRIMARY KEY);
CREATE TABLE "pizzas"(id serial PRIMARY KEY);

CREATE TABLE "restaurants_to_pizzas"(
    "restaurant_id" INT REFERENCES "restaurants".id,
    "pizzas_id" INT REFERENCES "pizzas".id,
    PRIMARY KEY ("restaurant_id", "pizzas_id")
);

CREATE TABLE "restaurants_to_deliveries"(
    "restaurant_id" INT REFERENCES "restaurants".id,
    "deliveries_id" INT REFERENCES "deliveries".id,
    pizza
    PRIMARY KEY ("restaurant_id", "deliveries_id")
);

INSERT INTO "restaurants_to_deliveries"
VALUES
(1,1),
(2,1);

INSERT INTO "restaurants_to_pizzas"
VALUES
(1,101),
(2,114);