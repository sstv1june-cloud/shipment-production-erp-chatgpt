create extension if not exists pgcrypto;
create type access_level as enum ('None','View','Edit');
create type purchase_item_type as enum ('RM','Packing Item');
create type stock_adjustment_type as enum ('Transfer Out','Transfer In','Correction','Stock Audit Adjustment');
create table app_settings (key text primary key, value jsonb not null, updated_at timestamptz not null default now());
insert into app_settings(key,value) values ('stuffing_buffer_days','1'),('purchase_usage_window','7') on conflict do nothing;
create table audit_log (id uuid primary key default gen_random_uuid(), occurred_at timestamptz not null default now(), actor_id uuid, table_name text not null, action text not null check(action in('INSERT','UPDATE','DELETE','STATE_CHANGE')), record_id text, old_values jsonb, new_values jsonb);
create or replace function audit_row() returns trigger language plpgsql security invoker set search_path=public as $$begin insert into audit_log(actor_id,table_name,action,record_id,old_values,new_values) values(auth.uid(),tg_table_name,tg_op,coalesce(to_jsonb(new)->>'id',to_jsonb(new)->>'transaction_id',to_jsonb(old)->>'id',to_jsonb(old)->>'transaction_id'),to_jsonb(old),to_jsonb(new));return coalesce(new,old);end $$;

