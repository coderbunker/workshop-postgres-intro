create extension if not exists pgcrypto;

begin;
  create schema if not exists stacko_v4;

  create table if not exists stacko_v4.users (
    id uuid primary key default gen_random_uuid(),
    username character varying not null check (char_length(username) >= 5),

    settings jsonb not null default '{}'::jsonb,

    created_at timestamp with time zone not null,
    updated_at timestamp with time zone not null
  );

  create table if not exists stacko_v4.posts (
    text text not null,

    vote smallint not null default 0,

    owner_id uuid not null references stacko_v4.users(id),

    created_at timestamp with time zone not null,
    updated_at timestamp with time zone not null
  );

  create table if not exists stacko_v4.questions (
    id uuid primary key default gen_random_uuid(),

    title character varying not null check (char_length(title) >= 5),
    slug character varying not null check (slug ~ '[a-z-]{5,}'),
    tags character varying[],

    unique (slug)
  ) inherits (stacko_v4.posts);

  create table if not exists stacko_v4.answers (
    id uuid primary key default gen_random_uuid(),

    question_id uuid references stacko_v4.questions(id) not null,
    accepted boolean not null default false
  ) inherits (stacko_v4.posts);

  create table if not exists stacko_v4.comments_on_questions (
    question_id uuid references stacko_v4.questions(id)
  ) inherits (stacko_v4.posts);

  create table if not exists stacko_v4.comments_on_answers (
    answers_id uuid references stacko_v4.answers(id)
  ) inherits (stacko_v4.posts);

  -- create basic created_at/updated_at function
  create or replace function stacko_v4.set_creation_time() returns trigger as $$
  begin
      NEW.created_at := current_timestamp;
      NEW.updated_at := NEW.created_at;

      RETURN NEW;
  end;
  $$ language plpgsql;

  create or replace function stacko_v4.set_update_time() returns trigger as $$
  begin
      -- Prevent update from erasing the created_at
      NEW.created_at := OLD.created_at;
      NEW.updated_at := current_timestamp;

      return NEW;
  end;
  $$ language plpgsql;

  -- init triggers for stacko_v4.questions table
  drop trigger if exists questions_creation_time_on_insert on stacko_v4.questions;
  create trigger questions_creation_time_on_insert before insert on stacko_v4.questions
    for each row execute procedure stacko_v4.set_creation_time();

  drop trigger if exists questions_update_time_on_update on stacko_v4.questions;
  create trigger questions_update_time_on_update before update on stacko_v4.questions
    for each row execute procedure stacko_v4.set_update_time();

  -- init triggers for stacko_v4.answers table
  drop trigger if exists answers_creation_time_on_insert on stacko_v4.answers;
  create trigger answers_creation_time_on_insert before insert on stacko_v4.answers
    for each row execute procedure stacko_v4.set_creation_time();

  drop trigger if exists answers_update_time_on_update on stacko_v4.answers;
  create trigger answers_update_time_on_update before update on stacko_v4.answers
    for each row execute procedure stacko_v4.set_update_time();

  -- init triggers for stacko_v4.comments table
  drop trigger if exists comments_creation_time_on_insert on stacko_v4.comments;
  create trigger comments_creation_time_on_insert before insert on stacko_v4.comments
    for each row execute procedure stacko_v4.set_creation_time();

  drop trigger if exists comments_update_time_on_update on stacko_v4.questions;
  create trigger comments_update_time_on_update before update on stacko_v4.comments
    for each row execute procedure stacko_v4.set_update_time();

  -- init triggers for stacko_v4.users table
  drop trigger if exists users_creation_time_on_insert on stacko_v4.users;
  create trigger users_creation_time_on_insert before insert on stacko_v4.users
    for each row execute procedure stacko_v4.set_creation_time();

  drop trigger if exists users_update_time_on_update on stacko_v4.users;
  create trigger users_update_time_on_update before update on stacko_v4.users
    for each row execute procedure stacko_v4.set_update_time();

  -- init trigger to create automatic slug
  create or replace function stacko_v4.create_slug(title text) returns text as $$
    begin
      -- replaces underscores and spaces with dash
      return regexp_replace(
        regexp_replace(lower(title), '[^a-z]', '-'),
        '[-]+', '-', 'g' -- remove ugly multiple -
      );
    end;
  $$ language plpgsql;

  create or replace function stacko_v4.update_question_slug() returns trigger as $$
    declare slug_count int;
    begin
      -- replaces underscores and spaces with dash
      NEW.slug = stacko_v4.create_slug(NEW.title);

      -- check slug is not unique
      select count(slug) into slug_count from stacko_v4.questions where position(NEW.slug in slug) = 0;
      if (slug_count > 0) then
        NEW.slug = NEW.slug || '-' || slug_count::text;
      end if;

      return NEW;
    end;
  $$ language plpgsql;

  drop trigger if exists create_slug on stacko_v4.questions;
  create trigger update_question_slug before insert or update on stacko_v4.questions
    for each row execute procedure stacko_v4.update_question_slug();

commit;
