-- Profiles table setup for Bridging Silence App
-- This script creates a profiles table and sets up necessary RLS policies and triggers

-- Create the profiles table if it doesn't exist
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text unique,
  full_name text,
  avatar_url text,
  bio text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table profiles enable row level security;

-- Create policies
-- Users can read their own profile
create policy "Users can view own profile" 
  on profiles for select 
  using (auth.uid() = id);

-- Users can update their own profile
create policy "Users can update own profile" 
  on profiles for update 
  using (auth.uid() = id);

-- Users can insert their own profile (though we primarily use a trigger for this)
create policy "Users can insert own profile" 
  on profiles for insert 
  with check (auth.uid() = id);

-- Create a trigger to automatically create a profile when a new user signs up
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

-- Drop the trigger if it exists already to avoid conflicts
drop trigger if exists on_auth_user_created on auth.users;

-- Create the trigger
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- This SQL script needs to be executed in your Supabase dashboard's SQL editor
-- After executing this, your profiles table will be set up with the correct
-- permissions and a trigger to automatically create profiles when users sign up.
