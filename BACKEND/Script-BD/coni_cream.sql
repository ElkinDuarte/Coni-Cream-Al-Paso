--
-- PostgreSQL database dump
--

\restrict pS6dQGyzAL1hjfVchNzCI0aBxh6tScSwhh8JU6FCgCeI5ltthxum8CeoWisqXNE

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-18 19:12:56

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
-- TOC entry 6 (class 2615 OID 32768)
-- Name: privado; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA privado;


ALTER SCHEMA privado OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 32769)
-- Name: TMCategoria_productos; Type: TABLE; Schema: privado; Owner: postgres
--

CREATE TABLE privado."TMCategoria_productos" (
    cod_categoria integer NOT NULL,
    descripcion character varying(20) NOT NULL
);


ALTER TABLE privado."TMCategoria_productos" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 32774)
-- Name: TMCategoria_productos_cod_categoria_seq; Type: SEQUENCE; Schema: privado; Owner: postgres
--

CREATE SEQUENCE privado."TMCategoria_productos_cod_categoria_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE privado."TMCategoria_productos_cod_categoria_seq" OWNER TO postgres;

--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 221
-- Name: TMCategoria_productos_cod_categoria_seq; Type: SEQUENCE OWNED BY; Schema: privado; Owner: postgres
--

ALTER SEQUENCE privado."TMCategoria_productos_cod_categoria_seq" OWNED BY privado."TMCategoria_productos".cod_categoria;


--
-- TOC entry 222 (class 1259 OID 32775)
-- Name: TMComerciantes; Type: TABLE; Schema: privado; Owner: postgres
--

CREATE TABLE privado."TMComerciantes" (
    numero_documento character varying(11) NOT NULL,
    nombre character varying(30) NOT NULL,
    clave character varying(30) CONSTRAINT "TMComerciantes_password_not_null" NOT NULL,
    rol_comerciante integer DEFAULT 2 NOT NULL,
    cods integer DEFAULT 1 NOT NULL,
    primer_apellido character varying(30)
);


ALTER TABLE privado."TMComerciantes" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 32785)
-- Name: TMProductos; Type: TABLE; Schema: privado; Owner: postgres
--

CREATE TABLE privado."TMProductos" (
    cod_marca character varying(15) NOT NULL,
    marca character varying(50) NOT NULL,
    nombre character varying(20),
    cantidad_disponible bigint NOT NULL,
    precio bigint CONSTRAINT "TMProductos_precio_unitario_not_null" NOT NULL,
    cods integer DEFAULT 1,
    categoria integer DEFAULT 0
);


ALTER TABLE privado."TMProductos" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 32794)
-- Name: TMRoles; Type: TABLE; Schema: privado; Owner: postgres
--

CREATE TABLE privado."TMRoles" (
    cod_rol integer CONSTRAINT "TMRoles_codRol_not_null" NOT NULL,
    rol character varying(30) NOT NULL
);


ALTER TABLE privado."TMRoles" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 32799)
-- Name: TMRoles_codRol_seq; Type: SEQUENCE; Schema: privado; Owner: postgres
--

CREATE SEQUENCE privado."TMRoles_codRol_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE privado."TMRoles_codRol_seq" OWNER TO postgres;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 225
-- Name: TMRoles_codRol_seq; Type: SEQUENCE OWNED BY; Schema: privado; Owner: postgres
--

ALTER SEQUENCE privado."TMRoles_codRol_seq" OWNED BY privado."TMRoles".cod_rol;


--
-- TOC entry 226 (class 1259 OID 32800)
-- Name: TMStatus; Type: TABLE; Schema: privado; Owner: postgres
--

CREATE TABLE privado."TMStatus" (
    cod_status integer CONSTRAINT "TMStatus_codStatus_not_null" NOT NULL,
    descripcion character varying(30) NOT NULL
);


ALTER TABLE privado."TMStatus" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 32805)
-- Name: TDDPedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TDDPedidos" (
    cod_lista integer NOT NULL,
    cod_pedido integer NOT NULL,
    cod_marca character varying(20) NOT NULL,
    cantidad_cargue integer DEFAULT 0 NOT NULL,
    cantidad_devuelta integer DEFAULT 0,
    cods integer DEFAULT 1,
    precio_unitario bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public."TDDPedidos" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 32817)
-- Name: TDPedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TDPedidos" (
    cod_pedido integer NOT NULL,
    comerciante character varying NOT NULL,
    fecha_pedido date NOT NULL,
    total_venta bigint DEFAULT 0,
    cods integer DEFAULT 1
);


ALTER TABLE public."TDPedidos" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 32827)
-- Name: TMSobrante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TMSobrante" (
    cod_sobrante integer NOT NULL,
    numero_documento character varying(11) NOT NULL,
    cod_marca character varying(20) NOT NULL,
    cantidad_devolucion integer NOT NULL,
    ultima_actualizacion date,
    cods integer DEFAULT 1
);


ALTER TABLE public."TMSobrante" OWNER TO postgres;

--
-- TOC entry 4785 (class 2604 OID 32835)
-- Name: TMCategoria_productos cod_categoria; Type: DEFAULT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMCategoria_productos" ALTER COLUMN cod_categoria SET DEFAULT nextval('privado."TMCategoria_productos_cod_categoria_seq"'::regclass);


--
-- TOC entry 4972 (class 0 OID 32769)
-- Dependencies: 220
-- Data for Name: TMCategoria_productos; Type: TABLE DATA; Schema: privado; Owner: postgres
--

COPY privado."TMCategoria_productos" (cod_categoria, descripcion) FROM stdin;
1	Paletas
2	Conos
3	Postres
0	sin categoria
\.


--
-- TOC entry 4974 (class 0 OID 32775)
-- Dependencies: 222
-- Data for Name: TMComerciantes; Type: TABLE DATA; Schema: privado; Owner: postgres
--

COPY privado."TMComerciantes" (numero_documento, nombre, clave, rol_comerciante, cods, primer_apellido) FROM stdin;
13198438	Agustin	ag123	2	1	\N
6466314	Henry	he123	2	1	\N
1094165032	Milton	ml123	2	1	\N
\.


--
-- TOC entry 4975 (class 0 OID 32785)
-- Dependencies: 223
-- Data for Name: TMProductos; Type: TABLE DATA; Schema: privado; Owner: postgres
--

COPY privado."TMProductos" (cod_marca, marca, nombre, cantidad_disponible, precio, cods, categoria) FROM stdin;
0160107	Conos Chococono	Conos	22	3500	1	2
0161105	Paletas Aloha Canal Movil	Paleta Agua	10	1600	1	1
0161116	Paletas Hobby	Paleta Crema	35	1600	1	1
0161193	Paletas Helado Artesanal	Artesanal	25	3200	1	3
\.


--
-- TOC entry 4976 (class 0 OID 32794)
-- Dependencies: 224
-- Data for Name: TMRoles; Type: TABLE DATA; Schema: privado; Owner: postgres
--

COPY privado."TMRoles" (cod_rol, rol) FROM stdin;
1	Administrador
2	Comerciante
\.


--
-- TOC entry 4978 (class 0 OID 32800)
-- Dependencies: 226
-- Data for Name: TMStatus; Type: TABLE DATA; Schema: privado; Owner: postgres
--

COPY privado."TMStatus" (cod_status, descripcion) FROM stdin;
0	Inactivo
1	Activo
2	Vendiendo
3	Finalizado
\.


--
-- TOC entry 4979 (class 0 OID 32805)
-- Dependencies: 227
-- Data for Name: TDDPedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TDDPedidos" (cod_lista, cod_pedido, cod_marca, cantidad_cargue, cantidad_devuelta, cods, precio_unitario) FROM stdin;
11	1	0161105	15	5	1	1600
12	1	0160107	8	2	1	3500
13	1	0161116	15	3	1	1600
14	2	0161105	10	0	1	1600
16	2	0161116	10	4	1	1600
15	2	0161193	5	1	1	3200
17	3	0161105	25	8	1	1600
18	3	0160107	10	3	1	3500
\.


--
-- TOC entry 4980 (class 0 OID 32817)
-- Dependencies: 228
-- Data for Name: TDPedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TDPedidos" (cod_pedido, comerciante, fecha_pedido, total_venta, cods) FROM stdin;
1	13198438	2026-03-24	56200	3
2	6466314	2026-03-24	38400	3
3	1094165032	2026-03-24	51700	3
\.


--
-- TOC entry 4981 (class 0 OID 32827)
-- Dependencies: 229
-- Data for Name: TMSobrante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TMSobrante" (cod_sobrante, numero_documento, cod_marca, cantidad_devolucion, ultima_actualizacion, cods) FROM stdin;
1	13198438	0161105	5	2026-03-24	1
2	13198438	0160107	2	2026-03-24	1
3	13198438	0161116	3	2026-03-24	1
4	6466314	0161116	4	2026-03-24	1
5	6466314	0161193	1	2026-03-24	1
6	1094165032	0161105	8	2026-03-24	1
7	1094165032	0160107	3	2026-03-24	1
\.


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 221
-- Name: TMCategoria_productos_cod_categoria_seq; Type: SEQUENCE SET; Schema: privado; Owner: postgres
--

SELECT pg_catalog.setval('privado."TMCategoria_productos_cod_categoria_seq"', 1, false);


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 225
-- Name: TMRoles_codRol_seq; Type: SEQUENCE SET; Schema: privado; Owner: postgres
--

SELECT pg_catalog.setval('privado."TMRoles_codRol_seq"', 1, false);


--
-- TOC entry 4798 (class 2606 OID 32837)
-- Name: TMCategoria_productos TMCategoria_productos_pkey; Type: CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMCategoria_productos"
    ADD CONSTRAINT "TMCategoria_productos_pkey" PRIMARY KEY (cod_categoria);


--
-- TOC entry 4800 (class 2606 OID 32839)
-- Name: TMComerciantes TMComerciantes_pkey; Type: CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMComerciantes"
    ADD CONSTRAINT "TMComerciantes_pkey" PRIMARY KEY (numero_documento);


--
-- TOC entry 4802 (class 2606 OID 32841)
-- Name: TMProductos TMProductos_pkey; Type: CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMProductos"
    ADD CONSTRAINT "TMProductos_pkey" PRIMARY KEY (cod_marca);


--
-- TOC entry 4804 (class 2606 OID 32843)
-- Name: TMRoles TMRoles_pkey; Type: CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMRoles"
    ADD CONSTRAINT "TMRoles_pkey" PRIMARY KEY (cod_rol);


--
-- TOC entry 4806 (class 2606 OID 32845)
-- Name: TMStatus TMStatus_pkey; Type: CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMStatus"
    ADD CONSTRAINT "TMStatus_pkey" PRIMARY KEY (cod_status);


--
-- TOC entry 4808 (class 2606 OID 32847)
-- Name: TDDPedidos TDDPedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDDPedidos"
    ADD CONSTRAINT "TDDPedidos_pkey" PRIMARY KEY (cod_lista);


--
-- TOC entry 4810 (class 2606 OID 32849)
-- Name: TDPedidos TDPedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDPedidos"
    ADD CONSTRAINT "TDPedidos_pkey" PRIMARY KEY (cod_pedido);


--
-- TOC entry 4812 (class 2606 OID 32851)
-- Name: TMSobrante TMSobrante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TMSobrante"
    ADD CONSTRAINT "TMSobrante_pkey" PRIMARY KEY (cod_sobrante);


--
-- TOC entry 4815 (class 2606 OID 32852)
-- Name: TMProductos categoria; Type: FK CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMProductos"
    ADD CONSTRAINT categoria FOREIGN KEY (categoria) REFERENCES privado."TMCategoria_productos"(cod_categoria) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4813 (class 2606 OID 32857)
-- Name: TMComerciantes cods; Type: FK CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMComerciantes"
    ADD CONSTRAINT cods FOREIGN KEY (cods) REFERENCES privado."TMStatus"(cod_status) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4816 (class 2606 OID 32862)
-- Name: TMProductos cods; Type: FK CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMProductos"
    ADD CONSTRAINT cods FOREIGN KEY (cods) REFERENCES privado."TMStatus"(cod_status) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4814 (class 2606 OID 32867)
-- Name: TMComerciantes rol_comerciante; Type: FK CONSTRAINT; Schema: privado; Owner: postgres
--

ALTER TABLE ONLY privado."TMComerciantes"
    ADD CONSTRAINT rol_comerciante FOREIGN KEY (rol_comerciante) REFERENCES privado."TMRoles"(cod_rol) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4817 (class 2606 OID 32872)
-- Name: TDDPedidos cod_marca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDDPedidos"
    ADD CONSTRAINT cod_marca FOREIGN KEY (cod_marca) REFERENCES privado."TMProductos"(cod_marca) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4822 (class 2606 OID 32877)
-- Name: TMSobrante cod_marca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TMSobrante"
    ADD CONSTRAINT cod_marca FOREIGN KEY (cod_marca) REFERENCES privado."TMProductos"(cod_marca) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4818 (class 2606 OID 32882)
-- Name: TDDPedidos cod_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDDPedidos"
    ADD CONSTRAINT cod_pedido FOREIGN KEY (cod_pedido) REFERENCES public."TDPedidos"(cod_pedido) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4819 (class 2606 OID 32887)
-- Name: TDDPedidos cods; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDDPedidos"
    ADD CONSTRAINT cods FOREIGN KEY (cods) REFERENCES privado."TMStatus"(cod_status) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4820 (class 2606 OID 32892)
-- Name: TDPedidos cods; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDPedidos"
    ADD CONSTRAINT cods FOREIGN KEY (cods) REFERENCES privado."TMStatus"(cod_status) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4823 (class 2606 OID 32897)
-- Name: TMSobrante cods; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TMSobrante"
    ADD CONSTRAINT cods FOREIGN KEY (cods) REFERENCES privado."TMStatus"(cod_status) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4821 (class 2606 OID 32902)
-- Name: TDPedidos comerciante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TDPedidos"
    ADD CONSTRAINT comerciante FOREIGN KEY (comerciante) REFERENCES privado."TMComerciantes"(numero_documento) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4824 (class 2606 OID 32907)
-- Name: TMSobrante numero_documento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TMSobrante"
    ADD CONSTRAINT numero_documento FOREIGN KEY (numero_documento) REFERENCES privado."TMComerciantes"(numero_documento) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


-- Completed on 2026-05-18 19:12:57

--
-- PostgreSQL database dump complete
--

\unrestrict pS6dQGyzAL1hjfVchNzCI0aBxh6tScSwhh8JU6FCgCeI5ltthxum8CeoWisqXNE

