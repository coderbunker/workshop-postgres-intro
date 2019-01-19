
begin;

  create schema if not exists stacko_v1;
  create table if not exists stacko_v1.tags (
    id uuid primary key,
    name character varying
  );

  create table if not exists stacko_v1.questions (
    id uuid primary key,
    title text not null,
    text text not null
  );

  create table if not exists stacko_v1.answers (
    id uuid primary key,
    question_id uuid references stacko_v1.questions(id),
    text text
  );

  create table if not exists stacko_v1.question_tag (
    question_id uuid references stacko_v1.questions(id),
    tag_id uuid references stacko_v1.tags(id),
    primary key (question_id, tag_id)
  );

commit;
