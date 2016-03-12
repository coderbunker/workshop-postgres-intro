
begin;

  create schema if not exists stacko_v1;
  create table if not exists stacko_v1.tags (
    id uuid primary key,
    name character varying
  );

  create table if not exists stacko_v1.questions (
    id uuid primary key,
    title character varying not null,
    text text
  );

  create table if not exists stacko_v1.answers (
    id uuid primary key,
    question_id uuid REFERENCES stacko_v1.questions(id),
    text text
  );

  create table if not exists stacko_v1.question_tag (
    question_id uuid REFERENCES stacko_v1.tags(id),
    tag_id uuid REFERENCES stacko_v1.questions(id),
    PRIMARY KEY (question_id, tag_id)
  );

commit;
