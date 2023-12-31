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
-- Name: donations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donations (
    donation_id integer NOT NULL,
    name character varying(30) NOT NULL,
    phone character varying(15),
    donation numeric(5,2) DEFAULT 0.00
);


ALTER TABLE public.donations OWNER TO postgres;

--
-- Name: donations_donation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donations_donation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donations_donation_id_seq OWNER TO postgres;

--
-- Name: donations_donation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donations_donation_id_seq OWNED BY public.donations.donation_id;


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
-- Name: donations donation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations ALTER COLUMN donation_id SET DEFAULT nextval('public.donations_donation_id_seq'::regclass);


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

INSERT INTO public.attendees VALUES (31, 'Fabio', 34, '5555555555');
INSERT INTO public.attendees VALUES (32, 'Mark', 43, '1234543333');
INSERT INTO public.attendees VALUES (33, 'mark', 26, '7324969800');
INSERT INTO public.attendees VALUES (35, 'Kenny', 23, '5847774444');
INSERT INTO public.attendees VALUES (36, 'Ian', 34, '9998475555');
INSERT INTO public.attendees VALUES (37, 'Joshua', 52, '8844757777');
INSERT INTO public.attendees VALUES (38, 'Shaun', 45, '1234321232');
INSERT INTO public.attendees VALUES (39, 'FabioFriend', 43, '15453338484');


--
-- Data for Name: donations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.donations VALUES (1, 'Fabio', '5555555555', 400.00);
INSERT INTO public.donations VALUES (2, 'NonGuest', '9249994888', 522.00);


--
-- Data for Name: rsvp; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rsvp VALUES (1, 2, 31, 180.00, 12.25, true);
INSERT INTO public.rsvp VALUES (2, 2, 32, 90.00, 7.25, false);
INSERT INTO public.rsvp VALUES (3, 1, 33, 180.00, 0.00, true);
INSERT INTO public.rsvp VALUES (4, 1, 35, 220.00, 10.00, true);
INSERT INTO public.rsvp VALUES (5, 2, 38, 102.00, 19.25, false);
INSERT INTO public.rsvp VALUES (6, 2, 39, 180.00, 12.25, true);


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tickets VALUES (3, 'WP', 297.90, 'Weekend Pass', 300, true);
INSERT INTO public.tickets VALUES (1, 'VIP', 125.00, 'Very Important Person', 298, true);
INSERT INTO public.tickets VALUES (2, 'GA', 82.75, 'General Admission', 296, true);


--
-- Name: attendees_attendee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendees_attendee_id_seq', 39, true);


--
-- Name: donations_donation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donations_donation_id_seq', 2, true);


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
-- Name: donations donations_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_phone_key UNIQUE (phone);


--
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (donation_id);


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

