--
-- PostgreSQL database dump
--

\restrict cdsFhrdgrsLpr7Zbbq65GzQDJQ3emR5YOLsm05qhlWmdPaJP4M7s7ZnOGlbLtXv

-- Dumped from database version 17.4
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: token_schema_versions; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.token_schema_versions (
    version integer NOT NULL
);


ALTER TABLE public.token_schema_versions OWNER TO postgresql;

--
-- Name: token_schema_versions token_schema_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresql
--

ALTER TABLE ONLY public.token_schema_versions
    ADD CONSTRAINT token_schema_versions_pkey PRIMARY KEY (version);


--
-- PostgreSQL database dump complete
--

\unrestrict cdsFhrdgrsLpr7Zbbq65GzQDJQ3emR5YOLsm05qhlWmdPaJP4M7s7ZnOGlbLtXv

