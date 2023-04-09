--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 14.4

-- Started on 2023-02-16 15:53:30

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
-- TOC entry 3070 (class 1262 OID 16809)
-- Name: lab_airport; Type: DATABASE; Schema: -; Owner: postgres
--


CREATE USER lab_air_user WITH PASSWORD 'lab_air_user';
ALTER ROLE lab_air_user superuser;

CREATE DATABASE lab_airport WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE lab_airport OWNER TO postgres;

\connect lab_airport

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
-- TOC entry 680 (class 1247 OID 17240)
-- Name: t_ticket; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.t_ticket AS (
	id bigint,
	passenger_id bigint,
	flight_id bigint,
	price numeric(12,2)
);


ALTER TYPE public.t_ticket OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 17235)
-- Name: delete_aircraft(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_aircraft(_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM aircraft WHERE id = _id;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'It is not possible to perform the deletion because there are foreign keys.';
END;
$$;


ALTER FUNCTION public.delete_aircraft(_id bigint) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 17259)
-- Name: delete_tickets(bigint[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_tickets(arr bigint[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM ticket WHERE id = ANY(arr);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'It is not possible to perform the deletion because there are foreign keys.';
END;
$$;


ALTER FUNCTION public.delete_tickets(arr bigint[]) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 17241)
-- Name: filter_array_of_tickets(public.t_ticket[], bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filter_array_of_tickets(arr public.t_ticket[], filter_var bigint) RETURNS public.t_ticket[]
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN ARRAY(
        SELECT (id, passenger_id, flight_id, price)::t_ticket
        FROM unnest(arr)
        WHERE price >= filter_var
    );
END;
$$;


ALTER FUNCTION public.filter_array_of_tickets(arr public.t_ticket[], filter_var bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 17202)
-- Name: ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket (
    id bigint NOT NULL,
    passenger_id bigint NOT NULL,
    flight_id bigint NOT NULL,
    price numeric(12,2) NOT NULL
);


ALTER TABLE public.ticket OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 17237)
-- Name: filter_ticket_by_price(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.filter_ticket_by_price(_min_val numeric) RETURNS SETOF public.ticket
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY (SELECT * FROM ticket WHERE price >= _min_val);
END;
$$;


ALTER FUNCTION public.filter_ticket_by_price(_min_val numeric) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 17258)
-- Name: get_value_by_id(character varying, character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_value_by_id(tablename character varying, columtname character varying, id bigint) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    result text;
BEGIN
    EXECUTE 'SELECT ' || columtName || ' FROM ' || tableName || ' WHERE id = $1' USING id INTO result;
    RETURN result;
END;
$_$;


ALTER FUNCTION public.get_value_by_id(tablename character varying, columtname character varying, id bigint) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 17233)
-- Name: save_aircraft(bigint, character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.save_aircraft(_id bigint, _model character varying, _tail_number character varying, _release_date date) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    DECLARE aid bigint;

BEGIN

    IF _id IS NULL THEN
        INSERT INTO aircraft (model, tail_number, release_date)
        VALUES (_model, _tail_number, _release_date)
        RETURNING id
        INTO aid;
    ELSE
        UPDATE aircraft SET
            model = _model,
            tail_number = _tail_number,
            release_date = _release_date
        WHERE id = _id;

        aid := _id;
    END IF;

    RETURN aid;
END;
$$;


ALTER FUNCTION public.save_aircraft(_id bigint, _model character varying, _tail_number character varying, _release_date date) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 17255)
-- Name: trigger_log_flight(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_log_flight() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE old_val integer;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        old_val := OLD.status;
    ELSIF (TG_OP = 'INSERT') THEN
        old_val := NULL;
    END IF;

    INSERT INTO log_flight (flight_id, old_value, new_value) VALUES (NEW.id, old_val, NEW.status);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_log_flight() OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 17171)
-- Name: aircraft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircraft (
    id bigint NOT NULL,
    model character varying(30) NOT NULL,
    tail_number character varying(15) NOT NULL,
    release_date date NOT NULL
);


ALTER TABLE public.aircraft OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 17169)
-- Name: aircraft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aircraft_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aircraft_id_seq OWNER TO postgres;

--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 208
-- Name: aircraft_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aircraft_id_seq OWNED BY public.aircraft.id;


--
-- TOC entry 207 (class 1259 OID 17160)
-- Name: airline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airline (
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    description text,
    contact text
);


ALTER TABLE public.airline OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 17158)
-- Name: airline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.airline_id_seq OWNER TO postgres;

--
-- TOC entry 3073 (class 0 OID 0)
-- Dependencies: 206
-- Name: airline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airline_id_seq OWNED BY public.airline.id;


--
-- TOC entry 205 (class 1259 OID 17149)
-- Name: airport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airport (
    id bigint NOT NULL,
    city character varying(30) NOT NULL,
    country character varying(30) NOT NULL,
    "IATA" character varying(3) NOT NULL,
    contact text
);


ALTER TABLE public.airport OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 17147)
-- Name: airport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.airport_id_seq OWNER TO postgres;

--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 204
-- Name: airport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airport_id_seq OWNED BY public.airport.id;


--
-- TOC entry 211 (class 1259 OID 17179)
-- Name: flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flight (
    id bigint NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    airport_id bigint NOT NULL,
    airline_id bigint NOT NULL,
    aircraft_id bigint NOT NULL,
    status integer NOT NULL
);


ALTER TABLE public.flight OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 17177)
-- Name: flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flight_id_seq OWNER TO postgres;

--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 210
-- Name: flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flight_id_seq OWNED BY public.flight.id;


--
-- TOC entry 216 (class 1259 OID 17228)
-- Name: flight_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.flight_info AS
 SELECT f.id AS "Flight ID",
    f.departure_time,
    (((a.city)::text || ' - '::text) || (a.country)::text) AS "Airport",
    al.name AS "Airline",
    ac.model AS "Aircraft"
   FROM (((public.flight f
     JOIN public.airport a ON ((a.id = f.airport_id)))
     JOIN public.airline al ON ((al.id = f.airline_id)))
     JOIN public.aircraft ac ON ((ac.id = f.aircraft_id)));


ALTER TABLE public.flight_info OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17244)
-- Name: log_flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_flight (
    id bigint NOT NULL,
    flight_id bigint,
    change_datetime timestamp without time zone DEFAULT now(),
    old_value integer,
    new_value integer
);


ALTER TABLE public.log_flight OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17242)
-- Name: log_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_flight_id_seq OWNER TO postgres;

--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 218
-- Name: log_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_flight_id_seq OWNED BY public.log_flight.id;


--
-- TOC entry 203 (class 1259 OID 17141)
-- Name: passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passenger (
    id bigint NOT NULL,
    surname character varying(30) NOT NULL,
    name character varying(30) NOT NULL,
    patronymic character varying(30) NOT NULL,
    passport_series integer NOT NULL,
    passport_number integer NOT NULL
);


ALTER TABLE public.passenger OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17223)
-- Name: passenger_flights_v; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.passenger_flights_v AS
 SELECT concat(p.surname, ' ', p.name, ' ', p.patronymic) AS "Passenger",
    t.id AS "Ticket ID",
    f.id AS "Flight ID",
    f.departure_time
   FROM ((public.passenger p
     JOIN public.ticket t ON ((p.id = t.passenger_id)))
     JOIN public.flight f ON ((t.flight_id = f.id)));


ALTER TABLE public.passenger_flights_v OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 17139)
-- Name: passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passenger_id_seq OWNER TO postgres;

--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 202
-- Name: passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passenger_id_seq OWNED BY public.passenger.id;


--
-- TOC entry 214 (class 1259 OID 17218)
-- Name: summary_v; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.summary_v AS
( SELECT 'Min value'::text AS val_type,
    ticket.price,
    ticket.id
   FROM public.ticket
  ORDER BY ticket.price
 LIMIT 1)
UNION ALL
( SELECT 'Max value'::text AS val_type,
    ticket.price,
    ticket.id
   FROM public.ticket
  ORDER BY ticket.price DESC
 LIMIT 1)
UNION ALL
 SELECT 'Avg value'::text AS val_type,
    avg(ticket.price) AS price,
    NULL::bigint AS id
   FROM public.ticket
UNION ALL
 SELECT 'Sum value'::text AS val_type,
    sum(ticket.price) AS price,
    NULL::bigint AS id
   FROM public.ticket;


ALTER TABLE public.summary_v OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 17200)
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ticket_id_seq OWNER TO postgres;

--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 212
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_id_seq OWNED BY public.ticket.id;


--
-- TOC entry 2898 (class 2604 OID 17174)
-- Name: aircraft id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft ALTER COLUMN id SET DEFAULT nextval('public.aircraft_id_seq'::regclass);


--
-- TOC entry 2897 (class 2604 OID 17163)
-- Name: airline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airline ALTER COLUMN id SET DEFAULT nextval('public.airline_id_seq'::regclass);


--
-- TOC entry 2896 (class 2604 OID 17152)
-- Name: airport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport ALTER COLUMN id SET DEFAULT nextval('public.airport_id_seq'::regclass);


--
-- TOC entry 2899 (class 2604 OID 17182)
-- Name: flight id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight ALTER COLUMN id SET DEFAULT nextval('public.flight_id_seq'::regclass);


--
-- TOC entry 2901 (class 2604 OID 17247)
-- Name: log_flight id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_flight ALTER COLUMN id SET DEFAULT nextval('public.log_flight_id_seq'::regclass);


--
-- TOC entry 2895 (class 2604 OID 17144)
-- Name: passenger id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger ALTER COLUMN id SET DEFAULT nextval('public.passenger_id_seq'::regclass);


--
-- TOC entry 2900 (class 2604 OID 17205)
-- Name: ticket id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket ALTER COLUMN id SET DEFAULT nextval('public.ticket_id_seq'::regclass);


--
-- TOC entry 3058 (class 0 OID 17171)
-- Dependencies: 209
-- Data for Name: aircraft; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.aircraft VALUES (1, 'A', 'A-123', '2005-03-04');
INSERT INTO public.aircraft VALUES (2, 'B', 'B-777', '1995-12-24');
INSERT INTO public.aircraft VALUES (3, 'ABC', 'ABC-99', '1999-01-01');
INSERT INTO public.aircraft VALUES (4, 'C', 'C-21', '1989-09-18');


--
-- TOC entry 3056 (class 0 OID 17160)
-- Dependencies: 207
-- Data for Name: airline; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.airline VALUES (1, 'Urals', 'Airline engaged in regular and charter domestic and international transportation', '+79822785555');
INSERT INTO public.airline VALUES (2, 'Q7', 'Airline Q7', '88005559090');


--
-- TOC entry 3054 (class 0 OID 17149)
-- Dependencies: 205
-- Data for Name: airport; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.airport VALUES (1, 'Cairo', 'Egypt', 'CAI', '+20222655000');
INSERT INTO public.airport VALUES (2, 'Ekaterinburg', 'Russia', 'SVX', '88001000333');


--
-- TOC entry 3060 (class 0 OID 17179)
-- Dependencies: 211
-- Data for Name: flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.flight VALUES (1, '2023-02-09 10:10:05', 1, 1, 2, 1);
INSERT INTO public.flight VALUES (2, '2022-12-24 11:13:35', 2, 2, 1, 0);
INSERT INTO public.flight VALUES (3, '2023-01-06 17:00:00', 1, 1, 3, 1);
INSERT INTO public.flight VALUES (4, '2022-12-19 11:12:13', 2, 2, 1, 1);


--
-- TOC entry 3064 (class 0 OID 17244)
-- Dependencies: 219
-- Data for Name: log_flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.log_flight VALUES (1, 4, '2023-02-10 19:23:19.465657', NULL, 0);
INSERT INTO public.log_flight VALUES (2, 4, '2023-02-10 19:30:59.796714', 0, 1);


--
-- TOC entry 3052 (class 0 OID 17141)
-- Dependencies: 203
-- Data for Name: passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.passenger VALUES (1, 'Ivanov', 'Petr', 'Alekseevich', 1111, 111111);
INSERT INTO public.passenger VALUES (2, 'Petrov', 'Ivan', 'Dmitrievich', 2222, 111111);
INSERT INTO public.passenger VALUES (3, 'Kalinina', 'Lyubov', 'Olegovna', 3333, 111111);


--
-- TOC entry 3062 (class 0 OID 17202)
-- Dependencies: 213
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ticket VALUES (1, 1, 1, 100.00);
INSERT INTO public.ticket VALUES (16, 2, 1, 10.65);
INSERT INTO public.ticket VALUES (17, 2, 4, 10.65);
INSERT INTO public.ticket VALUES (19, 1, 1, 156.98);


--
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 208
-- Name: aircraft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircraft_id_seq', 5, true);


--
-- TOC entry 3080 (class 0 OID 0)
-- Dependencies: 206
-- Name: airline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airline_id_seq', 2, true);


--
-- TOC entry 3081 (class 0 OID 0)
-- Dependencies: 204
-- Name: airport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airport_id_seq', 2, true);


--
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 210
-- Name: flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flight_id_seq', 4, true);


--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 218
-- Name: log_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_flight_id_seq', 2, true);


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 202
-- Name: passenger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passenger_id_seq', 3, true);


--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 212
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_id_seq', 19, true);


--
-- TOC entry 2910 (class 2606 OID 17176)
-- Name: aircraft aircraft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircraft
    ADD CONSTRAINT aircraft_pkey PRIMARY KEY (id);


--
-- TOC entry 2908 (class 2606 OID 17168)
-- Name: airline airline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airline
    ADD CONSTRAINT airline_pkey PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 17157)
-- Name: airport airport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport
    ADD CONSTRAINT airport_pkey PRIMARY KEY (id);


--
-- TOC entry 2912 (class 2606 OID 17184)
-- Name: flight flight_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_pkey PRIMARY KEY (id);


--
-- TOC entry 2904 (class 2606 OID 17146)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (id);


--
-- TOC entry 2914 (class 2606 OID 17207)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 2921 (class 2620 OID 17257)
-- Name: flight commit_flight_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER commit_flight_change AFTER INSERT OR UPDATE ON public.flight FOR EACH ROW EXECUTE FUNCTION public.trigger_log_flight();


--
-- TOC entry 2917 (class 2606 OID 17195)
-- Name: flight flight_aircraft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_aircraft_id_fkey FOREIGN KEY (aircraft_id) REFERENCES public.aircraft(id);


--
-- TOC entry 2916 (class 2606 OID 17190)
-- Name: flight flight_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES public.airline(id);


--
-- TOC entry 2915 (class 2606 OID 17185)
-- Name: flight flight_airport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight
    ADD CONSTRAINT flight_airport_id_fkey FOREIGN KEY (airport_id) REFERENCES public.airport(id);


--
-- TOC entry 2920 (class 2606 OID 17249)
-- Name: log_flight log_flight_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_flight
    ADD CONSTRAINT log_flight_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flight(id);


--
-- TOC entry 2919 (class 2606 OID 17213)
-- Name: ticket ticket_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flight(id);


--
-- TOC entry 2918 (class 2606 OID 17208)
-- Name: ticket ticket_passenger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES public.passenger(id);


--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO lab_air_user;


-- Completed on 2023-02-16 15:53:44

--
-- PostgreSQL database dump complete
--

