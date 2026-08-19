create table users (user_id uuid primary key references auth.users(id) on delete cascade, name text not null default '', email text not null unique, status text not null default 'Active' check(status in('Active','Inactive')), created_at timestamptz not null default now());
create table module_master (module_id uuid primary key default gen_random_uuid(), module_name text not null unique, parent_menu text not null, route text not null unique);
create table user_module_access (user_id uuid references users(user_id) on delete cascade, module_id uuid references module_master(module_id) on delete cascade, access_level access_level not null default 'None', primary key(user_id,module_id));
create table role_templates (role_id uuid primary key default gen_random_uuid(), role_name text not null unique);
create table role_template_access (role_id uuid references role_templates(role_id) on delete cascade,module_id uuid references module_master(module_id) on delete cascade,access_level access_level not null,primary key(role_id,module_id));
create or replace function has_module_access(route_name text, needed access_level default 'View') returns boolean language sql stable security invoker set search_path=public as $$select exists(select 1 from user_module_access a join module_master m on m.module_id=a.module_id where a.user_id=auth.uid() and m.route=route_name and (a.access_level='Edit' or a.access_level=needed))$$;
alter table users enable row level security; alter table module_master enable row level security; alter table user_module_access enable row level security; alter table role_templates enable row level security; alter table role_template_access enable row level security;
create policy users_self_read on users for select to authenticated using(user_id=(select auth.uid()));
create policy modules_read on module_master for select to authenticated using(true);
create policy access_self_read on user_module_access for select to authenticated using(user_id=(select auth.uid()));

