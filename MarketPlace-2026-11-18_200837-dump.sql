--
-- PostgreSQL database dump
--

\restrict WWgUXZF5eecbMC2dSVVmSd5I84ErN5nvf8xmir35EGqsyqO4Rt3fAHmvpRAuXx3

-- Dumped from database version 18.7
-- Dumped by pg_dump version 18.7

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.categories (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(120) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    sort_order smallint DEFAULT '0'::smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    merchant_profile_id uuid
);


ALTER TABLE public.categories OWNER TO katering_app;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.invoices (
    id uuid NOT NULL,
    order_id uuid NOT NULL,
    invoice_number character varying(50) NOT NULL,
    invoice_date date NOT NULL,
    subtotal numeric(14,2) NOT NULL,
    total numeric(14,2) NOT NULL,
    status character varying(30) DEFAULT 'issued'::character varying NOT NULL,
    paid_at timestamp(0) without time zone
);


ALTER TABLE public.invoices OWNER TO katering_app;

--
-- Name: menus; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.menus (
    id uuid NOT NULL,
    merchant_profile_id uuid NOT NULL,
    category_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    slug character varying(180) NOT NULL,
    description text,
    photo character varying(255),
    price numeric(14,2) NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.menus OWNER TO katering_app;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO katering_app;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: katering_app
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO katering_app;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: katering_app
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.order_items (
    id uuid NOT NULL,
    order_id uuid NOT NULL,
    menu_id uuid,
    menu_name character varying(150) NOT NULL,
    price numeric(14,2) NOT NULL,
    quantity integer NOT NULL,
    subtotal numeric(14,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.order_items OWNER TO katering_app;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.orders (
    id uuid NOT NULL,
    order_number character varying(50) NOT NULL,
    customer_profile_id uuid NOT NULL,
    merchant_profile_id uuid NOT NULL,
    delivery_date date NOT NULL,
    delivery_address text NOT NULL,
    subtotal numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    total numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.orders OWNER TO katering_app;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO katering_app;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: katering_app
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO katering_app;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: katering_app
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    full_name character varying(150) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    company_name character varying(255),
    contact_person character varying(255),
    address text,
    city character varying(100),
    description text,
    logo character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.profiles OWNER TO katering_app;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO katering_app;

--
-- Name: users; Type: TABLE; Schema: public; Owner: katering_app
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO katering_app;

--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.categories (id, name, slug, description, is_active, sort_order, created_at, updated_at, merchant_profile_id) FROM stdin;
01a1e84d-996d-7aa7-a433-890538448dc8	Makanan Pedas	makanan-pedas	Kategori makanan dengan tingkat kepedasan tinggi.	t	1	2026-11-17 06:59:22	2026-11-17 06:59:22	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e858-c74b-7eb4-8e6d-468a8f6ecd38	Makanan Pedas	makanan-pedas-1	Kategori makanan dengan tingkat kepedasan tinggi.	t	1	2026-11-17 07:11:34	2026-11-17 07:11:34	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e954-e727-7851-bdac-97e004589c4d	Paket Nasi	paket-nasi	Kategori paket nasi	t	0	2026-11-17 11:46:57	2026-11-17 11:46:57	01a1e953-a12a-726a-b98e-ad0c12de7c89
01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Makanan Berat	makanan-berat-merchant-01	Kategori makanan berat dari Katering Nusantara	t	1	2026-11-17 13:52:02	2026-11-17 13:52:02	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e9c7-6ba0-7abc-8300-d44410203925	Makanan Ringan	makanan-ringan-merchant-01	Kategori makanan ringan dari Katering Nusantara	t	2	2026-11-17 13:52:02	2026-11-17 13:52:02	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Minuman	minuman-merchant-01	Kategori minuman dari Katering Nusantara	t	3	2026-11-17 13:52:02	2026-11-17 13:52:02	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Kotak	paket-nasi-kotak-merchant-01	Kategori paket nasi kotak dari Katering Nusantara	t	4	2026-11-17 13:52:02	2026-11-17 13:52:02	01a1e773-f3a3-749b-900d-ef85dc0893c0
01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Makanan Berat	makanan-berat-merchant	Kategori makanan berat dari 	t	1	2026-11-17 13:52:02	2026-11-17 13:52:02	01a1e953-a12a-726a-b98e-ad0c12de7c89
01a1e9c7-6bba-7999-b901-1e8cd06146e3	Makanan Ringan	makanan-ringan-merchant	Kategori makanan ringan dari 	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e953-a12a-726a-b98e-ad0c12de7c89
01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Minuman	minuman-merchant	Kategori minuman dari 	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e953-a12a-726a-b98e-ad0c12de7c89
01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Kotak	paket-nasi-kotak-merchant	Kategori paket nasi kotak dari 	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e953-a12a-726a-b98e-ad0c12de7c89
01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Makanan Berat	makanan-berat-merchant-02	Kategori makanan berat dari Dapur Bunda	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5e19-70fd-bd60-f606ea48ef70
01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Makanan Ringan	makanan-ringan-merchant-02	Kategori makanan ringan dari Dapur Bunda	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5e19-70fd-bd60-f606ea48ef70
01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Minuman	minuman-merchant-02	Kategori minuman dari Dapur Bunda	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5e19-70fd-bd60-f606ea48ef70
01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Kotak	paket-nasi-kotak-merchant-02	Kategori paket nasi kotak dari Dapur Bunda	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5e19-70fd-bd60-f606ea48ef70
01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Makanan Berat	makanan-berat-merchant-03	Kategori makanan berat dari Berkah Catering	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5ed5-749f-b1b6-365e3732bf63
01a1e9c7-6beb-77eb-9606-0268a102153f	Makanan Ringan	makanan-ringan-merchant-03	Kategori makanan ringan dari Berkah Catering	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5ed5-749f-b1b6-365e3732bf63
01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Minuman	minuman-merchant-03	Kategori minuman dari Berkah Catering	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5ed5-749f-b1b6-365e3732bf63
01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Kotak	paket-nasi-kotak-merchant-03	Kategori paket nasi kotak dari Berkah Catering	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5ed5-749f-b1b6-365e3732bf63
01a1e9c7-6bfd-7856-96af-2afb544a958f	Makanan Berat	makanan-berat-merchant-04	Kategori makanan berat dari Rasa Nusantara	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5f91-7943-8af2-a81d845ade3a
01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Makanan Ringan	makanan-ringan-merchant-04	Kategori makanan ringan dari Rasa Nusantara	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5f91-7943-8af2-a81d845ade3a
01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Minuman	minuman-merchant-04	Kategori minuman dari Rasa Nusantara	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5f91-7943-8af2-a81d845ade3a
01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Kotak	paket-nasi-kotak-merchant-04	Kategori paket nasi kotak dari Rasa Nusantara	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-5f91-7943-8af2-a81d845ade3a
01a1e9c7-6c15-71ef-a916-d5e48072e857	Makanan Berat	makanan-berat-merchant-05	Kategori makanan berat dari Kalimantan Food	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6053-707a-996c-07818c555b6a
01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Makanan Ringan	makanan-ringan-merchant-05	Kategori makanan ringan dari Kalimantan Food	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6053-707a-996c-07818c555b6a
01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Minuman	minuman-merchant-05	Kategori minuman dari Kalimantan Food	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6053-707a-996c-07818c555b6a
01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Kotak	paket-nasi-kotak-merchant-05	Kategori paket nasi kotak dari Kalimantan Food	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6053-707a-996c-07818c555b6a
01a1e9c7-6c2c-7c51-89a3-4944845b2523	Makanan Berat	makanan-berat-merchant-06	Kategori makanan berat dari Dapur Sehat	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6113-762d-9762-2cd544186c3e
01a1e9c7-6c32-7d58-be52-8334af04a001	Makanan Ringan	makanan-ringan-merchant-06	Kategori makanan ringan dari Dapur Sehat	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6113-762d-9762-2cd544186c3e
01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Minuman	minuman-merchant-06	Kategori minuman dari Dapur Sehat	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6113-762d-9762-2cd544186c3e
01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Kotak	paket-nasi-kotak-merchant-06	Kategori paket nasi kotak dari Dapur Sehat	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6113-762d-9762-2cd544186c3e
01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Makanan Berat	makanan-berat-merchant-07	Kategori makanan berat dari Cita Rasa Catering	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40
01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Makanan Ringan	makanan-ringan-merchant-07	Kategori makanan ringan dari Cita Rasa Catering	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40
01a1e9c7-6c50-7ac8-865c-7b09340e374f	Minuman	minuman-merchant-07	Kategori minuman dari Cita Rasa Catering	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40
01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Kotak	paket-nasi-kotak-merchant-07	Kategori paket nasi kotak dari Cita Rasa Catering	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40
01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Makanan Berat	makanan-berat-merchant-08	Kategori makanan berat dari Sweet Kitchen	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6286-79df-93cc-5050a1dd21de
01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Makanan Ringan	makanan-ringan-merchant-08	Kategori makanan ringan dari Sweet Kitchen	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6286-79df-93cc-5050a1dd21de
01a1e9c7-6c69-7a93-a611-dbd77f45c857	Minuman	minuman-merchant-08	Kategori minuman dari Sweet Kitchen	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6286-79df-93cc-5050a1dd21de
01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Kotak	paket-nasi-kotak-merchant-08	Kategori paket nasi kotak dari Sweet Kitchen	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-6286-79df-93cc-5050a1dd21de
01a1e9c7-6c75-768b-8f6b-4e918be11904	Makanan Berat	makanan-berat-merchant-09	Kategori makanan berat dari Warung Premium	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-633c-71d7-90af-6f1706435591
01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Makanan Ringan	makanan-ringan-merchant-09	Kategori makanan ringan dari Warung Premium	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-633c-71d7-90af-6f1706435591
01a1e9c7-6c81-7543-803e-eedf8596c529	Minuman	minuman-merchant-09	Kategori minuman dari Warung Premium	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-633c-71d7-90af-6f1706435591
01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Kotak	paket-nasi-kotak-merchant-09	Kategori paket nasi kotak dari Warung Premium	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-633c-71d7-90af-6f1706435591
01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Makanan Berat	makanan-berat-merchant-10	Kategori makanan berat dari Healthy Meal	t	1	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c
01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Makanan Ringan	makanan-ringan-merchant-10	Kategori makanan ringan dari Healthy Meal	t	2	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c
01a1e9c7-6c98-779d-875c-4a3be01905a3	Minuman	minuman-merchant-10	Kategori minuman dari Healthy Meal	t	3	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c
01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Kotak	paket-nasi-kotak-merchant-10	Kategori paket nasi kotak dari Healthy Meal	t	4	2026-11-17 13:52:03	2026-11-17 13:52:03	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c
01a1e96e-f1f9-7fef-8c3c-8fee7a55a7ea	Paket Nasi Hijau	paket-nasi-hijau	Kategori paket nasi	t	0	2026-11-17 12:15:24	2026-11-18 02:11:42	01a1e953-a12a-726a-b98e-ad0c12de7c89
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.invoices (id, order_id, invoice_number, invoice_date, subtotal, total, status, paid_at) FROM stdin;
01a1e970-bf0a-7d26-88ed-9f2a9ae006e1	01a1e970-bf08-7a04-8733-8de1c89d8e63	INV-20261117-LFELVYNL	2026-11-17	250000.00	250000.00	issued	\N
01a1eca1-dfb3-73df-b376-97d661576503	01a1eca1-dfb0-796c-aa01-d87d5ed83ed2	INV-20261118-XZFVI1EY	2026-11-18	50000.00	50000.00	issued	\N
01a1ee86-aeb5-7010-8549-3b58d8cde116	01a1ee86-aeb1-77f7-9320-42fac2e09d3f	INV-20261118-Q6QM0V8X	2026-11-18	80000.00	80000.00	issued	\N
\.


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.menus (id, merchant_profile_id, category_id, name, slug, description, photo, price, is_available, created_at, updated_at, deleted_at) FROM stdin;
01a1e84e-96ab-7133-a151-939c9664f275	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e84d-996d-7aa7-a433-890538448dc8	Nasi Ayam Bakar Spesial	nasi-ayam-bakar-spesial	Nasi dengan ayam bakar dan sambal.	\N	30000.00	t	2026-11-17 07:00:26	2026-11-17 07:02:34	\N
01a1e85f-d6d8-7697-b8a8-8d5ac318c8a3	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e858-c74b-7eb4-8e6d-468a8f6ecd38	Nasi Ayam Bakar Spesial	nasi-ayam-bakar-spesial-1	Nasi ayam bakar dengan sambal spesial.	menus/01a1e773-f3a3-749b-900d-ef85dc0893c0/aQeDUiMi0nYxk6kXsck5GRAdiHNsCnbJqhVjMX6n.png	30000.00	t	2026-11-17 07:19:17	2026-11-17 07:25:35	\N
01a1e96f-041c-75be-836f-d6a0bdefb4e2	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e96e-f1f9-7fef-8c3c-8fee7a55a7ea	Nasi Ayam Bakar	nasi-ayam-bakar-1	Nasi ayam bakar lengkap	menus/01a1e953-a12a-726a-b98e-ad0c12de7c89/F2cwysaB3Bc2edDPtLqQAwkO2kk8iqbiWhZD0wHi.png	25000.00	t	2026-11-17 12:15:29	2026-11-17 12:15:29	\N
01a1e9c7-6ca6-7aed-8374-63db85569224	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cb1-7ee9-8458-830d2eec1746	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cb8-7066-a940-83ebfbd91d38	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cbe-7041-adc4-8368d238b85b	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cc4-7200-a6f4-a13749b82c53	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6b99-75a9-9bcf-122d1c6960f1	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cca-7093-a0ac-8049ee3098d7	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba0-7abc-8300-d44410203925	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ccf-7f8d-8e0e-19f487de3872	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba0-7abc-8300-d44410203925	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cd5-7a87-a6be-21e8c7750e92	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba0-7abc-8300-d44410203925	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cdb-761c-9f06-a101fd378645	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba0-7abc-8300-d44410203925	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ce1-746e-912a-7c933ed55570	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba0-7abc-8300-d44410203925	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ce7-71a5-8390-23f073d39170	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cec-7dca-8c20-50e504c5c045	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cf2-7b70-92e6-bf797f59ded5	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cf8-79f3-bead-22d710fa5a81	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6cfe-77fb-ab42-19a5dc2bc367	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6ba7-7a76-b3e2-c69981e3b1c4	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d04-795c-98f2-6e482dafffac	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d0a-7da5-b6f9-c7cb89458950	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d10-7c93-9aa2-49919152f7b5	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d16-7bc2-802f-674c1acecd76	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d1d-701c-9dd6-4702edf2db79	01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e9c7-6bae-707e-ae18-6de4e3666d08	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e955-be8b-7385-b69c-e59b07f73c21	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 11:47:53	2026-11-17 13:52:03	\N
01a1e9c7-6d2d-7160-912f-4a26b97c240b	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d33-726a-b711-3b761f3f1dd5	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d39-702d-a088-bee995ef62d8	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d3e-7ee5-9afe-838e01260cbd	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bb4-7960-8350-5477f6cfbb51	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d44-7c83-8ab3-c321a03eaef2	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bba-7999-b901-1e8cd06146e3	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d4b-712f-ad73-1c9827e7957d	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bba-7999-b901-1e8cd06146e3	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d51-7a35-8b10-d380016bb746	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bba-7999-b901-1e8cd06146e3	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d57-7b47-b0d9-a8707c831135	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bba-7999-b901-1e8cd06146e3	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d5d-7c18-be86-cdc883da87aa	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bba-7999-b901-1e8cd06146e3	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d64-71a5-ad17-7b6029c5eaeb	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d6a-74e9-b2eb-27e14b53b704	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d70-73e7-817b-e9a57fff210c	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d76-71c6-b2cf-93508129d572	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d7c-7056-97fc-2cfce0802fda	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d81-7d6c-9bb9-9b46d881ccbf	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d87-7856-80ad-a90cb657bd1b	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d8d-74d9-ada9-2d629b1da81d	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d93-72d9-91c5-4c16ffe9ab71	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6d9e-7fe7-b6ae-5a0eac97426f	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6da4-7efd-9f6a-9ba2fb8db66a	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6daa-7e62-b898-0bfe5941771a	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6db0-7aa7-b2e9-4883d89dd583	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6db6-76a7-9a13-6f239f6c7f57	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bcc-794b-9042-7fd5b3bf286b	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dbc-7404-9f9a-7fd299b6b386	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dc2-71ae-8092-9b41acac606a	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dc8-70d4-b1d0-ea819b2317ee	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dce-727e-86f2-a5154e1a5b09	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dd4-772f-ac5e-7c95854cf4b3	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd2-747e-b688-11e6ea0488b9	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dda-7a04-9fd8-e41f660051d9	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6de0-7ce9-88f2-e021f3ab0b89	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6de6-7e9b-86f9-225ab753db1d	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dec-7dbe-bc46-dd26aff27f71	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6df2-7bc2-9933-6f7f4bd55a69	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bd8-786e-9294-3c5fa57060c2	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6df8-797c-8d5f-9c2869900612	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6dfe-79df-bda4-51175dda101b	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e04-789b-9a04-c0a3b77c3a51	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e0a-750e-aa07-bb8d44d23176	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e10-7245-b242-683208748a30	01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-6bde-75e7-981b-13440c903394	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e15-7da5-8ff6-f5bf7d5a378f	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e1b-7deb-a77d-dbc8833d0af5	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e21-7c83-959f-53fe6936daee	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e27-7b64-a436-b4e63495d771	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e2d-7856-bc07-0d32b582b151	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6be5-70a3-9675-5dd2a9b5d0ce	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e33-74e1-a610-11a35dd1b04e	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6beb-77eb-9606-0268a102153f	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e39-751e-bcd9-d770f35c44cb	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6beb-77eb-9606-0268a102153f	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e3f-7820-9939-20c8b72b93e8	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6beb-77eb-9606-0268a102153f	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e45-752b-ac3f-93d12dee24d4	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6beb-77eb-9606-0268a102153f	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e4b-72d9-a29f-c4d41bfff582	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6beb-77eb-9606-0268a102153f	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e51-7041-ba94-fcdedbd07a61	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e56-7d68-acd5-f1e7d9b2ca8e	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e5c-7ae5-8622-e53565e78161	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e62-7702-babf-9f708b4c70d5	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e68-73d2-84b4-f3c99c337d2a	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf1-797c-85dc-a5e5e87a9525	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e6e-712f-b389-dc51e1d5d3a6	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e73-7ebc-9b8c-ab83164e5259	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e79-7fc6-8668-4ff193177cc9	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e80-712b-8e3b-936d058ed3dd	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e85-7eb4-bdf6-3ff1c3bb7832	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-6bf7-7789-a7b3-c2e315e8c632	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e8c-74b4-b23a-41125266b1e1	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6bfd-7856-96af-2afb544a958f	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e92-77f7-b27e-24f23164a4ed	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6bfd-7856-96af-2afb544a958f	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e98-7c04-ae33-1e23c55bee4e	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6bfd-7856-96af-2afb544a958f	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6e9e-7cbc-b0a3-6607997d1f5b	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6bfd-7856-96af-2afb544a958f	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ea4-7989-bb3f-40eb03d9228e	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6bfd-7856-96af-2afb544a958f	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6eaa-7a18-8b0c-7b1653bfffe2	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6eb0-7ccc-8807-dd395733dfb9	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6eb6-79b6-9c4a-eb324567c51b	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ebc-750a-b244-261266629607	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ec2-731e-b9f4-5caf3736a663	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c03-73b2-84fa-bb47613ceac3	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ec8-7420-b58f-633bdd9923f0	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ece-72f1-bd7e-7b2ebd75b203	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ed4-7102-b9fe-e420a30f34f4	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6eda-7370-a827-c5153adfa837	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ee0-7326-8f37-c182b2e69a53	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c09-7204-9a1b-9f0240da4b26	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ee6-7316-9c1d-14f0c2f54896	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6eec-7208-9308-2db188eb5dfd	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ef2-711a-bff0-455a8332590f	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6ef8-71e7-8bdb-f925a9bb2f1e	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6efe-759d-b096-dbf7c99f9f22	01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-6c0f-7418-90fe-683b3313b066	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f04-7764-9658-ad10006bd9a0	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c15-71ef-a916-d5e48072e857	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f0a-7a20-bfe7-c00c8870c80e	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c15-71ef-a916-d5e48072e857	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f10-7bc2-a314-a293665e61ac	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c15-71ef-a916-d5e48072e857	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f16-7df3-bc29-c1c79dc748d1	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c15-71ef-a916-d5e48072e857	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f1d-79db-9cbb-6abe49c53960	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c15-71ef-a916-d5e48072e857	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f24-7168-bf38-913c9a243e11	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f2a-7768-8776-3abf6635e890	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f30-763d-bdae-7935a54e8169	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f36-75d2-9df5-cd3a8adc5ae8	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f3c-744d-b57b-48cf1a24a377	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c1b-7028-ad34-9ac2f2343c8b	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f42-71c2-befe-4a0c970f3df9	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f48-7168-ab61-1543402d11dd	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f4e-700c-99dd-1275a795ad33	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f54-70ac-871c-286c39cce0fd	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f59-7ef9-9cdc-2c404a8d5920	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c20-7dd2-8a42-30dd5e19b1a4	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f5f-7ee9-9669-7ab334372f17	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f66-73f7-81e3-2c4dbc6dc45b	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f6c-7764-88e8-e4fbc4752864	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f72-756c-ad55-640d98807fe9	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f78-74b0-b859-dbbb83a44fc2	01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6c26-7e51-94d8-b2d1e0dafb6b	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f7e-72c0-8aa1-a95942abfafd	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c2c-7c51-89a3-4944845b2523	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f84-7764-a73b-4a8105c597e3	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c2c-7c51-89a3-4944845b2523	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f8b-729f-a229-b6e68d1b6a5b	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c2c-7c51-89a3-4944845b2523	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f91-77ca-a597-947f65862248	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c2c-7c51-89a3-4944845b2523	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f97-7eb4-ad32-30e615a9a428	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c2c-7c51-89a3-4944845b2523	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6f9e-730e-96a8-5a087aa64ad8	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c32-7d58-be52-8334af04a001	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:03	2026-11-17 13:52:03	\N
01a1e9c7-6fa4-7a83-8ab4-80a24b98a7f5	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c32-7d58-be52-8334af04a001	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fab-78b8-8828-1a912dabb90e	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c32-7d58-be52-8334af04a001	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fb1-79be-9f4c-8c73b6ae4673	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c32-7d58-be52-8334af04a001	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fb7-7c18-a788-662a5acfd736	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c32-7d58-be52-8334af04a001	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fbd-7edd-8bb5-b8b5e87d93c4	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fc4-781c-a5a2-846e2af46d5c	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fca-7a39-8805-466e122f4fd9	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fd0-7f2f-9c0a-8ba8d6cfa5c3	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fd7-7112-82ef-87fa5dba6f79	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c38-7f4f-ba94-69eb5c857ff9	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fdd-7410-abed-d6e8ed4b8ca1	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fe3-7306-9ec3-908ea358409a	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fe9-723d-91ca-38525cdfcff5	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6fef-73fb-a32c-a01a2006873d	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6ff5-72ac-88bd-2d61a265da64	01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6c3e-7e83-b16f-75fef3511cbd	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6ffb-70f1-bb0e-30c80eadc9d2	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7001-700c-bd89-4c47eaa806cf	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7006-7d37-b087-7fd7ecad5e39	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-700c-7f91-98a6-aa862b9bedce	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7013-71df-9a02-0f1c4c7dfe7e	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c44-7ecc-8a68-74bad24c5335	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7019-72d9-8703-92a1238da8be	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-701f-767a-8d9d-bcb2cd29a674	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7025-7808-b5bd-fe2c3f6ffc5a	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-702b-7906-b26f-84983409debe	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7031-7ae9-8d6d-d936104256bb	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c4a-7d3f-ae27-72e207171a26	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7037-7be3-a9d2-ac36367d9d74	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c50-7ac8-865c-7b09340e374f	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-703d-7eb4-a96b-ce5c68b8e8aa	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c50-7ac8-865c-7b09340e374f	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7044-77ca-8a16-64f9324f8c65	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c50-7ac8-865c-7b09340e374f	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-704a-78c4-92e2-3e9bdfc6b961	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c50-7ac8-865c-7b09340e374f	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7050-7c18-a99b-98b7ba41520c	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c50-7ac8-865c-7b09340e374f	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7057-74c0-bc8c-c797d0eaf8ca	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-705d-7410-b0f9-c059dfe0f9f8	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7063-737c-9d92-14ab9d09c41c	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7069-7451-accf-0fd5031a0f9c	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-706f-71ca-be08-fe3a8222c44d	01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-6c56-79a5-bb83-00708067eff5	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7075-72cc-8159-13f2dbd38d14	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-707b-72ac-89d7-8f0c03e85b86	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7081-7218-82cf-78e3ab7b8292	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7087-704d-aff6-6543f4c9d289	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-708d-7431-aac7-7128e8a94a85	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c5c-7e8f-87fd-962240bae2cc	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7093-7472-bcad-1e5b9c0c40ff	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7099-7185-ba3d-0153be497220	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-709e-7f4b-8e44-46b1ed4533eb	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70a4-7e28-8468-01a0dc2d6c97	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70aa-7ed0-b325-c9b2bea99f50	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c63-7666-9de3-ffdab0dc3c80	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70b1-7266-88c1-d7276109780b	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c69-7a93-a611-dbd77f45c857	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70b7-71c6-9ddd-de2364b67750	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c69-7a93-a611-dbd77f45c857	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70bc-7e24-bd50-6b88b9ac5629	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c69-7a93-a611-dbd77f45c857	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70c2-7d6c-a30a-b885318676c4	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c69-7a93-a611-dbd77f45c857	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70c8-7ee9-b9af-44b3823d5f3d	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c69-7a93-a611-dbd77f45c857	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70ce-7f26-8254-cb6df4fc052d	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70d4-7e66-98b7-1a03e013e41b	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70da-7cb4-84f4-cf90ddaf617c	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70e1-71a9-86e7-74f02c5789ee	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70e7-74b4-bbce-9ca421193d90	01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6c6f-7a41-91e6-13e0f34a77c7	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70ed-74bc-ba00-0664431ae54d	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c75-768b-8f6b-4e918be11904	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70f3-7256-914a-4d8bcdade3a2	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c75-768b-8f6b-4e918be11904	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70f9-71e7-82e0-2c04e6b89218	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c75-768b-8f6b-4e918be11904	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-70ff-71c6-8b84-31c8a3530cf1	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c75-768b-8f6b-4e918be11904	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7105-7199-86c8-42384f7aabf6	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c75-768b-8f6b-4e918be11904	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-710b-7210-ba08-391aab77ff95	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7111-71a1-adf7-70d3e680d285	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7116-7fe3-aa0d-44b7eb41bcc8	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-711d-7195-b6b5-fc3e533f26ef	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7123-7235-8bce-c8f8c4ee4b7e	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c7b-756c-aff6-fcd154a12ba9	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7129-72f5-886f-54a017ae975c	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c81-7543-803e-eedf8596c529	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-712f-7322-9ac9-ace8b58aa8d2	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c81-7543-803e-eedf8596c529	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7135-71b6-bb57-741bc6872697	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c81-7543-803e-eedf8596c529	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-713b-77b2-98d8-ec5bc593ac04	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c81-7543-803e-eedf8596c529	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7142-7639-b559-37b3013f59a9	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c81-7543-803e-eedf8596c529	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7148-78a3-b0ed-d2663ccbb8f4	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-714e-791a-8622-ae860a3edb60	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7154-7b7c-82eb-8c8c65f13dcc	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-715a-7e9b-ad22-8ab447661345	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7161-7337-b2c6-ec9ef6609989	01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6c87-730a-bf40-a20df38ad88e	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7167-756c-af23-181d2bfb008a	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Nasi Ayam Bakar	nasi-ayam-bakar	Nasi Ayam Bakar dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-716d-7851-aced-ee03b5729edd	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Nasi Rendang	nasi-rendang	Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	30000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7173-7770-9e33-5deed00fbecc	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Nasi Goreng Spesial	nasi-goreng-spesial	Nasi Goreng Spesial dibuat dengan bahan pilihan dan berkualitas.	\N	22000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7179-772f-946c-baea2280c72e	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Ayam Geprek	ayam-geprek	Ayam Geprek dibuat dengan bahan pilihan dan berkualitas.	\N	20000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-717f-786a-8c84-41e5c01c81ab	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c8d-70a7-90fe-cd12e2d7c99a	Nasi Ikan Goreng	nasi-ikan-goreng	Nasi Ikan Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7185-7a5a-bb3c-f3bdd8ea1745	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Risoles Mayo	risoles-mayo	Risoles Mayo dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-718b-7a93-b1b6-d8296e77a833	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Pastel Ayam	pastel-ayam	Pastel Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-7195-7a6e-8ede-e650877a9200	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Lumpia Sayur	lumpia-sayur	Lumpia Sayur dibuat dengan bahan pilihan dan berkualitas.	\N	6000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-719c-708b-a46c-bbabde6371af	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Kentang Goreng	kentang-goreng	Kentang Goreng dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71a2-7414-ae1c-860dbcc42e4b	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c92-7bef-9c4a-bc13d3b72aeb	Pisang Cokelat	pisang-cokelat	Pisang Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71a8-75b2-9012-63b0bc78caed	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c98-779d-875c-4a3be01905a3	Es Teh Manis	es-teh-manis	Es Teh Manis dibuat dengan bahan pilihan dan berkualitas.	\N	5000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71af-7018-9e69-262f166da404	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c98-779d-875c-4a3be01905a3	Jus Alpukat	jus-alpukat	Jus Alpukat dibuat dengan bahan pilihan dan berkualitas.	\N	15000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71b5-7639-887f-4b294f1aa5df	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c98-779d-875c-4a3be01905a3	Es Jeruk	es-jeruk	Es Jeruk dibuat dengan bahan pilihan dan berkualitas.	\N	8000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71bb-7887-b434-3c9320348697	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c98-779d-875c-4a3be01905a3	Kopi Susu	kopi-susu	Kopi Susu dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71c1-79c2-af7e-6e18c570aced	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c98-779d-875c-4a3be01905a3	Es Cokelat	es-cokelat	Es Cokelat dibuat dengan bahan pilihan dan berkualitas.	\N	12000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71c7-7c83-a7e0-0baee513ba23	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Ayam	paket-nasi-ayam	Paket Nasi Ayam dibuat dengan bahan pilihan dan berkualitas.	\N	25000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71cd-7df7-8d81-40a826fdc564	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Rendang	paket-nasi-rendang	Paket Nasi Rendang dibuat dengan bahan pilihan dan berkualitas.	\N	35000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71d3-7b0e-b39b-c986ff627f94	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Ikan	paket-nasi-ikan	Paket Nasi Ikan dibuat dengan bahan pilihan dan berkualitas.	\N	28000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71da-7845-8daa-67605b62e1f5	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Telur	paket-nasi-telur	Paket Nasi Telur dibuat dengan bahan pilihan dan berkualitas.	\N	18000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-71e0-7a6e-8407-55b8662b2393	01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-6c9e-72d0-b959-ea6491605bce	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	\N	40000.00	t	2026-11-17 13:52:04	2026-11-17 13:52:04	\N
01a1e9c7-6d99-7116-9c51-126e2d7446d3	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc6-7ca3-a5ae-01b219aede2e	Paket Nasi Komplit	paket-nasi-komplit	Paket Nasi Komplit dibuat dengan bahan pilihan dan berkualitas.	menus/01a1e953-a12a-726a-b98e-ad0c12de7c89/bxCShek1rqH7ZGu16g4F4W9pPrMXAVxL8O8LIM0c.png	40000.00	t	2026-11-17 13:52:03	2026-11-18 02:20:22	\N
01a1ec79-065f-7424-969e-4ae926f8a0cf	01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e9c7-6bc0-7f64-86dc-95006c3a989f	Jus Kecubung	jus-kecubung	Jus Kecubung sehat	menus/01a1e953-a12a-726a-b98e-ad0c12de7c89/OdT72PoY3nYZUVzY6DuXhTdKfNgxSU6VF9flBOsx.png	10000.00	t	2026-11-18 02:25:16	2026-11-18 02:25:16	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.migrations (id, migration, batch) FROM stdin;
18	0001_01_01_000000_create_users_table	1
19	2026_11_17_010413_create_profiles_table	1
20	2026_11_17_010414_create_categories_table	1
21	2026_11_17_010415_create_menus_table	1
22	2026_11_17_010416_create_orders_table	1
23	2026_11_17_010417_create_order_items_table	1
24	2026_11_17_010418_create_invoices_table	1
25	2026_11_17_023303_create_personal_access_tokens_table	2
26	2026_11_17_062637_add_merchant_profile_id_to_categories_table	3
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.order_items (id, order_id, menu_id, menu_name, price, quantity, subtotal, created_at, updated_at) FROM stdin;
01a1e959-ee4f-7778-9840-b50acb767058	01a1e959-ee4d-74ed-bb6a-79f004305acb	01a1e955-be8b-7385-b69c-e59b07f73c21	Nasi Ayam Bakar	25000.00	10	250000.00	2026-11-17 11:52:27	2026-11-17 11:52:27
01a1e970-bf09-7989-8395-00980f31e549	01a1e970-bf08-7a04-8733-8de1c89d8e63	01a1e96f-041c-75be-836f-d6a0bdefb4e2	Nasi Ayam Bakar	25000.00	10	250000.00	2026-11-17 12:17:22	2026-11-17 12:17:22
01a1eca1-dfb1-76e9-99fa-f8f4aa3d75e6	01a1eca1-dfb0-796c-aa01-d87d5ed83ed2	01a1e9c7-6e15-7da5-8ff6-f5bf7d5a378f	Nasi Ayam Bakar	25000.00	2	50000.00	2026-11-18 03:09:53	2026-11-18 03:09:53
01a1ee86-aeb3-764d-8daf-c1173c989dff	01a1ee86-aeb1-77f7-9320-42fac2e09d3f	01a1ec79-065f-7424-969e-4ae926f8a0cf	Jus Kecubung	10000.00	2	20000.00	2026-11-18 11:59:26	2026-11-18 11:59:26
01a1ee86-aeb4-7174-b348-67c427036e84	01a1ee86-aeb1-77f7-9320-42fac2e09d3f	01a1e9c7-6d2d-7160-912f-4a26b97c240b	Nasi Rendang	30000.00	2	60000.00	2026-11-18 11:59:26	2026-11-18 11:59:26
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.orders (id, order_number, customer_profile_id, merchant_profile_id, delivery_date, delivery_address, subtotal, total, status, notes, created_at, updated_at) FROM stdin;
01a1e959-ee4d-74ed-bb6a-79f004305acb	ORD-20261117-0OXNKRFF	01a1e956-7898-785e-92cd-77d73dd242e3	01a1e953-a12a-726a-b98e-ad0c12de7c89	2026-12-01	Jl. Contoh No. 10, Samarinda	250000.00	250000.00	completed	Mohon dikirim sebelum pukul 11.00	2026-11-17 11:52:27	2026-11-17 11:54:00
01a1e970-bf08-7a04-8733-8de1c89d8e63	ORD-20261117-J3ZLHLRP	01a1e956-7898-785e-92cd-77d73dd242e3	01a1e953-a12a-726a-b98e-ad0c12de7c89	2026-12-01	Jl. Contoh No. 10, Samarinda	250000.00	250000.00	ready	Mohon dikirim sebelum pukul 11.00	2026-11-17 12:17:22	2026-11-18 02:36:22
01a1eca1-dfb0-796c-aa01-d87d5ed83ed2	ORD-20261118-DYYB8Y34	01a1e956-7898-785e-92cd-77d73dd242e3	01a1e9c7-5ed5-749f-b1b6-365e3732bf63	2026-11-20	Kubar	50000.00	50000.00	pending	test	2026-11-18 03:09:53	2026-11-18 03:09:53
01a1ee86-aeb1-77f7-9320-42fac2e09d3f	ORD-20261118-NZWF9NGE	01a1e956-7898-785e-92cd-77d73dd242e3	01a1e953-a12a-726a-b98e-ad0c12de7c89	2026-11-25	Melak	80000.00	80000.00	completed	Tolong pedas	2026-11-18 11:59:26	2026-11-18 12:00:38
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.profiles (id, user_id, full_name, email, phone, company_name, contact_person, address, city, description, logo, created_at, updated_at) FROM stdin;
01a1e956-7898-785e-92cd-77d73dd242e3	01a1e956-7897-772b-a483-0137df648aac	Customer Baru	customer@example.com	081234567890	\N	\N	\N	\N	\N	\N	2026-11-17 11:48:40	2026-11-17 11:48:40
01a1e773-f3a3-749b-900d-ef85dc0893c0	01a1e773-f39a-745e-8342-a544a8277970	Andi Pratama	merchant01@example.com	081200000001	Katering Nusantara	Andi Pratama	Jl. Katering Nusantara No. 10	Samarinda	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 03:01:38	2026-11-17 13:51:59
01a1e9c7-5e19-70fd-bd60-f606ea48ef70	01a1e9c7-5e0a-730a-9ea2-a1c2068506e4	Siti Rahmawati	merchant02@example.com	081200000002	Dapur Bunda	Siti Rahmawati	Jl. Dapur Bunda No. 10	Balikpapan	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-5ed5-749f-b1b6-365e3732bf63	01a1e9c7-5ec7-74d4-ab5d-1a8e38fb91a7	Budi Santoso	merchant03@example.com	081200000003	Berkah Catering	Budi Santoso	Jl. Berkah Catering No. 10	Tenggarong	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-5f91-7943-8af2-a81d845ade3a	01a1e9c7-5f83-773b-8340-f479ac33db14	Dewi Anggraini	merchant04@example.com	081200000004	Rasa Nusantara	Dewi Anggraini	Jl. Rasa Nusantara No. 10	Samarinda	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-6053-707a-996c-07818c555b6a	01a1e9c7-6043-7f64-93ce-9e154e4ae770	Rizky Maulana	merchant05@example.com	081200000005	Kalimantan Food	Rizky Maulana	Jl. Kalimantan Food No. 10	Balikpapan	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-6113-762d-9762-2cd544186c3e	01a1e9c7-6105-76bc-8dbb-8a593ed51437	Maya Sari	merchant06@example.com	081200000006	Dapur Sehat	Maya Sari	Jl. Dapur Sehat No. 10	Samarinda	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-61c8-7ffb-a02b-ab47aece0d40	01a1e9c7-61c2-76b8-8887-d71b7c9f6c5b	Agus Setiawan	merchant07@example.com	081200000007	Cita Rasa Catering	Agus Setiawan	Jl. Cita Rasa Catering No. 10	Bontang	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-6286-79df-93cc-5050a1dd21de	01a1e9c7-6278-72c0-9578-230f4bcd0a4d	Putri Amelia	merchant08@example.com	081200000008	Sweet Kitchen	Putri Amelia	Jl. Sweet Kitchen No. 10	Samarinda	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-633c-71d7-90af-6f1706435591	01a1e9c7-6335-7947-883b-d5ae7b681680	Fajar Ramadhan	merchant09@example.com	081200000009	Warung Premium	Fajar Ramadhan	Jl. Warung Premium No. 10	Tenggarong	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-63fb-7e62-9bed-2c9f02e1907c	01a1e9c7-63ed-71c6-8fdc-96934074befc	Nadia Putri	merchant10@example.com	081200000010	Healthy Meal	Nadia Putri	Jl. Healthy Meal No. 10	Balikpapan	Penyedia layanan katering dan makanan berkualitas.	\N	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-64cb-7770-9639-6c70fca6b1c4	01a1e9c7-64bc-7693-a0fb-7c24de6e7408	Bambang Saputra	customer01@example.com	081300000001	\N	\N	Jl. Contoh No. 15	Samarinda	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-6596-769b-a51e-daac49958d62	01a1e9c7-6587-7f1e-802f-4ea8bd79f945	Citra Lestari	customer02@example.com	081300000002	\N	\N	Jl. Contoh No. 15	Balikpapan	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-665a-7218-bfab-40142014c411	01a1e9c7-664c-706a-a904-04f2e5e260f6	Dimas Prakoso	customer03@example.com	081300000003	\N	\N	Jl. Contoh No. 15	Tenggarong	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-6716-7c2d-bf47-81808dccbc86	01a1e9c7-6707-7d0e-a63e-6058ecfa9cf8	Eka Wulandari	customer04@example.com	081300000004	\N	\N	Jl. Contoh No. 15	Samarinda	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-67d5-71c6-91f1-15c3fbd7f82e	01a1e9c7-67c6-7b53-a990-80476ff71c1e	Farhan Akbar	customer05@example.com	081300000005	\N	\N	Jl. Contoh No. 15	Balikpapan	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6898-7814-afed-dcfed8628f02	01a1e9c7-688a-71a1-8f1c-680b63f3e6d3	Gita Permata	customer06@example.com	081300000006	\N	\N	Jl. Contoh No. 15	Bontang	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-695c-7d7c-a830-ec6ce60310cc	01a1e9c7-694e-77d2-93bc-f0fbf7d5fa22	Hendra Wijaya	customer07@example.com	081300000007	\N	\N	Jl. Contoh No. 15	Samarinda	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6a18-74d4-9485-06b3f484af75	01a1e9c7-6a11-79db-aef3-34a0b4e3ee44	Intan Maharani	customer08@example.com	081300000008	\N	\N	Jl. Contoh No. 15	Tenggarong	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6ad7-71a9-b911-d8550d0ef493	01a1e9c7-6ac8-7bdb-b88a-5ae89ed787a1	Joko Susanto	customer09@example.com	081300000009	\N	\N	Jl. Contoh No. 15	Balikpapan	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6b8c-7e8f-a775-cc6653170e13	01a1e9c7-6b85-7c24-889b-297710529b0e	Kartika Sari	customer10@example.com	081300000010	\N	\N	Jl. Contoh No. 15	Samarinda	Akun customer dummy untuk pengujian marketplace.	\N	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1ec56-dd63-71ca-b93c-8d7d02538282	01a1ec56-dd5a-730e-bee9-4a5765d52151	testing	test@gmail.com	081256433423	\N	\N	\N	\N	\N	\N	2026-11-18 01:47:58	2026-11-18 01:47:58
01a1ec57-b963-7d9d-bbaf-811ea9be4c8a	01a1ec57-b962-7420-8742-68b50c43ca97	UsahaJaya	Usaha@gmail.com	082465432345	Usaha saha	Bryan	bukit pinang	samarinda	\N	\N	2026-11-18 01:48:54	2026-11-18 01:48:54
01a1e953-a12a-726a-b98e-ad0c12de7c89	01a1e953-a120-77e3-9aae-e29087975662	bryan Baru	bryan@example.com	081234567890	BUMBN	BB	bukit pinang	samarinda	Makanan Berkelas	\N	2026-11-17 11:45:34	2026-11-18 03:26:30
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
9K3Zf2EsSiMuHd8RibUfDCJLziZqP4AZu9PWgNBp	\N	127.0.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36	eyJfdG9rZW4iOiJCR0loODcxYWpIblpIUDFHOUVwUmpHVXlmalZNckE3S2MycjNVYTNMIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19	1794884028
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: katering_app
--

COPY public.users (id, username, password, role, is_active, created_at, updated_at) FROM stdin;
01a1e953-a120-77e3-9aae-e29087975662	bryan	$2y$12$.XHgvshqhetNHbiVm4xLJu0EtN0NFWEJD3IgGDouAOwxjhoSwlDqS	merchant	t	2026-11-17 11:45:34	2026-11-17 11:45:34
01a1e956-7897-772b-a483-0137df648aac	customer_baru	$2y$12$rKKlnHrsRan9gcKeskKci.xJD70fCUPPO3fqNAUayf1iKrpYJYBJK	customer	t	2026-11-17 11:48:40	2026-11-17 11:48:40
01a1e773-f39a-745e-8342-a544a8277970	merchant01	$2y$12$jBHyyETQV4GZLeyHPipn/.XQC86NNK8B7Ay8BNZSj.WkTekiPko/e	merchant	t	2026-11-17 03:01:38	2026-11-17 13:51:59
01a1e9c7-5e0a-730a-9ea2-a1c2068506e4	merchant02	$2y$12$LLu4/IokjFoh5Y.J7rW6ceVpKWqb/6qPLYIE191YhQCO1ciZQ6Zyq	merchant	t	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-5ec7-74d4-ab5d-1a8e38fb91a7	merchant03	$2y$12$g887ZjN9pdC1S2TsYrRDgOC2c8hjlrSYIWiDojQxlV93Ze.7TAqD2	merchant	t	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-5f83-773b-8340-f479ac33db14	merchant04	$2y$12$FkjhIaJ5lzM1dRVgyO06QOjxOqxTHuuK0bOs7T.t63PqYSj9vVVIO	merchant	t	2026-11-17 13:51:59	2026-11-17 13:51:59
01a1e9c7-6043-7f64-93ce-9e154e4ae770	merchant05	$2y$12$wFD/5PLgvyTIJbWjwW6e4O.cZYJCG0a2HhmP6Bbd8evSBPXpP3vYy	merchant	t	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-6105-76bc-8dbb-8a593ed51437	merchant06	$2y$12$GGvoubE.rhn6KYGOOrjsvOPXJ7V1t15nhbolLDGxG1UwJSktoaycC	merchant	t	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-61c2-76b8-8887-d71b7c9f6c5b	merchant07	$2y$12$tN.WOxL6dWayUehWt3.QputGVsfsvCKC0CFEhlvKMamXJ/XNywCpe	merchant	t	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-6278-72c0-9578-230f4bcd0a4d	merchant08	$2y$12$8s5v4A./2hsBB4rvYm5j9ef9lptb/1oTE.u6hL0LYsCNajaOByErS	merchant	t	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-6335-7947-883b-d5ae7b681680	merchant09	$2y$12$KeT3/PMBCgbCrWqHZLTH.e73YdgzM/1EfGjbpv7LzpZpoWSNJAdOe	merchant	t	2026-11-17 13:52:00	2026-11-17 13:52:00
01a1e9c7-63ed-71c6-8fdc-96934074befc	merchant10	$2y$12$a0lS0Iquc6iDKHUAKa8EwOmc26hVptcokA/3zUQGEHmFp4tOyUz3e	merchant	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-64bc-7693-a0fb-7c24de6e7408	customer01	$2y$12$KAxgYJ.Ff.GDa2R3MuRi8OWj5TTI1i6RaWvRvuiePbEPLv0k025YO	customer	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-6587-7f1e-802f-4ea8bd79f945	customer02	$2y$12$056QezavPLFqIUWcTbefXeG/d7XHrMecAiR9EmFImnwJhtnBwts1y	customer	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-664c-706a-a904-04f2e5e260f6	customer03	$2y$12$j1blbqadeEoIOMuJYeKnp.KRPTWmKctzFIEyQD.20Ye4PXyy4vo3a	customer	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-6707-7d0e-a63e-6058ecfa9cf8	customer04	$2y$12$t9WZ.X9ZSUX7EGjacPcv9uHtsQj.8RSPUR3oWUEl39YnZDNYWIOHG	customer	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-67c6-7b53-a990-80476ff71c1e	customer05	$2y$12$phzNEw3QCVX74MYUL2wIteN5633hS6VB/7U/DNuxplBMoYuTOmSRO	customer	t	2026-11-17 13:52:01	2026-11-17 13:52:01
01a1e9c7-688a-71a1-8f1c-680b63f3e6d3	customer06	$2y$12$VSxpuF5WvXlNRaXly31SjeJsdK6rLz1/TU/fmGiESAp/2my08AwHe	customer	t	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-694e-77d2-93bc-f0fbf7d5fa22	customer07	$2y$12$ufUljgQIEWKQdMI5n/oRae6G17I.VrxL8dB3ItfWNwPmv7aqdzRIW	customer	t	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6a11-79db-aef3-34a0b4e3ee44	customer08	$2y$12$m7LJeoXb02FRxaYKenDAmeiGavj7UNNZMfwL9CPdA9Ixjro7M/.Zu	customer	t	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6ac8-7bdb-b88a-5ae89ed787a1	customer09	$2y$12$S2qjkmqTepxmpRxZseuG0.NqMClIG4VvajcdJkpAEJKM2GQ3txe/S	customer	t	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1e9c7-6b85-7c24-889b-297710529b0e	customer10	$2y$12$0DANPCteWNMU0/QqcAvEJeNKyUxr3Oeb3P9X/4eEPq9leB92b6YnK	customer	t	2026-11-17 13:52:02	2026-11-17 13:52:02
01a1ec56-dd5a-730e-bee9-4a5765d52151	test	$2y$12$UtcL9zRE3zX17HWBeeGK1OKnmHMJe6z3OgkrCnvk3LLYOT.7P/GXy	customer	t	2026-11-18 01:47:58	2026-11-18 01:47:58
01a1ec57-b962-7420-8742-68b50c43ca97	Usaha	$2y$12$WvbjVDsWCmRB2nEo.y8HL.6jGKOoDEqSEFtKJ75EjAlK1R6XnZg3W	merchant	t	2026-11-18 01:48:54	2026-11-18 01:48:54
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: katering_app
--

SELECT pg_catalog.setval('public.migrations_id_seq', 26, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: katering_app
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_unique UNIQUE (slug);


--
-- Name: invoices invoices_invoice_number_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_unique UNIQUE (invoice_number);


--
-- Name: invoices invoices_order_id_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_unique UNIQUE (order_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: menus menus_merchant_profile_id_slug_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_merchant_profile_id_slug_unique UNIQUE (merchant_profile_id, slug);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_unique UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: profiles profiles_email_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_email_unique UNIQUE (email);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_unique UNIQUE (user_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: categories_is_active_sort_order_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX categories_is_active_sort_order_index ON public.categories USING btree (is_active, sort_order);


--
-- Name: categories_merchant_profile_id_is_active_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX categories_merchant_profile_id_is_active_index ON public.categories USING btree (merchant_profile_id, is_active);


--
-- Name: invoices_status_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX invoices_status_index ON public.invoices USING btree (status);


--
-- Name: menus_category_id_is_available_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX menus_category_id_is_available_index ON public.menus USING btree (category_id, is_available);


--
-- Name: menus_merchant_profile_id_is_available_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX menus_merchant_profile_id_is_available_index ON public.menus USING btree (merchant_profile_id, is_available);


--
-- Name: order_items_menu_id_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX order_items_menu_id_index ON public.order_items USING btree (menu_id);


--
-- Name: orders_customer_profile_id_status_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX orders_customer_profile_id_status_index ON public.orders USING btree (customer_profile_id, status);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: users_role_index; Type: INDEX; Schema: public; Owner: katering_app
--

CREATE INDEX users_role_index ON public.users USING btree (role);


--
-- Name: categories categories_merchant_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_merchant_profile_id_foreign FOREIGN KEY (merchant_profile_id) REFERENCES public.profiles(id) ON DELETE RESTRICT;


--
-- Name: invoices invoices_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE RESTRICT;


--
-- Name: menus menus_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: menus menus_merchant_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_merchant_profile_id_foreign FOREIGN KEY (merchant_profile_id) REFERENCES public.profiles(id) ON DELETE RESTRICT;


--
-- Name: order_items order_items_menu_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_id_foreign FOREIGN KEY (menu_id) REFERENCES public.menus(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_customer_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_profile_id_foreign FOREIGN KEY (customer_profile_id) REFERENCES public.profiles(id) ON DELETE RESTRICT;


--
-- Name: orders orders_merchant_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_merchant_profile_id_foreign FOREIGN KEY (merchant_profile_id) REFERENCES public.profiles(id) ON DELETE RESTRICT;


--
-- Name: profiles profiles_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: katering_app
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict WWgUXZF5eecbMC2dSVVmSd5I84ErN5nvf8xmir35EGqsyqO4Rt3fAHmvpRAuXx3

