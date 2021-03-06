"use strict";

import knex from "knex";

const sslConfig = {
  require: true,
  rejectUnauthorized: false
}

export const db = knex({
  client: "pg",
  connection: {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    port: process.env.DB_PORT,
    ssl: process.env.NODE_ENV === "production" ? sslConfig : false,
  },
  debug: false,
  pool: {min: 1, max: 5},
});