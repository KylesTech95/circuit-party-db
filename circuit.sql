--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5 (Debian 15.5-1.pgdg110+1)
-- Dumped by pg_dump version 15.5 (Debian 15.5-1.pgdg110+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendees (
    attendee_id integer NOT NULL,
    name character varying(30) NOT NULL,
    age integer NOT NULL,
    phone character varying(15) NOT NULL
);


ALTER TABLE public.attendees OWNER TO postgres;

--
-- Name: attendees_attendee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendees_attendee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendees_attendee_id_seq OWNER TO postgres;

--
-- Name: attendees_attendee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendees_attendee_id_seq OWNED BY public.attendees.attendee_id;


--
-- Name: rsvp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rsvp (
    rsvp_id integer NOT NULL,
    ticket_id integer NOT NULL,
    attendee_id integer NOT NULL,
    customer_payment numeric(5,2),
    customer_change numeric(5,2),
    parking boolean DEFAULT false
);


ALTER TABLE public.rsvp OWNER TO postgres;

--
-- Name: rsvp_rsvp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rsvp_rsvp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rsvp_rsvp_id_seq OWNER TO postgres;

--
-- Name: rsvp_rsvp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rsvp_rsvp_id_seq OWNED BY public.rsvp.rsvp_id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    ticket_id integer NOT NULL,
    type character varying(20) NOT NULL,
    price numeric(5,2),
    description character varying(30),
    count integer DEFAULT 300,
    available boolean DEFAULT true
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: tickets_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tickets_ticket_id_seq OWNER TO postgres;

--
-- Name: tickets_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_ticket_id_seq OWNED BY public.tickets.ticket_id;


--
-- Name: attendees attendee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendees ALTER COLUMN attendee_id SET DEFAULT nextval('public.attendees_attendee_id_seq'::regclass);


--
-- Name: rsvp rsvp_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rsvp ALTER COLUMN rsvp_id SET DEFAULT nextval('public.rsvp_rsvp_id_seq'::regclass);


--
-- Name: tickets ticket_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN ticket_id SET DEFAULT nextval('public.tickets_ticket_id_seq'::regclass);


--
-- Data for Name: attendees; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.attendees VALUES (2, 'Kyle', 22, '1231231234');
INSERT INTO public.attendees VALUES (3, 'Fabio', 24, '5555555555');
INSERT INTO public.attendees VALUES (4, 'Byron', 32, '9595995999');
INSERT INTO public.attendees VALUES (5, 'Jamie', 33, '541123123');
INSERT INTO public.attendees VALUES (6, 'Dennis', 34, '1234233300');
INSERT INTO public.attendees VALUES (7, 'Nick', 43, '1234299999');


--
-- Data for Name: rsvp; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rsvp VALUES (1, 1, 2, 140.50, 15.50, false);
INSERT INTO public.rsvp VALUES (2, 3, 3, 400.00, 102.10, false);
INSERT INTO public.rsvp VALUES (3, 1, 4, 154.00, 29.00, false);
INSERT INTO public.rsvp VALUES (4, 1, 5, 140.00, 15.00, false);
INSERT INTO public.rsvp VALUES (5, 1, 6, 300.00, 175.00, false);
INSERT INTO public.rsvp VALUES (6, 2, 7, 100.00, 17.25, false);


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tickets VALUES (3, 'WP', 297.90, 'Weekend Pass', 299, true);
INSERT INTO public.tickets VALUES (1, 'VIP', 125.00, 'Very Important Person', 296, true);
INSERT INTO public.tickets VALUES (2, 'GA', 82.75, 'General Admission', 299, true);


--
-- Name: attendees_attendee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendees_attendee_id_seq', 7, true);


--
-- Name: rsvp_rsvp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rsvp_rsvp_id_seq', 6, true);


--
-- Name: tickets_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_ticket_id_seq', 3, true);


--
-- Name: attendees attendees_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_phone_key UNIQUE (phone);


--
-- Name: attendees attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendees
    ADD CONSTRAINT attendees_pkey PRIMARY KEY (attendee_id);


--
-- Name: rsvp rsvp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rsvp
    ADD CONSTRAINT rsvp_pkey PRIMARY KEY (rsvp_id);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (ticket_id);


--
-- Name: rsvp rsvp_attendee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rsvp
    ADD CONSTRAINT rsvp_attendee_id_fkey FOREIGN KEY (attendee_id) REFERENCES public.attendees(attendee_id);


--
-- Name: rsvp rsvp_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rsvp
    ADD CONSTRAINT rsvp_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(ticket_id);


--
-- PostgreSQL database dump complete
--

