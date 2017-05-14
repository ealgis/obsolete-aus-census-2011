--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = aus_census_2011, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ealgis_metadata; Type: TABLE; Schema: aus_census_2011; Owner: postgres
--

CREATE TABLE ealgis_metadata (
    id integer NOT NULL,
    name character varying(256),
    version double precision,
    description text,
    date timestamp with time zone
);


ALTER TABLE ealgis_metadata OWNER TO postgres;

--
-- Name: ealgis_metadata_id_seq; Type: SEQUENCE; Schema: aus_census_2011; Owner: postgres
--

CREATE SEQUENCE ealgis_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ealgis_metadata_id_seq OWNER TO postgres;

--
-- Name: ealgis_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: aus_census_2011; Owner: postgres
--

ALTER SEQUENCE ealgis_metadata_id_seq OWNED BY ealgis_metadata.id;


--
-- Name: ealgis_metadata id; Type: DEFAULT; Schema: aus_census_2011; Owner: postgres
--

ALTER TABLE ONLY ealgis_metadata ALTER COLUMN id SET DEFAULT nextval('ealgis_metadata_id_seq'::regclass);


--
-- Data for Name: ealgis_metadata; Type: TABLE DATA; Schema: aus_census_2011; Owner: postgres
--

COPY ealgis_metadata (id, name, version, description, date) FROM stdin;
1	ABS Census 2011	1	The full 2011 Census data dump from the ABS.	2017-01-11 12:51:36.805242+00
\.


--
-- Name: ealgis_metadata_id_seq; Type: SEQUENCE SET; Schema: aus_census_2011; Owner: postgres
--

SELECT pg_catalog.setval('ealgis_metadata_id_seq', 1, true);


--
-- Name: ealgis_metadata ealgis_metadata_pkey; Type: CONSTRAINT; Schema: aus_census_2011; Owner: postgres
--

ALTER TABLE ONLY ealgis_metadata
    ADD CONSTRAINT ealgis_metadata_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--