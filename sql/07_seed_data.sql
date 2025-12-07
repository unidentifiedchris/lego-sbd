-- Seed data
DECLARE
    v_id_pais_sa      NUMBER;
    v_id_pais_ph      NUMBER;
    v_id_pais_ie      NUMBER;
    v_id_pais_cl      NUMBER;
    v_id_pais_id      NUMBER;
    v_id_pais_kr      NUMBER;

    v_id_cliente_1    NUMBER;
    v_id_cliente_2    NUMBER;
    v_id_cliente_3    NUMBER;
    v_id_cliente_4    NUMBER;
    v_id_cliente_5    NUMBER;
    v_id_cliente_6    NUMBER;
    v_id_cliente_7    NUMBER;
    v_id_cliente_8    NUMBER;
    v_id_cliente_9    NUMBER;
    v_id_cliente_10   NUMBER;

    v_id_fan_1        NUMBER;
    v_id_fan_2        NUMBER;
    v_id_fan_3        NUMBER;
    v_id_fan_4        NUMBER;
    v_id_fan_5        NUMBER;
    v_id_fan_6        NUMBER;
    v_id_fan_7        NUMBER;
    v_id_fan_8        NUMBER;
    v_id_fan_9        NUMBER;
    v_id_fan_10       NUMBER;

    v_num_inscripcion NUMBER;
    v_num_entrada     NUMBER;
    v_precio_tour     NUMBER;
    v_inscrito_id     NUMBER;
BEGIN
    pkg_lego_inserts_t.SP_INSERT_PAIS('Sudafrica', 'Sudafricana', 'AFRICA', 0, v_id_pais_sa);
    pkg_lego_inserts_t.SP_INSERT_PAIS('Filipinas', 'Filipina', 'ASIA', 0, v_id_pais_ph);
    pkg_lego_inserts_t.SP_INSERT_PAIS('Irlanda', 'Irlandesa', 'EUROPA', 1, v_id_pais_ie);
    pkg_lego_inserts_t.SP_INSERT_PAIS('Chile', 'Chilena', 'AMERICA', 0, v_id_pais_cl);
    pkg_lego_inserts_t.SP_INSERT_PAIS('Indonesia', 'Indonesa', 'ASIA', 0, v_id_pais_id);
    pkg_lego_inserts_t.SP_INSERT_PAIS('Corea del Sur', 'Surcoreana', 'ASIA', 0, v_id_pais_kr);
    COMMIT;

    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-10', 25.00, 25);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-15', 25.00, 25);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-01', 30.50, 30);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-05', 30.50, 30);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-08', 30.50, 30);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-10', 35.00, 20);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-20', 35.00, 20);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-04-01', 35.00, 20);
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-04-05', 35.00, 20);
    COMMIT;

    pkg_lego_inserts_t.SP_INSERT_CLIENTE('JUAN', 'SOTO', 'MUNOZ', DATE '1990-05-15', 'DOC-CH-001', '+98 7654321', v_id_pais_cl, v_id_pais_cl, 'CARLOS', 'PASS-001', DATE '2030-05-15', 'juan.soto@email.com', v_id_cliente_1);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SIOBHAN', 'O-CONNOR', 'SMITH', DATE '1988-11-20', 'DOC-IR-022', '+44 5566778', v_id_pais_ie, v_id_pais_ie, NULL, 'PASS-002', DATE '2029-11-20', 'siobhan.oc@email.com', v_id_cliente_2);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('BUDI', 'SANTOSO', 'PUTRA', DATE '1995-02-10', 'DOC-IN-033', '+11 2233445', v_id_pais_id, v_id_pais_kr, 'DARMA', 'PASS-003', DATE '2028-02-10', 'budi.santoso@email.com', v_id_cliente_3);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('THABO', 'MOLEFE', 'ZULU', DATE '1982-07-30', 'DOC-SA-044', '+99 8877665', v_id_pais_sa, v_id_pais_ph, NULL, 'PASS-004', DATE '2027-07-30', 'thabo.mz@email.com', v_id_cliente_4);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('MARIA', 'SANTOS', 'REYES', DATE '2000-12-05', 'DOC-PH-055', '+66 7788990', v_id_pais_ph, v_id_pais_ie, 'ISABEL', 'PASS-005', DATE '2032-12-05', 'maria.reyes@email.com', v_id_cliente_5);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('JABULANI', 'DLAMINI', 'NKOSI', DATE '1975-03-25', 'DOC-SA-066', '+27 821234567', v_id_pais_sa, v_id_pais_sa, NULL, 'PASS-006', DATE '2028-08-15', 'jabulani.d@email.com', v_id_cliente_6);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SEAN', 'MURPHY', 'KELLY', DATE '1992-08-12', 'DOC-IR-077', '+56 987654321', v_id_pais_ie, v_id_pais_cl, 'PATRICK', 'PASS-007', DATE '2031-01-20', 'sean.murphy@email.com', v_id_cliente_7);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SOO-JIN', 'PARK', 'CHOI', DATE '1980-11-30', 'DOC-KR-088', '+82 1098765432', v_id_pais_kr, v_id_pais_kr, NULL, 'PASS-008', DATE '2026-11-30', 'soojin.park@email.com', v_id_cliente_8);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('AGUNG', 'WIDODO', 'HIDAYAT', DATE '1989-01-18', 'DOC-IN-099', '+62 8123456789', v_id_pais_id, v_id_pais_id, 'DEWI', 'PASS-009', DATE '2029-05-22', 'agung.w@email.com', v_id_cliente_9);
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('CAMILA', 'ROJAS', 'VERGARA', DATE '1998-07-07', 'DOC-CL-101', '+353 876543210', v_id_pais_cl, v_id_pais_ie, NULL, 'PASS-010', DATE '2033-07-07', 'camila.rojas@email.com', v_id_cliente_10);
    COMMIT;

    pkg_lego_inserts_t.SP_INSERT_FAN('TOMAS', 'SOTO', 'DIAZ', v_id_pais_cl, DATE '2015-06-01', 'DOC-FAN-CH-1', NULL, v_id_cliente_1, 'PASS-FAN-01', DATE '2028-03-15', v_id_fan_1);
    pkg_lego_inserts_t.SP_INSERT_FAN('CIARA', 'O-CONNOR', 'WALSH', v_id_pais_ie, DATE '2006-03-15', 'DOC-FAN-IR-2', NULL, v_id_cliente_2, 'PASS-FAN-02', DATE '2028-03-15', v_id_fan_2);
    pkg_lego_inserts_t.SP_INSERT_FAN('SARI', 'SANTOS', 'KUSUMA', v_id_pais_id, DATE '2018-09-09', 'DOC-FAN-IN-3', NULL, v_id_cliente_3, 'PASS-FAN-03', DATE '2028-03-15', v_id_fan_3);
    pkg_lego_inserts_t.SP_INSERT_FAN('LEO', 'MOLEFE', 'KHUMALO', v_id_pais_sa, DATE '2009-11-20', 'DOC-FAN-SA-4', NULL, v_id_cliente_4, 'PASS-FAN-04', DATE '2029-11-20', v_id_fan_4);
    pkg_lego_inserts_t.SP_INSERT_FAN('MIN-JI', 'KIM', 'LEE', v_id_pais_kr, DATE '2005-06-15', 'DOC-FAN-KR-5', NULL, NULL, 'PASS-FAN-05', DATE '2035-06-15', v_id_fan_5);
    pkg_lego_inserts_t.SP_INSERT_FAN('AMARA', 'DLAMINI', 'SITHOLE', v_id_pais_sa, DATE '2020-02-20', 'DOC-FAN-SA-6', NULL, v_id_cliente_6, 'PASS-FAN-06', DATE '2030-02-20', v_id_fan_6);
    pkg_lego_inserts_t.SP_INSERT_FAN('AOIFE', 'MURPHY', 'BYRNE', v_id_pais_ie, DATE '2006-09-01', 'DOC-FAN-IR-7', NULL, v_id_cliente_7, 'PASS-FAN-07', DATE '2029-09-01', v_id_fan_7);
    pkg_lego_inserts_t.SP_INSERT_FAN('JI-HOO', 'PARK', 'KANG', v_id_pais_kr, DATE '2013-04-10', 'DOC-FAN-KR-8', NULL, v_id_cliente_8, 'PASS-FAN-08', DATE '2028-04-10', v_id_fan_8);
    pkg_lego_inserts_t.SP_INSERT_FAN('RATNA', 'WIDODO', 'LESTARI', v_id_pais_id, DATE '2008-12-24', 'DOC-FAN-IN-9', NULL, v_id_cliente_9, 'PASS-FAN-09', DATE '2027-12-24', v_id_fan_9);
    pkg_lego_inserts_t.SP_INSERT_FAN('MATEO', 'ROJAS', 'SILVA', v_id_pais_cl, DATE '2005-11-11', 'DOC-FAN-CL-10', NULL, NULL, 'PASS-FAN-10', DATE '2034-11-11', v_id_fan_10);
    COMMIT;

    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRIPCION_FECHA_INICIO DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRITO_FECHA_INICIO DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_ENTRADA_FECHA_INICIO DISABLE';

    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2024-01-10', DATE '2023-12-01', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-10', v_num_inscripcion, NULL, v_id_cliente_1, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-10', v_num_inscripcion, v_id_fan_1, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2024-01-10';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2024-01-10' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-10', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-10', v_num_inscripcion, 'MENOR', v_num_entrada);

    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2024-01-15', DATE '2023-12-10', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, NULL, v_id_cliente_2, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, NULL, v_id_cliente_5, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, v_id_fan_2, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2024-01-15';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 3) WHERE F_INICIO = DATE '2024-01-15' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'MENOR', v_num_entrada);

    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-01', DATE '2025-04-01', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-01', v_num_inscripcion, NULL, v_id_cliente_3, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-01', v_num_inscripcion, v_id_fan_3, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-01';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2025-05-01' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-01', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-01', v_num_inscripcion, 'MENOR', v_num_entrada);

    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-05', DATE '2025-04-15', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-05', v_num_inscripcion, NULL, v_id_cliente_4, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-05', v_num_inscripcion, v_id_fan_4, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-05';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2025-05-05' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-05', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-05', v_num_inscripcion, 'MENOR', v_num_entrada);

    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-08', DATE '2025-04-20', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-08', v_num_inscripcion, v_id_fan_5, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-08';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 1) WHERE F_INICIO = DATE '2025-05-08' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-08', v_num_inscripcion, 'MENOR', v_num_entrada);

    COMMIT;

    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRIPCION_FECHA_INICIO ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRITO_FECHA_INICIO ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_ENTRADA_FECHA_INICIO ENABLE';
END;
/

-- ESTADOS
INSERT ALL
    INTO ESTADOS VALUES (1, 1, 'Provincia de Gauteng')
    INTO ESTADOS VALUES (2, 2, 'Metro Manila')
    INTO ESTADOS VALUES (3, 3, 'Condado de Dublín')
    INTO ESTADOS VALUES (4, 4, 'Región del Biobío')
    INTO ESTADOS VALUES (4, 5, 'Región Metropolitana')
    INTO ESTADOS VALUES (5, 6, 'Java Oriental')
    INTO ESTADOS VALUES (5, 7, 'Banten')
    INTO ESTADOS VALUES (6, 8, 'Gyeonggi-do')
SELECT * FROM DUAL;
COMMIT;

-- CIUDADES
INSERT ALL
    INTO CIUDADES VALUES (1, 1, 1, 'Sandton')
    INTO CIUDADES VALUES (2, 2, 2, 'Quezon City')
    INTO CIUDADES VALUES (3, 3, 3, 'Dublín')
    INTO CIUDADES VALUES (4, 4, 4, 'Talcahuano')
    INTO CIUDADES VALUES (4, 5, 5, 'Santiago de Chile')
    INTO CIUDADES VALUES (5, 6, 6, 'Surabaya')
    INTO CIUDADES VALUES (5, 7, 7, 'Kabupaten Tangerang')
    INTO CIUDADES VALUES (6, 8, 8, 'Suwon')
SELECT * FROM DUAL;
COMMIT;

-- TIENDAS
INSERT ALL
    INTO TIENDAS VALUES (1, 1, 1, 1, 'LEGO Store Sandton City', 'Unit 51C Sandton City, Rivonia Rd / 5th St', '+27 116 621777')
    INTO TIENDAS VALUES (2, 2, 2, 2, 'LEGO Store Certified BGC', 'Unit 1034 Level 1 Trinoma Mall, EDSA cor North Avenue', '+63 279 152206')
    INTO TIENDAS VALUES (3, 3, 3, 3, 'LEGO Store Dublin - Grafton St.', '41 Grafton Street', '+353 161 78497')
    INTO TIENDAS VALUES (4, 4, 4, 4, 'LEGO Store El Trébol', 'Av. Pdte. Jorge Alessandri Rodriguez 3177', '+56 412 788847')
    INTO TIENDAS VALUES (5, 4, 5, 5, 'LEGO Store Vespucio', 'Av. Vicuña Mackenna Ote. 7110', '+56 226 569672')
    INTO TIENDAS VALUES (6, 5, 6, 6, 'LEGO Store Ciputra World Surabaya', 'Level 1, 117-119 Ciputra World Surabaya Jl. Mayjen Sungkono No.89. Gunung Sari. Dukuh Pakis, Surabaya East Java', '+62 316 0801017')
    INTO TIENDAS VALUES (7, 5, 7, 7, 'LEGO Store LCS Aeon BSD Mall', 'Jl. BSD Raya Utama, Pagedangan. FF 1-08. Kec. Pagedangan Kabupaten Tangerang Banten 15345', '+62 215 5691506')
    INTO TIENDAS VALUES (8, 6, 8, 8, 'LEGO Store Suwon', 'LEGO store, 3F, 134, Sehwa-ro, Gwonseon-gu, Suwon-si', '+82 157 70001')
SELECT * FROM DUAL;
COMMIT;

-- HORARIOS
INSERT ALL 
    INTO HORARIOS VALUES (1, 2, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 3, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 4, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 5, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 6, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 7, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (1, 1, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('18:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 2, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 4, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 5, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 6, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 7, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (2, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 2, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 3, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 4, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 5, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 6, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 7, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (3, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('19:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 2, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 4, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 5, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 6, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 7, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (4, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('20:30:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 2, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 4, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 5, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 6, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 7, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (5, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 2, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 4, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 5, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 6, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 7, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (6, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 2, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 4, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 5, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 6, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 7, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (7, 1, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 2, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 3, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 4, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 5, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 6, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 7, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
    INTO HORARIOS VALUES (8, 1, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'))
SELECT * FROM DUAL;
COMMIT;
