--
-- PostgreSQL database dump
--

\restrict efBlWrZb2wfY5Y1mHNReUQpXzzpBVPrhps9ZXSVeGMCJWWU5EPQ3i41bEeFeVBV

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
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.tokens (
    storage_token bytea NOT NULL,
    key_version integer NOT NULL,
    ciphertext bytea NOT NULL,
    encrypted_metadata bytea,
    fingerprint bytea NOT NULL,
    expiration_time timestamp with time zone,
    creation_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tokens OWNER TO postgresql;

--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresql
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (storage_token);


--
-- Name: tokens_creation_time_index; Type: INDEX; Schema: public; Owner: postgresql
--

CREATE INDEX tokens_creation_time_index ON public.tokens USING btree (creation_time);


--
-- Name: tokens_expiration_time_idx; Type: INDEX; Schema: public; Owner: postgresql
--

CREATE INDEX tokens_expiration_time_idx ON public.tokens USING btree (expiration_time) WHERE (expiration_time IS NOT NULL);


--
-- Name: tokens_fingerprint_idx; Type: INDEX; Schema: public; Owner: postgresql
--

CREATE INDEX tokens_fingerprint_idx ON public.tokens USING btree (fingerprint);


--
-- PostgreSQL database dump complete
--

\unrestrict efBlWrZb2wfY5Y1mHNReUQpXzzpBVPrhps9ZXSVeGMCJWWU5EPQ3i41bEeFeVBV

