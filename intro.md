# Introduction to PostgreSQL for programmers

## Content

This workshop is ideal for developers who interact with databases and build schema in their
daily work and who want to know more about PostgreSQL. Those developers used to other
RDBMS (like MySQL) should be particularly interested.

* We will learn how to use special type of PostgreSQL
  * JSON
  * Array
  * UUID
* We will check how to use some basic PostgreSQL only features
  * inheritance
  * type constraint
  * trigger
  * procedure creation
  * plpgsql the PostgreSQL procedural language

* We will create our own database schema based on StackOverflow

## SQL Guidelines

* We follow coding guidelines: http://www.sqlstyle.guide/

## PostgreSQL

### Organize your data

* database: relational database, relation are essentially tables
* table: a collection of rows in which all rows have same number of columns
* schema: in PostgreSQL, is a way of separating your tables, types, functions, etc into logical entities, default schema is public
  * easy to handle permissions,
  * avoid conflicting names,
* view: a way to filter data and query it in a similar way to a table

### Some relational database concepts

* index: a way to access your data faster using an indexed column; select are faster, but insert slower
  * PostgreSQL supports partial index
* trigger: upon INSERT, UPDATE, DELETE trigger certain functions on selected table rows
* check: validate the data using check constraints on column values
* reference: force a column to reference a row in another table, the row must have a primary key
  * in PostgreSQL references are not automatically indexed (unlike MySQL)

### Some special data types

* UUID: a universal identifier, can be randomly generated
* Array: every PostgreSQL type can be used in an array, there are functions for manipulating, searching arrays
* JSON: a text value that must be a valid json type
* JSONB: a binary json, values inside JSON can be indexed
* You can also create your own types!

## Organize your database changes

* Use transaction,
* PostgreSQL support DDL statement in transactions, i.e. schema changes,
* Avoid inconsistent schema,
* Make changes idempotent:
  * database can be in an unknown state,
  * running the script will bring the database into a know state
  * so re-running a script won't affect the expected state of your database schema

## What will we do ?

Reverse engineer StackOverflow and modify to use with PostgreSQL.
