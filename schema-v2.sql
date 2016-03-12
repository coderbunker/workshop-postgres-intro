
begin;
  create schema if not exists stacko_v2;

  create table if not exists stacko_v2.posts (
    id uuid primary key,
    text text not null,
    vote smallint not null DEFAULT 0
  );

  create table if not exists stacko_v2.questions (
    title character varying,
    tags character varying[]
  ) inherits (stacko_v2.posts);

  create table if not exists stacko_v2.answers (
    question_id uuid references stacko_v2.posts(id) not null,
    accepted boolean not null default false
  ) inherits (stacko_v2.posts);

  create table if not exists stacko_v2.comments (
    post_id uuid references stacko_v2.posts(id),
    text text not null
  );
commit;
