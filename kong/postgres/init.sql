--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.24
-- Dumped by pg_dump version 9.6.24

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

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: sync_tags(); Type: FUNCTION; Schema: public; Owner: architect
--

CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'TRUNCATE') THEN
            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;
            RETURN NULL;
          ELSIF (TG_OP = 'DELETE') THEN
            DELETE FROM tags WHERE entity_id = OLD.id;
            RETURN OLD;
          ELSE

          -- Triggered by INSERT/UPDATE
          -- Do an upsert on the tags table
          -- So we don't need to migrate pre 1.1 entities
          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)
          ON CONFLICT (entity_id) DO UPDATE
                  SET tags=EXCLUDED.tags;
          END IF;
          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.sync_tags() OWNER TO architect;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acls; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    "group" text,
    cache_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.acls OWNER TO architect;

--
-- Name: acme_storage; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.acme_storage (
    id uuid NOT NULL,
    key text,
    value text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.acme_storage OWNER TO architect;

--
-- Name: basicauth_credentials; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    password text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.basicauth_credentials OWNER TO architect;

--
-- Name: ca_certificates; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.ca_certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text NOT NULL,
    tags text[],
    cert_digest text NOT NULL
);


ALTER TABLE public.ca_certificates OWNER TO architect;

--
-- Name: certificates; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text,
    key text,
    tags text[],
    ws_id uuid,
    cert_alt text,
    key_alt text
);


ALTER TABLE public.certificates OWNER TO architect;

--
-- Name: cluster_events; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);


ALTER TABLE public.cluster_events OWNER TO architect;

--
-- Name: clustering_data_planes; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.clustering_data_planes (
    id uuid NOT NULL,
    hostname text NOT NULL,
    ip text NOT NULL,
    last_seen timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    config_hash text NOT NULL,
    ttl timestamp with time zone,
    version text,
    sync_status text DEFAULT 'unknown'::text NOT NULL
);


ALTER TABLE public.clustering_data_planes OWNER TO architect;

--
-- Name: consumers; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    username text,
    custom_id text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.consumers OWNER TO architect;

--
-- Name: hmacauth_credentials; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    secret text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.hmacauth_credentials OWNER TO architect;

--
-- Name: jwt_secrets; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.jwt_secrets OWNER TO architect;

--
-- Name: keyauth_credentials; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    tags text[],
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.keyauth_credentials OWNER TO architect;

--
-- Name: konga_api_health_checks; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_api_health_checks (
    id integer NOT NULL,
    api_id text,
    api json,
    health_check_endpoint text,
    notification_endpoint text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_api_health_checks OWNER TO architect;

--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_api_health_checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_api_health_checks_id_seq OWNER TO architect;

--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_api_health_checks_id_seq OWNED BY public.konga_api_health_checks.id;


--
-- Name: konga_email_transports; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_email_transports (
    id integer NOT NULL,
    name text,
    description text,
    schema json,
    settings json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_email_transports OWNER TO architect;

--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_email_transports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_email_transports_id_seq OWNER TO architect;

--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_email_transports_id_seq OWNED BY public.konga_email_transports.id;


--
-- Name: konga_kong_nodes; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_kong_nodes (
    id integer NOT NULL,
    name text,
    type text,
    kong_admin_url text,
    netdata_url text,
    kong_api_key text,
    jwt_algorithm text,
    jwt_key text,
    jwt_secret text,
    username text,
    password text,
    kong_version text,
    health_checks boolean,
    health_check_details json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_nodes OWNER TO architect;

--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_kong_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_nodes_id_seq OWNER TO architect;

--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_kong_nodes_id_seq OWNED BY public.konga_kong_nodes.id;


--
-- Name: konga_kong_services; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_kong_services (
    id integer NOT NULL,
    service_id text,
    kong_node_id text,
    description text,
    tags json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_services OWNER TO architect;

--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_kong_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_services_id_seq OWNER TO architect;

--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_kong_services_id_seq OWNED BY public.konga_kong_services.id;


--
-- Name: konga_kong_snapshot_schedules; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_kong_snapshot_schedules (
    id integer NOT NULL,
    connection integer,
    active boolean,
    cron text,
    "lastRunAt" date,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshot_schedules OWNER TO architect;

--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_kong_snapshot_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshot_schedules_id_seq OWNER TO architect;

--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_kong_snapshot_schedules_id_seq OWNED BY public.konga_kong_snapshot_schedules.id;


--
-- Name: konga_kong_snapshots; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_kong_snapshots (
    id integer NOT NULL,
    name text,
    kong_node_name text,
    kong_node_url text,
    kong_version text,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshots OWNER TO architect;

--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_kong_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshots_id_seq OWNER TO architect;

--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_kong_snapshots_id_seq OWNED BY public.konga_kong_snapshots.id;


--
-- Name: konga_kong_upstream_alerts; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_kong_upstream_alerts (
    id integer NOT NULL,
    upstream_id text,
    connection integer,
    email boolean,
    slack boolean,
    cron text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_upstream_alerts OWNER TO architect;

--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_kong_upstream_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_upstream_alerts_id_seq OWNER TO architect;

--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_kong_upstream_alerts_id_seq OWNED BY public.konga_kong_upstream_alerts.id;


--
-- Name: konga_netdata_connections; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_netdata_connections (
    id integer NOT NULL,
    "apiId" text,
    url text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_netdata_connections OWNER TO architect;

--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_netdata_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_netdata_connections_id_seq OWNER TO architect;

--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_netdata_connections_id_seq OWNED BY public.konga_netdata_connections.id;


--
-- Name: konga_passports; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_passports (
    id integer NOT NULL,
    protocol text,
    password text,
    provider text,
    identifier text,
    tokens json,
    "user" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.konga_passports OWNER TO architect;

--
-- Name: konga_passports_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_passports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_passports_id_seq OWNER TO architect;

--
-- Name: konga_passports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_passports_id_seq OWNED BY public.konga_passports.id;


--
-- Name: konga_settings; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_settings (
    id integer NOT NULL,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_settings OWNER TO architect;

--
-- Name: konga_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_settings_id_seq OWNER TO architect;

--
-- Name: konga_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_settings_id_seq OWNED BY public.konga_settings.id;


--
-- Name: konga_users; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.konga_users (
    id integer NOT NULL,
    username text,
    email text,
    "firstName" text,
    "lastName" text,
    admin boolean,
    node_id text,
    active boolean,
    "activationToken" text,
    node integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_users OWNER TO architect;

--
-- Name: konga_users_id_seq; Type: SEQUENCE; Schema: public; Owner: architect
--

CREATE SEQUENCE public.konga_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_users_id_seq OWNER TO architect;

--
-- Name: konga_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: architect
--

ALTER SEQUENCE public.konga_users_id_seq OWNED BY public.konga_users.id;


--
-- Name: locks; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);


ALTER TABLE public.locks OWNER TO architect;

--
-- Name: oauth2_authorization_codes; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    challenge text,
    challenge_method text,
    ws_id uuid
);


ALTER TABLE public.oauth2_authorization_codes OWNER TO architect;

--
-- Name: oauth2_credentials; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[],
    tags text[],
    client_type text,
    hash_secret boolean,
    ws_id uuid
);


ALTER TABLE public.oauth2_credentials OWNER TO architect;

--
-- Name: oauth2_tokens; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.oauth2_tokens OWNER TO architect;

--
-- Name: parameters; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.parameters (
    key text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone
);


ALTER TABLE public.parameters OWNER TO architect;

--
-- Name: plugins; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    protocols text[],
    tags text[],
    ws_id uuid
);


ALTER TABLE public.plugins OWNER TO architect;

--
-- Name: ratelimiting_metrics; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer,
    ttl timestamp with time zone
);


ALTER TABLE public.ratelimiting_metrics OWNER TO architect;

--
-- Name: response_ratelimiting_metrics; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.response_ratelimiting_metrics OWNER TO architect;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    tags text[],
    https_redirect_status_code integer,
    headers jsonb,
    path_handling text DEFAULT 'v0'::text,
    ws_id uuid,
    request_buffering boolean,
    response_buffering boolean
);


ALTER TABLE public.routes OWNER TO architect;

--
-- Name: schema_meta; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);


ALTER TABLE public.schema_meta OWNER TO architect;

--
-- Name: services; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[],
    client_certificate_id uuid,
    tls_verify boolean,
    tls_verify_depth smallint,
    ca_certificates uuid[],
    ws_id uuid,
    enabled boolean DEFAULT true
);


ALTER TABLE public.services OWNER TO architect;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    session_id text,
    expires integer,
    data text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO architect;

--
-- Name: snis; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    certificate_id uuid,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.snis OWNER TO architect;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);


ALTER TABLE public.tags OWNER TO architect;

--
-- Name: targets; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.targets OWNER TO architect;

--
-- Name: ttls; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ttls OWNER TO architect;

--
-- Name: upstreams; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[],
    algorithm text,
    host_header text,
    client_certificate_id uuid,
    ws_id uuid
);


ALTER TABLE public.upstreams OWNER TO architect;

--
-- Name: vaults_beta; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.vaults_beta (
    id uuid NOT NULL,
    ws_id uuid,
    prefix text,
    name text NOT NULL,
    description text,
    config jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    updated_at timestamp with time zone,
    tags text[]
);


ALTER TABLE public.vaults_beta OWNER TO architect;

--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: architect
--

CREATE TABLE public.workspaces (
    id uuid NOT NULL,
    name text,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    meta jsonb,
    config jsonb
);


ALTER TABLE public.workspaces OWNER TO architect;

--
-- Name: konga_api_health_checks id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_api_health_checks ALTER COLUMN id SET DEFAULT nextval('public.konga_api_health_checks_id_seq'::regclass);


--
-- Name: konga_email_transports id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_email_transports ALTER COLUMN id SET DEFAULT nextval('public.konga_email_transports_id_seq'::regclass);


--
-- Name: konga_kong_nodes id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_nodes ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_nodes_id_seq'::regclass);


--
-- Name: konga_kong_services id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_services ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_services_id_seq'::regclass);


--
-- Name: konga_kong_snapshot_schedules id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshot_schedules_id_seq'::regclass);


--
-- Name: konga_kong_snapshots id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_snapshots ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshots_id_seq'::regclass);


--
-- Name: konga_kong_upstream_alerts id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_upstream_alerts_id_seq'::regclass);


--
-- Name: konga_netdata_connections id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_netdata_connections ALTER COLUMN id SET DEFAULT nextval('public.konga_netdata_connections_id_seq'::regclass);


--
-- Name: konga_passports id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_passports ALTER COLUMN id SET DEFAULT nextval('public.konga_passports_id_seq'::regclass);


--
-- Name: konga_settings id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_settings ALTER COLUMN id SET DEFAULT nextval('public.konga_settings_id_seq'::regclass);


--
-- Name: konga_users id; Type: DEFAULT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_users ALTER COLUMN id SET DEFAULT nextval('public.konga_users_id_seq'::regclass);


--
-- Data for Name: acls; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.acls (id, created_at, consumer_id, "group", cache_key, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: acme_storage; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.acme_storage (id, key, value, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: basicauth_credentials; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.basicauth_credentials (id, created_at, consumer_id, username, password, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: ca_certificates; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.ca_certificates (id, created_at, cert, tags, cert_digest) FROM stdin;
\.


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.certificates (id, created_at, cert, key, tags, ws_id, cert_alt, key_alt) FROM stdin;
\.


--
-- Data for Name: cluster_events; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) FROM stdin;
549d05b5-61ff-46ac-966a-ed0390b03bac	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 14:56:29.428+00	\N	2022-07-04 15:56:29.428+00	invalidations	services:6559c1f6-364a-4ebb-9a83-51b85d690c64:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
bf839276-7477-45a0-8a30-6ef3b6c75cfe	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:15:21.204+00	\N	2022-07-04 16:15:21.204+00	invalidations	services:f6e099ba-2779-464e-9a9a-2e857fb6d8a8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
08514ac5-cfe4-4670-848c-5bfcb462d4f1	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:40:27.397+00	\N	2022-07-04 16:40:27.397+00	invalidations	routes:2d6e7d56-47ea-4d9d-8a1a-b466b72261a3:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
6c994735-8546-44c5-abcc-60f506cfba14	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:40:27.4+00	\N	2022-07-04 16:40:27.4+00	invalidations	router:version
87e9be25-6aeb-4c4a-be18-d22a3a3e8e50	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 14:58:35.314+00	\N	2022-07-04 15:58:35.314+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
bbaca989-0788-4c4f-ba4e-f53656a790ee	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 14:58:35.316+00	\N	2022-07-04 15:58:35.316+00	invalidations	router:version
449912b5-f22c-4143-baf2-f2dee32dee24	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 14:59:32.451+00	\N	2022-07-04 15:59:32.451+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
f76826be-8a1b-4d8c-8eea-d0599ef2deec	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 14:59:32.453+00	\N	2022-07-04 15:59:32.453+00	invalidations	router:version
b0c6edbf-e8ad-41b2-be90-b215f4369c69	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:01:06.847+00	\N	2022-07-04 16:01:06.847+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
d28b04a1-5a00-4e4b-9027-b30ef9cca766	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:01:06.849+00	\N	2022-07-04 16:01:06.849+00	invalidations	router:version
630a367b-3efe-4be5-887d-430b5dfde983	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:12.312+00	\N	2022-07-04 16:02:12.312+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
6962c201-b50a-45a8-8957-0754fb0b7890	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:12.314+00	\N	2022-07-04 16:02:12.314+00	invalidations	router:version
21c1d0bc-defb-4ca7-a29f-2774f5809267	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:28.372+00	\N	2022-07-04 16:02:28.372+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
27271790-1903-4f38-b4f5-4e373ed13986	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:28.377+00	\N	2022-07-04 16:02:28.377+00	invalidations	router:version
c83481a7-2ffc-4898-bd5c-4edf93198edc	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:50.522+00	\N	2022-07-04 16:02:50.522+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
c7e86cbd-107a-43a5-84d4-bc86a46cf16e	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:02:50.524+00	\N	2022-07-04 16:02:50.524+00	invalidations	router:version
ff52678e-eeb2-4c33-90c7-226596590a40	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:32.088+00	\N	2022-07-04 16:03:32.088+00	invalidations	services:6559c1f6-364a-4ebb-9a83-51b85d690c64:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
57fdaf01-e652-4985-b229-7ad4524c8819	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:32.09+00	\N	2022-07-04 16:03:32.09+00	invalidations	router:version
9658318b-913b-4933-9246-7767abc51d7e	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:43.49+00	\N	2022-07-04 16:03:43.49+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
70fccfee-fcce-4f96-b111-dc68c2d8a017	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:43.491+00	\N	2022-07-04 16:03:43.491+00	invalidations	router:version
1ef34770-8f17-4a84-b4f4-d870c4ebfa54	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:46.935+00	\N	2022-07-04 16:03:46.935+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
0fa7210d-931a-40c4-a86e-376a5c8695c0	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:03:46.936+00	\N	2022-07-04 16:03:46.936+00	invalidations	router:version
e01175bb-f8f1-4b06-8128-020273033e92	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:04:04.02+00	\N	2022-07-04 16:04:04.02+00	invalidations	services:6559c1f6-364a-4ebb-9a83-51b85d690c64:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
908df8bc-af9a-473a-865b-10a1b39cb06d	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:04:04.024+00	\N	2022-07-04 16:04:04.024+00	invalidations	router:version
000d3ce1-85db-44a2-997b-2c8e1c9d5614	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:04:12.441+00	\N	2022-07-04 16:04:12.441+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
d0066e9c-cab6-4db9-add8-aaa41ab2d604	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:04:12.442+00	\N	2022-07-04 16:04:12.442+00	invalidations	router:version
72434786-8ec8-414f-9501-6ad2f59a623c	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:28.909+00	\N	2022-07-04 16:05:28.909+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
1de5d8c3-4d7f-44b8-a73d-8acec422483a	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:28.911+00	\N	2022-07-04 16:05:28.911+00	invalidations	router:version
2c233637-a65b-4bf0-ae50-246cbb21c89a	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:39.704+00	\N	2022-07-04 16:05:39.704+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
39034387-8c39-43af-a253-b0c983a87dcd	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:39.706+00	\N	2022-07-04 16:05:39.706+00	invalidations	router:version
356aa109-b172-46f4-ac6c-e0e103de6a86	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:55.467+00	\N	2022-07-04 16:05:55.467+00	invalidations	services:6559c1f6-364a-4ebb-9a83-51b85d690c64:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
8d00dfa6-3d3a-44d7-8e55-47d56443ca9d	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:05:55.469+00	\N	2022-07-04 16:05:55.469+00	invalidations	router:version
c51a8b2a-39a4-4119-8c16-f1d24f83a817	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:06:12.952+00	\N	2022-07-04 16:06:12.952+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
cdf31fda-885f-4d8f-a0fd-91b3ed5d1ccb	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:06:12.954+00	\N	2022-07-04 16:06:12.954+00	invalidations	router:version
a2d8f7e3-eb5a-4b9e-a49b-e6b05eafc40b	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:06:39.822+00	\N	2022-07-04 16:06:39.822+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
b8114c40-e5a1-49a2-8cf1-ee95dbba50c1	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:06:39.824+00	\N	2022-07-04 16:06:39.824+00	invalidations	router:version
47f71da8-1718-4f80-9f43-5112447c7449	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:06.021+00	\N	2022-07-04 16:07:06.021+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
754c4eee-8a28-4ac1-b99c-4ab832a5fb28	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:06.023+00	\N	2022-07-04 16:07:06.023+00	invalidations	router:version
c19fe431-9021-43f1-8d1d-61ff8c9de034	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:40.865+00	\N	2022-07-04 16:07:40.865+00	invalidations	services:6559c1f6-364a-4ebb-9a83-51b85d690c64:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
f7d5d51f-d234-4830-8e09-064bfc5c4381	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:40.866+00	\N	2022-07-04 16:07:40.866+00	invalidations	router:version
b58c44fc-c620-4274-89a6-2fdd7f5b2fa4	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:17:26.123+00	\N	2022-07-04 16:17:26.123+00	invalidations	routes:374c531a-fe60-4c86-b4a0-d17b829837c1:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
fc00518b-84d2-436d-8905-e3dd01fcad9a	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:17:26.125+00	\N	2022-07-04 16:17:26.125+00	invalidations	router:version
819b86d1-f05f-43e3-8ebb-dc3de0e0723c	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:48.791+00	\N	2022-07-04 16:07:48.791+00	invalidations	routes:945a1d67-3fec-4e1a-8ede-524161729cf8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
3e8902aa-393b-40b4-8376-7cb8ca799098	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:07:48.794+00	\N	2022-07-04 16:07:48.794+00	invalidations	router:version
0abaf46b-4fa3-401d-8185-b294ddeca966	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:34:07.75+00	\N	2022-07-04 16:34:07.75+00	invalidations	services:f6e099ba-2779-464e-9a9a-2e857fb6d8a8:::::8472221a-9632-4b1c-9cfb-25fb3efaad8d
940e1592-a829-4d23-85a4-a8223ff9067b	97e8ad8c-6d5f-4311-88bb-2aaad8d5cb89	2022-07-04 15:34:07.753+00	\N	2022-07-04 16:34:07.753+00	invalidations	router:version
\.


--
-- Data for Name: clustering_data_planes; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.clustering_data_planes (id, hostname, ip, last_seen, config_hash, ttl, version, sync_status) FROM stdin;
\.


--
-- Data for Name: consumers; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.consumers (id, created_at, username, custom_id, tags, ws_id) FROM stdin;
5dc9fb49-396c-48b1-aac4-d20812b461d2	2022-06-30 12:50:35+00	authenticated	authenticated	{backend,archivel,laravel,authenticated}	8472221a-9632-4b1c-9cfb-25fb3efaad8d
51c44ada-fea6-43fc-b75d-3d69a973eca7	2022-06-30 12:39:38+00	authentication	authentication	{archivel,backend,authentication,laravel}	8472221a-9632-4b1c-9cfb-25fb3efaad8d
\.


--
-- Data for Name: hmacauth_credentials; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.hmacauth_credentials (id, created_at, consumer_id, username, secret, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: jwt_secrets; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.jwt_secrets (id, created_at, consumer_id, key, secret, algorithm, rsa_public_key, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: keyauth_credentials; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.keyauth_credentials (id, created_at, consumer_id, key, tags, ttl, ws_id) FROM stdin;
2ffc54ce-b8a1-4fa3-95b3-b66cb98b2077	2022-06-30 12:47:56+00	51c44ada-fea6-43fc-b75d-3d69a973eca7	DovOzH7VOuKlJ3SPr8dhNEACzW3S81Z1	\N	\N	8472221a-9632-4b1c-9cfb-25fb3efaad8d
\.


--
-- Data for Name: konga_api_health_checks; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_api_health_checks (id, api_id, api, health_check_endpoint, notification_endpoint, active, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_api_health_checks_id_seq', 1, false);


--
-- Data for Name: konga_email_transports; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_email_transports (id, name, description, schema, settings, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	smtp	Send emails using the SMTP protocol	[{"name":"host","description":"The SMTP host","type":"text","required":true},{"name":"port","description":"The SMTP port","type":"text","required":true},{"name":"username","model":"auth.user","description":"The SMTP user username","type":"text","required":true},{"name":"password","model":"auth.pass","description":"The SMTP user password","type":"text","required":true},{"name":"secure","model":"secure","description":"Use secure connection","type":"boolean"}]	{"host":"","port":"","auth":{"user":"","pass":""},"secure":false}	t	2022-06-30 08:22:42+00	2022-07-04 14:51:49+00	\N	\N
2	sendmail	Pipe messages to the sendmail command	\N	{"sendmail":true}	f	2022-06-30 08:22:42+00	2022-07-04 14:51:49+00	\N	\N
3	mailgun	Send emails through Mailgun’s Web API	[{"name":"api_key","model":"auth.api_key","description":"The API key that you got from www.mailgun.com/cp","type":"text","required":true},{"name":"domain","model":"auth.domain","description":"One of your domain names listed at your https://mailgun.com/app/domains","type":"text","required":true}]	{"auth":{"api_key":"","domain":""}}	f	2022-06-30 08:22:42+00	2022-07-04 14:51:50+00	\N	\N
\.


--
-- Name: konga_email_transports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_email_transports_id_seq', 3, true);


--
-- Data for Name: konga_kong_nodes; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_kong_nodes (id, name, type, kong_admin_url, netdata_url, kong_api_key, jwt_algorithm, jwt_key, jwt_secret, username, password, kong_version, health_checks, health_check_details, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	Archikong	default	http://kong:8001	\N		HS256	\N	\N			2.8.1	f	\N	f	2022-06-30 08:24:03+00	2022-06-30 08:24:04+00	1	1
\.


--
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_kong_nodes_id_seq', 1, true);


--
-- Data for Name: konga_kong_services; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_kong_services (id, service_id, kong_node_id, description, tags, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	6559c1f6-364a-4ebb-9a83-51b85d690c64	1	\N	\N	2022-07-04 14:56:29+00	2022-07-04 15:07:40+00	\N	\N
2	f6e099ba-2779-464e-9a9a-2e857fb6d8a8	1	\N	\N	2022-07-04 15:15:21+00	2022-07-04 15:34:07+00	\N	\N
\.


--
-- Name: konga_kong_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_kong_services_id_seq', 2, true);


--
-- Data for Name: konga_kong_snapshot_schedules; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_kong_snapshot_schedules (id, connection, active, cron, "lastRunAt", "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_kong_snapshot_schedules_id_seq', 1, false);


--
-- Data for Name: konga_kong_snapshots; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_kong_snapshots (id, name, kong_node_name, kong_node_url, kong_version, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_kong_snapshots_id_seq', 1, false);


--
-- Data for Name: konga_kong_upstream_alerts; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_kong_upstream_alerts (id, upstream_id, connection, email, slack, cron, active, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_kong_upstream_alerts_id_seq', 1, false);


--
-- Data for Name: konga_netdata_connections; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_netdata_connections (id, "apiId", url, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
\.


--
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_netdata_connections_id_seq', 1, false);


--
-- Data for Name: konga_passports; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_passports (id, protocol, password, provider, identifier, tokens, "user", "createdAt", "updatedAt") FROM stdin;
1	local	$2a$10$2L0B/NiGaKULwUMnNz.Vmu.eDnXIvPeDjsnGJr5630Cl4tqQMsX6G	\N	\N	\N	1	2022-06-30 08:23:27+00	2022-06-30 08:23:27+00
\.


--
-- Name: konga_passports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_passports_id_seq', 1, true);


--
-- Data for Name: konga_settings; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_settings (id, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	{"signup_enable":false,"signup_require_activation":false,"info_polling_interval":5000,"email_default_sender_name":"KONGA","email_default_sender":"konga@konga.test","email_notifications":false,"default_transport":"mailgun","notify_when":{"node_down":{"title":"A node is down or unresponsive","description":"Health checks must be enabled for the nodes that need to be monitored.","active":false},"api_down":{"title":"An API is down or unresponsive","description":"Health checks must be enabled for the APIs that need to be monitored.","active":false}},"integrations":[{"id":"slack","name":"Slack","image":"slack_rgb.png","config":{"enabled":false,"fields":[{"id":"slack_webhook_url","name":"Slack Webhook URL","type":"text","required":true,"value":""}],"slack_webhook_url":""}}],"user_permissions":{"apis":{"create":false,"read":true,"update":false,"delete":false},"services":{"create":false,"read":true,"update":false,"delete":false},"routes":{"create":false,"read":true,"update":false,"delete":false},"consumers":{"create":false,"read":true,"update":false,"delete":false},"plugins":{"create":false,"read":true,"update":false,"delete":false},"upstreams":{"create":false,"read":true,"update":false,"delete":false},"certificates":{"create":false,"read":true,"update":false,"delete":false},"connections":{"create":false,"read":true,"update":false,"delete":false},"users":{"create":false,"read":true,"update":false,"delete":false}}}	2022-06-30 08:22:42+00	2022-07-04 14:51:50+00	\N	\N
\.


--
-- Name: konga_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_settings_id_seq', 1, true);


--
-- Data for Name: konga_users; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.konga_users (id, username, email, "firstName", "lastName", admin, node_id, active, "activationToken", node, "createdAt", "updatedAt", "createdUserId", "updatedUserId") FROM stdin;
1	architect	god@architect.com	\N	\N	t		t	14a94110-9c43-4f6d-aaa4-b72656f6869e	1	2022-06-30 08:23:25+00	2022-06-30 08:24:04+00	\N	1
\.


--
-- Name: konga_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: architect
--

SELECT pg_catalog.setval('public.konga_users_id_seq', 1, true);


--
-- Data for Name: locks; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.locks (key, owner, ttl) FROM stdin;
\.


--
-- Data for Name: oauth2_authorization_codes; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.oauth2_authorization_codes (id, created_at, credential_id, service_id, code, authenticated_userid, scope, ttl, challenge, challenge_method, ws_id) FROM stdin;
\.


--
-- Data for Name: oauth2_credentials; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.oauth2_credentials (id, created_at, name, consumer_id, client_id, client_secret, redirect_uris, tags, client_type, hash_secret, ws_id) FROM stdin;
\.


--
-- Data for Name: oauth2_tokens; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.oauth2_tokens (id, created_at, credential_id, service_id, access_token, refresh_token, token_type, expires_in, authenticated_userid, scope, ttl, ws_id) FROM stdin;
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.parameters (key, value, created_at) FROM stdin;
cluster_id	504ccecc-ff3a-4ddc-8dcc-cddc73a2c934	\N
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.plugins (id, created_at, name, consumer_id, service_id, route_id, config, enabled, cache_key, protocols, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value, ttl) FROM stdin;
\.


--
-- Data for Name: response_ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.response_ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.routes (id, created_at, updated_at, name, service_id, protocols, methods, hosts, paths, snis, sources, destinations, regex_priority, strip_path, preserve_host, tags, https_redirect_status_code, headers, path_handling, ws_id, request_buffering, response_buffering) FROM stdin;
a9a9e6e2-8d07-4331-9c31-22a2f1ad6032	2022-07-01 13:06:41+00	2022-07-04 12:03:41+00	crud-operations	6b7f4e68-d856-475e-a6d4-b99530a84401	{http,https}	{GET,POST,PUT,PATCH,DELETE}	{localhost,architect.com,archifront_nginx}	{/users,/users/any/}	{snis}	\N	\N	0	t	f	{archivel,authenticated,users,services,index}	426	{"accept": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
40125995-0ca5-49bb-a314-891e0de6d076	2022-06-30 08:40:07+00	2022-07-04 12:27:57+00	login	f0adec3a-e02f-4b82-9ae8-c6ccfb5e4776	{http,https}	{POST}	{architect.com,localhost,archifront_nginx}	{/login}	{snis}	\N	\N	0	f	f	{authentication,login,laravel,backend}	426	{"content-type": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
945a1d67-3fec-4e1a-8ede-524161729cf8	2022-07-04 14:58:35+00	2022-07-04 15:07:48+00	logged-in	6559c1f6-364a-4ebb-9a83-51b85d690c64	{http,https}	{POST}	{localhost,architect.com,balancer_nginx}	{/users/logged-in}	{snis}	\N	\N	0	f	f	{balancer,users,services,logged-in}	426	{"content-type": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
374c531a-fe60-4c86-b4a0-d17b829837c1	2022-07-04 15:17:26+00	2022-07-04 15:17:26+00	send-email	f6e099ba-2779-464e-9a9a-2e857fb6d8a8	{http,https}	{POST}	{localhost,architect.com,mailman}	{/users/send-email}	{snis}	\N	\N	0	f	f	{mailman,users,services,send-email,mailgun}	426	{"content-type": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
2d6e7d56-47ea-4d9d-8a1a-b466b72261a3	2022-07-04 15:40:27+00	2022-07-04 15:40:27+00	registered	6559c1f6-364a-4ebb-9a83-51b85d690c64	{http,https}	{POST}	{localhost,architect.com,balancer_nginx}	{/users/registered}	{snis}	\N	\N	0	f	f	{balancer,users,services,registered}	426	{"content-type": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
fd616af9-2120-4d2a-a7ab-78af5ceeb236	2022-06-30 10:03:05+00	2022-06-30 14:43:20+00	register	f0adec3a-e02f-4b82-9ae8-c6ccfb5e4776	{http,https}	{POST}	{localhost}	{/register}	{snis}	\N	\N	0	f	f	{register,backend,laravel,authentication}	426	{"content-type": ["application/json"]}	v1	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t	t
\.


--
-- Data for Name: schema_meta; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.schema_meta (key, subsystem, last_executed, executed, pending) FROM stdin;
schema_meta	jwt	003_200_to_210	{000_base_jwt,002_130_to_140,003_200_to_210}	{}
schema_meta	key-auth	003_200_to_210	{000_base_key_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	oauth2	005_210_to_211	{000_base_oauth2,003_130_to_140,004_200_to_210,005_210_to_211}	{}
schema_meta	rate-limiting	004_200_to_210	{000_base_rate_limiting,003_10_to_112,004_200_to_210}	\N
schema_meta	response-ratelimiting	000_base_response_rate_limiting	{000_base_response_rate_limiting}	\N
schema_meta	session	001_add_ttl_index	{000_base_session,001_add_ttl_index}	\N
schema_meta	core	015_270_to_280	{000_base,003_100_to_110,004_110_to_120,005_120_to_130,006_130_to_140,007_140_to_150,008_150_to_200,009_200_to_210,010_210_to_211,011_212_to_213,012_213_to_220,013_220_to_230,014_230_to_270,015_270_to_280}	{}
schema_meta	acl	004_212_to_213	{000_base_acl,002_130_to_140,003_200_to_210,004_212_to_213}	{}
schema_meta	acme	000_base_acme	{000_base_acme}	\N
schema_meta	basic-auth	003_200_to_210	{000_base_basic_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	bot-detection	001_200_to_210	{001_200_to_210}	{}
schema_meta	hmac-auth	003_200_to_210	{000_base_hmac_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	ip-restriction	001_200_to_210	{001_200_to_210}	{}
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags, client_certificate_id, tls_verify, tls_verify_depth, ca_certificates, ws_id, enabled) FROM stdin;
6559c1f6-364a-4ebb-9a83-51b85d690c64	2022-07-04 14:56:29+00	2022-07-04 15:07:40+00	balancer-user-services	5	http	balancer_nginx	80	/	60000	60000	60000	{balancer,users,services,backend,javascript,rust}	\N	\N	\N	\N	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t
f6e099ba-2779-464e-9a9a-2e857fb6d8a8	2022-07-04 15:15:21+00	2022-07-04 15:34:07+00	mailman-user-services	5	http	mailman	5555	/	60000	60000	60000	{mailman,users,services,backend,typescript,mailgun}	\N	\N	\N	\N	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t
f0adec3a-e02f-4b82-9ae8-c6ccfb5e4776	2022-06-30 08:34:46+00	2022-06-30 13:15:11+00	archivel-authentication-services	5	http	archivel_nginx	80	/api/auth/	60000	60000	60000	{laravel,backend,authentication,archivel}	\N	\N	\N	\N	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t
6b7f4e68-d856-475e-a6d4-b99530a84401	2022-06-30 13:16:13+00	2022-06-30 13:19:29+00	archivel-authenticated-users-services	5	http	archivel_nginx	80	/api/users/	60000	60000	60000	{archivel,autheticated,users,services,backend,laravel}	\N	\N	\N	\N	8472221a-9632-4b1c-9cfb-25fb3efaad8d	t
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.sessions (id, session_id, expires, data, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: snis; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.snis (id, created_at, name, certificate_id, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.tags (entity_id, entity_name, tags) FROM stdin;
2ffc54ce-b8a1-4fa3-95b3-b66cb98b2077	keyauth_credentials	\N
5dc9fb49-396c-48b1-aac4-d20812b461d2	consumers	{backend,archivel,laravel,authenticated}
51c44ada-fea6-43fc-b75d-3d69a973eca7	consumers	{archivel,backend,authentication,laravel}
a9a9e6e2-8d07-4331-9c31-22a2f1ad6032	routes	{archivel,authenticated,users,services,index}
40125995-0ca5-49bb-a314-891e0de6d076	routes	{authentication,login,laravel,backend}
f0adec3a-e02f-4b82-9ae8-c6ccfb5e4776	services	{laravel,backend,authentication,archivel}
6b7f4e68-d856-475e-a6d4-b99530a84401	services	{archivel,autheticated,users,services,backend,laravel}
fd616af9-2120-4d2a-a7ab-78af5ceeb236	routes	{register,backend,laravel,authentication}
6559c1f6-364a-4ebb-9a83-51b85d690c64	services	{balancer,users,services,backend,javascript,rust}
945a1d67-3fec-4e1a-8ede-524161729cf8	routes	{balancer,users,services,logged-in}
374c531a-fe60-4c86-b4a0-d17b829837c1	routes	{mailman,users,services,send-email,mailgun}
f6e099ba-2779-464e-9a9a-2e857fb6d8a8	services	{mailman,users,services,backend,typescript,mailgun}
2d6e7d56-47ea-4d9d-8a1a-b466b72261a3	routes	{balancer,users,services,registered}
\.


--
-- Data for Name: targets; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: ttls; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.ttls (primary_key_value, primary_uuid_value, table_name, primary_key_name, expire_at) FROM stdin;
\.


--
-- Data for Name: upstreams; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags, algorithm, host_header, client_certificate_id, ws_id) FROM stdin;
\.


--
-- Data for Name: vaults_beta; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.vaults_beta (id, ws_id, prefix, name, description, config, created_at, updated_at, tags) FROM stdin;
\.


--
-- Data for Name: workspaces; Type: TABLE DATA; Schema: public; Owner: architect
--

COPY public.workspaces (id, name, comment, created_at, meta, config) FROM stdin;
8472221a-9632-4b1c-9cfb-25fb3efaad8d	default	\N	2022-06-30 08:22:00+00	\N	\N
\.


--
-- Name: acls acls_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);


--
-- Name: acls acls_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- Name: acme_storage acme_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_key_key UNIQUE (key);


--
-- Name: acme_storage acme_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: basicauth_credentials basicauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: ca_certificates ca_certificates_cert_digest_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_cert_digest_key UNIQUE (cert_digest);


--
-- Name: ca_certificates ca_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: cluster_events cluster_events_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);


--
-- Name: clustering_data_planes clustering_data_planes_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.clustering_data_planes
    ADD CONSTRAINT clustering_data_planes_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: consumers consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_ws_id_custom_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);


--
-- Name: consumers consumers_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: hmacauth_credentials hmacauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: hmacauth_credentials hmacauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: jwt_secrets jwt_secrets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: jwt_secrets jwt_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);


--
-- Name: jwt_secrets jwt_secrets_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_key_unique UNIQUE (ws_id, key);


--
-- Name: keyauth_credentials keyauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: keyauth_credentials keyauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: keyauth_credentials keyauth_credentials_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_key_unique UNIQUE (ws_id, key);


--
-- Name: konga_api_health_checks konga_api_health_checks_api_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_api_id_key UNIQUE (api_id);


--
-- Name: konga_api_health_checks konga_api_health_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_pkey PRIMARY KEY (id);


--
-- Name: konga_email_transports konga_email_transports_name_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_name_key UNIQUE (name);


--
-- Name: konga_email_transports konga_email_transports_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_nodes konga_kong_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_nodes
    ADD CONSTRAINT konga_kong_nodes_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_services konga_kong_services_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_services konga_kong_services_service_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_service_id_key UNIQUE (service_id);


--
-- Name: konga_kong_snapshot_schedules konga_kong_snapshot_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules
    ADD CONSTRAINT konga_kong_snapshot_schedules_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_snapshots konga_kong_snapshots_name_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_name_key UNIQUE (name);


--
-- Name: konga_kong_snapshots konga_kong_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_pkey PRIMARY KEY (id);


--
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_upstream_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_upstream_id_key UNIQUE (upstream_id);


--
-- Name: konga_netdata_connections konga_netdata_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_netdata_connections
    ADD CONSTRAINT konga_netdata_connections_pkey PRIMARY KEY (id);


--
-- Name: konga_passports konga_passports_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_passports
    ADD CONSTRAINT konga_passports_pkey PRIMARY KEY (id);


--
-- Name: konga_settings konga_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_settings
    ADD CONSTRAINT konga_settings_pkey PRIMARY KEY (id);


--
-- Name: konga_users konga_users_email_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_email_key UNIQUE (email);


--
-- Name: konga_users konga_users_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_pkey PRIMARY KEY (id);


--
-- Name: konga_users konga_users_username_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_username_key UNIQUE (username);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_code_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_code_unique UNIQUE (ws_id, code);


--
-- Name: oauth2_credentials oauth2_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_credentials oauth2_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);


--
-- Name: oauth2_credentials oauth2_credentials_ws_id_client_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_client_id_unique UNIQUE (ws_id, client_id);


--
-- Name: oauth2_tokens oauth2_tokens_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_tokens oauth2_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_access_token_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_access_token_unique UNIQUE (ws_id, access_token);


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_refresh_token_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_refresh_token_unique UNIQUE (ws_id, refresh_token);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (key);


--
-- Name: plugins plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);


--
-- Name: plugins plugins_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: ratelimiting_metrics ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: response_ratelimiting_metrics response_ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: routes routes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: routes routes_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: schema_meta schema_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);


--
-- Name: services services_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: services services_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);


--
-- Name: snis snis_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: snis snis_name_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);


--
-- Name: snis snis_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);


--
-- Name: targets targets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- Name: ttls ttls_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);


--
-- Name: upstreams upstreams_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: upstreams upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);


--
-- Name: upstreams upstreams_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: vaults_beta vaults_beta_id_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_id_ws_id_key UNIQUE (id, ws_id);


--
-- Name: vaults_beta vaults_beta_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_pkey PRIMARY KEY (id);


--
-- Name: vaults_beta vaults_beta_prefix_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_key UNIQUE (prefix);


--
-- Name: vaults_beta vaults_beta_prefix_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_ws_id_key UNIQUE (prefix, ws_id);


--
-- Name: workspaces workspaces_name_key; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_name_key UNIQUE (name);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: acls_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);


--
-- Name: acls_group_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX acls_group_idx ON public.acls USING btree ("group");


--
-- Name: acls_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX acls_tags_idex_tags_idx ON public.acls USING gin (tags);


--
-- Name: basicauth_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);


--
-- Name: basicauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX basicauth_tags_idex_tags_idx ON public.basicauth_credentials USING gin (tags);


--
-- Name: certificates_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);


--
-- Name: cluster_events_at_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);


--
-- Name: cluster_events_channel_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);


--
-- Name: cluster_events_expire_at_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX cluster_events_expire_at_idx ON public.cluster_events USING btree (expire_at);


--
-- Name: clustering_data_planes_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX clustering_data_planes_ttl_idx ON public.clustering_data_planes USING btree (ttl);


--
-- Name: consumers_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);


--
-- Name: consumers_username_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));


--
-- Name: hmacauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);


--
-- Name: hmacauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX hmacauth_tags_idex_tags_idx ON public.hmacauth_credentials USING gin (tags);


--
-- Name: jwt_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);


--
-- Name: jwt_secrets_secret_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);


--
-- Name: jwtsecrets_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX jwtsecrets_tags_idex_tags_idx ON public.jwt_secrets USING gin (tags);


--
-- Name: keyauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);


--
-- Name: keyauth_credentials_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX keyauth_credentials_ttl_idx ON public.keyauth_credentials USING btree (ttl);


--
-- Name: keyauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX keyauth_tags_idex_tags_idx ON public.keyauth_credentials USING gin (tags);


--
-- Name: locks_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);


--
-- Name: oauth2_authorization_codes_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);


--
-- Name: oauth2_authorization_codes_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_authorization_codes_ttl_idx ON public.oauth2_authorization_codes USING btree (ttl);


--
-- Name: oauth2_authorization_credential_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);


--
-- Name: oauth2_authorization_service_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);


--
-- Name: oauth2_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);


--
-- Name: oauth2_credentials_secret_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);


--
-- Name: oauth2_credentials_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_credentials_tags_idex_tags_idx ON public.oauth2_credentials USING gin (tags);


--
-- Name: oauth2_tokens_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);


--
-- Name: oauth2_tokens_credential_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);


--
-- Name: oauth2_tokens_service_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);


--
-- Name: oauth2_tokens_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX oauth2_tokens_ttl_idx ON public.oauth2_tokens USING btree (ttl);


--
-- Name: plugins_consumer_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);


--
-- Name: plugins_name_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);


--
-- Name: plugins_route_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);


--
-- Name: plugins_service_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);


--
-- Name: plugins_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);


--
-- Name: ratelimiting_metrics_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX ratelimiting_metrics_idx ON public.ratelimiting_metrics USING btree (service_id, route_id, period_date, period);


--
-- Name: ratelimiting_metrics_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX ratelimiting_metrics_ttl_idx ON public.ratelimiting_metrics USING btree (ttl);


--
-- Name: routes_service_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);


--
-- Name: routes_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);


--
-- Name: services_fkey_client_certificate; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX services_fkey_client_certificate ON public.services USING btree (client_certificate_id);


--
-- Name: services_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX services_tags_idx ON public.services USING gin (tags);


--
-- Name: session_sessions_expires_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX session_sessions_expires_idx ON public.sessions USING btree (expires);


--
-- Name: sessions_ttl_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX sessions_ttl_idx ON public.sessions USING btree (ttl);


--
-- Name: snis_certificate_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);


--
-- Name: snis_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);


--
-- Name: tags_entity_name_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);


--
-- Name: tags_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);


--
-- Name: targets_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);


--
-- Name: targets_target_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX targets_target_idx ON public.targets USING btree (target);


--
-- Name: targets_upstream_id_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);


--
-- Name: ttls_primary_uuid_value_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);


--
-- Name: upstreams_fkey_client_certificate; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX upstreams_fkey_client_certificate ON public.upstreams USING btree (client_certificate_id);


--
-- Name: upstreams_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);


--
-- Name: vaults_beta_tags_idx; Type: INDEX; Schema: public; Owner: architect
--

CREATE INDEX vaults_beta_tags_idx ON public.vaults_beta USING gin (tags);


--
-- Name: acls acls_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER acls_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.acls FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: basicauth_credentials basicauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER basicauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.basicauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: ca_certificates ca_certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER ca_certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.ca_certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: certificates certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: consumers consumers_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: hmacauth_credentials hmacauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER hmacauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.hmacauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: jwt_secrets jwtsecrets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER jwtsecrets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.jwt_secrets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: keyauth_credentials keyauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER keyauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.keyauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: oauth2_credentials oauth2_credentials_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER oauth2_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.oauth2_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: plugins plugins_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: routes routes_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: services services_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: snis snis_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: targets targets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: upstreams upstreams_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: vaults_beta vaults_beta_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: architect
--

CREATE TRIGGER vaults_beta_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.vaults_beta FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();


--
-- Name: acls acls_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: acls acls_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: basicauth_credentials basicauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: basicauth_credentials basicauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: certificates certificates_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: consumers consumers_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: hmacauth_credentials hmacauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: jwt_secrets jwt_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: jwt_secrets jwt_secrets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: keyauth_credentials keyauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: keyauth_credentials keyauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_credentials oauth2_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_credentials oauth2_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_tokens oauth2_tokens_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: plugins plugins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id, ws_id) REFERENCES public.routes(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: routes routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);


--
-- Name: routes routes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: services services_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_client_certificate_id_fkey FOREIGN KEY (client_certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- Name: services services_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: snis snis_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- Name: snis snis_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: targets targets_upstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id, ws_id) REFERENCES public.upstreams(id, ws_id) ON DELETE CASCADE;


--
-- Name: targets targets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: upstreams upstreams_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_client_certificate_id_fkey FOREIGN KEY (client_certificate_id) REFERENCES public.certificates(id);


--
-- Name: upstreams upstreams_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: vaults_beta vaults_beta_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: architect
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- PostgreSQL database dump complete
--
