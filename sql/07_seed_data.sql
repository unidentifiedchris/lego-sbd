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

INSERT INTO TEMAS (ID_TEMA, NOMBRE_TEMA, DESCRIPCION_TEMA, TIPO_TEMA, LICENCIA_EXTERNA)
VALUES (1, 'LEGO Bluey',
        'Sets basados en la serie animada Bluey.',
        'SERIE', 1);

INSERT INTO TEMAS (ID_TEMA, NOMBRE_TEMA, DESCRIPCION_TEMA, TIPO_TEMA, LICENCIA_EXTERNA)
VALUES (2, 'LEGO City',
        'Ciudad LEGO con vehículos y escenas urbanas.',
        'TEMA', 0);

INSERT INTO TEMAS (ID_TEMA, NOMBRE_TEMA, DESCRIPCION_TEMA, TIPO_TEMA, LICENCIA_EXTERNA)
VALUES (3, 'LEGO Creator 3in1',
        'Modelos 3 en 1 que se pueden reconstruir en diferentes diseños.',
        'TEMA', 0);

INSERT INTO TEMAS (ID_TEMA, NOMBRE_TEMA, DESCRIPCION_TEMA, TIPO_TEMA, LICENCIA_EXTERNA)
VALUES (4, 'LEGO Avatar',
        'Sets basados en las películas de Avatar de James Cameron.',
        'SERIE', 1);


------------------------------------------------------------
-- 6. JUGUETES
--   ES_SET: 1 = set principal
--   RANGO_PRECIO: 'A','B','C','D' (aquí asignado arbitrariamente)
--   NUMERO_PIEZAS y RANGO_EDAD son valores de ejemplo.
--   ARCHIVO_INSTRUCCIONES: se usa la URL del producto.
------------------------------------------------------------

--------------------------
-- Tema 1: LEGO Bluey (ID_TEMA = 1)
--------------------------
INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    11203,
    1,
    'Bluey''s Family House (11203)',
    '4+',
    150,
    1,
    'https://www.lego.com/en-us/product/blueys-family-house-11203',
    'B',
    'Casa de la familia de Bluey con varias habitaciones y figuras.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    11201,
    1,
    'Playground Fun with Bluey and Chloe (11201)',
    '4+',
    80,
    1,
    'https://www.lego.com/en-us/product/playground-fun-with-bluey-and-chloe-11201',
    'A',
    'Parque infantil con Bluey, Chloe y accesorios de juego.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    11202,
    1,
    'Bluey''s Beach & Family Car Trip (11202)',
    '4+',
    120,
    1,
    'https://www.lego.com/en-us/product/blueys-beach-family-car-trip-11202',
    'B',
    'Viaje familiar de Bluey a la playa con carro y accesorios.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    10458,
    1,
    'Ice Cream Trip with Bluey (10458)',
    '2+',
    40,
    1,
    'https://www.lego.com/en-us/product/ice-cream-trip-with-bluey-10458',
    'A',
    'Set sencillo de viaje por helado con Bluey, ideal para peques.'
);


--------------------------
-- Tema 2: LEGO City (ID_TEMA = 2)
--------------------------
INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    60466,
    2,
    'Yellow Bulldozer (60466)',
    '6+',
    150,
    1,
    'https://www.lego.com/en-us/product/yellow-bulldozer-60466',
    'B',
    'Bulldozer amarillo de construcción con minifiguras y accesorios.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    60456,
    2,
    'Police Boat Chase (60456)',
    '6+',
    200,
    1,
    'https://www.lego.com/en-us/product/police-boat-chase-60456',
    'B',
    'Persecución policial en bote con lanchas y minifiguras.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    60465,
    2,
    'Emergency Air Ambulance Airplane (60465)',
    '7+',
    250,
    1,
    'https://www.lego.com/en-us/product/emergency-air-ambulance-airplane-60465',
    'C',
    'Avión ambulancia de emergencia con equipo médico y tripulación.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    60367,
    2,
    'Passenger Airplane (60367)',
    '7+',
    300,
    1,
    'https://www.lego.com/en-us/product/passenger-airplane-60367',
    'C',
    'Avión de pasajeros de LEGO City con terminal y minifiguras.'
);


--------------------------
-- Tema 3: LEGO Creator 3in1 (ID_TEMA = 3)
--------------------------
INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    31109,
    3,
    'Pirate Ship (31109)',
    '9+',
    1200,
    1,
    'https://www.lego.com/en-us/product/pirate-ship-31109',
    'D',
    'Barco pirata Creator 3en1 que se puede reconstruir en otros modelos.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    31154,
    3,
    'Forest Animals: Red Fox (31154)',
    '9+',
    600,
    1,
    'https://www.lego.com/en-us/product/forest-animals-red-fox-31154',
    'C',
    'Zorro rojo y otros animales del bosque en un set 3en1.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    31142,
    3,
    'Space Roller Coaster (31142)',
    '9+',
    900,
    1,
    'https://www.lego.com/en-us/product/space-roller-coaster-31142',
    'D',
    'Montaña rusa espacial 3en1 con vagones y decoración temática.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    31173,
    3,
    'Wild Animals: Tropical Toucan (31173)',
    '7+',
    250,
    1,
    'https://www.lego.com/en-us/product/wild-animals-tropical-toucan-31173',
    'B',
    'Tucán tropical y otros animales salvajes en formato 3en1.'
);


--------------------------
-- Tema 4: LEGO Avatar (ID_TEMA = 4)
--------------------------
INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    75571,
    4,
    'Neytiri & Thanator vs. AMP Suit Quaritch (75571)',
    '9+',
    800,
    1,
    'https://www.lego.com/en-us/product/neytiri-thanator-vs-amp-suit-quaritch-75571',
    'C',
    'Batalla entre Neytiri en su Thanator y el AMP Suit de Quaritch.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    75572,
    4,
    'Jake & Neytiri''s First Banshee Flight (75572)',
    '9+',
    750,
    1,
    'https://www.lego.com/en-us/product/jake-neytiris-first-banshee-flight-75572',
    'C',
    'Primer vuelo de Jake y Neytiri sobre los banshees de Pandora.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    75573,
    4,
    'Floating Mountains: Site 26 & RDA Samson (75573)',
    '10+',
    950,
    1,
    'https://www.lego.com/en-us/product/floating-mountains-site-26-rda-samson-75573',
    'D',
    'Montañas flotantes de Pandora, sitio 26 y helicóptero RDA Samson.'
);

INSERT INTO JUGUETES (
    ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE,
    RANGO_EDAD, NUMERO_PIEZAS, ES_SET,
    ARCHIVO_INSTRUCCIONES, RANGO_PRECIO, DESCRIPCION
) VALUES (
    75574,
    4,
    'Toruk Makto & Tree of Souls (75574)',
    '12+',
    1200,
    1,
    'https://www.lego.com/en-us/product/toruk-makto-tree-of-souls-75574',
    'D',
    'Escena emblemática con Toruk Makto y el Árbol de las Almas.'
);

------------------------------------------------------------
-- CATALOGO_PAIS
--  ID_PAIS, ID_JUGUETE, LIMITE_COMPRA
------------------------------------------------------------

-- Sudáfrica (10): Bluey + City
INSERT INTO CATALOGO_PAIS VALUES (10, 11203, 5);
INSERT INTO CATALOGO_PAIS VALUES (10, 11201, 5);
INSERT INTO CATALOGO_PAIS VALUES (10, 11202, 5);
INSERT INTO CATALOGO_PAIS VALUES (10, 10458, 5);
INSERT INTO CATALOGO_PAIS VALUES (10, 60466, 4);
INSERT INTO CATALOGO_PAIS VALUES (10, 60456, 4);
INSERT INTO CATALOGO_PAIS VALUES (10, 60465, 4);
INSERT INTO CATALOGO_PAIS VALUES (10, 60367, 4);

-- Filipinas (20): Bluey + Creator
INSERT INTO CATALOGO_PAIS VALUES (20, 11203, 5);
INSERT INTO CATALOGO_PAIS VALUES (20, 11201, 5);
INSERT INTO CATALOGO_PAIS VALUES (20, 11202, 5);
INSERT INTO CATALOGO_PAIS VALUES (20, 10458, 5);
INSERT INTO CATALOGO_PAIS VALUES (20, 31109, 3);
INSERT INTO CATALOGO_PAIS VALUES (20, 31154, 3);
INSERT INTO CATALOGO_PAIS VALUES (20, 31142, 3);
INSERT INTO CATALOGO_PAIS VALUES (20, 31173, 3);

-- Irlanda (30): catálogo completo (todos los sets)
-- Bluey
INSERT INTO CATALOGO_PAIS VALUES (30, 11203, 5);
INSERT INTO CATALOGO_PAIS VALUES (30, 11201, 5);
INSERT INTO CATALOGO_PAIS VALUES (30, 11202, 5);
INSERT INTO CATALOGO_PAIS VALUES (30, 10458, 5);
-- City
INSERT INTO CATALOGO_PAIS VALUES (30, 60466, 4);
INSERT INTO CATALOGO_PAIS VALUES (30, 60456, 4);
INSERT INTO CATALOGO_PAIS VALUES (30, 60465, 4);
INSERT INTO CATALOGO_PAIS VALUES (30, 60367, 4);
-- Creator 3in1
INSERT INTO CATALOGO_PAIS VALUES (30, 31109, 3);
INSERT INTO CATALOGO_PAIS VALUES (30, 31154, 3);
INSERT INTO CATALOGO_PAIS VALUES (30, 31142, 3);
INSERT INTO CATALOGO_PAIS VALUES (30, 31173, 3);
-- Avatar
INSERT INTO CATALOGO_PAIS VALUES (30, 75571, 2);
INSERT INTO CATALOGO_PAIS VALUES (30, 75572, 2);
INSERT INTO CATALOGO_PAIS VALUES (30, 75573, 2);
INSERT INTO CATALOGO_PAIS VALUES (30, 75574, 2);

-- Chile (40): City + Avatar
INSERT INTO CATALOGO_PAIS VALUES (40, 60466, 4);
INSERT INTO CATALOGO_PAIS VALUES (40, 60456, 4);
INSERT INTO CATALOGO_PAIS VALUES (40, 60465, 4);
INSERT INTO CATALOGO_PAIS VALUES (40, 60367, 4);
INSERT INTO CATALOGO_PAIS VALUES (40, 75571, 2);
INSERT INTO CATALOGO_PAIS VALUES (40, 75572, 2);
INSERT INTO CATALOGO_PAIS VALUES (40, 75573, 2);
INSERT INTO CATALOGO_PAIS VALUES (40, 75574, 2);

-- Indonesia (50): Creator + Avatar
INSERT INTO CATALOGO_PAIS VALUES (50, 31109, 3);
INSERT INTO CATALOGO_PAIS VALUES (50, 31154, 3);
INSERT INTO CATALOGO_PAIS VALUES (50, 31142, 3);
INSERT INTO CATALOGO_PAIS VALUES (50, 31173, 3);
INSERT INTO CATALOGO_PAIS VALUES (50, 75571, 2);
INSERT INTO CATALOGO_PAIS VALUES (50, 75572, 2);
INSERT INTO CATALOGO_PAIS VALUES (50, 75573, 2);
INSERT INTO CATALOGO_PAIS VALUES (50, 75574, 2);

-- Corea del Sur (60): Bluey + Avatar
INSERT INTO CATALOGO_PAIS VALUES (60, 11203, 5);
INSERT INTO CATALOGO_PAIS VALUES (60, 11201, 5);
INSERT INTO CATALOGO_PAIS VALUES (60, 11202, 5);
INSERT INTO CATALOGO_PAIS VALUES (60, 10458, 5);
INSERT INTO CATALOGO_PAIS VALUES (60, 75571, 2);
INSERT INTO CATALOGO_PAIS VALUES (60, 75572, 2);
INSERT INTO CATALOGO_PAIS VALUES (60, 75573, 2);
INSERT INTO CATALOGO_PAIS VALUES (60, 75574, 2);

------------------------------------------------------------
-- HISTORICO_PRECIO
--  Un registro vigente por JUGUETE (FECHA_FIN NULL)
------------------------------------------------------------

-- Bluey
INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (11203, DATE '2024-01-01', 59.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (11201, DATE '2024-01-01', 24.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (11202, DATE '2024-01-01', 39.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (10458, DATE '2024-01-01', 19.99, NULL);

-- City
INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (60466, DATE '2024-01-01', 34.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (60456, DATE '2024-01-01', 39.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (60465, DATE '2024-01-01', 49.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (60367, DATE '2024-01-01', 79.99, NULL);

-- Creator 3in1
INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (31109, DATE '2024-01-01', 119.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (31154, DATE '2024-01-01', 49.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (31142, DATE '2024-01-01', 109.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (31173, DATE '2024-01-01', 24.99, NULL);

-- Avatar
INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (75571, DATE '2024-01-01', 79.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (75572, DATE '2024-01-01', 79.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (75573, DATE '2024-01-01', 99.99, NULL);

INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
VALUES (75574, DATE '2024-01-01', 149.99, NULL);

------------------------------------------------------------
-- LOTES_INVENTARIO
------------------------------------------------------------

-- Tienda 100 - LEGO Store Sandton City (Sudáfrica)
INSERT INTO LOTES_INVENTARIO VALUES (1, 100, 11203, 100);
INSERT INTO LOTES_INVENTARIO VALUES (2, 100, 60466, 80);
INSERT INTO LOTES_INVENTARIO VALUES (3, 100, 31109, 60);
INSERT INTO LOTES_INVENTARIO VALUES (4, 100, 75571, 40);

-- Tienda 110 - LEGO Certified Store BGC (Filipinas)
INSERT INTO LOTES_INVENTARIO VALUES (1, 110, 11201, 90);
INSERT INTO LOTES_INVENTARIO VALUES (2, 110, 60456, 70);
INSERT INTO LOTES_INVENTARIO VALUES (3, 110, 31154, 50);
INSERT INTO LOTES_INVENTARIO VALUES (4, 110, 75572, 30);

-- Tienda 120 - LEGO Store Dublin - Grafton St. (Irlanda)
INSERT INTO LOTES_INVENTARIO VALUES (1, 120, 11202, 80);
INSERT INTO LOTES_INVENTARIO VALUES (2, 120, 60465, 60);
INSERT INTO LOTES_INVENTARIO VALUES (3, 120, 31142, 40);
INSERT INTO LOTES_INVENTARIO VALUES (4, 120, 75573, 20);

-- Tienda 130 - LEGO Store El Trébol (Chile)
INSERT INTO LOTES_INVENTARIO VALUES (1, 130, 10458, 120);
INSERT INTO LOTES_INVENTARIO VALUES (2, 130, 60367, 90);
INSERT INTO LOTES_INVENTARIO VALUES (3, 130, 31173, 70);
INSERT INTO LOTES_INVENTARIO VALUES (4, 130, 75574, 50);

-- Tienda 131 - LEGO Store Vespucio (Chile)
INSERT INTO LOTES_INVENTARIO VALUES (1, 131, 11203, 50);
INSERT INTO LOTES_INVENTARIO VALUES (2, 131, 60456, 45);
INSERT INTO LOTES_INVENTARIO VALUES (3, 131, 31154, 35);
INSERT INTO LOTES_INVENTARIO VALUES (4, 131, 75574, 25);

-- Tienda 140 - LEGO Store Ciputra World Surabaya (Indonesia)
INSERT INTO LOTES_INVENTARIO VALUES (1, 140, 11201, 60);
INSERT INTO LOTES_INVENTARIO VALUES (2, 140, 60466, 55);
INSERT INTO LOTES_INVENTARIO VALUES (3, 140, 31109, 45);
INSERT INTO LOTES_INVENTARIO VALUES (4, 140, 75571, 35);

-- Tienda 141 - LEGO Store LCS Aeon BSD Mall (Indonesia)
INSERT INTO LOTES_INVENTARIO VALUES (1, 141, 11202, 65);
INSERT INTO LOTES_INVENTARIO VALUES (2, 141, 60465, 55);
INSERT INTO LOTES_INVENTARIO VALUES (3, 141, 31142, 45);
INSERT INTO LOTES_INVENTARIO VALUES (4, 141, 75573, 35);

-- Tienda 150 - LEGO Store Suwon (Corea del Sur)
INSERT INTO LOTES_INVENTARIO VALUES (1, 150, 10458, 70);
INSERT INTO LOTES_INVENTARIO VALUES (2, 150, 60367, 60);
INSERT INTO LOTES_INVENTARIO VALUES (3, 150, 31173, 50);
INSERT INTO LOTES_INVENTARIO VALUES (4, 150, 75572, 40);