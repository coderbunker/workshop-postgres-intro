# Introduction to PostgreSQL for programmers

This workshop is ideal for developers who interact with databases and build schema in their
daily work and who want to know more about PostgreSQL. Those developers used to other
RDBMS (like MySQL) should be particularly interested.

* We will learn how to use special type of PostgreSQL
  * JSON => has jsonb since 9.3, can index field, can set field since 9.5
  * Array => every type have an equivalent array type
  * UUID => instead of sequential id, good for sharing, multiple database
* We will check how to use some basic PostgreSQL only features
  * inheritance
  * type constraint
  * trigger (also exists in other db actually)
  * procedure creation
  * plpgsql the PostgreSQL procedural language

* We will create our own database schema based on StackOverflow
