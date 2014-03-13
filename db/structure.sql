--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

--
-- Name: f_unaccent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION f_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    SET search_path TO public, pg_temp
    AS $_$
      select unaccent('unaccent', $1)
      $_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    sort_name character varying(255) NOT NULL,
    first_letter character varying(1) NOT NULL,
    legacy_ids integer[] DEFAULT '{}'::integer[] NOT NULL,
    facebook_page character varying(255),
    twitter_widget_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thumbnail character varying(255),
    banner character varying(255),
    banner_width integer,
    banner_height integer,
    view_count integer DEFAULT 0 NOT NULL
);


--
-- Name: artists_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists_genres (
    artist_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- Name: artists_instruments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists_instruments (
    artist_id integer NOT NULL,
    instrument_id integer NOT NULL
);


--
-- Name: auth_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auth_providers (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(255),
    user_id character varying(255),
    user_name character varying(255),
    synced_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: auth_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auth_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auth_providers_id_seq OWNED BY auth_providers.id;


--
-- Name: band_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE band_members (
    id integer NOT NULL,
    song_id integer NOT NULL,
    artist_name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: band_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE band_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: band_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE band_members_id_seq OWNED BY band_members.id;


--
-- Name: band_members_instruments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE band_members_instruments (
    band_member_id integer NOT NULL,
    instrument_id integer NOT NULL
);


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contact_messages (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    message text NOT NULL,
    ip_address character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_messages_id_seq OWNED BY contact_messages.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    date date NOT NULL,
    type character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    description text NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    factsheet text,
    legacy_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    debuts_at timestamp without time zone,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: features; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE features (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    banner character varying(255) NOT NULL,
    banner_width integer NOT NULL,
    banner_height integer NOT NULL,
    enabled boolean DEFAULT false NOT NULL
);


--
-- Name: features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE features_id_seq OWNED BY features.id;


--
-- Name: gallery_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gallery_images (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    image character varying(255) NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: gallery_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gallery_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gallery_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gallery_images_id_seq OWNED BY gallery_images.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genres_id_seq OWNED BY genres.id;


--
-- Name: genres_search_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres_search_results (
    search_result_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: genres_songs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres_songs (
    genre_id integer NOT NULL,
    song_id integer NOT NULL
);


--
-- Name: instruments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instruments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: instruments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instruments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instruments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE instruments_id_seq OWNED BY instruments.id;


--
-- Name: instruments_search_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instruments_search_results (
    search_result_id integer NOT NULL,
    instrument_id integer NOT NULL
);


--
-- Name: live_transmission_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE live_transmission_settings (
    id integer NOT NULL,
    starts_at time without time zone NOT NULL,
    ends_at time without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: live_transmission_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE live_transmission_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: live_transmission_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE live_transmission_settings_id_seq OWNED BY live_transmission_settings.id;


--
-- Name: live_transmissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE live_transmissions (
    id integer NOT NULL,
    date date NOT NULL,
    artist_id integer NOT NULL,
    description text NOT NULL,
    band_members text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: live_transmissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE live_transmissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: live_transmissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE live_transmissions_id_seq OWNED BY live_transmissions.id;


--
-- Name: pdf_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pdf_schedules (
    id integer NOT NULL,
    available_date date NOT NULL,
    file character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pdf_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pdf_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pdf_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pdf_schedules_id_seq OWNED BY pdf_schedules.id;


--
-- Name: schedule_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_items (
    id integer NOT NULL,
    date date NOT NULL,
    artist_id integer NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schedule_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_items_id_seq OWNED BY schedule_items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: search_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_results (
    id integer NOT NULL,
    searchable_id integer NOT NULL,
    searchable_type character varying(255) NOT NULL,
    result_type character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: search_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_results_id_seq OWNED BY search_results.id;


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE songs (
    id integer NOT NULL,
    playlistable_id integer NOT NULL,
    playlistable_type character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    composer character varying(255) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE songs_id_seq OWNED BY songs.id;


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscribers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscribers_id_seq OWNED BY subscribers.id;


--
-- Name: timecodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timecodes (
    id integer NOT NULL,
    video_id integer NOT NULL,
    seconds integer NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: timecodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timecodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timecodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timecodes_id_seq OWNED BY timecodes.id;


--
-- Name: tv_features; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tv_features (
    id integer NOT NULL,
    debuts_at timestamp without time zone NOT NULL,
    show_id integer NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tv_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_features_id_seq OWNED BY tv_features.id;


--
-- Name: tv_schedule_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tv_schedule_items (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tv_schedule_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_schedule_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_schedule_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_schedule_items_id_seq OWNED BY tv_schedule_items.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE videos (
    id integer NOT NULL,
    viewable_id integer NOT NULL,
    viewable_type character varying(255) NOT NULL,
    auth_user_id character varying(255) NOT NULL,
    youtube_id character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    tags character varying(255)[] DEFAULT '{}'::character varying[] NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    likes integer DEFAULT 0 NOT NULL,
    dislikes integer DEFAULT 0 NOT NULL,
    comments integer DEFAULT 0 NOT NULL,
    small_thumbnail character varying(255),
    large_thumbnail character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auth_providers ALTER COLUMN id SET DEFAULT nextval('auth_providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY band_members ALTER COLUMN id SET DEFAULT nextval('band_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_messages ALTER COLUMN id SET DEFAULT nextval('contact_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY features ALTER COLUMN id SET DEFAULT nextval('features_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gallery_images ALTER COLUMN id SET DEFAULT nextval('gallery_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY genres ALTER COLUMN id SET DEFAULT nextval('genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY instruments ALTER COLUMN id SET DEFAULT nextval('instruments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY live_transmission_settings ALTER COLUMN id SET DEFAULT nextval('live_transmission_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY live_transmissions ALTER COLUMN id SET DEFAULT nextval('live_transmissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pdf_schedules ALTER COLUMN id SET DEFAULT nextval('pdf_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_items ALTER COLUMN id SET DEFAULT nextval('schedule_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_results ALTER COLUMN id SET DEFAULT nextval('search_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY songs ALTER COLUMN id SET DEFAULT nextval('songs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers ALTER COLUMN id SET DEFAULT nextval('subscribers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timecodes ALTER COLUMN id SET DEFAULT nextval('timecodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_features ALTER COLUMN id SET DEFAULT nextval('tv_features_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_schedule_items ALTER COLUMN id SET DEFAULT nextval('tv_schedule_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Name: artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: auth_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auth_providers
    ADD CONSTRAINT auth_providers_pkey PRIMARY KEY (id);


--
-- Name: band_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY band_members
    ADD CONSTRAINT band_members_pkey PRIMARY KEY (id);


--
-- Name: contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: features_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- Name: gallery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gallery_images
    ADD CONSTRAINT gallery_images_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instruments
    ADD CONSTRAINT instruments_pkey PRIMARY KEY (id);


--
-- Name: live_transmission_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY live_transmission_settings
    ADD CONSTRAINT live_transmission_settings_pkey PRIMARY KEY (id);


--
-- Name: live_transmissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY live_transmissions
    ADD CONSTRAINT live_transmissions_pkey PRIMARY KEY (id);


--
-- Name: pdf_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pdf_schedules
    ADD CONSTRAINT pdf_schedules_pkey PRIMARY KEY (id);


--
-- Name: schedule_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_items
    ADD CONSTRAINT schedule_items_pkey PRIMARY KEY (id);


--
-- Name: search_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_results
    ADD CONSTRAINT search_results_pkey PRIMARY KEY (id);


--
-- Name: songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- Name: timecodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timecodes
    ADD CONSTRAINT timecodes_pkey PRIMARY KEY (id);


--
-- Name: tv_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tv_features
    ADD CONSTRAINT tv_features_pkey PRIMARY KEY (id);


--
-- Name: tv_schedule_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tv_schedule_items
    ADD CONSTRAINT tv_schedule_items_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: index_artists_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_artists_on_name ON artists USING btree (name);


--
-- Name: index_artists_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_artists_on_slug ON artists USING btree (slug);


--
-- Name: index_artists_on_sort_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artists_on_sort_name ON artists USING btree (sort_name);


--
-- Name: index_auth_providers_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_auth_providers_on_key ON auth_providers USING btree (key);


--
-- Name: index_band_members_on_song_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_band_members_on_song_id ON band_members USING btree (song_id);


--
-- Name: index_events_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_artist_id ON events USING btree (artist_id);


--
-- Name: index_events_on_date_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_events_on_date_and_type ON events USING btree (date, type);


--
-- Name: index_events_on_debuts_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_debuts_at ON events USING btree (debuts_at);


--
-- Name: index_events_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_events_on_slug ON events USING btree (slug);


--
-- Name: index_events_on_sort_order; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_sort_order ON events USING btree (sort_order);


--
-- Name: index_features_on_enabled_and_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_features_on_enabled_and_priority ON features USING btree (enabled, priority);


--
-- Name: index_gallery_images_on_artist_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_gallery_images_on_artist_id_and_position ON gallery_images USING btree (artist_id, "position");


--
-- Name: index_genres_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_genres_on_name ON genres USING btree (name);


--
-- Name: index_genres_songs_on_genre_id_and_song_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_genres_songs_on_genre_id_and_song_id ON genres_songs USING btree (genre_id, song_id);


--
-- Name: index_instruments_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_instruments_on_name ON instruments USING btree (name);


--
-- Name: index_live_transmissions_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_live_transmissions_on_date ON live_transmissions USING btree (date);


--
-- Name: index_pdf_schedules_on_available_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_pdf_schedules_on_available_date ON pdf_schedules USING btree (available_date);


--
-- Name: index_schedule_items_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_schedule_items_on_date ON schedule_items USING btree (date);


--
-- Name: index_search_results_on_result_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_search_results_on_result_type ON search_results USING btree (result_type);


--
-- Name: index_subscribers_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_subscribers_on_email ON subscribers USING btree (email);


--
-- Name: index_timecodes_on_video_id_and_seconds; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timecodes_on_video_id_and_seconds ON timecodes USING btree (video_id, seconds);


--
-- Name: index_tv_features_on_debuts_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tv_features_on_debuts_at ON tv_features USING btree (debuts_at);


--
-- Name: index_tv_schedule_items_on_starts_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tv_schedule_items_on_starts_at ON tv_schedule_items USING btree (starts_at);


--
-- Name: index_videos_on_viewable_type_and_viewable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_videos_on_viewable_type_and_viewable_id ON videos USING btree (viewable_type, viewable_id);


--
-- Name: index_videos_on_youtube_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_videos_on_youtube_id ON videos USING btree (youtube_id);


--
-- Name: ix_search_results; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_search_results ON search_results USING gin (((setweight(to_tsvector('portuguese'::regconfig, f_unaccent(COALESCE((title)::text, ''::text))), 'A'::"char") || setweight(to_tsvector('portuguese'::regconfig, f_unaccent(COALESCE(content, ''::text))), 'B'::"char"))));


--
-- Name: unique_artists_instruments; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_artists_instruments ON artists_instruments USING btree (artist_id, instrument_id);


--
-- Name: unique_band_members_instruments; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_band_members_instruments ON band_members_instruments USING btree (band_member_id, instrument_id);


--
-- Name: unique_genres_search_results; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_genres_search_results ON genres_search_results USING btree (genre_id, search_result_id);


--
-- Name: unique_instruments_search_results; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_instruments_search_results ON instruments_search_results USING btree (instrument_id, search_result_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131012195133');

INSERT INTO schema_migrations (version) VALUES ('20131207224757');

INSERT INTO schema_migrations (version) VALUES ('20131208104413');

INSERT INTO schema_migrations (version) VALUES ('20131208104414');

INSERT INTO schema_migrations (version) VALUES ('20131210132721');

INSERT INTO schema_migrations (version) VALUES ('20131210132929');

INSERT INTO schema_migrations (version) VALUES ('20131211124130');

INSERT INTO schema_migrations (version) VALUES ('20131212011201');

INSERT INTO schema_migrations (version) VALUES ('20131212043807');

INSERT INTO schema_migrations (version) VALUES ('20131212221304');

INSERT INTO schema_migrations (version) VALUES ('20140113013751');

INSERT INTO schema_migrations (version) VALUES ('20140212014322');

INSERT INTO schema_migrations (version) VALUES ('20140213062337');

INSERT INTO schema_migrations (version) VALUES ('20140215024958');

INSERT INTO schema_migrations (version) VALUES ('20140219235601');

INSERT INTO schema_migrations (version) VALUES ('20140222062943');

INSERT INTO schema_migrations (version) VALUES ('20140228000024');

INSERT INTO schema_migrations (version) VALUES ('20140228000700');

INSERT INTO schema_migrations (version) VALUES ('20140228000704');

INSERT INTO schema_migrations (version) VALUES ('20140228031621');

INSERT INTO schema_migrations (version) VALUES ('20140228042036');

INSERT INTO schema_migrations (version) VALUES ('20140228054332');

INSERT INTO schema_migrations (version) VALUES ('20140228071217');

INSERT INTO schema_migrations (version) VALUES ('20140309193856');
