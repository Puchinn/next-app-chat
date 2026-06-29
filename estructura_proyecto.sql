--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8
-- docker exec -i supabase-db psql -U postgres -d postgres < estructura_proyecto.sql

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP PUBLICATION IF EXISTS supabase_realtime_messages_publication;
DROP PUBLICATION IF EXISTS supabase_realtime;
DROP POLICY IF EXISTS "Avatar images are publicly accessible." ON storage.objects;
DROP POLICY IF EXISTS "Auth Users can upsert 1kl1id_2" ON storage.objects;
DROP POLICY IF EXISTS "Auth Users can upsert 1kl1id_1" ON storage.objects;
DROP POLICY IF EXISTS "Auth Users can upsert 1kl1id_0" ON storage.objects;
DROP POLICY IF EXISTS "Auth Users can upload 1kl1id_0" ON storage.objects;
DROP POLICY IF EXISTS "Auth Users can select 1kl1id_0" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can upload an avatar." ON storage.objects;
DROP POLICY IF EXISTS "ANON_CAN_UPLOAD 1j7mwej_0" ON storage.objects;
DROP POLICY IF EXISTS "owner message can delete" ON public.messages;
DROP POLICY IF EXISTS "allow select to public" ON public.messages;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP POLICY IF EXISTS "Users can insert their own profile." ON public.profiles;
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.messages;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_namespace_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_namespaces DROP CONSTRAINT IF EXISTS iceberg_namespaces_catalog_id_fkey;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_id_fkey;
ALTER TABLE IF EXISTS ONLY public.messages DROP CONSTRAINT IF EXISTS messages_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_oauth_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
ALTER TABLE IF EXISTS ONLY _realtime.extensions DROP CONSTRAINT IF EXISTS extensions_tenant_external_id_fkey;
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP INDEX IF EXISTS supabase_functions.supabase_functions_hooks_request_id_idx;
DROP INDEX IF EXISTS supabase_functions.supabase_functions_hooks_h_table_id_h_name_idx;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name_lower;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.idx_iceberg_tables_namespace_id;
DROP INDEX IF EXISTS storage.idx_iceberg_tables_location;
DROP INDEX IF EXISTS storage.idx_iceberg_namespaces_bucket_id;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX IF EXISTS realtime.messages_2026_07_02_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_07_01_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_06_30_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_06_29_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_06_28_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_06_27_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_2026_06_26_inserted_at_topic_idx;
DROP INDEX IF EXISTS realtime.messages_inserted_at_topic_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_pattern_idx;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_oauth_client_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.oauth_consents_user_order_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_user_client_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_client_idx;
DROP INDEX IF EXISTS auth.oauth_clients_deleted_at_idx;
DROP INDEX IF EXISTS auth.oauth_auth_pending_exp_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_oauth_client_states_created_at;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
DROP INDEX IF EXISTS _realtime.tenants_external_id_index;
DROP INDEX IF EXISTS _realtime.extensions_tenant_external_id_type_index;
DROP INDEX IF EXISTS _realtime.extensions_tenant_external_id_index;
ALTER TABLE IF EXISTS ONLY supabase_functions.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY supabase_functions.hooks DROP CONSTRAINT IF EXISTS hooks_pkey;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.iceberg_tables DROP CONSTRAINT IF EXISTS iceberg_tables_pkey;
ALTER TABLE IF EXISTS ONLY storage.iceberg_namespaces DROP CONSTRAINT IF EXISTS iceberg_namespaces_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_vectors DROP CONSTRAINT IF EXISTS buckets_vectors_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_analytics DROP CONSTRAINT IF EXISTS buckets_analytics_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_07_02 DROP CONSTRAINT IF EXISTS messages_2026_07_02_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_07_01 DROP CONSTRAINT IF EXISTS messages_2026_07_01_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_06_30 DROP CONSTRAINT IF EXISTS messages_2026_06_30_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_06_29 DROP CONSTRAINT IF EXISTS messages_2026_06_29_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_06_28 DROP CONSTRAINT IF EXISTS messages_2026_06_28_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_06_27 DROP CONSTRAINT IF EXISTS messages_2026_06_27_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages_2026_06_26 DROP CONSTRAINT IF EXISTS messages_2026_06_26_pkey;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_username_key;
ALTER TABLE IF EXISTS ONLY public.profiles DROP CONSTRAINT IF EXISTS profiles_pkey;
ALTER TABLE IF EXISTS ONLY public.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_client_unique;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_clients DROP CONSTRAINT IF EXISTS oauth_clients_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_client_states DROP CONSTRAINT IF EXISTS oauth_client_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_id_key;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_code_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS ONLY _realtime.tenants DROP CONSTRAINT IF EXISTS tenants_pkey;
ALTER TABLE IF EXISTS ONLY _realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY _realtime.extensions DROP CONSTRAINT IF EXISTS extensions_pkey;
ALTER TABLE IF EXISTS supabase_functions.hooks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS supabase_functions.migrations;
DROP SEQUENCE IF EXISTS supabase_functions.hooks_id_seq;
DROP TABLE IF EXISTS supabase_functions.hooks;
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.iceberg_tables;
DROP TABLE IF EXISTS storage.iceberg_namespaces;
DROP TABLE IF EXISTS storage.buckets_vectors;
DROP TABLE IF EXISTS storage.buckets_analytics;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages_2026_07_02;
DROP TABLE IF EXISTS realtime.messages_2026_07_01;
DROP TABLE IF EXISTS realtime.messages_2026_06_30;
DROP TABLE IF EXISTS realtime.messages_2026_06_29;
DROP TABLE IF EXISTS realtime.messages_2026_06_28;
DROP TABLE IF EXISTS realtime.messages_2026_06_27;
DROP TABLE IF EXISTS realtime.messages_2026_06_26;
DROP TABLE IF EXISTS realtime.messages;
DROP TABLE IF EXISTS public.profiles;
DROP TABLE IF EXISTS public.messages;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.oauth_consents;
DROP TABLE IF EXISTS auth.oauth_clients;
DROP TABLE IF EXISTS auth.oauth_client_states;
DROP TABLE IF EXISTS auth.oauth_authorizations;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP TABLE IF EXISTS _realtime.tenants;
DROP TABLE IF EXISTS _realtime.schema_migrations;
DROP TABLE IF EXISTS _realtime.extensions;
DROP FUNCTION IF EXISTS supabase_functions.http_request();
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.handle_new_userkk();
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS storage.buckettype;
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.oauth_response_type;
DROP TYPE IF EXISTS auth.oauth_registration_type;
DROP TYPE IF EXISTS auth.oauth_client_type;
DROP TYPE IF EXISTS auth.oauth_authorization_status;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS supabase_vault;
DROP EXTENSION IF EXISTS pgjwt;
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP EXTENSION IF EXISTS pg_graphql;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS supabase_functions;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
DROP SCHEMA IF EXISTS pgbouncer;
DROP EXTENSION IF EXISTS pg_net;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
DROP SCHEMA IF EXISTS extensions;
DROP SCHEMA IF EXISTS auth;
DROP SCHEMA IF EXISTS _realtime;
--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO supabase_admin;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$

begin

  insert into public.profiles (id, full_name, avatar_url, email)

  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url', new.email);

  return new;

end;

$$;


ALTER FUNCTION public.handle_new_user() OWNER TO supabase_admin;

--
-- Name: handle_new_userkk(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.handle_new_userkk() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$BEGIN
END;$$;


ALTER FUNCTION public.handle_new_userkk() OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$

    DECLARE

      request_id bigint;

      payload jsonb;

      url text := TG_ARGV[0]::text;

      method text := TG_ARGV[1]::text;

      headers jsonb DEFAULT '{}'::jsonb;

      params jsonb DEFAULT '{}'::jsonb;

      timeout_ms integer DEFAULT 1000;

    BEGIN

      IF url IS NULL OR url = 'null' THEN

        RAISE EXCEPTION 'url argument is missing';

      END IF;



      IF method IS NULL OR method = 'null' THEN

        RAISE EXCEPTION 'method argument is missing';

      END IF;



      IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN

        headers = '{"Content-Type": "application/json"}'::jsonb;

      ELSE

        headers = TG_ARGV[2]::jsonb;

      END IF;



      IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN

        params = '{}'::jsonb;

      ELSE

        params = TG_ARGV[3]::jsonb;

      END IF;



      IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN

        timeout_ms = 1000;

      ELSE

        timeout_ms = TG_ARGV[4]::integer;

      END IF;



      CASE

        WHEN method = 'GET' THEN

          SELECT http_get INTO request_id FROM net.http_get(

            url,

            params,

            headers,

            timeout_ms

          );

        WHEN method = 'POST' THEN

          payload = jsonb_build_object(

            'old_record', OLD,

            'record', NEW,

            'type', TG_OP,

            'table', TG_TABLE_NAME,

            'schema', TG_TABLE_SCHEMA

          );



          SELECT http_post INTO request_id FROM net.http_post(

            url,

            payload,

            params,

            headers,

            timeout_ms

          );

        ELSE

          RAISE EXCEPTION 'method argument % is invalid', method;

      END CASE;



      INSERT INTO supabase_functions.hooks

        (hook_table_id, hook_name, request_id)

      VALUES

        (TG_RELID, TG_NAME, request_id);



      RETURN NEW;

    END

  $$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000,
    max_client_presence_events_per_window integer,
    client_presence_window_ms integer,
    CONSTRAINT jwt_secret_or_jwt_jwks_required CHECK (((jwt_secret IS NOT NULL) OR (jwt_jwks IS NOT NULL)))
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: messages; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    content text,
    author text,
    user_id uuid DEFAULT auth.uid()
);


ALTER TABLE public.messages OWNER TO supabase_admin;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    updated_at timestamp with time zone,
    username text,
    full_name text,
    avatar_url text,
    website text,
    email text,
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);


ALTER TABLE public.profiles OWNER TO supabase_admin;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_06_26; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_06_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_06_26 OWNER TO supabase_admin;

--
-- Name: messages_2026_06_27; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_06_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_06_27 OWNER TO supabase_admin;

--
-- Name: messages_2026_06_28; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_06_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_06_28 OWNER TO supabase_admin;

--
-- Name: messages_2026_06_29; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_06_29 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_06_29 OWNER TO supabase_admin;

--
-- Name: messages_2026_06_30; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_06_30 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_06_30 OWNER TO supabase_admin;

--
-- Name: messages_2026_07_01; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_07_01 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_07_01 OWNER TO supabase_admin;

--
-- Name: messages_2026_07_02; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_07_02 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_07_02 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_namespaces OWNER TO supabase_storage_admin;

--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


ALTER TABLE storage.iceberg_tables OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: messages_2026_06_26; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_06_26 FOR VALUES FROM ('2026-06-26 00:00:00') TO ('2026-06-27 00:00:00');


--
-- Name: messages_2026_06_27; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_06_27 FOR VALUES FROM ('2026-06-27 00:00:00') TO ('2026-06-28 00:00:00');


--
-- Name: messages_2026_06_28; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_06_28 FOR VALUES FROM ('2026-06-28 00:00:00') TO ('2026-06-29 00:00:00');


--
-- Name: messages_2026_06_29; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_06_29 FOR VALUES FROM ('2026-06-29 00:00:00') TO ('2026-06-30 00:00:00');


--
-- Name: messages_2026_06_30; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_06_30 FOR VALUES FROM ('2026-06-30 00:00:00') TO ('2026-07-01 00:00:00');


--
-- Name: messages_2026_07_01; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_01 FOR VALUES FROM ('2026-07-01 00:00:00') TO ('2026-07-02 00:00:00');


--
-- Name: messages_2026_07_02; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_07_02 FOR VALUES FROM ('2026-07-02 00:00:00') TO ('2026-07-03 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
52c54a81-3ab6-4666-8036-f2aa4498b0a0	postgres_cdc_rls	{"region": "us-east-1", "db_host": "QhixI0o7PYIABziLUL4f0A==", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "PP8cB2+GIM7eRtFcyw8l3Ep9DWw7UoequjXSxjMZm15PNrrhma6I8nd28t/mto4/", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2026-06-29 14:21:36	2026-06-29 14:21:36
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2026-03-26 21:10:51
20220329161857	2026-03-26 21:10:51
20220410212326	2026-03-26 21:10:51
20220506102948	2026-03-26 21:10:51
20220527210857	2026-03-26 21:10:51
20220815211129	2026-03-26 21:10:51
20220815215024	2026-03-26 21:10:51
20220818141501	2026-03-26 21:10:51
20221018173709	2026-03-26 21:10:51
20221102172703	2026-03-26 21:10:51
20221223010058	2026-03-26 21:10:51
20230110180046	2026-03-26 21:10:51
20230810220907	2026-03-26 21:10:51
20230810220924	2026-03-26 21:10:51
20231024094642	2026-03-26 21:10:51
20240306114423	2026-03-26 21:10:51
20240418082835	2026-03-26 21:10:51
20240625211759	2026-03-26 21:10:51
20240704172020	2026-03-26 21:10:51
20240902173232	2026-03-26 21:10:51
20241106103258	2026-03-26 21:10:51
20250424203323	2026-03-26 21:10:51
20250613072131	2026-03-26 21:10:51
20250711044927	2026-03-26 21:10:51
20250811121559	2026-03-26 21:10:51
20250926223044	2026-03-26 21:10:51
20251204170944	2026-03-26 21:10:51
20251218000543	2026-03-26 21:10:51
20260209232800	2026-03-26 21:10:51
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb, max_client_presence_events_per_window, client_presence_window_ms) FROM stdin;
8b435b36-25f3-4c88-9972-8edf3b3884eb	realtime-dev	realtime-dev	I592o8tcolvAXJTOghq/zlJiTXvoxCshjXwCDJC7+f4hS97xcpwYXsYsmem/F5Do	200	2026-06-29 14:21:36	2026-06-29 14:21:36	100	postgres_cdc_rls	100000	100	100	f	\N	f	f	67	gen_rpc	1000	3000	\N	\N
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	4804dbd8-1e3a-4f77-98d7-60480d2fa791	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"esteban@gmail.com","user_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","user_phone":""}}	2026-06-18 15:13:14.326272+00	
00000000-0000-0000-0000-000000000000	ea6d47ee-e630-4b96-8978-0b7aa0ceebee	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-18 15:13:21.0374+00	
00000000-0000-0000-0000-000000000000	e85c6f2b-562b-4237-ba9e-7fac5cf9d545	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-18 15:14:18.235965+00	
00000000-0000-0000-0000-000000000000	3f61f2bc-93ec-4ab4-bdfc-fcafb0908df7	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-18 15:15:06.694152+00	
00000000-0000-0000-0000-000000000000	6227df04-2678-48ae-a087-9c9c455683e0	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-18 15:24:41.675684+00	
00000000-0000-0000-0000-000000000000	2d9dbe9a-ee58-402b-baf7-459da5603439	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 16:22:43.056945+00	
00000000-0000-0000-0000-000000000000	28978764-36d0-4498-a1c2-d51fa74fec0b	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 16:22:43.065677+00	
00000000-0000-0000-0000-000000000000	3822ec6d-bc39-447f-9a32-d336090ccd0b	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 17:21:12.820176+00	
00000000-0000-0000-0000-000000000000	ed3885ff-1623-4872-bde4-c2f6ae06645b	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 17:21:12.822029+00	
00000000-0000-0000-0000-000000000000	a4b0b613-a575-4076-8d95-b80fd90e08b5	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 18:19:12.816421+00	
00000000-0000-0000-0000-000000000000	17742ec0-f6c4-4db2-afaf-3ed20401119f	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 18:19:12.818362+00	
00000000-0000-0000-0000-000000000000	9306a812-b960-4255-910f-5442faedb727	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 19:17:12.814956+00	
00000000-0000-0000-0000-000000000000	baf47750-0dd1-40cd-8d52-396b249fc3aa	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 19:17:12.817049+00	
00000000-0000-0000-0000-000000000000	f98f6c20-d014-401a-b7e7-06cfbad7d6b5	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 20:15:12.992866+00	
00000000-0000-0000-0000-000000000000	0e8c975a-d4ab-45b2-8772-9eadfbc39362	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 20:15:13.000255+00	
00000000-0000-0000-0000-000000000000	df3bbd6c-615e-4a55-a14c-e598ea63025f	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 21:13:42.802272+00	
00000000-0000-0000-0000-000000000000	9a402fcb-129f-44be-b2fb-387babcc0a8b	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 21:13:42.804203+00	
00000000-0000-0000-0000-000000000000	5b22afe9-556a-4ac1-b729-da402368d1ab	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 22:21:15.799831+00	
00000000-0000-0000-0000-000000000000	0d95c15d-2108-4b35-943c-79d6356a5da4	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-18 22:21:15.801888+00	
00000000-0000-0000-0000-000000000000	d6b5122f-1c20-4eae-81a8-c9aee99163c3	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 00:00:29.399705+00	
00000000-0000-0000-0000-000000000000	00b60b43-2e32-4307-93b5-6f753ea6dc98	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-19 00:58:58.684111+00	
00000000-0000-0000-0000-000000000000	abc2257c-4893-41df-971d-9a5526aa3e44	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-19 00:58:58.686778+00	
00000000-0000-0000-0000-000000000000	d8d3c9dd-9e22-418f-8bd0-226cd9ebf2b5	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 01:34:06.69133+00	
00000000-0000-0000-0000-000000000000	81eb0dcd-bbcf-4de8-8637-22c8b8feb5f3	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 01:38:09.548933+00	
00000000-0000-0000-0000-000000000000	5cc591f8-ad85-40c2-957d-21b92e4d79d4	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 01:50:12.298692+00	
00000000-0000-0000-0000-000000000000	88ae15d6-dafd-4ff4-b912-319787efa8bc	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 01:51:41.887438+00	
00000000-0000-0000-0000-000000000000	ea779ab7-3e92-4759-82d3-9e2553cf045d	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 01:51:54.060391+00	
00000000-0000-0000-0000-000000000000	193885d0-c1cb-4ddd-822e-9b3057113e57	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 02:54:34.411078+00	
00000000-0000-0000-0000-000000000000	e57d45d9-aca3-47d4-a1dd-1b69adfe45f0	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 02:57:40.026859+00	
00000000-0000-0000-0000-000000000000	4280d7e5-28ce-4fd4-8772-ac43c9b1dbe2	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 02:58:04.309185+00	
00000000-0000-0000-0000-000000000000	2e6ff6ed-abc3-41b9-8d19-498e8dc18ea3	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 02:58:15.246251+00	
00000000-0000-0000-0000-000000000000	f18d09ab-84f5-4080-b671-6deae3109a62	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 02:59:02.805104+00	
00000000-0000-0000-0000-000000000000	a0555eb2-eea1-4c1e-8fb7-c3bb0a24cb69	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 02:59:06.252893+00	
00000000-0000-0000-0000-000000000000	2216aa8c-6cee-43cd-bc90-7d043463a292	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 22:39:38.844583+00	
00000000-0000-0000-0000-000000000000	9939fbb4-bcbe-423f-b06e-c8f5eaeb7214	{"action":"logout","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-19 22:41:09.681319+00	
00000000-0000-0000-0000-000000000000	29c200f8-39a6-4f3e-8c09-d3ec313196c3	{"action":"login","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-19 22:41:22.176797+00	
00000000-0000-0000-0000-000000000000	323236bc-d12b-4355-87f0-e3e8ff633415	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 00:04:51.403785+00	
00000000-0000-0000-0000-000000000000	f3f4ff90-2082-4e71-8a2b-760fea943c76	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 00:04:51.406173+00	
00000000-0000-0000-0000-000000000000	dfd085d6-836d-4dc0-9f96-138dcb26f0c3	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 01:02:54.074513+00	
00000000-0000-0000-0000-000000000000	293305ff-fb7a-4236-ad0a-b79a33a22e23	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 01:02:54.077923+00	
00000000-0000-0000-0000-000000000000	c656d87e-8e9d-44c7-85b3-e28a3873ab96	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 02:06:10.767685+00	
00000000-0000-0000-0000-000000000000	cb41c0da-92a7-4711-98c7-8d6a17f69fc9	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 02:06:10.782888+00	
00000000-0000-0000-0000-000000000000	5c7aada1-f634-452d-8a88-8bfc6a09fb0a	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 03:04:10.526514+00	
00000000-0000-0000-0000-000000000000	b88b5763-3982-46ff-9fb8-e88e14042ff3	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-20 03:04:10.530845+00	
00000000-0000-0000-0000-000000000000	a8f7aef6-521e-4502-b451-8ee8ed54fb4d	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 01:50:19.557381+00	
00000000-0000-0000-0000-000000000000	bf802422-6de1-4bfe-ba3e-a530da6f46f0	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 01:50:19.566094+00	
00000000-0000-0000-0000-000000000000	5d9c4ac0-9b71-43a6-bc2f-5b0419b1f36e	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 01:50:20.749299+00	
00000000-0000-0000-0000-000000000000	9da090ac-6f99-44ee-a9fb-64102b559d49	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 01:50:21.603272+00	
00000000-0000-0000-0000-000000000000	ba3e5d27-5137-464d-b01c-df841beed672	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"puchin@gmail.com","user_id":"94d3821f-b33f-45f5-aede-68decf273c04","user_phone":""}}	2026-06-22 02:10:48.201914+00	
00000000-0000-0000-0000-000000000000	f0e07ead-cb0c-4e5d-ab2a-76d419710b60	{"action":"login","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-22 02:10:52.574332+00	
00000000-0000-0000-0000-000000000000	9cf77e0b-ae32-47bf-bf27-ab5a39d3e546	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 02:48:38.778083+00	
00000000-0000-0000-0000-000000000000	547799ff-94be-4da4-9748-ecd6215767eb	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 02:48:38.780683+00	
00000000-0000-0000-0000-000000000000	e830ef21-5cd6-42ac-b958-e93fd1e45a6a	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 03:11:38.482694+00	
00000000-0000-0000-0000-000000000000	f371fa9e-8259-4b5a-9ac6-a3967e3e200c	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 03:11:38.48547+00	
00000000-0000-0000-0000-000000000000	d0781e45-e3c6-47a6-bf54-dd7588c335e2	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 03:46:38.968825+00	
00000000-0000-0000-0000-000000000000	425b8a9c-55dc-49ae-8226-0d2ab76f534c	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 03:46:38.984723+00	
00000000-0000-0000-0000-000000000000	17d53ae3-fcb9-4804-a871-90670f3fc7b0	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 13:01:26.07317+00	
00000000-0000-0000-0000-000000000000	ea60a7c2-1088-424e-87f4-8c73c8f4ab63	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 13:01:26.082502+00	
00000000-0000-0000-0000-000000000000	d14f5dc2-caeb-4d5f-aaff-21284fe795fd	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 13:01:26.919889+00	
00000000-0000-0000-0000-000000000000	8a6ef2f3-9fb0-4139-9f31-11fe0eff1bf5	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 13:01:27.453406+00	
00000000-0000-0000-0000-000000000000	1f5ed55a-86f6-4bf2-abd1-e02904190e1e	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 14:29:40.466337+00	
00000000-0000-0000-0000-000000000000	411eb15e-ebbf-4390-8793-73deef458116	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 14:29:40.469127+00	
00000000-0000-0000-0000-000000000000	2b73df70-ceb9-4c41-b74e-1645d2eb5d13	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:31:38.658448+00	
00000000-0000-0000-0000-000000000000	67288cf5-94b2-4314-9f28-f1e9e16919e0	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:31:38.671994+00	
00000000-0000-0000-0000-000000000000	901560ec-320e-458f-b7a3-0dd42af3f832	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:42:57.426153+00	
00000000-0000-0000-0000-000000000000	56f598f2-6394-4e8b-82da-70f166532b18	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:42:57.42856+00	
00000000-0000-0000-0000-000000000000	dc77fdb3-0ac1-4b46-8ab7-227603b3d3b4	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:42:57.851151+00	
00000000-0000-0000-0000-000000000000	1629bab0-399a-46ed-bbeb-8300f1063090	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 16:42:58.24054+00	
00000000-0000-0000-0000-000000000000	b11d42bf-ffe8-446e-9563-30b20daac987	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 17:29:46.260656+00	
00000000-0000-0000-0000-000000000000	5a769b54-cfc1-4a5b-9b01-4e348fc54dca	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 17:29:46.263307+00	
00000000-0000-0000-0000-000000000000	c4573090-916a-4a87-9208-f5461d56d23b	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 17:41:19.11263+00	
00000000-0000-0000-0000-000000000000	85c0e0de-6e6c-4878-bbe4-87952e94871d	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 17:41:19.114866+00	
00000000-0000-0000-0000-000000000000	14fb2de8-25f3-429d-821c-cf85b6455475	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 18:39:49.151272+00	
00000000-0000-0000-0000-000000000000	94f0beda-7dd4-45f8-81d2-c2d949128e2c	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 18:39:49.153735+00	
00000000-0000-0000-0000-000000000000	9d2c28ed-135e-4d12-b38d-e9512c22f3be	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 19:49:50.050557+00	
00000000-0000-0000-0000-000000000000	f90b95b2-c71a-488d-9cc5-92e7e13cfa79	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 19:49:50.054331+00	
00000000-0000-0000-0000-000000000000	3d99f2c5-3154-4dcf-bc8f-b1bfc1c50374	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 20:23:02.705735+00	
00000000-0000-0000-0000-000000000000	0ff09e0e-57a6-4887-b739-6c56b0008f34	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 20:23:02.708212+00	
00000000-0000-0000-0000-000000000000	8d29b646-4ff5-4750-9ccd-1832fe216ad6	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 20:48:19.963959+00	
00000000-0000-0000-0000-000000000000	d7e69411-3155-4892-a866-b0aef124702a	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 20:48:19.966339+00	
00000000-0000-0000-0000-000000000000	81dcd3ec-996b-408b-b856-94498152994b	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 21:28:19.016268+00	
00000000-0000-0000-0000-000000000000	a29cb455-0758-4057-b0fa-25e79692e361	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 21:28:19.028868+00	
00000000-0000-0000-0000-000000000000	77f3538f-d821-40b2-b2ac-11fb3c0a0fe5	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 21:46:45.853222+00	
00000000-0000-0000-0000-000000000000	03ff5438-c3ff-4e0c-b341-1821b2167544	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 21:46:45.855402+00	
00000000-0000-0000-0000-000000000000	f457e616-2ce4-4269-8538-30fef33c90aa	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:27:36.457334+00	
00000000-0000-0000-0000-000000000000	3ba14137-eae5-4083-93c2-9efc1ea85eb6	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:27:36.459772+00	
00000000-0000-0000-0000-000000000000	3faba044-a267-4f36-bb21-8fb59eb52669	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:27:43.650046+00	
00000000-0000-0000-0000-000000000000	df8c6aa4-96cd-49d2-ba5a-64bfd20ed924	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:27:44.91157+00	
00000000-0000-0000-0000-000000000000	0c3c3570-034b-4028-9675-70e5f0f4b22f	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:44:46.757468+00	
00000000-0000-0000-0000-000000000000	e3f67393-7c78-46b8-88c8-4f4ac60d0ee9	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 22:44:46.759921+00	
00000000-0000-0000-0000-000000000000	bff939af-e3f2-49ce-8572-05f40ba0b197	{"action":"token_refreshed","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 23:43:05.528493+00	
00000000-0000-0000-0000-000000000000	d72a2d22-0915-405e-9e8c-121f92f6ac0c	{"action":"token_revoked","actor_id":"94d3821f-b33f-45f5-aede-68decf273c04","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 23:43:05.531151+00	
00000000-0000-0000-0000-000000000000	a0c7c54d-7b4f-4abe-86d4-11e996715a6c	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"puchaina@gmail.com","user_id":"e4783b22-3e7c-4434-a6c7-2299281741bf","user_phone":""}}	2026-06-22 23:47:24.595516+00	
00000000-0000-0000-0000-000000000000	8ede72de-c4c3-4632-b87a-e7dbf3c97857	{"action":"token_refreshed","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 23:47:44.243022+00	
00000000-0000-0000-0000-000000000000	6ebf3bfc-a754-4801-b1f2-c6f8d775dcaf	{"action":"token_revoked","actor_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-22 23:47:44.245282+00	
00000000-0000-0000-0000-000000000000	a74c7d97-b1d6-4b9e-8b46-b00109adb80b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"puchin@gmail.com","user_id":"94d3821f-b33f-45f5-aede-68decf273c04","user_phone":""}}	2026-06-22 23:56:33.648627+00	
00000000-0000-0000-0000-000000000000	beeadd03-ef0e-4fb2-a59b-3fb9adcef5ad	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"puchaina@gmail.com","user_id":"e4783b22-3e7c-4434-a6c7-2299281741bf","user_phone":""}}	2026-06-22 23:56:33.648469+00	
00000000-0000-0000-0000-000000000000	2aff99c0-4e3f-4315-9b07-5e3dda5831c8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"esteban@gmail.com","user_id":"d6cf5cb5-d088-4c47-81a5-49ef93583e26","user_phone":""}}	2026-06-22 23:56:33.648361+00	
00000000-0000-0000-0000-000000000000	f0986370-03a5-4d3a-9c33-5f98739194a4	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"esteban@gmail.com","user_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","user_phone":""}}	2026-06-22 23:57:11.250778+00	
00000000-0000-0000-0000-000000000000	6d2dab59-1a4f-4539-b822-c5471c907bb9	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-22 23:57:20.033579+00	
00000000-0000-0000-0000-000000000000	baafcfb5-cbfb-4efd-ad1d-d8088236b3f7	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-23 02:51:39.867476+00	
00000000-0000-0000-0000-000000000000	385cebe9-361c-4956-8450-cb6d7e6e5fd1	{"action":"token_revoked","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-23 02:51:39.883297+00	
00000000-0000-0000-0000-000000000000	9ee36e95-5ace-485f-b003-927664926a01	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"pauli@gmail.com","user_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","user_phone":""}}	2026-06-23 02:52:27.721991+00	
00000000-0000-0000-0000-000000000000	793e4207-a75e-4827-b01d-a8a7fe1943dd	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-23 02:53:15.711961+00	
00000000-0000-0000-0000-000000000000	c48660bf-33cd-4f87-9115-1c61e8e900cf	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 02:53:18.162593+00	
00000000-0000-0000-0000-000000000000	e4df7c38-9f03-461c-9ac9-0ed119c852a0	{"action":"logout","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-23 02:53:21.071806+00	
00000000-0000-0000-0000-000000000000	4566e5b9-60c0-43f2-bda9-87f9b76f2391	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 02:53:32.880587+00	
00000000-0000-0000-0000-000000000000	ed01c77d-7d0c-4971-86a4-7a2a6be0b7d2	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 03:07:51.370029+00	
00000000-0000-0000-0000-000000000000	933bbe86-6688-4232-a7bb-7e54d104bf86	{"action":"logout","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-23 03:07:56.582355+00	
00000000-0000-0000-0000-000000000000	251a7880-b0c4-4312-b1c5-31261f318593	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 03:08:16.995254+00	
00000000-0000-0000-0000-000000000000	c12b15ec-4b59-491b-af95-10b463a023cb	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 03:08:23.417786+00	
00000000-0000-0000-0000-000000000000	4549fdc6-3df4-447d-ba94-6256498d1320	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 03:08:24.073461+00	
00000000-0000-0000-0000-000000000000	eb8f47b8-1d40-4cee-bb92-a9e67c25cb63	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-23 03:09:09.938225+00	
00000000-0000-0000-0000-000000000000	4f09428b-0756-4386-a1bf-fd67a5a130f2	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-23 03:10:51.374857+00	
00000000-0000-0000-0000-000000000000	6478c0c4-953c-4c7a-8ed7-659d28b2dc5f	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 01:10:11.29446+00	
00000000-0000-0000-0000-000000000000	d30e895a-48dc-466f-a23c-f9bc1487f962	{"action":"token_revoked","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 01:10:11.302337+00	
00000000-0000-0000-0000-000000000000	417d866a-87cb-4851-8b2c-b6b82050384d	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 01:10:11.795521+00	
00000000-0000-0000-0000-000000000000	776937be-69a7-49fe-842d-49c750d9d39a	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 01:10:12.745654+00	
00000000-0000-0000-0000-000000000000	9425059b-b4fc-47cb-981b-21611ae60932	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 01:10:54.023059+00	
00000000-0000-0000-0000-000000000000	cf4fcbc9-a11d-4bce-a5b4-e19f89fd24ff	{"action":"token_refreshed","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 02:57:54.775862+00	
00000000-0000-0000-0000-000000000000	5f6469fb-e8ce-42e5-86ee-2b12c2a6117e	{"action":"token_revoked","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 02:57:54.779036+00	
00000000-0000-0000-0000-000000000000	947b8408-832e-4200-b4d8-7aec7c736962	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:00:40.048409+00	
00000000-0000-0000-0000-000000000000	b4c09040-bd32-4705-b4a8-a8ae39242c83	{"action":"token_revoked","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:00:40.052518+00	
00000000-0000-0000-0000-000000000000	bdd2fbd4-32de-4624-8452-75e9aab66e78	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:00:40.674888+00	
00000000-0000-0000-0000-000000000000	07fd6e30-f5da-4b52-8bd5-a3a01721f743	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:00:41.021828+00	
00000000-0000-0000-0000-000000000000	9014f1a4-213d-47c8-a1ba-77e6c510da20	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 03:29:23.124593+00	
00000000-0000-0000-0000-000000000000	1d7d7640-3af6-49d2-bca4-4ac9c5fda8db	{"action":"token_refreshed","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:57:23.488102+00	
00000000-0000-0000-0000-000000000000	b7353ae7-b5c8-4be0-a751-bfc652c91605	{"action":"token_revoked","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 03:57:23.491043+00	
00000000-0000-0000-0000-000000000000	cf8715d1-c22a-4d21-80c4-fbdcdb86b3db	{"action":"token_refreshed","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 13:29:40.230589+00	
00000000-0000-0000-0000-000000000000	232caff6-4cb1-4432-8848-d268ddf527bf	{"action":"token_revoked","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 13:29:40.238503+00	
00000000-0000-0000-0000-000000000000	06826183-1a7b-403a-be50-a38c881162a1	{"action":"token_refreshed","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 13:29:40.727108+00	
00000000-0000-0000-0000-000000000000	e77b5202-a68e-4908-a0ba-c3219f3410db	{"action":"token_refreshed","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 13:29:41.634032+00	
00000000-0000-0000-0000-000000000000	0dbc0618-9670-4831-b426-9cf0fdac67e8	{"action":"logout","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 13:34:49.50376+00	
00000000-0000-0000-0000-000000000000	566e4911-ce0c-4dad-8c0e-8af6accf50af	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 14:50:41.69656+00	
00000000-0000-0000-0000-000000000000	82ee24f3-7cd8-4b4f-904b-61bd0cabc0f0	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 14:50:53.107304+00	
00000000-0000-0000-0000-000000000000	126e2731-2970-46ba-9a1b-a847a401bc86	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 14:52:04.301451+00	
00000000-0000-0000-0000-000000000000	523018e5-a4d5-46c7-9f77-d5537e622396	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 14:52:08.446568+00	
00000000-0000-0000-0000-000000000000	d58efc31-bbe6-4969-abdd-575324b7c9ec	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 14:52:26.58092+00	
00000000-0000-0000-0000-000000000000	2eae65b1-fe26-4928-a779-430d09685e71	{"action":"logout","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 14:54:34.93565+00	
00000000-0000-0000-0000-000000000000	407ecd26-5a06-41af-8928-a30c6f2e1018	{"action":"login","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 14:55:07.953219+00	
00000000-0000-0000-0000-000000000000	b0932ab1-de07-4ab7-9c30-dcdd4e44972a	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 16:11:10.594039+00	
00000000-0000-0000-0000-000000000000	581b2f2a-797b-466f-9a3c-30a26471a5e1	{"action":"token_revoked","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 16:11:10.596447+00	
00000000-0000-0000-0000-000000000000	e14dc53c-daf0-4b5b-b5c7-3e48228c6e07	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:10:22.665916+00	
00000000-0000-0000-0000-000000000000	00672e95-957f-4e46-9f30-c7606a499bff	{"action":"token_revoked","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:10:22.668319+00	
00000000-0000-0000-0000-000000000000	6cc47308-69e2-4d3a-823d-186d728169b6	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:10:22.896113+00	
00000000-0000-0000-0000-000000000000	ac8030c3-8100-404d-8289-44d02bbfdb67	{"action":"token_refreshed","actor_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 17:11:31.81643+00	
00000000-0000-0000-0000-000000000000	53ffa897-cba9-4890-8fd0-63ccbe84b392	{"action":"login","actor_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 17:11:48.054804+00	
00000000-0000-0000-0000-000000000000	82dd508d-7528-45e5-879d-fa877e5c2716	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"esteban@gmail.com","user_id":"b744733e-9cfe-45ff-a447-31e72525fd1f","user_phone":""}}	2026-06-24 17:25:45.068422+00	
00000000-0000-0000-0000-000000000000	32006d21-18ab-4884-8919-d29d838b276b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"pauli@gmail.com","user_id":"0d81b1ee-0ca1-4c31-b1ba-7721ab4f3f8d","user_phone":""}}	2026-06-24 17:25:45.06858+00	
00000000-0000-0000-0000-000000000000	15aea78f-082b-45bf-a910-bca9bb8f195d	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"esteban@gmail.com","user_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","user_phone":""}}	2026-06-24 17:40:18.703698+00	
00000000-0000-0000-0000-000000000000	3005b499-99c3-4753-b91e-338c8aac1b25	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 17:41:07.512635+00	
00000000-0000-0000-0000-000000000000	73244814-d7d1-4f1a-8ccb-a6e240bb1a3d	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 20:30:47.556387+00	
00000000-0000-0000-0000-000000000000	071a9648-4f21-4d70-8091-e9bcdc54c5da	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 20:30:47.570207+00	
00000000-0000-0000-0000-000000000000	dcfb0c49-cfa5-4e0d-aaa3-44c87bd0106d	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 20:55:14.023099+00	
00000000-0000-0000-0000-000000000000	602dddc5-a5ee-4d7b-9b08-33c595648a34	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:53:14.524641+00	
00000000-0000-0000-0000-000000000000	d2e1f53c-7781-4624-b426-1ff97a99c176	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:53:14.526782+00	
00000000-0000-0000-0000-000000000000	5a997627-928e-4e6a-8092-48767483f187	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:58:31.80429+00	
00000000-0000-0000-0000-000000000000	740b91a6-26ae-477b-a596-ed4780f87158	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:58:31.808042+00	
00000000-0000-0000-0000-000000000000	bfb72744-17c9-44e2-91c2-eb82c3acc4dc	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:58:31.907963+00	
00000000-0000-0000-0000-000000000000	b6ad444c-7865-4609-8b78-af0b4a83adc3	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:58:32.084542+00	
00000000-0000-0000-0000-000000000000	02881261-4885-411e-8c29-d1372b14296e	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 21:58:32.170395+00	
00000000-0000-0000-0000-000000000000	65b870c8-724a-4649-b379-f014c9fba6cf	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 22:09:18.354214+00	
00000000-0000-0000-0000-000000000000	755bd25d-a250-4b8b-8cfa-a579a4d1b4a3	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 22:51:22.357168+00	
00000000-0000-0000-0000-000000000000	a3e9058d-d142-4c44-a91d-1395981d4c39	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 22:51:22.35957+00	
00000000-0000-0000-0000-000000000000	6e187e8b-a1a5-4252-9477-2a4e62eb3db4	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 23:07:18.607013+00	
00000000-0000-0000-0000-000000000000	44706140-8aa7-4479-a714-0395b05125c1	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-24 23:07:18.609534+00	
00000000-0000-0000-0000-000000000000	f04b03ab-04aa-47e4-ade8-b66433ee7fc0	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"pauli@gmail.com","user_id":"4656c837-6b1c-4cb0-a386-2842def95b59","user_phone":""}}	2026-06-24 23:22:42.236861+00	
00000000-0000-0000-0000-000000000000	d48e6a68-bd00-4da9-a3bd-167cc18edf23	{"action":"logout","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 23:22:45.756411+00	
00000000-0000-0000-0000-000000000000	8b952ba6-1ae9-4c67-aef9-83ec67770407	{"action":"login","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 23:24:59.459216+00	
00000000-0000-0000-0000-000000000000	85397132-177d-419f-9efd-be36b93b70a4	{"action":"logout","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-24 23:25:10.176252+00	
00000000-0000-0000-0000-000000000000	4a63e81f-faba-4758-9779-a10d5ac6adbd	{"action":"login","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 23:26:22.293066+00	
00000000-0000-0000-0000-000000000000	36dffd12-102e-47a8-9c57-04dbc9f555b5	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-24 23:26:44.62549+00	
00000000-0000-0000-0000-000000000000	1001e712-6b93-4aa5-9f5d-9c076aaf15db	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:24:47.342446+00	
00000000-0000-0000-0000-000000000000	f4faae00-d70d-459e-9d56-855dc3bcb210	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 00:24:47.346148+00	
00000000-0000-0000-0000-000000000000	6790d639-7634-48b4-8798-e010b638655f	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 01:22:51.029446+00	
00000000-0000-0000-0000-000000000000	654832b4-cf72-46a4-aaa4-ebca791aedff	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 01:22:51.03281+00	
00000000-0000-0000-0000-000000000000	b9095e4f-8979-4e0d-8c61-a8b6f6605b8e	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 01:23:03.686938+00	
00000000-0000-0000-0000-000000000000	5366e9ef-bb6f-4116-bc20-25ed79d4cbb9	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 01:23:03.689806+00	
00000000-0000-0000-0000-000000000000	2751fe41-9543-4995-9a1d-976706c0f098	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 02:21:12.661771+00	
00000000-0000-0000-0000-000000000000	3c326e94-45de-4366-a6b5-6113423c96e0	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 02:21:12.676602+00	
00000000-0000-0000-0000-000000000000	cbfdfa79-d666-4e68-b39d-aaba39f98ad5	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 02:42:18.554203+00	
00000000-0000-0000-0000-000000000000	e9e466ea-b1e4-4e99-acaf-ea16543dd2eb	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 02:42:18.556682+00	
00000000-0000-0000-0000-000000000000	44c84d12-2b6a-480c-85e4-5a4a284b67af	{"action":"logout","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 03:10:46.561171+00	
00000000-0000-0000-0000-000000000000	c9405376-64bb-45c4-b1cc-fc14f1e782f8	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 03:11:14.554316+00	
00000000-0000-0000-0000-000000000000	4fc66a2a-38a3-426e-9eff-34cd1fde7f3b	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 03:47:42.887599+00	
00000000-0000-0000-0000-000000000000	a3d6636f-8be0-4b31-82dd-6c720e04354b	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 03:47:42.891375+00	
00000000-0000-0000-0000-000000000000	1a84bd2a-e851-4307-9bf5-c110eabec800	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 03:47:43.093975+00	
00000000-0000-0000-0000-000000000000	f1200469-6c4f-49fe-9c6a-ad7f00910422	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 04:04:25.880752+00	
00000000-0000-0000-0000-000000000000	5afbefc1-2d88-4d32-b6ff-f784ae46415a	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 04:09:16.692455+00	
00000000-0000-0000-0000-000000000000	ea61769c-829a-48ba-a0ba-9b4b3682f121	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 04:09:16.695238+00	
00000000-0000-0000-0000-000000000000	633082b0-1a7e-40cd-8786-a23dd89722a6	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"provider":"email","user_email":"puchin@gmail.com","user_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","user_phone":""}}	2026-06-25 04:28:49.119468+00	
00000000-0000-0000-0000-000000000000	220fa316-3899-47bb-a527-5b55c3feb866	{"action":"logout","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 04:29:00.70339+00	
00000000-0000-0000-0000-000000000000	744538e1-a45b-4dec-906b-51a81081a784	{"action":"login","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 04:29:06.486961+00	
00000000-0000-0000-0000-000000000000	7dd3c596-b998-4d3b-8bf1-f2f50d3b48e2	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:16.62491+00	
00000000-0000-0000-0000-000000000000	177d6407-7a5e-4e46-93ab-ffbf8f17b049	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:16.631299+00	
00000000-0000-0000-0000-000000000000	b7770b17-686b-426c-9330-c38717859e3f	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:16.826148+00	
00000000-0000-0000-0000-000000000000	a0a7c0df-1487-4a28-88b8-568f9fb63f7c	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:17.695265+00	
00000000-0000-0000-0000-000000000000	75c84b13-b085-4f6c-b171-cf6d06e4bd7a	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:17.916859+00	
00000000-0000-0000-0000-000000000000	257a9e9f-99f6-4285-9b6f-c727d8c15d21	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:39.911905+00	
00000000-0000-0000-0000-000000000000	653d49d1-baa5-41db-9ee0-68cd52a0056a	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:39.915125+00	
00000000-0000-0000-0000-000000000000	64ee3883-73ef-4128-b321-cdee5e6696ad	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:40.130451+00	
00000000-0000-0000-0000-000000000000	d933b3f0-8ed3-419e-bc9d-6141b979fed1	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:40.737732+00	
00000000-0000-0000-0000-000000000000	d6447d93-d33c-4042-99e7-9513b0073a00	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 14:46:40.999342+00	
00000000-0000-0000-0000-000000000000	d045e6e6-09c3-4efd-b750-0ff30005b926	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:44:23.311748+00	
00000000-0000-0000-0000-000000000000	455da214-a726-4700-882d-eb07a07a9659	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:44:23.31424+00	
00000000-0000-0000-0000-000000000000	b353c021-7e9e-48ee-8027-0c9ed2d67e1c	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:45:04.701612+00	
00000000-0000-0000-0000-000000000000	21328e76-6d3e-4e36-9226-2ad016b067f4	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 15:45:04.704063+00	
00000000-0000-0000-0000-000000000000	fcd806be-c75e-4c74-b653-2fe5421f3549	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 16:42:23.327904+00	
00000000-0000-0000-0000-000000000000	53669c0f-ebde-4e3c-95c5-45cabc659dad	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 16:42:23.330527+00	
00000000-0000-0000-0000-000000000000	0cbadf78-1efc-4144-9960-d1b8014aac30	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:42:29.09657+00	
00000000-0000-0000-0000-000000000000	fe63b71b-0c86-42fb-85c1-8e8879c6a4bb	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:42:29.099978+00	
00000000-0000-0000-0000-000000000000	7b56940b-08e5-4cb3-ab8f-45253dc2b400	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:42:32.737236+00	
00000000-0000-0000-0000-000000000000	500f9813-ecd0-4ab8-9688-8a2ff2c9b7e3	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 17:42:32.739992+00	
00000000-0000-0000-0000-000000000000	09a7615a-2418-4474-a3bf-c490f6eed17e	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:41:51.75338+00	
00000000-0000-0000-0000-000000000000	10b8987e-a1af-442e-bd5f-efa9bde46526	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 18:41:51.755555+00	
00000000-0000-0000-0000-000000000000	e41d2ee7-f97c-434c-8f7d-7d52d55212df	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 19:40:04.585777+00	
00000000-0000-0000-0000-000000000000	bd3f1424-3ea3-47fb-aa56-427ad114cc0e	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 19:40:04.588049+00	
00000000-0000-0000-0000-000000000000	0e06840a-e48a-427f-9ab1-b58e436285d0	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 20:19:11.921024+00	
00000000-0000-0000-0000-000000000000	aa1a794f-9066-4bc4-a7cb-fd68b37cf38a	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 20:19:11.92496+00	
00000000-0000-0000-0000-000000000000	173a2691-2cd9-44e3-a984-41dd927e69bb	{"action":"logout","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-25 20:29:57.733612+00	
00000000-0000-0000-0000-000000000000	bebd9873-25b4-478a-bc58-e95e64b9d461	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 20:36:35.701318+00	
00000000-0000-0000-0000-000000000000	6d88712b-cea5-4a1f-ab62-88f67fe0afc3	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:24:05.978421+00	
00000000-0000-0000-0000-000000000000	3576e9ee-93f9-4ebb-80c7-fd7859e9ab03	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:24:05.994058+00	
00000000-0000-0000-0000-000000000000	5e7db957-7cec-4bc8-b4ac-ec4d5e98ff9f	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:24:07.337373+00	
00000000-0000-0000-0000-000000000000	8e0a2ee7-e0f9-4a71-a3a6-42d4417df3a7	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:24:07.544204+00	
00000000-0000-0000-0000-000000000000	35fdb782-52b4-4269-921d-368870ad9707	{"action":"login","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-25 21:30:35.668992+00	
00000000-0000-0000-0000-000000000000	62078b55-edcd-4955-ae06-60c90b021697	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:34:48.817646+00	
00000000-0000-0000-0000-000000000000	28fbb6c6-33bb-4eb0-8059-fc6dab0fb587	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-25 21:34:48.820277+00	
00000000-0000-0000-0000-000000000000	b1789947-190b-4ce3-a203-87d9d1b3d441	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 13:49:56.374801+00	
00000000-0000-0000-0000-000000000000	c13819c0-94ff-40c0-936d-d84fc0bb25bd	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 13:49:56.382116+00	
00000000-0000-0000-0000-000000000000	228aacb4-19be-4aa7-8546-d359b41d9735	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 13:49:57.436306+00	
00000000-0000-0000-0000-000000000000	76f7590e-04f7-4977-bfea-e4a3ae1e6647	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 13:49:57.643656+00	
00000000-0000-0000-0000-000000000000	d8256c25-9196-4098-b489-445b9d52f27c	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:02:10.389592+00	
00000000-0000-0000-0000-000000000000	328eb21f-3a77-427b-b56e-bd2a8d183346	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:02:10.392002+00	
00000000-0000-0000-0000-000000000000	e39ca102-1029-4f16-a0b5-75706f48c367	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:02:10.796188+00	
00000000-0000-0000-0000-000000000000	5f3341c4-a365-4a4f-afe5-4ca48e09dc6a	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:02:11.008557+00	
00000000-0000-0000-0000-000000000000	d7a82922-9412-4b53-acb3-4d8ed4939179	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:49:27.165753+00	
00000000-0000-0000-0000-000000000000	ba62dbd1-ace8-4eba-89d4-eed4e62f44e1	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:49:27.180953+00	
00000000-0000-0000-0000-000000000000	0384dca5-c1a7-41f6-810a-566a0156210a	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:49:27.653743+00	
00000000-0000-0000-0000-000000000000	3c1ee168-b8d0-4ff9-b37e-8ab95ab66761	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 14:49:27.856225+00	
00000000-0000-0000-0000-000000000000	cc4c6b8e-8b92-49d0-8a1e-8be6ebba6861	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:00:12.953843+00	
00000000-0000-0000-0000-000000000000	4bbcb282-1629-49a9-b869-82f0f26d5bc6	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:00:12.955968+00	
00000000-0000-0000-0000-000000000000	7dfafc74-505a-4534-8da8-3493e4977e65	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:58:31.002048+00	
00000000-0000-0000-0000-000000000000	ec75c5a5-4fef-44b7-b61b-bc682f39c62b	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 15:58:31.004327+00	
00000000-0000-0000-0000-000000000000	b23c7539-3f4f-47cf-8552-3eddac5b5968	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 16:56:32.267647+00	
00000000-0000-0000-0000-000000000000	822e193e-0e43-4f7e-a94b-e96dcf9d9a1d	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 16:56:32.270097+00	
00000000-0000-0000-0000-000000000000	33fb6726-c131-46e4-853f-f7bd352f0d33	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:15.477433+00	
00000000-0000-0000-0000-000000000000	405840e8-590a-4a7d-9d3e-dbc1b12791ba	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:15.479906+00	
00000000-0000-0000-0000-000000000000	d819f656-b520-4369-9e18-5162940316ba	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:15.701966+00	
00000000-0000-0000-0000-000000000000	21133847-4e92-4951-b3cf-233ae73339b1	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:16.159739+00	
00000000-0000-0000-0000-000000000000	d110af88-d843-45a0-971e-b47461a0be6c	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:16.384847+00	
00000000-0000-0000-0000-000000000000	60651474-3230-4ab4-b6fa-61e1bdb5e098	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:16.597732+00	
00000000-0000-0000-0000-000000000000	91263d42-5a86-421a-a95e-657fd3d3ee09	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:16.870851+00	
00000000-0000-0000-0000-000000000000	598d1f99-0ca0-4524-9c61-6df25cc95a71	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:17.135948+00	
00000000-0000-0000-0000-000000000000	2802e4d4-758f-4561-bfde-2f24861f0033	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:17.42559+00	
00000000-0000-0000-0000-000000000000	1a4ebaf7-6dcd-43b2-ac8d-d378109085d4	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:17.713023+00	
00000000-0000-0000-0000-000000000000	64467745-f993-414e-947e-de99d8881182	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:17.970189+00	
00000000-0000-0000-0000-000000000000	372ce095-84c6-4197-8a54-02da6035281f	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:18.244128+00	
00000000-0000-0000-0000-000000000000	5b9d35d0-cc63-48f2-bb09-c4c2a8292ae2	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:18.535749+00	
00000000-0000-0000-0000-000000000000	fb4135ea-0d04-44d9-bc2d-3479e27408d7	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:18.794527+00	
00000000-0000-0000-0000-000000000000	cff7ee73-77ea-48c1-8683-36fbaae7c76c	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:19.063648+00	
00000000-0000-0000-0000-000000000000	f2c3a343-1330-43c8-85f2-89260ce4e53b	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:19.322063+00	
00000000-0000-0000-0000-000000000000	174fce6e-ac56-45a6-9dc0-93867f5fb56d	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:19.596201+00	
00000000-0000-0000-0000-000000000000	cfae968f-1019-4a58-b822-946e25691b06	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:19.866829+00	
00000000-0000-0000-0000-000000000000	b476f6bd-3886-477c-9b52-04287487e3c0	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:20.133644+00	
00000000-0000-0000-0000-000000000000	c415c9da-88f0-4b3b-92f0-9a296b1a937a	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:20.409218+00	
00000000-0000-0000-0000-000000000000	489d0c41-b095-4d86-949d-2d2cd5b9db13	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:20.672106+00	
00000000-0000-0000-0000-000000000000	9e294a56-bac1-4bbe-b1a0-83037177f49c	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:20.922561+00	
00000000-0000-0000-0000-000000000000	93d54373-7d16-4da1-883e-26dc20d8052e	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:21.192274+00	
00000000-0000-0000-0000-000000000000	32d30fd7-4bfa-405f-acce-cb88dc434cea	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:21.460793+00	
00000000-0000-0000-0000-000000000000	63a7e0b7-abf0-4b76-b77a-1e7cbfb4b8d8	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:21.735281+00	
00000000-0000-0000-0000-000000000000	f3adbbec-e867-4a8a-8bb6-0665ae21cac1	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:21.999714+00	
00000000-0000-0000-0000-000000000000	361f8eb9-5ccb-4125-b475-9276656ad2b4	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:22.269412+00	
00000000-0000-0000-0000-000000000000	8ccc236c-d4ee-4ee8-9cbe-c0099e629cd2	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:22.539119+00	
00000000-0000-0000-0000-000000000000	e51d1dc0-3ccc-4f7d-99bc-f9beaece8726	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:22.825692+00	
00000000-0000-0000-0000-000000000000	5e814b3c-e761-47d3-a914-5652f4ff2e57	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:23.079589+00	
00000000-0000-0000-0000-000000000000	a2188166-aece-44cc-8576-a71ff48e7dd5	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:23.375378+00	
00000000-0000-0000-0000-000000000000	0345992e-5935-4592-b23f-aa941c1cad52	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:23.707048+00	
00000000-0000-0000-0000-000000000000	c9e0834d-3f21-4ec2-b415-9050da14f724	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:23.758472+00	
00000000-0000-0000-0000-000000000000	25336739-9967-4dfd-8d94-b5f204066846	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:23.98456+00	
00000000-0000-0000-0000-000000000000	a427c5c0-dc4b-4727-a4d6-18a458b234da	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:24.303706+00	
00000000-0000-0000-0000-000000000000	583cdc9a-ed4b-4976-85ce-9083c3e909f9	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:24.426228+00	
00000000-0000-0000-0000-000000000000	ed9c6dfd-9d0a-43a0-a377-9249ec55dc4e	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:24.689844+00	
00000000-0000-0000-0000-000000000000	75938e82-eb02-4e90-928c-953818a51a0b	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:25.008139+00	
00000000-0000-0000-0000-000000000000	b7412aa1-e55d-42a6-9d5d-5b796ec9933b	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:25.106665+00	
00000000-0000-0000-0000-000000000000	afbb3fff-aff7-4420-b497-4398a9ef1f79	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:25.3145+00	
00000000-0000-0000-0000-000000000000	5e9eaf4a-17e9-4646-bc9f-5cf6bf8c3a08	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:25.699896+00	
00000000-0000-0000-0000-000000000000	51e6a6c3-3161-4aa4-b137-bc2d5805f997	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 17:47:25.980574+00	
00000000-0000-0000-0000-000000000000	ec80f5b5-1899-43cc-b1d1-34a74c548f76	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:05:22.366778+00	
00000000-0000-0000-0000-000000000000	2d63914b-eae3-47bc-8ff8-5eb06db9fd50	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:05:22.369486+00	
00000000-0000-0000-0000-000000000000	f5d71ab5-ed5e-40d0-ba5c-caf93f24b0c9	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:05:23.085009+00	
00000000-0000-0000-0000-000000000000	43b8e022-7270-4407-8867-4856cde2f79e	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 18:05:23.306047+00	
00000000-0000-0000-0000-000000000000	476bf68f-2a79-438b-b966-6b40e0f51105	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:03:28.397754+00	
00000000-0000-0000-0000-000000000000	989db29f-33c6-41b0-bc99-a4f043c180c8	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:03:28.40004+00	
00000000-0000-0000-0000-000000000000	0ba455a6-6e49-4510-9ff1-5903cd176409	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:13:38.460203+00	
00000000-0000-0000-0000-000000000000	106011fb-7151-439e-8d79-67b07289aa50	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 19:13:38.462907+00	
00000000-0000-0000-0000-000000000000	e9d0bbdc-739f-4d77-b7de-8c3a093f5a92	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 20:22:41.024322+00	
00000000-0000-0000-0000-000000000000	d518c66f-e220-47ac-802c-c0e02b00e912	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 20:22:41.02771+00	
00000000-0000-0000-0000-000000000000	032864ba-89d8-4929-81d6-616092302315	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:21:06.705314+00	
00000000-0000-0000-0000-000000000000	8a7f10bb-fca5-4f59-a23f-73d6571f80d4	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:21:06.724203+00	
00000000-0000-0000-0000-000000000000	79db1204-b0bb-4295-bfee-dc576ae1cf77	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:12.440532+00	
00000000-0000-0000-0000-000000000000	7129ce40-258b-4b08-aba3-26af66891145	{"action":"token_revoked","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:12.443745+00	
00000000-0000-0000-0000-000000000000	c2cb7ea9-448f-4be6-a5f1-91d94fbaca49	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:12.666684+00	
00000000-0000-0000-0000-000000000000	773c3f83-e6de-4a4e-9463-805806e94ea3	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:13.121582+00	
00000000-0000-0000-0000-000000000000	3f8037a7-b224-4491-a073-5663fec671b9	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:13.357071+00	
00000000-0000-0000-0000-000000000000	9461044c-72d4-4000-b713-f8215ad62538	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:13.613591+00	
00000000-0000-0000-0000-000000000000	86d7c6ef-e935-4ec1-b0f0-3c2211653bcd	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:14.076999+00	
00000000-0000-0000-0000-000000000000	d51f323d-f898-46c5-bc59-9caf43e863c4	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:14.51022+00	
00000000-0000-0000-0000-000000000000	d24ef0dc-56f0-42a0-bd72-a2b338ea09cb	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:14.923175+00	
00000000-0000-0000-0000-000000000000	5c39a9a1-7814-43d5-89be-d2493be7ce97	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:15.325527+00	
00000000-0000-0000-0000-000000000000	5bd650a7-f1c0-4a94-9425-cc7773bdd127	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:15.724658+00	
00000000-0000-0000-0000-000000000000	56a0ffa3-b21d-446f-b5c3-3101fb3b1b78	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:16.132074+00	
00000000-0000-0000-0000-000000000000	608a8a99-7cfe-4795-9d08-dfb3dbca8ecf	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:16.571947+00	
00000000-0000-0000-0000-000000000000	e599f048-48af-469e-aad6-9439533b95f9	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:16.985873+00	
00000000-0000-0000-0000-000000000000	0b7a35e5-3303-41bc-85db-9abf352a7965	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:17.4116+00	
00000000-0000-0000-0000-000000000000	ccf3c0e2-d97c-4292-8432-ec0ed98c6862	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:17.832422+00	
00000000-0000-0000-0000-000000000000	2e5a7efa-26a4-4d33-9358-ef44ebf21e53	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:18.222828+00	
00000000-0000-0000-0000-000000000000	12763d56-ee3a-4838-99a4-b0d21bddfca1	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:18.644303+00	
00000000-0000-0000-0000-000000000000	71c020aa-76e1-4e28-9c0b-fdc1d2b3a949	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:19.071366+00	
00000000-0000-0000-0000-000000000000	6d174bd0-1a70-4dc5-9107-9a80f8653893	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:19.505543+00	
00000000-0000-0000-0000-000000000000	31e1145b-ecba-4f75-bcca-83dd15361f09	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:19.946426+00	
00000000-0000-0000-0000-000000000000	85fb87c6-d610-4b3a-b42b-14f34b473fb9	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:20.352774+00	
00000000-0000-0000-0000-000000000000	9c5ed8d8-61d0-426e-bef8-db0365d477bb	{"action":"token_refreshed","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 21:36:20.759778+00	
00000000-0000-0000-0000-000000000000	b567c05a-7ff2-4cdc-95c8-5862cd519c11	{"action":"logout","actor_id":"4656c837-6b1c-4cb0-a386-2842def95b59","actor_username":"pauli@gmail.com","actor_via_sso":false,"log_type":"account"}	2026-06-26 21:37:34.801702+00	
00000000-0000-0000-0000-000000000000	de15ec3e-3c13-4b9c-b43e-18a5320c4243	{"action":"login","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2026-06-26 21:37:44.736426+00	
00000000-0000-0000-0000-000000000000	e7f9d0a7-42c1-445a-b285-161d2c824053	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:19:21.836752+00	
00000000-0000-0000-0000-000000000000	b49d4411-a8ef-4839-a8db-18c00e77d2d5	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:19:21.84041+00	
00000000-0000-0000-0000-000000000000	da15a651-8611-4f90-8a3a-731cfacc913e	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:18.871322+00	
00000000-0000-0000-0000-000000000000	f6bf7ac0-e744-40f5-b376-7c3e6536f08e	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:18.874945+00	
00000000-0000-0000-0000-000000000000	0093861f-ed82-4aea-85b5-c4af6e8cbc99	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:19.161577+00	
00000000-0000-0000-0000-000000000000	66969ea8-3087-42cb-9b14-a86e6235b494	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:19.677175+00	
00000000-0000-0000-0000-000000000000	3857579d-35ae-4ede-b3e9-b5f8ceee0eb2	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:19.892052+00	
00000000-0000-0000-0000-000000000000	3f95402b-e002-4bda-b929-632ba1aaa0fe	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:20.191254+00	
00000000-0000-0000-0000-000000000000	03a7a47f-763f-435f-babb-0166cb5f3cde	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:20.476438+00	
00000000-0000-0000-0000-000000000000	543d8ffe-55ff-44ce-8045-b050d8eda35e	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:20.748472+00	
00000000-0000-0000-0000-000000000000	3402a6b2-7e0f-478a-81bd-2f2e0862bd28	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:20.813139+00	
00000000-0000-0000-0000-000000000000	abf003e7-1cc0-4f19-92de-8fcf24f17a74	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.050505+00	
00000000-0000-0000-0000-000000000000	de1096d2-578d-4ddf-8bca-54239ad36a6a	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.353735+00	
00000000-0000-0000-0000-000000000000	7ed46214-4c62-4919-8d21-0f7f87c9a2d5	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.42073+00	
00000000-0000-0000-0000-000000000000	b9100639-002e-41c4-8d9d-489a3666b6f2	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.630572+00	
00000000-0000-0000-0000-000000000000	63187ce1-4507-4aff-ae53-7909f545aecf	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.71871+00	
00000000-0000-0000-0000-000000000000	1df7e3e9-765d-4dbd-8ed8-40ff44cbfe8f	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:21.954947+00	
00000000-0000-0000-0000-000000000000	d05df5d8-f434-4b9a-ad19-ad24e198cf49	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:22.236174+00	
00000000-0000-0000-0000-000000000000	5b4a67f2-7a06-4a25-bad4-d7563db52b4b	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:22.31284+00	
00000000-0000-0000-0000-000000000000	6e50714f-abc2-47d2-8def-1a0c3b80fc3e	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:22.574068+00	
00000000-0000-0000-0000-000000000000	a5b3cb2c-fc4f-40c5-a0e2-a3c0748fdaf8	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:22.871979+00	
00000000-0000-0000-0000-000000000000	95e3c3ca-6325-4520-b2cc-2e22d37b3d2c	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:22.917329+00	
00000000-0000-0000-0000-000000000000	f1eb3fbe-4007-4280-acee-3b4eb96c978a	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.14522+00	
00000000-0000-0000-0000-000000000000	29c530d7-df90-4049-a2e2-21812f70a08a	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.22031+00	
00000000-0000-0000-0000-000000000000	95339c97-c356-4e1b-80f3-40abe1293d85	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.467499+00	
00000000-0000-0000-0000-000000000000	d49dc082-501d-4df5-b002-bf72390048cd	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.522679+00	
00000000-0000-0000-0000-000000000000	aa718cde-53af-4833-b9b3-6779bf6400a7	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.774429+00	
00000000-0000-0000-0000-000000000000	c9716398-9b66-4747-b2cf-b813df9c72bf	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:23.829947+00	
00000000-0000-0000-0000-000000000000	4200de77-673f-417a-bc37-4f8559baf659	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:24.149665+00	
00000000-0000-0000-0000-000000000000	3fd0d79c-6624-45a1-bbfc-faee95930a9f	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:24.445164+00	
00000000-0000-0000-0000-000000000000	bf12920a-0f07-41f4-809d-4c619f5cfa48	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:24.86786+00	
00000000-0000-0000-0000-000000000000	948aef98-4964-449f-9bcf-cdcb93cc38ba	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:25.361431+00	
00000000-0000-0000-0000-000000000000	434b2ef7-b816-422c-8aae-e32a81100fa6	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:25.441483+00	
00000000-0000-0000-0000-000000000000	59787cc3-7917-424c-a21f-a7aa0d36cf0a	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:25.553627+00	
00000000-0000-0000-0000-000000000000	d3405267-3de0-474b-87fa-6975de21962d	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:26.00443+00	
00000000-0000-0000-0000-000000000000	45b37f96-cb92-4463-84cd-1c3eb53d4ca0	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:26.130086+00	
00000000-0000-0000-0000-000000000000	09188e8c-b2da-4372-baf9-28ef598afa0e	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:26.58707+00	
00000000-0000-0000-0000-000000000000	e72f8602-5aea-435a-8951-b336bc7d78bb	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:26.693442+00	
00000000-0000-0000-0000-000000000000	6139426c-e52c-4b08-b205-10063c7c5628	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:27.020021+00	
00000000-0000-0000-0000-000000000000	5de39cf0-fa4a-42fa-9ad9-f5fb0a8f5529	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:27.319227+00	
00000000-0000-0000-0000-000000000000	97f6423d-87df-4024-a5d8-a4e21df56503	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:27.61971+00	
00000000-0000-0000-0000-000000000000	26ebc807-5406-4cd8-a316-389f36c9a6d0	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:27.900227+00	
00000000-0000-0000-0000-000000000000	5e66fde8-9483-492e-933a-72201fbf7b3d	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 22:47:28.127209+00	
00000000-0000-0000-0000-000000000000	5e875718-ca2c-41d8-ad9c-b8bde0c86703	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 23:17:50.551652+00	
00000000-0000-0000-0000-000000000000	95dfcb13-df02-4225-b06a-4edd4fd73f97	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-26 23:17:50.554415+00	
00000000-0000-0000-0000-000000000000	0f6d942b-8a86-4b8e-ae71-8c7bc4734371	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 00:15:56.713903+00	
00000000-0000-0000-0000-000000000000	9d0472a0-c74e-4f59-803c-b55d53f71bf2	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 00:15:56.718143+00	
00000000-0000-0000-0000-000000000000	536588c6-e35b-48e9-adb0-0c2158541218	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 01:13:56.743587+00	
00000000-0000-0000-0000-000000000000	69bfc766-b0b4-410c-aacd-2892dc55a943	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 01:13:56.747939+00	
00000000-0000-0000-0000-000000000000	fc88d29e-1d48-4eb1-b94f-8831210b9da6	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 02:12:19.482668+00	
00000000-0000-0000-0000-000000000000	5f439cc1-8fab-4393-87d4-07db7914d94c	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 02:12:19.486131+00	
00000000-0000-0000-0000-000000000000	73765efa-1481-48f4-95cb-6c67cbc31532	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 02:15:09.90655+00	
00000000-0000-0000-0000-000000000000	e249f8b4-07de-487a-bfcc-fc404797b69d	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 02:15:09.909788+00	
00000000-0000-0000-0000-000000000000	606bc99b-649d-4871-aa80-e06a90cfc23e	{"action":"token_refreshed","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 03:47:57.899334+00	
00000000-0000-0000-0000-000000000000	3ba0ea16-e3a8-496f-94e6-2cecb2ebee00	{"action":"token_revoked","actor_id":"6cfeec2d-10c6-40ec-93a4-71836838ccac","actor_username":"esteban@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 03:47:57.914977+00	
00000000-0000-0000-0000-000000000000	12f40af2-8fee-4c66-9b41-9b3b0f85d4de	{"action":"token_refreshed","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 03:48:14.861029+00	
00000000-0000-0000-0000-000000000000	bc08a8d1-ece7-478c-b704-baa23e2264b9	{"action":"token_revoked","actor_id":"f96c5bdc-5579-4be6-909a-7dcf63dcc81f","actor_username":"puchin@gmail.com","actor_via_sso":false,"log_type":"token"}	2026-06-27 03:48:14.864886+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
6cfeec2d-10c6-40ec-93a4-71836838ccac	6cfeec2d-10c6-40ec-93a4-71836838ccac	{"sub": "6cfeec2d-10c6-40ec-93a4-71836838ccac", "email": "esteban@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-06-24 17:40:18.690367+00	2026-06-24 17:40:18.690408+00	2026-06-24 17:40:18.690408+00	07b17a19-c374-43d7-b3e7-01fab5d520e7
4656c837-6b1c-4cb0-a386-2842def95b59	4656c837-6b1c-4cb0-a386-2842def95b59	{"sub": "4656c837-6b1c-4cb0-a386-2842def95b59", "email": "pauli@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-06-24 23:22:42.234557+00	2026-06-24 23:22:42.234593+00	2026-06-24 23:22:42.234593+00	0d50a239-149a-4654-9e5e-2692636b5412
f96c5bdc-5579-4be6-909a-7dcf63dcc81f	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	{"sub": "f96c5bdc-5579-4be6-909a-7dcf63dcc81f", "email": "puchin@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-06-25 04:28:49.117248+00	2026-06-25 04:28:49.117288+00	2026-06-25 04:28:49.117288+00	55c8fb6f-1488-44b3-b92b-888b498649e8
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
11e173dc-3aa5-4298-b08c-a33960f09d9a	2026-06-25 20:36:35.722924+00	2026-06-25 20:36:35.722924+00	password	73e6e5ef-ff4b-463f-83e0-e69efcc721c0
9f167321-ffbb-4e2e-b1e8-7e877fc31a60	2026-06-25 21:30:35.694678+00	2026-06-25 21:30:35.694678+00	password	0ade89b2-5be8-4832-8bcc-93516268871a
c8192c35-2deb-4c47-91ff-4c07176038a5	2026-06-26 21:37:44.768375+00	2026-06-26 21:37:44.768375+00	password	e6983abb-8936-4d0c-99f2-d2d11e5ec154
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	151	x73uwowx3khy	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-27 01:13:56.751278+00	2026-06-27 02:12:19.486822+00	ugfxzykungdm	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	148	e3qbfapil3dk	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	t	2026-06-26 22:47:18.877271+00	2026-06-27 02:15:09.910468+00	seoirv7u4omr	c8192c35-2deb-4c47-91ff-4c07176038a5
00000000-0000-0000-0000-000000000000	152	76737gh26fzz	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-27 02:12:19.488041+00	2026-06-27 03:47:57.915857+00	x73uwowx3khy	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	154	6fx2ccjg2kgq	6cfeec2d-10c6-40ec-93a4-71836838ccac	f	2026-06-27 03:47:57.918349+00	2026-06-27 03:47:57.918349+00	76737gh26fzz	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	153	lst52ubumrkk	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	t	2026-06-27 02:15:09.911449+00	2026-06-27 03:48:14.865963+00	e3qbfapil3dk	c8192c35-2deb-4c47-91ff-4c07176038a5
00000000-0000-0000-0000-000000000000	155	lfuxdl7i3uoy	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	f	2026-06-27 03:48:14.867924+00	2026-06-27 03:48:14.867924+00	lst52ubumrkk	c8192c35-2deb-4c47-91ff-4c07176038a5
00000000-0000-0000-0000-000000000000	131	no627siy6dok	6cfeec2d-10c6-40ec-93a4-71836838ccac	f	2026-06-25 21:30:35.684992+00	2026-06-25 21:30:35.684992+00	\N	9f167321-ffbb-4e2e-b1e8-7e877fc31a60
00000000-0000-0000-0000-000000000000	129	ip73sqoxcczw	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-25 20:36:35.71664+00	2026-06-25 21:34:48.821021+00	\N	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	132	kferf7mz6j4k	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-25 21:34:48.822073+00	2026-06-26 14:02:10.392651+00	ip73sqoxcczw	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	134	4kwxfx6dlgoo	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 14:02:10.393595+00	2026-06-26 15:00:12.956525+00	kferf7mz6j4k	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	136	eestoocvqrbg	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 15:00:12.957412+00	2026-06-26 15:58:31.004998+00	4kwxfx6dlgoo	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	137	cioaqhler5cj	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 15:58:31.006298+00	2026-06-26 16:56:32.270722+00	eestoocvqrbg	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	138	qtg55x5savvs	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 16:56:32.272012+00	2026-06-26 18:05:22.370366+00	cioaqhler5cj	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	140	bg7yciph3c7b	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 18:05:22.37165+00	2026-06-26 19:03:28.400664+00	qtg55x5savvs	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	141	z6y45urhvuwj	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 19:03:28.401921+00	2026-06-26 20:22:41.028595+00	bg7yciph3c7b	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	143	i3cptkxp5ovc	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 20:22:41.030325+00	2026-06-26 21:21:06.72509+00	z6y45urhvuwj	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	144	fkchc2xlhlof	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 21:21:06.726345+00	2026-06-26 22:19:21.841238+00	i3cptkxp5ovc	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	146	seoirv7u4omr	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	t	2026-06-26 21:37:44.761581+00	2026-06-26 22:47:18.875968+00	\N	c8192c35-2deb-4c47-91ff-4c07176038a5
00000000-0000-0000-0000-000000000000	147	h3bucbpunfej	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 22:19:21.843146+00	2026-06-26 23:17:50.555213+00	fkchc2xlhlof	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	149	4revpobk2p27	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-26 23:17:50.556247+00	2026-06-27 00:15:56.719237+00	h3bucbpunfej	11e173dc-3aa5-4298-b08c-a33960f09d9a
00000000-0000-0000-0000-000000000000	150	ugfxzykungdm	6cfeec2d-10c6-40ec-93a4-71836838ccac	t	2026-06-27 00:15:56.721456+00	2026-06-27 01:13:56.748843+00	4revpobk2p27	11e173dc-3aa5-4298-b08c-a33960f09d9a
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
11e173dc-3aa5-4298-b08c-a33960f09d9a	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-25 20:36:35.704297+00	2026-06-27 03:47:57.929771+00	\N	aal1	\N	2026-06-27 03:47:57.92969	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	172.18.0.1	\N	\N	\N	\N	\N
c8192c35-2deb-4c47-91ff-4c07176038a5	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	2026-06-26 21:37:44.739844+00	2026-06-27 03:48:14.871693+00	\N	aal1	\N	2026-06-27 03:48:14.871633	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	172.18.0.1	\N	\N	\N	\N	\N
9f167321-ffbb-4e2e-b1e8-7e877fc31a60	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-25 21:30:35.672296+00	2026-06-25 21:30:35.672296+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.126.0 Chrome/148.0.7778.97 Electron/42.2.0 Safari/537.36	172.18.0.1	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	6cfeec2d-10c6-40ec-93a4-71836838ccac	authenticated	authenticated	esteban@gmail.com	$2a$10$hElpKuHaZQIuc0rNcuJ5J.oH.XeoULTjwGWLbBLoGl4KmdWl/d7jy	2026-06-24 17:40:18.713726+00	\N		\N		\N			\N	2026-06-25 21:30:35.672159+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-06-24 17:40:18.670685+00	2026-06-27 03:47:57.927462+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	authenticated	authenticated	puchin@gmail.com	$2a$10$TJ/QZQ4Csw90GwQ7FOB2qeijHMFwgLJZwgjjddvfQTKM3Oce9v1R.	2026-06-25 04:28:49.123495+00	\N		\N		\N			\N	2026-06-26 21:37:44.739531+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-06-25 04:28:49.105111+00	2026-06-27 03:48:14.87015+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4656c837-6b1c-4cb0-a386-2842def95b59	authenticated	authenticated	pauli@gmail.com	$2a$10$71hTDRd2ZOPiJo5p8n58GeH9YgIg4OsEdhploTsBoldE5xB.L65Ee	2026-06-24 23:22:42.240399+00	\N		\N		\N			\N	2026-06-24 23:26:22.295743+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-06-24 23:22:42.221449+00	2026-06-26 21:36:12.448836+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.messages (id, created_at, content, author, user_id) FROM stdin;
37ddf94f-4319-4b08-a3eb-9039cedb27a6	2026-06-25 01:37:00.543954+00	ahora si viste perro	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
75ad3fdb-580c-440e-98b3-9250739d782e	2026-06-25 02:42:29.264771+00	wasaaaaaaa	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
b1086dcb-441e-4871-8c9b-cd6e88d34a2a	2026-06-25 02:54:16.260627+00	q onda	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
08129867-f10e-4dd9-b1ce-ab1c4951f176	2026-06-25 02:54:17.794891+00	q ondaasdsad	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
81b59bd7-b4f9-4b6d-8d4a-6543023e6c69	2026-06-25 03:23:49.650111+00	loquito	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
377e8fe9-782e-4f02-a751-988e0ff6e669	2026-06-25 03:23:55.807813+00	q onda	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
71c3338d-c2ca-43d3-b4a2-c5c24c0a0bf9	2026-06-25 04:28:17.988902+00	aaaaa	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
96320b5a-94f9-4af7-8054-d81dc5ff78e2	2026-06-25 04:28:24.394819+00	trola	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
4c289daf-3811-4d0e-b0d2-42391cdf25cb	2026-06-25 04:30:00.724399+00	que onda gatos	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
b3bc6418-9c7f-49db-971a-a5ffdb1d895b	2026-06-25 14:47:54.329698+00	cambie la foto 🫦	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
ba3bf537-d27e-4d6c-8ca4-9b1c0acfef07	2026-06-25 14:49:23.233312+00	oaaa	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
19614598-22bb-40a3-9ece-9590e11be3a9	2026-06-25 14:54:20.585942+00	cambie la foto 🫦	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
36443bab-f02f-470e-9ab9-35161ff59c59	2026-06-25 14:54:26.876166+00	a veerrr	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
10d81605-be45-4b0a-9288-8f372eeed0dc	2026-06-25 14:54:50.961429+00	a veerrr	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
1c13b333-8e5d-439e-8c1f-1fc82e0ccce7	2026-06-25 14:55:02.638625+00	no funciona ah	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
07bcc678-1aca-4dbf-b0d6-b694cfc4878a	2026-06-25 14:55:04.50604+00	no funciona ah	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
35a54f5e-17b2-489b-b1d6-5222a1953c43	2026-06-25 14:55:11.917678+00	no funciona ahasdsadsad	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
fc2b608a-b1b0-431b-9473-1774f0db428b	2026-06-25 14:56:42.470314+00	no funciona ahasdsadsadasdasdasdasd no si cambia chabon	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
4a03c6be-f7e9-4b54-aa41-f4cb9cd9e045	2026-06-25 14:57:52.694594+00	asdasdas	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
3b5ca1a4-51e4-42ea-97b8-8d89fa14c18a	2026-06-25 14:58:27.856276+00	asdasdasasdsad	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
15df3886-cd79-4e6a-98bc-1b45bfb03da3	2026-06-25 14:58:47.526241+00	asdasdasasdsadasdsada	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
d2e398cb-e8b2-43f1-bddb-06a05ba4c391	2026-06-25 14:59:02.448802+00	a veerrraaaaaaaa	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
64a62008-715d-407d-9b81-4d87b1be1790	2026-06-25 14:59:04.694294+00	a veerrraaaaaaaasoy una vergaaa	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
2497b4e8-169e-4134-8813-44ebc818ed0c	2026-06-25 14:59:06.255756+00	a veerrraaaaaaaasoy una vergaaapelotudo	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
1a3c7b44-111c-4b8d-99a3-c6297d8ecc3a	2026-06-25 14:59:06.85569+00	a veerrraaaaaaaasoy una vergaaapelotudoxd	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
28d359b3-7218-4cd2-89df-09a3dfbc0a0a	2026-06-25 14:59:11.539626+00	pero ya esta	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
9e455df3-7cba-431b-ba86-6298c6497ce7	2026-06-25 14:59:15.575408+00	uwu	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
9cea46db-6e09-4e0b-8899-66e9d1a014f5	2026-06-25 14:59:36.316945+00	hola bb	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
5a8d29ca-5ac7-4c25-a06f-dd9a202a6eb8	2026-06-25 15:02:36.289309+00	owo	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
862c5b30-449c-4af7-af6f-19c6ac45c1c1	2026-06-25 15:02:38.348448+00	xd	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
3bf65d31-8c03-49e3-a6ed-6e02f77e15c4	2026-06-25 15:03:28.856426+00	a q si	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
fbe10a2c-3417-4300-b646-d948bc01832d	2026-06-25 15:05:53.357583+00	hola pauli	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
18b651cd-74b1-417e-87d3-c6b4c75fa66e	2026-06-25 15:06:02.361168+00	lo se siente extrano	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
5f5e515a-af52-491c-b33e-a2aa121aff5e	2026-06-25 15:06:09.084052+00	v:	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
dc8d4685-3929-41ac-8c9a-f93f016d1c80	2026-06-25 15:06:16.219838+00	:v	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
fd7e2ea2-a69f-40e5-b7a0-6c697440c9b1	2026-06-25 15:20:28.164487+00		pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
1f31871b-ab24-4d8d-9e82-c7385fb409d3	2026-06-25 15:20:31.650959+00	:v	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
0fe6de9c-ae5e-4b9f-9f68-0eea58692a01	2026-06-25 15:20:34.894616+00		pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
3f4d3fd5-e467-426b-9c12-a7e2372b1411	2026-06-25 15:20:36.87436+00	      	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
7606237f-d1fb-40fc-9fbd-4528da2218e4	2026-06-25 15:20:39.1656+00	                         	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
5e5dfde6-3539-4500-b251-8a551427ecce	2026-06-25 15:20:41.027384+00	l;ol 	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
edaa6f76-8358-4cdd-94c4-17f6df46ab3e	2026-06-25 15:20:43.396247+00	gay	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
0975d1d6-6ae7-41a2-9547-f52a06f03079	2026-06-25 20:24:38.606036+00	asdsadas	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
dfc6def2-34d5-473d-8f41-888454cc75fa	2026-06-25 20:37:02.031677+00	que onda gatos	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
ed0f70d8-18c3-429a-944e-1d717856e524	2026-06-25 20:37:36.61951+00	tu sanja la onda	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
8aff016d-41b9-475a-8cd4-4602fdce8c5a	2026-06-25 20:54:15.993577+00	Hola puchin 🫦	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
e03edb50-2c70-41f1-94e6-8c10fbd4243f	2026-06-25 20:54:22.543666+00	Hola pauli 🫦🫦	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
b5a05356-6d74-48f2-935c-6c6db0114c68	2026-06-25 21:37:46.862336+00	:v	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
da3b7b84-2679-47cd-9dd2-aec957a1b5bf	2026-06-25 22:02:13.949006+00	holaaa	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
b20572dc-6d3f-4f3e-9196-c85d21cd3236	2026-06-25 22:02:19.668509+00	todo bien?	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
fe704619-a9a2-4929-8ed5-031a11083fe5	2026-06-25 22:02:23.693651+00	si y vos?	pauli@gmail.com	4656c837-6b1c-4cb0-a386-2842def95b59
99101a3d-68f3-4e80-a17a-f0e5d4bab87f	2026-06-25 22:06:29.711677+00	bien :v	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
2ceef480-a020-44d2-a623-1c1e4a6c428a	2026-06-26 22:38:35.503334+00	:v	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
6901e3e8-8189-4bc7-a875-9fe8011eaca6	2026-06-26 22:40:27.783299+00	e.e	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
725d02b8-7160-4006-ae78-3c7573502a50	2026-06-26 22:40:34.769534+00	asdasdsad	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
15e59106-f780-460a-9571-ae3432dde425	2026-06-26 22:41:47.448579+00	aaaaaaaaaaaaaaaaaaaaaaaaaaaa	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
e5e09954-f998-43c8-9cb2-9448a530565e	2026-06-26 22:44:39.484718+00	:v	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
9b2c6c1e-6af6-4eec-9d2d-a18356b9d8ab	2026-06-26 22:45:04.484918+00	a	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
f2f2b234-2f9a-4d5b-9bc0-d1941c5b1ab7	2026-06-26 22:45:05.80949+00	ahora	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
d430049f-d2d9-45a4-bc86-207b50d0a7a8	2026-06-26 22:45:07.982242+00	se ve lol	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
a6287954-4c45-48d8-a10a-ac3655506d24	2026-06-26 22:47:13.644646+00	asdasdasdsad	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
cb3a578e-4d5f-47af-8431-79fa60a7767d	2026-06-26 22:47:32.054796+00	e.e	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
b962f822-9ac9-4fec-b15f-5fba01040f66	2026-06-26 22:51:53.793315+00	asdasdsa	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
2868cb38-dc0c-402d-9202-0c72f5b0107c	2026-06-26 22:51:55.356003+00	asdasdadasd	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
5befb730-284b-4e43-ad77-3635e1c9e21e	2026-06-26 23:06:51.469263+00	eeeeeeeeeeeee	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
93600748-5a10-43e7-a876-1066e584b5a1	2026-06-26 23:07:06.638478+00	asdddddddddddddddddddddddddd	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
5313ea97-2044-4525-b789-3372af02b1dd	2026-06-26 23:09:25.707031+00	aaaaaaaaaa	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
8c67dc8b-66d0-418c-bd50-90cebe5ff807	2026-06-26 23:09:29.61377+00	asdasdsadsad	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
93c693d0-85da-49b0-aea5-652d67afd3e9	2026-06-26 23:09:44.338069+00	aaaaaaa	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
e96a9c43-bd61-4bd2-876a-126e6aff0ae1	2026-06-26 23:09:52.695189+00	e.e	puchin@gmail.com	f96c5bdc-5579-4be6-909a-7dcf63dcc81f
f0332a15-0242-47ca-9d44-4ff0839c2d2a	2026-06-26 23:10:23.84675+00	asdsada	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
308649eb-fe63-4307-b533-1b10e86d6664	2026-06-26 23:10:25.456905+00	eeeeeeee	esteban@gmail.com	6cfeec2d-10c6-40ec-93a4-71836838ccac
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.profiles (id, updated_at, username, full_name, avatar_url, website, email) FROM stdin;
4656c837-6b1c-4cb0-a386-2842def95b59	\N	Pauli	Paula Tatiana	https://tse1.explicit.bing.net/th/id/OIP.h17g7_JfK79RuuF4x9FhsAHaEK?rs=1&pid=ImgDetMain&o=7&rm=3	\N	pauli@gmail.com
f96c5bdc-5579-4be6-909a-7dcf63dcc81f	\N	Puchincito Capo	El Puchin	https://i.pinimg.com/originals/8c/51/f3/8c51f3fa2f62e74bd1cb6bc052cb26e8.jpg	\N	puchin@gmail.com
6cfeec2d-10c6-40ec-93a4-71836838ccac	\N	Puchincitoooo	Esteban Sayago	http://localhost:8000/storage/v1/object/public/profiles_avatars/yo.jpg	\N	esteban@gmail.com
\.


--
-- Data for Name: messages_2026_06_26; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_06_26 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_06_27; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_06_27 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_06_28; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_06_28 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_06_29; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_06_29 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_06_30; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_06_30 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_01; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_07_01 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_07_02; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2026_07_02 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-26 21:10:54
20211116045059	2026-03-26 21:10:54
20211116050929	2026-03-26 21:10:54
20211116051442	2026-03-26 21:10:54
20211116212300	2026-03-26 21:10:54
20211116213355	2026-03-26 21:10:54
20211116213934	2026-03-26 21:10:54
20211116214523	2026-03-26 21:10:54
20211122062447	2026-03-26 21:10:54
20211124070109	2026-03-26 21:10:54
20211202204204	2026-03-26 21:10:54
20211202204605	2026-03-26 21:10:54
20211210212804	2026-03-26 21:10:54
20211228014915	2026-03-26 21:10:54
20220107221237	2026-03-26 21:10:54
20220228202821	2026-03-26 21:10:54
20220312004840	2026-03-26 21:10:54
20220603231003	2026-03-26 21:10:54
20220603232444	2026-03-26 21:10:54
20220615214548	2026-03-26 21:10:54
20220712093339	2026-03-26 21:10:54
20220908172859	2026-03-26 21:10:54
20220916233421	2026-03-26 21:10:54
20230119133233	2026-03-26 21:10:54
20230128025114	2026-03-26 21:10:54
20230128025212	2026-03-26 21:10:54
20230227211149	2026-03-26 21:10:54
20230228184745	2026-03-26 21:10:54
20230308225145	2026-03-26 21:10:54
20230328144023	2026-03-26 21:10:54
20231018144023	2026-03-26 21:10:54
20231204144023	2026-03-26 21:10:54
20231204144024	2026-03-26 21:10:54
20231204144025	2026-03-26 21:10:54
20240108234812	2026-03-26 21:10:54
20240109165339	2026-03-26 21:10:54
20240227174441	2026-03-26 21:10:55
20240311171622	2026-03-26 21:10:55
20240321100241	2026-03-26 21:10:55
20240401105812	2026-03-26 21:10:55
20240418121054	2026-03-26 21:10:55
20240523004032	2026-03-26 21:10:55
20240618124746	2026-03-26 21:10:55
20240801235015	2026-03-26 21:10:55
20240805133720	2026-03-26 21:10:55
20240827160934	2026-03-26 21:10:55
20240919163303	2026-03-26 21:10:55
20240919163305	2026-03-26 21:10:55
20241019105805	2026-03-26 21:10:55
20241030150047	2026-03-26 21:10:56
20241108114728	2026-03-26 21:10:56
20241121104152	2026-03-26 21:10:56
20241130184212	2026-03-26 21:10:56
20241220035512	2026-03-26 21:10:56
20241220123912	2026-03-26 21:10:56
20241224161212	2026-03-26 21:10:56
20250107150512	2026-03-26 21:10:56
20250110162412	2026-03-26 21:10:56
20250123174212	2026-03-26 21:10:56
20250128220012	2026-03-26 21:10:56
20250506224012	2026-03-26 21:10:56
20250523164012	2026-03-26 21:10:56
20250714121412	2026-03-26 21:10:56
20250905041441	2026-03-26 21:10:56
20251103001201	2026-03-26 21:10:56
20251120212548	2026-03-26 21:10:56
20251120215549	2026-03-26 21:10:56
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
imagenes-privadas	imagenes-privadas	\N	2026-03-27 20:38:44.007334+00	2026-03-27 20:38:44.007334+00	f	f	\N	\N	\N	STANDARD
subir-fotos	subir-fotos	\N	2026-03-30 17:21:46.919828+00	2026-03-30 17:21:46.919828+00	t	f	\N	\N	\N	STANDARD
avatars	avatars	\N	2026-06-22 23:45:43.772943+00	2026-06-22 23:45:43.772943+00	f	f	\N	\N	\N	STANDARD
profiles_avatars	profiles_avatars	\N	2026-06-26 14:01:09.72654+00	2026-06-26 14:01:09.72654+00	t	f	2097152	{image/jpg,image/png,image/webp,image/jpeg,image/AVIF,image/avif}	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_namespaces (id, bucket_name, name, created_at, updated_at, metadata, catalog_id) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_tables (id, namespace_id, bucket_name, name, location, created_at, updated_at, remote_table_id, shard_key, shard_id, catalog_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-26 21:10:53.213937
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-26 21:10:53.265245
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-26 21:10:53.271039
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-26 21:10:53.51128
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-26 21:10:53.607635
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-26 21:10:53.614919
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-26 21:10:53.645131
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-26 21:10:53.673137
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-26 21:10:53.685587
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-26 21:10:53.716648
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-26 21:10:53.742141
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-26 21:10:53.758214
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-26 21:10:53.788774
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-26 21:10:53.799122
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-26 21:10:53.827101
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-26 21:10:53.886659
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-26 21:10:53.892384
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-26 21:10:53.91893
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-26 21:10:53.934185
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-26 21:10:54.049418
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-26 21:10:54.064717
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-26 21:10:54.100912
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-26 21:10:54.229005
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-26 21:10:54.297942
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-26 21:10:54.305905
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-26 21:10:54.318383
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-26 21:10:54.341615
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-26 21:10:54.343918
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-26 21:10:54.345547
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-26 21:10:54.347014
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-26 21:10:54.348505
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-26 21:10:54.350075
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-26 21:10:54.351616
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-26 21:10:54.354037
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-26 21:10:54.355665
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-26 21:10:54.357554
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-26 21:10:54.359109
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-26 21:10:54.360546
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-26 21:10:54.391023
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-26 21:10:54.452176
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-26 21:10:54.454375
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-26 21:10:54.456224
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-26 21:10:54.457922
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-26 21:10:54.459473
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-26 21:10:54.460964
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-26 21:10:54.467526
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-26 21:10:54.512196
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-26 21:10:54.537621
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-26 21:10:54.553746
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-26 21:10:54.641322
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-26 21:10:54.660153
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-26 21:10:54.927534
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-26 21:10:54.929072
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-26 21:10:55.294238
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-26 21:10:55.306764
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-26 21:10:55.308274
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-26 21:10:55.394124
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
c872fd9b-994b-437c-a8df-da0cd0335440	subir-fotos	1774733427413.jpg	\N	2026-03-30 17:27:24.203402+00	2026-03-30 17:27:24.203402+00	2026-03-30 17:27:24.203402+00	{"eTag": "\\"2ab3beb7d64cc186a3493c8d40a6c66a\\"", "size": 80013, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-30T17:27:24.188Z", "contentLength": 80013, "httpStatusCode": 200}	e848cf15-8fdd-4af4-b2db-5da3e678a1da	\N	{}
aca4d0b7-c1ba-4c6f-b9a0-f6f88ec3c703	subir-fotos	photo-1522071820081-009f0129c71c.avif	\N	2026-03-30 20:32:11.416536+00	2026-03-30 20:32:11.416536+00	2026-03-30 20:32:11.416536+00	{"eTag": "\\"733cc06557c697341cf653fe260dba90\\"", "size": 486656, "mimetype": "image/avif", "cacheControl": "max-age=3600", "lastModified": "2026-03-30T20:32:11.397Z", "contentLength": 486656, "httpStatusCode": 200}	185b7af8-389e-44bf-aa31-5c45411b1bcf	\N	{}
8b9a2e4a-e780-4760-88b0-af956cb7ad79	imagenes-privadas	image-1775487546937.jpeg	\N	2026-04-06 14:59:07.053707+00	2026-04-06 14:59:07.053707+00	2026-04-06 14:59:07.053707+00	{"eTag": "\\"859f64a012c3dafd2ddd5c53b64a2814\\"", "size": 1961126, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:59:07.029Z", "contentLength": 1961126, "httpStatusCode": 200}	48b73f38-9dbb-4060-8d3b-a3a758b87c5f	\N	{}
8b2ee2c9-084a-4da0-adf5-828ea3aea657	imagenes-privadas	image-1775506417941.jpeg	\N	2026-04-06 20:13:38.120209+00	2026-04-06 20:13:38.120209+00	2026-04-06 20:13:38.120209+00	{"eTag": "\\"859f64a012c3dafd2ddd5c53b64a2814\\"", "size": 1961126, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:13:38.094Z", "contentLength": 1961126, "httpStatusCode": 200}	c0237405-87be-4dd9-be20-5826490985b2	\N	{}
385e6607-b362-427b-9857-e10c44aeff0a	imagenes-privadas	image-1775506458846.jpeg	\N	2026-04-06 20:14:18.936204+00	2026-04-06 20:14:18.936204+00	2026-04-06 20:14:18.936204+00	{"eTag": "\\"6512bb9042491c13260471e3275d56a7\\"", "size": 90943, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:14:18.926Z", "contentLength": 90943, "httpStatusCode": 200}	c9e4ede6-2ae9-432a-814d-b402b2e8e43f	\N	{}
36c16264-9c91-48c4-95d4-391fd3871d75	imagenes-privadas	image-1775506458862.jpeg	\N	2026-04-06 20:14:18.941926+00	2026-04-06 20:14:18.941926+00	2026-04-06 20:14:18.941926+00	{"eTag": "\\"6512bb9042491c13260471e3275d56a7\\"", "size": 90943, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:14:18.930Z", "contentLength": 90943, "httpStatusCode": 200}	102e5ded-1af7-4896-9479-831785cc866b	\N	{}
2f37b635-94da-4c9f-b2f5-6476f8f834ce	imagenes-privadas	image-1775506630784.jpeg	\N	2026-04-06 20:17:10.903084+00	2026-04-06 20:17:10.903084+00	2026-04-06 20:17:10.903084+00	{"eTag": "\\"6512bb9042491c13260471e3275d56a7\\"", "size": 90943, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:17:10.893Z", "contentLength": 90943, "httpStatusCode": 200}	4e8d1664-7c55-4fe2-817f-9064c2a0c8bd	\N	{}
468f38c1-7794-47ab-be6d-ecb293fa96c1	imagenes-privadas	image-1775507237954.jpeg	\N	2026-04-06 20:27:18.08117+00	2026-04-06 20:27:18.08117+00	2026-04-06 20:27:18.08117+00	{"eTag": "\\"79154f3eaed4e5fd2bd224a036e8446c\\"", "size": 27815, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:27:18.069Z", "contentLength": 27815, "httpStatusCode": 200}	7bc51043-6c68-472a-8f87-7d457318e854	\N	{}
e33f4fcb-a31a-4560-80b2-b8acde76c036	imagenes-privadas	image-1775508005711.webp	\N	2026-04-06 20:40:05.790744+00	2026-04-06 20:40:05.790744+00	2026-04-06 20:40:05.790744+00	{"eTag": "\\"f6559972e6458640bdedb749e61d0f91\\"", "size": 81230, "mimetype": "image/webp", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:40:05.775Z", "contentLength": 81230, "httpStatusCode": 200}	a5446ba5-b761-4918-8d2e-3ac72acb3c06	\N	{}
c1a2099f-e737-4621-9612-7492737a59d8	imagenes-privadas	image-1775487546926.jpeg	\N	2026-04-06 14:59:07.05082+00	2026-04-06 14:59:07.05082+00	2026-04-06 14:59:07.05082+00	{"eTag": "\\"859f64a012c3dafd2ddd5c53b64a2814\\"", "size": 1961126, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:59:07.028Z", "contentLength": 1961126, "httpStatusCode": 200}	d7a77ff4-3bf2-4d63-b05b-88fbbcd6a066	\N	{}
a72e8f2b-e53a-4fbf-b733-d23eca121329	imagenes-privadas	image-1775506630785.jpeg	\N	2026-04-06 20:17:10.903232+00	2026-04-06 20:17:10.903232+00	2026-04-06 20:17:10.903232+00	{"eTag": "\\"6512bb9042491c13260471e3275d56a7\\"", "size": 90943, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:17:10.893Z", "contentLength": 90943, "httpStatusCode": 200}	d7982174-bcb7-470f-90fd-c7916cc21f22	\N	{}
c2f08406-6453-4c3f-91d0-d1bd0ee7645b	imagenes-privadas	image-1775506757430.jpeg	\N	2026-04-06 20:19:17.508629+00	2026-04-06 20:19:17.509116+00	2026-04-06 20:19:17.508629+00	{"eTag": "\\"a8694d7a26468cc97f6c36d05575a799\\"", "size": 449056, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:19:17.496Z", "contentLength": 449056, "httpStatusCode": 200}	7360943f-ee33-4b8a-a8bb-bcc36e1a5745	\N	{}
b1739180-c128-45fc-8a50-4ec83c447f64	imagenes-privadas	image-1775507237962.jpeg	\N	2026-04-06 20:27:18.083487+00	2026-04-06 20:27:18.083487+00	2026-04-06 20:27:18.083487+00	{"eTag": "\\"79154f3eaed4e5fd2bd224a036e8446c\\"", "size": 27815, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:27:18.071Z", "contentLength": 27815, "httpStatusCode": 200}	454b0128-dec5-4614-be24-90b5226bac3e	\N	{}
41a5190e-cb76-4aab-80f5-19e359afb816	imagenes-privadas	image-1775508048311.jpeg	\N	2026-04-06 20:40:48.408917+00	2026-04-06 20:40:48.408917+00	2026-04-06 20:40:48.408917+00	{"eTag": "\\"879592f955302db0b8a2f368e3ea45ea\\"", "size": 600173, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:40:48.395Z", "contentLength": 600173, "httpStatusCode": 200}	86cad52d-9868-42a7-bcef-96c687e3c1fb	\N	{}
2c20331f-ea7b-419d-8aca-c72fc68dc900	imagenes-privadas	image-1775508048318.jpeg	\N	2026-04-06 20:40:48.411901+00	2026-04-06 20:40:48.411901+00	2026-04-06 20:40:48.411901+00	{"eTag": "\\"879592f955302db0b8a2f368e3ea45ea\\"", "size": 600173, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T20:40:48.396Z", "contentLength": 600173, "httpStatusCode": 200}	40b4b7a1-cdd2-4283-ad7f-952b1f0397d2	\N	{}
6b26e892-3e70-4faa-adb8-0641839ad3c1	imagenes-privadas	.emptyFolderPlaceholder	\N	2026-04-03 21:35:33.013534+00	2026-04-03 21:35:33.013534+00	2026-04-03 21:35:33.013534+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-04-03T21:35:32.998Z", "contentLength": 0, "httpStatusCode": 200}	4865e6f5-7507-4af1-9587-0400bc565c2b	\N	{}
9c8069d8-e827-4397-b29e-7ee8e6981221	imagenes-privadas	image-1775487216049.jpeg	\N	2026-04-06 14:53:36.146807+00	2026-04-06 14:53:36.147125+00	2026-04-06 14:53:36.146807+00	{"eTag": "\\"b995d2f7abf9ca74ced4131fffc4a2b8\\"", "size": 331379, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:53:36.134Z", "contentLength": 331379, "httpStatusCode": 200}	2474e2bc-974f-40a5-97c7-0dbb6b9d20aa	\N	{}
d76a735f-18fc-4c7a-adb3-81aa0d3cffe3	imagenes-privadas	image-1775487207873.webp	\N	2026-04-06 14:53:27.976685+00	2026-04-06 14:53:27.976685+00	2026-04-06 14:53:27.976685+00	{"eTag": "\\"f6559972e6458640bdedb749e61d0f91\\"", "size": 81230, "mimetype": "image/webp", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:53:27.964Z", "contentLength": 81230, "httpStatusCode": 200}	480caf6a-92a9-47a2-b5d0-dade7173e351	\N	{}
5aac6459-80d0-42c4-9d06-612eca889bfa	imagenes-privadas	image-1775487207867.webp	\N	2026-04-06 14:53:27.984228+00	2026-04-06 14:53:27.984228+00	2026-04-06 14:53:27.984228+00	{"eTag": "\\"685b39ac5808107b6a143cdefa49d558\\"", "size": 563468, "mimetype": "image/webp", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:53:27.968Z", "contentLength": 563468, "httpStatusCode": 200}	bc28ddc6-c8ff-4435-ba9e-6cb4ac660a3e	\N	{}
0ab80d74-b80a-4568-88de-557395ea43a3	imagenes-privadas	image-1775487216048.jpeg	\N	2026-04-06 14:53:36.557869+00	2026-04-06 14:53:36.557869+00	2026-04-06 14:53:36.557869+00	{"eTag": "\\"e5b1f2bae49e6b8d1ad1a4c8a43200f2\\"", "size": 17456081, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:53:36.377Z", "contentLength": 17456081, "httpStatusCode": 200}	f0345c47-e2e4-4e53-b627-28b45e131d9b	\N	{}
c503a2f3-2ee0-43bd-ad58-8d2adb7b235c	imagenes-privadas	image-1775487216051.jpeg	\N	2026-04-06 14:53:36.55985+00	2026-04-06 14:53:36.55985+00	2026-04-06 14:53:36.55985+00	{"eTag": "\\"e5b1f2bae49e6b8d1ad1a4c8a43200f2\\"", "size": 17456081, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:53:36.377Z", "contentLength": 17456081, "httpStatusCode": 200}	0ca67f41-5b26-4e5f-98ef-6ae3a9c7607f	\N	{}
fbe0a4b6-decb-4706-9c3f-e336a324576a	imagenes-privadas	image-1775487251323.webp	\N	2026-04-06 14:54:11.378631+00	2026-04-06 14:54:11.378631+00	2026-04-06 14:54:11.378631+00	{"eTag": "\\"5c07ff651adcf64f1e223de54db2454b\\"", "size": 21088, "mimetype": "image/webp", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:54:11.365Z", "contentLength": 21088, "httpStatusCode": 200}	fb7a0283-8e26-444e-a3c5-12745e4b857a	\N	{}
08325da6-91b5-47b9-82c7-b3e8d00136d3	imagenes-privadas	image-1775487251324.png	\N	2026-04-06 14:54:11.422841+00	2026-04-06 14:54:11.422841+00	2026-04-06 14:54:11.422841+00	{"eTag": "\\"e9eef0043f17f87d8dabf3e9d2c7a164\\"", "size": 107369, "mimetype": "image/png", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:54:11.407Z", "contentLength": 107369, "httpStatusCode": 200}	6fae4245-693c-4715-ae1e-cc1d17ec428e	\N	{}
f0dc4703-3cfa-4910-91ac-7abb84120cb4	imagenes-privadas	image-1775487251323.png	\N	2026-04-06 14:54:11.422967+00	2026-04-06 14:54:11.422967+00	2026-04-06 14:54:11.422967+00	{"eTag": "\\"e9eef0043f17f87d8dabf3e9d2c7a164\\"", "size": 107369, "mimetype": "image/png", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:54:11.407Z", "contentLength": 107369, "httpStatusCode": 200}	3decb787-696a-401b-9baa-260c7a5f6657	\N	{}
ee968936-e105-471b-a352-400c8c18b726	imagenes-privadas	image-1775487251342.webp	\N	2026-04-06 14:54:11.430308+00	2026-04-06 14:54:11.430308+00	2026-04-06 14:54:11.430308+00	{"eTag": "\\"5c07ff651adcf64f1e223de54db2454b\\"", "size": 21088, "mimetype": "image/webp", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T14:54:11.415Z", "contentLength": 21088, "httpStatusCode": 200}	708b43ad-e57f-4b8f-b869-5333b5188a02	\N	{}
1243d71c-c1ba-4114-92c6-6071401e443c	imagenes-privadas	image-1775513961107.jpeg	\N	2026-04-06 22:19:21.230873+00	2026-04-06 22:19:21.230873+00	2026-04-06 22:19:21.230873+00	{"eTag": "\\"3332b9ef86f50e3be2692bd09e719cd2\\"", "size": 290356, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-06T22:19:21.214Z", "contentLength": 290356, "httpStatusCode": 200}	a161621c-ac2d-40f6-b218-00f4f903865d	\N	{}
c44a461b-fd22-4bf3-9f11-e50d4c60258d	imagenes-privadas	image-1775593175496.jpeg	\N	2026-04-07 20:19:35.760488+00	2026-04-07 20:19:35.760488+00	2026-04-07 20:19:35.760488+00	{"eTag": "\\"00de08bfc0a9af1934a51e0324775351\\"", "size": 617318, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-07T20:19:35.740Z", "contentLength": 617318, "httpStatusCode": 200}	16224499-0581-454c-8168-a137d1e3e076	\N	{}
48d48312-f63b-4389-84d4-aec5448a61d8	imagenes-privadas	image-1775594320202.jpeg	\N	2026-04-07 20:38:40.335954+00	2026-04-07 20:38:40.335954+00	2026-04-07 20:38:40.335954+00	{"eTag": "\\"3332b9ef86f50e3be2692bd09e719cd2\\"", "size": 290356, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-07T20:38:40.320Z", "contentLength": 290356, "httpStatusCode": 200}	dba13b7a-3bb0-46c0-ae5f-b252eb14d783	\N	{}
c895a0fe-b5bc-49a2-b48d-096e76cbc064	imagenes-privadas	image-1775683113570.jpeg	\N	2026-04-08 21:18:33.745288+00	2026-04-08 21:18:33.745288+00	2026-04-08 21:18:33.745288+00	{"eTag": "\\"18e4289a4531da630eab65cb67c8ed39\\"", "size": 2585408, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-08T21:18:33.713Z", "contentLength": 2585408, "httpStatusCode": 200}	afee2b01-f02c-44a9-a85e-3b9c801c2d5e	\N	{}
90ae6d8d-6161-401b-a351-06faba8f51b5	imagenes-privadas	image-1775683225681.jpeg	\N	2026-04-08 21:20:25.848045+00	2026-04-08 21:20:25.848045+00	2026-04-08 21:20:25.848045+00	{"eTag": "\\"18e4289a4531da630eab65cb67c8ed39\\"", "size": 2585408, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-08T21:20:25.816Z", "contentLength": 2585408, "httpStatusCode": 200}	e1ffdca7-c6f3-4d41-9a23-727c12d01396	\N	{}
b29352f2-d573-4abc-a3d5-bffe89462066	imagenes-privadas	image-1775683354196.jpeg	\N	2026-04-08 21:22:34.363437+00	2026-04-08 21:22:34.363437+00	2026-04-08 21:22:34.363437+00	{"eTag": "\\"18e4289a4531da630eab65cb67c8ed39\\"", "size": 2585408, "mimetype": "image/jpeg", "cacheControl": "max-age=undefined", "lastModified": "2026-04-08T21:22:34.331Z", "contentLength": 2585408, "httpStatusCode": 200}	28e32de9-c296-4f4e-8dfa-b25be3a904a6	\N	{}
d24b9529-1897-4cc1-82d2-2fa7cbd46035	profiles_avatars	d1b5adf5f37458f4fab04e1cebe665f0.jpg	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-26 18:14:37.611179+00	2026-06-26 18:14:37.611179+00	2026-06-26 18:14:37.611179+00	{"eTag": "\\"a061e549238c2d29d0c1b5189b46af5e\\"", "size": 104603, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-06-26T18:14:37.593Z", "contentLength": 104603, "httpStatusCode": 200}	dd1e5096-3f01-4f86-b29e-f072e34068b4	6cfeec2d-10c6-40ec-93a4-71836838ccac	{}
110f4f37-8b79-47e8-b60d-8a4087d5a782	profiles_avatars	1771539267880-removebg-preview.png	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-26 18:16:13.411292+00	2026-06-26 18:16:13.411292+00	2026-06-26 18:16:13.411292+00	{"eTag": "\\"5bde84feac99d3aa857f47e593465fec\\"", "size": 162605, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-06-26T18:16:13.395Z", "contentLength": 162605, "httpStatusCode": 200}	2be4e6e8-d749-4788-ab21-c0a2d13e0443	6cfeec2d-10c6-40ec-93a4-71836838ccac	{}
548241fe-b8eb-4754-8d16-18bac2b63e98	profiles_avatars	f4cb3631a066aac334c1853a3372b841.jpg	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-26 21:24:31.170878+00	2026-06-26 21:24:31.170878+00	2026-06-26 21:24:31.170878+00	{"eTag": "\\"f709db3b137753ea059ddffc51a8205a\\"", "size": 39248, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-06-26T21:24:31.149Z", "contentLength": 39248, "httpStatusCode": 200}	af9dd559-2f5c-4faa-bba5-abb263672706	6cfeec2d-10c6-40ec-93a4-71836838ccac	{}
032e1ab2-e3a2-484d-83cf-3a7ab365d4ae	profiles_avatars	test.jpg	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	2026-06-26 21:42:24.540035+00	2026-06-26 21:42:24.540035+00	2026-06-26 21:42:24.540035+00	{"eTag": "\\"5b5eda20fbd21269e4029b3647dc901e\\"", "size": 1119777, "mimetype": "image/png", "cacheControl": "no-cache", "lastModified": "2026-06-26T21:42:24.515Z", "contentLength": 1119777, "httpStatusCode": 200}	bf6f0780-5f45-49bd-be18-9f6bcca72ca1	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	{}
49a542a5-7d57-4c3c-97d7-dd0b4009e077	profiles_avatars	test2.jpg	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	2026-06-26 21:43:49.681997+00	2026-06-26 21:43:49.681997+00	2026-06-26 21:43:49.681997+00	{"eTag": "\\"5b5eda20fbd21269e4029b3647dc901e\\"", "size": 1119777, "mimetype": "image/png", "cacheControl": "no-cache", "lastModified": "2026-06-26T21:43:49.657Z", "contentLength": 1119777, "httpStatusCode": 200}	da7f2369-7475-4464-9dc6-729c83c7712b	f96c5bdc-5579-4be6-909a-7dcf63dcc81f	{}
4dc32d01-0866-44eb-93ef-c750b2ac0fff	profiles_avatars	yo.jpg	6cfeec2d-10c6-40ec-93a4-71836838ccac	2026-06-26 22:20:28.719768+00	2026-06-26 22:35:40.116019+00	2026-06-26 22:20:28.719768+00	{"eTag": "\\"afc7bcf476984d8e6dac95b58be6a34a\\"", "size": 204783, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-06-26T22:35:40.097Z", "contentLength": 204783, "httpStatusCode": 200}	267534b8-8d9f-436d-a1e2-5d5e355cf243	6cfeec2d-10c6-40ec-93a4-71836838ccac	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2026-03-26 21:10:38.726722+00
20210809183423_update_grants	2026-03-26 21:10:38.726722+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 155, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 660, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_06_26 messages_2026_06_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_06_26
    ADD CONSTRAINT messages_2026_06_26_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_06_27 messages_2026_06_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_06_27
    ADD CONSTRAINT messages_2026_06_27_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_06_28 messages_2026_06_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_06_28
    ADD CONSTRAINT messages_2026_06_28_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_06_29 messages_2026_06_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_06_29
    ADD CONSTRAINT messages_2026_06_29_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_06_30 messages_2026_06_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_06_30
    ADD CONSTRAINT messages_2026_06_30_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_01 messages_2026_07_01_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_01
    ADD CONSTRAINT messages_2026_07_01_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_07_02 messages_2026_07_02_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_07_02
    ADD CONSTRAINT messages_2026_07_02_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_06_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_06_26_inserted_at_topic_idx ON realtime.messages_2026_06_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_06_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_06_27_inserted_at_topic_idx ON realtime.messages_2026_06_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_06_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_06_28_inserted_at_topic_idx ON realtime.messages_2026_06_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_06_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_06_29_inserted_at_topic_idx ON realtime.messages_2026_06_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_06_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_06_30_inserted_at_topic_idx ON realtime.messages_2026_06_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_01_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_07_01_inserted_at_topic_idx ON realtime.messages_2026_07_01 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_07_02_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_07_02_inserted_at_topic_idx ON realtime.messages_2026_07_02 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_06_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_06_26_inserted_at_topic_idx;


--
-- Name: messages_2026_06_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_06_26_pkey;


--
-- Name: messages_2026_06_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_06_27_inserted_at_topic_idx;


--
-- Name: messages_2026_06_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_06_27_pkey;


--
-- Name: messages_2026_06_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_06_28_inserted_at_topic_idx;


--
-- Name: messages_2026_06_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_06_28_pkey;


--
-- Name: messages_2026_06_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_06_29_inserted_at_topic_idx;


--
-- Name: messages_2026_06_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_06_29_pkey;


--
-- Name: messages_2026_06_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_06_30_inserted_at_topic_idx;


--
-- Name: messages_2026_06_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_06_30_pkey;


--
-- Name: messages_2026_07_01_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_01_inserted_at_topic_idx;


--
-- Name: messages_2026_07_01_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_01_pkey;


--
-- Name: messages_2026_07_02_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_07_02_inserted_at_topic_idx;


--
-- Name: messages_2026_07_02_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_07_02_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: messages messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Enable insert for authenticated users only" ON public.messages FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((( SELECT auth.uid() AS uid) = id));


--
-- Name: messages allow select to public; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "allow select to public" ON public.messages FOR SELECT USING (true);


--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: messages owner message can delete; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "owner message can delete" ON public.messages FOR DELETE TO authenticated USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects ANON_CAN_UPLOAD 1j7mwej_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "ANON_CAN_UPLOAD 1j7mwej_0" ON storage.objects FOR INSERT TO anon WITH CHECK ((bucket_id = 'subir-fotos'::text));


--
-- Name: objects Anyone can upload an avatar.; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Anyone can upload an avatar." ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'avatars'::text));


--
-- Name: objects Auth Users can select 1kl1id_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Users can select 1kl1id_0" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'profiles_avatars'::text));


--
-- Name: objects Auth Users can upload 1kl1id_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Users can upload 1kl1id_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'profiles_avatars'::text));


--
-- Name: objects Auth Users can upsert 1kl1id_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Users can upsert 1kl1id_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'profiles_avatars'::text));


--
-- Name: objects Auth Users can upsert 1kl1id_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Users can upsert 1kl1id_1" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'profiles_avatars'::text));


--
-- Name: objects Auth Users can upsert 1kl1id_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Users can upsert 1kl1id_2" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'profiles_avatars'::text));


--
-- Name: objects Avatar images are publicly accessible.; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Avatar images are publicly accessible." ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime messages; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.messages;


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_user() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION handle_new_userkk(); Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION public.handle_new_userkk() TO postgres;
GRANT ALL ON FUNCTION public.handle_new_userkk() TO anon;
GRANT ALL ON FUNCTION public.handle_new_userkk() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_userkk() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.messages TO postgres;
GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.profiles TO postgres;
GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_06_26; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_06_26 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_06_26 TO dashboard_user;


--
-- Name: TABLE messages_2026_06_27; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_06_27 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_06_27 TO dashboard_user;


--
-- Name: TABLE messages_2026_06_28; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_06_28 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_06_28 TO dashboard_user;


--
-- Name: TABLE messages_2026_06_29; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_06_29 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_06_29 TO dashboard_user;


--
-- Name: TABLE messages_2026_06_30; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_06_30 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_06_30 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_01; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_01 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_01 TO dashboard_user;


--
-- Name: TABLE messages_2026_07_02; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_07_02 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_07_02 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE iceberg_namespaces; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_namespaces TO service_role;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO anon;


--
-- Name: TABLE iceberg_tables; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_tables TO service_role;
GRANT SELECT ON TABLE storage.iceberg_tables TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_tables TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

