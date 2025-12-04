
-- CREATE TABLE STATEMENTS FOR LEGO DB PROJECT
-- Tables: PAISES, INSIDE_TOURS, CLIENTES_LEGO, FANS_MENOR_LEGO, INSCRIPCIONES_TOUR, INSCRITOS, ENTRADAS
-- Constraints Added with ALTER TABLE statements (not inline) EXCEPT FOR PKs AND NNs

-- 1) PAIS
CREATE TABLE PAISES (
    ID_PAIS NUMBER(4) PRIMARY KEY,
    NOMBRE VARCHAR2(28) NOT NULL,
    NACIONALIDAD VARCHAR2(36) NOT NULL,
    CONTINENTE VARCHAR2(7) NOT NULL CONSTRAINT CHK_PAIS_CONTINENTE CHECK (CONTINENTE IN ('AMERICA','AFRICA','ASIA','EUROPA','OCEANIA')),
    UNION_EUROPEA NUMBER(1) NOT NULL CONSTRAINT CHK_PAIS_UNION_EUROPEA CHECK (UNION_EUROPEA IN (0,1))
);

-- 2) INSIDE_TOURS
CREATE TABLE INSIDE_TOURS (
    F_INICIO DATE PRIMARY KEY,
    PRECIO_PERSONA NUMBER(7,2) NOT NULL CONSTRAINT CHK_INSIDE_TOUR_PRECIO CHECK (PRECIO_PERSONA > 0),
    TOTAL_CUPOS NUMBER(4) NOT NULL CONSTRAINT CHK_INSIDE_TOUR_CUPOS CHECK (TOTAL_CUPOS > 0)
);

-- 3) CLIENTES_LEGO
CREATE TABLE CLIENTES_LEGO (
    ID_CLIENTE NUMBER(4) PRIMARY KEY,
    P_NOMBRE VARCHAR2(28) NOT NULL,
    P_APELLIDO VARCHAR2(28) NOT NULL,
    S_APELLIDO VARCHAR2(28) NOT NULL,
    FECHA_NAC DATE NOT NULL,
    NUM_DOC VARCHAR2(50) NOT NULL CONSTRAINT UNQ_CLIENTE_DOC_NAC UNIQUE,
    TELEFONO VARCHAR2(20) NOT NULL CONSTRAINT CHK_CLIENTE_TELEFONO CHECK (TELEFONO IS NULL OR REGEXP_LIKE(TELEFONO, '^\+?\d{1,3}( ?\d+)+$')),
    NACIMIENTO NUMBER(4) NOT NULL CONSTRAINT FK_CLIENTE_NACIMIENTO_PAIS REFERENCES PAISES (ID_PAIS),
    RESIDENCIA NUMBER(4) NOT NULL CONSTRAINT FK_CLIENTE_RESIDENCIA_PAIS REFERENCES PAISES (ID_PAIS),
    S_NOMBRE VARCHAR2(28),
    NUM_PASS VARCHAR2(50) CONSTRAINT UNQ_CLIENTE_NUM_PASS UNIQUE,
    F_VEN_PASS DATE,
    EMAIL VARCHAR2(254) CONSTRAINT CHK_CLIENTE_EMAIL CHECK (EMAIL IS NULL OR REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}$'))
);

-- 4) FANS_MENOR_LEGO
CREATE TABLE FANS_MENOR_LEGO (
    ID_FAN NUMBER(4) PRIMARY KEY,
    P_NOMBRE VARCHAR2(28) NOT NULL,
    P_APELLIDO VARCHAR2(28) NOT NULL,
    S_APELLIDO VARCHAR2(28) NOT NULL,
    NACIMIENTO NUMBER(4) NOT NULL CONSTRAINT FK_FAN_NACIMIENTO_PAIS REFERENCES PAISES (ID_PAIS),
    FECHA_NAC DATE NOT NULL,
    NUM_DOC VARCHAR2(50) NOT NULL CONSTRAINT UNQ_FAN_DOC_NAC UNIQUE,
    S_NOMBRE VARCHAR2(28),
    ID_REPRESENTANTE NUMBER(4) CONSTRAINT FK_FAN_REPRESENTANTE REFERENCES CLIENTES_LEGO (ID_CLIENTE),
    NUM_PASS VARCHAR2(50) CONSTRAINT UNQ_FAN_NUM_PASS UNIQUE,
    F_VEN_PASS DATE
);

-- 5) INSCRIPCIONES_TOUR
CREATE TABLE INSCRIPCIONES_TOUR (
    F_INICIO DATE NOT NULL CONSTRAINT FK_INSCRIPCION_F_INICIO REFERENCES INSIDE_TOURS (F_INICIO),
    NUM_INSCRIPCION NUMBER(4),
    TOTAL NUMBER(9,2) NOT NULL CONSTRAINT CHK_INSCRIPCION_TOTAL CHECK (TOTAL >= 0),
    F_INSCRIPCION DATE NOT NULL,
    STATUS_CONF VARCHAR2(10) NOT NULL CONSTRAINT CHK_INSCRIPCION_STATUS CHECK (STATUS_CONF IN ('PENDIENTE', 'PAGO')),
    CONSTRAINT PK_INSCRIPCION PRIMARY KEY (NUM_INSCRIPCION, F_INICIO)
);

-- 6) INSCRITOS
CREATE TABLE INSCRITOS (
    F_INICIO DATE NOT NULL,
    NUM_INSCRIPCION NUMBER(4) NOT NULL,
    ID_INSCRITOS NUMBER(4),
    PARTICIPANTE_MENOR NUMBER(4) CONSTRAINT FK_INSCRITOS_PART_MENOR REFERENCES FANS_MENOR_LEGO (ID_FAN),
    PARTICIPANTE_MAYOR NUMBER(4) CONSTRAINT FK_INSCRITOS_PART_MAYOR REFERENCES CLIENTES_LEGO (ID_CLIENTE),
    CONSTRAINT FK_INSCRITOS_INSCRIPCION_FULL FOREIGN KEY (NUM_INSCRIPCION, F_INICIO) REFERENCES INSCRIPCIONES_TOUR (NUM_INSCRIPCION, F_INICIO),
    CONSTRAINT PK_INSCRITOS PRIMARY KEY (F_INICIO, NUM_INSCRIPCION, ID_INSCRITOS),
    CONSTRAINT CHK_INSCRITOS_PARTICIPANT_XOR CHECK (
        (PARTICIPANTE_MENOR IS NOT NULL AND PARTICIPANTE_MAYOR IS NULL) OR
        (PARTICIPANTE_MENOR IS NULL AND PARTICIPANTE_MAYOR IS NOT NULL)
    )
);

-- 7) ENTRADAS
CREATE TABLE ENTRADAS (
    F_INICIO DATE NOT NULL,
    NUM_INSCRIPCION NUMBER(4) NOT NULL,
    NUM_ENTRADA NUMBER(4),
    TIPO VARCHAR2(7) NOT NULL CONSTRAINT CHK_ENTRADA_TIPO CHECK (TIPO IN ('MENOR','REGULAR')),
    CONSTRAINT FK_ENTRADA_INSCRIPCION_FULL FOREIGN KEY (NUM_INSCRIPCION, F_INICIO) REFERENCES INSCRIPCIONES_TOUR (NUM_INSCRIPCION, F_INICIO),
    CONSTRAINT PK_ENTRADA PRIMARY KEY (F_INICIO, NUM_INSCRIPCION, NUM_ENTRADA)
);

-- 8)
CREATE TABLE ESTADOS (
    ID_PAIS NUMBER(4) NOT NULL,
    ID_ESTADO NUMBER(4) NOT NULL,
    NOMBRE VARCHAR2(50) NOT NULL,
    CONSTRAINT FK_ESTADOS FOREIGN KEY (ID_PAIS) REFERENCES PAISES (ID_PAIS),
    CONSTRAINT PK1_ESTADOS PRIMARY KEY (ID_PAIS, ID_ESTADO)
);

-- 9)
CREATE TABLE CIUDADES (
    ID_PAIS NUMBER(4) NOT NULL,
    ID_ESTADO NUMBER(4) NOT NULL,
    ID_CUIDAD NUMBER(4) NOT NULL,
    NOMBRE VARCHAR2(50) NOT NULL,
    CONSTRAINT FK1_CIUDADES FOREIGN KEY (ID_PAIS, ID_ESTADO) REFERENCES ESTADOS (ID_PAIS, ID_ESTADO),
    CONSTRAINT PK1_CIUDADES PRIMARY KEY (ID_PAIS, ID_ESTADO, ID_CUIDAD)
);


-- 10)
CREATE TABLE TIENDAS (
    ID_TIENDA NUMBER(4) PRIMARY KEY,
    ID_PAIS NUMBER(4) NOT NULL,
    ID_ESTADO NUMBER(4) NOT NULL,
    ID_CUIDAD NUMBER(4) NOT NULL,
    NOMBRE VARCHAR2(100) NOT NULL,
    DIRECCION VARCHAR2(200) NOT NULL,
    TELEFONO VARCHAR2(17) NOT NULL,
    CONSTRAINT FK1_TIENDAS FOREIGN KEY (ID_PAIS, ID_ESTADO, ID_CUIDAD) REFERENCES CIUDADES (ID_PAIS, ID_ESTADO, ID_CUIDAD),
    CONSTRAINT CHK_TIENDA_TELEFONO CHECK (TELEFONO IS NULL OR REGEXP_LIKE(TELEFONO, '^\+?\d{1,3}( ?\d+)+$'))
);

-- 11)
CREATE TABLE HORARIOS (
    ID_TIENDA NUMBER(4) NOT NULL,
    DIA NUMBER(1) NOT NULL,
    HORA_INICIO DATE NOT NULL, 
    HORA_FIN DATE NOT NULL,
    CONSTRAINT FK_HORARIOS FOREIGN KEY (ID_TIENDA) REFERENCES TIENDAS (ID_TIENDA),
    CONSTRAINT PK1_HORARIOS PRIMARY KEY (ID_TIENDA,DIA),
    CONSTRAINT CHK_DIA_VALIDO CHECK (DIA BETWEEN 1 AND 7),
    CONSTRAINT CHK_HORA_INICIO_FORMATO CHECK (REGEXP_LIKE(TO_CHAR(HORA_INICIO, 'HH24:MI:SS'), '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$')),
    CONSTRAINT CHK_HORA_FIN_FORMATO CHECK (REGEXP_LIKE(TO_CHAR(HORA_FIN, 'HH24:MI:SS'), '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$')),
    CONSTRAINT CHK_HORARIO_VALIDO CHECK (HORA_FIN > HORA_INICIO)
);

-- CREATE OR REPLACE TRIGGERS 

-- CLIENTES_LEGO: must be at least 21 years old
CREATE OR REPLACE TRIGGER TRG_CLIENTE_AGE
BEFORE INSERT OR UPDATE ON CLIENTES_LEGO
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.FECHA_NAC > ADD_MONTHS(SYSDATE, -12*21) THEN
        RAISE_APPLICATION_ERROR(-20101, 'Client must be at least 21 years old');
        DBMS_OUTPUT.PUT_LINE('CLIENTE DEBE SER MAYOR A 21 AÑOS');
    END IF;
END;
/

-- FANS_MENOR_LEGO: must be less than 21 years old; if under 18, ID_REPRESENTANTE required
CREATE OR REPLACE TRIGGER TRG_FAN_AGE_AND_REP
BEFORE INSERT OR UPDATE ON FANS_MENOR_LEGO
FOR EACH ROW
DECLARE
    v_union_europea NUMBER(1);
BEGIN
    -- Fan must be younger than 21
    IF :NEW.FECHA_NAC <= ADD_MONTHS(SYSDATE, -12*21) THEN
        RAISE_APPLICATION_ERROR(-20102, 'Fan must be younger than 21 years old');
        DBMS_OUTPUT.PUT_LINE('FAN DEBE SER MENOR A 21 AÑOS');
    END IF;
    -- If fan is under 18 years old (FECHA_NAC > add_months(sysdate, -12*18)), a representative is required
    IF :NEW.FECHA_NAC > ADD_MONTHS(SYSDATE, -12*18) AND :NEW.ID_REPRESENTANTE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20103, 'Fan under 18 must have a representative (ID_REPRESENTANTE)');
        DBMS_OUTPUT.PUT_LINE('FAN MENOR A 18 AÑOS REQUIERE REPRESENTANTE');
    END IF;
    -- Check: If nationality is NOT in the EU (PAISES.UNION_EUROPEA = 0) then passport and expiration must be provided
    BEGIN
        SELECT UNION_EUROPEA INTO v_union_europea FROM PAISES WHERE ID_PAIS = :NEW.NACIMIENTO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_union_europea := 1; -- default assume EU if not found, FK should prevent this from happening
    END;
    IF v_union_europea = 0 THEN
        IF :NEW.NUM_PASS IS NULL OR :NEW.F_VEN_PASS IS NULL THEN
            RAISE_APPLICATION_ERROR(-20104, 'Para nacionalidades fuera de la Union Europea, se requieren NUM_pass y F_VEN_PASS');
        END IF;
    END IF;
END;
/

-- TRIGGER: Prevent new INSIDE_TOURS from starting within 3 days of another tour
-- The constraint considers that each Inside Tour lasts 3 days starting at F_INICIO
-- So no two tours can have start dates within a 3-day overlapping window.
CREATE OR REPLACE TRIGGER TRG_INSIDE_TOURS_NO_OVERLAP
BEFORE INSERT ON INSIDE_TOURS
FOR EACH ROW
DECLARE
    v_conflicts NUMBER;
BEGIN
    -- Check for any existing tour whose 3-day window overlaps with the new/updated tour start date
    SELECT COUNT(*) INTO v_conflicts
    FROM INSIDE_TOURS t
    WHERE (
        -- overlapping
        (t.F_INICIO BETWEEN :NEW.F_INICIO -2 AND :NEW.F_INICIO + 2)
    );

    IF v_conflicts > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'INSIDE_TOURS overlap: F_INICIO en conflicto con otro tour planificado');
    END IF;
END;
/

-- TRIGGER: Ensure legal representative is part of same INSCRIPCION_TOUR when inserting a minor
CREATE OR REPLACE TRIGGER TRG_INSCRITOS_MINOR_REP_CHECK
BEFORE INSERT ON INSCRITOS
FOR EACH ROW
DECLARE
    v_fan_fecha DATE;
    v_rep_id NUMBER(4);
    v_rep_exists NUMBER;
BEGIN
    -- If the participant is a minor, validate their representation
    IF :NEW.PARTICIPANTE_MENOR IS NOT NULL THEN
        BEGIN
            SELECT FECHA_NAC, ID_REPRESENTANTE INTO v_fan_fecha, v_rep_id
            FROM FANS_MENOR_LEGO
            WHERE ID_FAN = :NEW.PARTICIPANTE_MENOR;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20024, 'Fan referenciado no exite');
        END;

        -- If fan is under 18 (born after cutoff), require representative presence in same INSCRIPCION
        IF v_fan_fecha > ADD_MONTHS(SYSDATE, -12*18) THEN
            IF v_rep_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20025, 'Fan menor a 18 debe tener un representante legal asignado');
            END IF;

            SELECT COUNT(*) INTO v_rep_exists
            FROM INSCRITOS
            WHERE NUM_INSCRIPCION = :NEW.NUM_INSCRIPCION
              AND F_INICIO = :NEW.F_INICIO
              AND PARTICIPANTE_MAYOR = v_rep_id;

            IF v_rep_exists = 0 THEN
                RAISE_APPLICATION_ERROR(-20026, 'Se debe inscribir al representante legal del menor para permitir inscripcion');
            END IF;
        END IF;
    END IF;
END;
/

COMMIT;

CREATE OR REPLACE TRIGGER TRG_INSCRIPCION_FECHA_INICIO
BEFORE INSERT ON INSCRIPCIONES_TOUR
FOR EACH ROW
BEGIN
    -- Check if the tour start date (F_INICIO) is in the past. TRUNC(SYSDATE) is used to compare dates only.
    IF :NEW.F_INICIO < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20030, 'No se puede crear una inscripción para un tour cuya fecha de inicio ya ha pasado.');
    END IF;
END;
/

COMMIT;

CREATE OR REPLACE TRIGGER TRG_INSCRITO_FECHA_INICIO
BEFORE INSERT ON INSCRITOS
FOR EACH ROW
BEGIN
    -- Check if the tour start date (F_INICIO) is in the past. TRUNC(SYSDATE) is used to compare dates only.
    IF :NEW.F_INICIO < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20030, 'No se puede registrar un participante para un tour cuya fecha de inicio ya ha pasado.');
    END IF;
END;
/

COMMIT;

CREATE OR REPLACE TRIGGER TRG_ENTRADA_FECHA_INICIO
BEFORE INSERT ON ENTRADAS
FOR EACH ROW
BEGIN
    -- Check if the tour start date (F_INICIO) is in the past. TRUNC(SYSDATE) is used to compare dates only.
    IF :NEW.F_INICIO < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20030, 'No se puede crear una entrada para un tour cuya fecha de inicio ya ha pasado.');
    END IF;
END;
/

COMMIT;

-- SEQUENCES
CREATE SEQUENCE S_PAISES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_CLIENTES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_FANS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_INSCRIPCIONES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_INSCRITOS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_ENTRADAS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- PROCEDURES, FUNCTONS AND PACKAGES

CREATE OR REPLACE FUNCTION FN_CALCULATE_CONVERSION(
    p_value IN NUMBER,
    p_operation_type IN VARCHAR2
) RETURN NUMBER IS
BEGIN
    -- Use a CASE statement to handle the different operation types
    CASE UPPER(p_operation_type)
        WHEN 'D' THEN -- Dolares
            RETURN p_value * 1.16;
        WHEN 'C' THEN -- Coronas
            RETURN p_value * 7.47;
        ELSE
            -- If the operation type is not recognized, raise an error
            -- to prevent unexpected behavior.
            RAISE_APPLICATION_ERROR(-20050, 'Tipo de operación inválido. Use ''D'' o ''C''.');
    END CASE;
END FN_CALCULATE_CONVERSION;
/

CREATE OR REPLACE FUNCTION FN_COUNT_INSCRITOS_BY_DATE(
    p_f_inicio IN DATE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM INSCRITOS
    WHERE F_INICIO = p_f_inicio;
    RETURN v_count;
END FN_COUNT_INSCRITOS_BY_DATE;
/

-- N° Inscripciones asociadas a un tour
CREATE OR REPLACE FUNCTION FN_COUNT_INSCRIPCIONES_BY_DATE(
    p_f_inicio IN DATE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM INSCRIPCIONES_TOUR
    WHERE F_INICIO = p_f_inicio;
    RETURN v_count;
END FN_COUNT_INSCRIPCIONES_BY_DATE;
/

-- N° Inscritos asociados a una inscripcion
CREATE OR REPLACE FUNCTION FN_COUNT_INSCRITOS_BY_INSCRIPCION(
    p_f_inicio IN DATE,
    p_num_inscripcion IN NUMBER
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM INSCRITOS
    WHERE F_INICIO = p_f_inicio
      AND NUM_INSCRIPCION = p_num_inscripcion;
    RETURN v_count;
END FN_COUNT_INSCRITOS_BY_INSCRIPCION;
/

CREATE OR REPLACE FUNCTION FN_GET_AGE(
    p_date IN DATE
) RETURN NUMBER IS
BEGIN
    -- Calculate age by finding the total months between today and the birth date,
    -- dividing by 12, and taking the integer part.
    RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, p_date) / 12);
END FN_GET_AGE;
/

CREATE OR REPLACE PACKAGE pkg_lego_inserts_t AS

   PROCEDURE SP_INSERT_PAIS(p_nombre IN VARCHAR2, p_nacionalidad IN VARCHAR2, p_continente IN VARCHAR2, p_union_europea IN NUMBER, p_id_out OUT NUMBER);
   PROCEDURE SP_INSERT_INSIDE_TOUR(p_f_inicio IN DATE, p_precio_persona IN NUMBER, p_total_cupos IN NUMBER);
   PROCEDURE SP_INSERT_CLIENTE(p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_fecha_nac IN DATE, p_num_doc IN VARCHAR2, p_telefono IN VARCHAR2, p_nacimiento IN NUMBER, p_residencia IN NUMBER, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL, p_email IN VARCHAR2 DEFAULT NULL, p_id_out OUT NUMBER);
   PROCEDURE SP_INSERT_FAN(p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_nacimiento IN NUMBER, p_fecha_nac IN DATE, p_num_doc IN VARCHAR2, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_id_representante IN NUMBER DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL, p_id_out OUT NUMBER);
   PROCEDURE SP_INSERT_INSCRIPCION(p_f_inicio IN DATE, p_f_inscripcion IN DATE DEFAULT SYSDATE, p_status_conf IN VARCHAR2 DEFAULT 'PENDIENTE', p_total IN NUMBER DEFAULT 0, p_num_inscripcion OUT NUMBER);
   PROCEDURE SP_INSERT_INSCRITO(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER, p_participante_menor IN NUMBER DEFAULT NULL, p_participante_mayor IN NUMBER DEFAULT NULL, p_id_out OUT NUMBER);
   PROCEDURE SP_INSERT_ENTRADA(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER, p_tipo IN VARCHAR2, p_num_entrada OUT NUMBER);

END pkg_lego_inserts_t;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY pkg_lego_inserts_t AS

   PROCEDURE SP_INSERT_PAIS(p_nombre IN VARCHAR2, p_nacionalidad IN VARCHAR2, p_continente IN VARCHAR2, p_union_europea IN NUMBER, p_id_out OUT NUMBER) IS
   BEGIN
      INSERT INTO PAISES (ID_PAIS, NOMBRE, NACIONALIDAD, CONTINENTE, UNION_EUROPEA)
      VALUES (S_PAISES.nextval, p_nombre, p_nacionalidad, p_continente, p_union_europea)
      RETURNING ID_PAIS INTO p_id_out;
   END SP_INSERT_PAIS;

   PROCEDURE SP_INSERT_INSIDE_TOUR(p_f_inicio IN DATE, p_precio_persona IN NUMBER, p_total_cupos IN NUMBER) IS
   BEGIN
      INSERT INTO INSIDE_TOURS (F_INICIO, PRECIO_PERSONA, TOTAL_CUPOS)
      VALUES (p_f_inicio, p_precio_persona, p_total_cupos);
   END SP_INSERT_INSIDE_TOUR;

   PROCEDURE SP_INSERT_CLIENTE(p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_fecha_nac IN DATE, p_num_doc IN VARCHAR2, p_telefono IN VARCHAR2, p_nacimiento IN NUMBER, p_residencia IN NUMBER, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL, p_email IN VARCHAR2 DEFAULT NULL, p_id_out OUT NUMBER) IS
   BEGIN
      INSERT INTO CLIENTES_LEGO (ID_CLIENTE, P_NOMBRE, P_APELLIDO, S_APELLIDO, FECHA_NAC, NUM_DOC, TELEFONO, NACIMIENTO, RESIDENCIA, S_NOMBRE, NUM_PASS, F_VEN_PASS, EMAIL)
      VALUES (S_CLIENTES.nextval, p_p_nombre, p_p_apellido, p_s_apellido, p_fecha_nac, p_num_doc, p_telefono, p_nacimiento, p_residencia, p_s_nombre, p_num_pass, p_f_ven_pass, p_email)
      RETURNING ID_CLIENTE INTO p_id_out;
   END SP_INSERT_CLIENTE;

   PROCEDURE SP_INSERT_FAN(p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_nacimiento IN NUMBER, p_fecha_nac IN DATE, p_num_doc IN VARCHAR2, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_id_representante IN NUMBER DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL, p_id_out OUT NUMBER) IS
   BEGIN
      INSERT INTO FANS_MENOR_LEGO (ID_FAN, P_NOMBRE, P_APELLIDO, S_APELLIDO, NACIMIENTO, FECHA_NAC, NUM_DOC, S_NOMBRE, ID_REPRESENTANTE, NUM_PASS, F_VEN_PASS)
      VALUES (S_FANS.nextval, p_p_nombre, p_p_apellido, p_s_apellido, p_nacimiento, p_fecha_nac, p_num_doc, p_s_nombre, p_id_representante, p_num_pass, p_f_ven_pass)
      RETURNING ID_FAN INTO p_id_out;
   END SP_INSERT_FAN;

   PROCEDURE SP_INSERT_INSCRIPCION(p_f_inicio IN DATE, p_f_inscripcion IN DATE DEFAULT SYSDATE, p_status_conf IN VARCHAR2 DEFAULT 'PENDIENTE', p_total IN NUMBER DEFAULT 0, p_num_inscripcion OUT NUMBER) IS
   BEGIN
      INSERT INTO INSCRIPCIONES_TOUR (F_INICIO, NUM_INSCRIPCION, F_INSCRIPCION, STATUS_CONF, TOTAL)
      VALUES (p_f_inicio, S_INSCRIPCIONES.nextval, p_f_inscripcion, p_status_conf, p_total)
      RETURNING NUM_INSCRIPCION INTO p_num_inscripcion;
   END SP_INSERT_INSCRIPCION;

   PROCEDURE SP_INSERT_INSCRITO(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER, p_participante_menor IN NUMBER DEFAULT NULL, p_participante_mayor IN NUMBER DEFAULT NULL, p_id_out OUT NUMBER) IS
   BEGIN
      INSERT INTO INSCRITOS (F_INICIO, NUM_INSCRIPCION, ID_INSCRITOS, PARTICIPANTE_MENOR, PARTICIPANTE_MAYOR)
      VALUES (p_f_inicio, p_num_inscripcion, S_INSCRITOS.nextval, p_participante_menor, p_participante_mayor)
      RETURNING ID_INSCRITOS INTO p_id_out;
   END SP_INSERT_INSCRITO;

   PROCEDURE SP_INSERT_ENTRADA(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER, p_tipo IN VARCHAR2, p_num_entrada OUT NUMBER) IS
   BEGIN
      INSERT INTO ENTRADAS (F_INICIO, NUM_INSCRIPCION, NUM_ENTRADA, TIPO)
      VALUES (p_f_inicio, p_num_inscripcion, S_ENTRADAS.nextval, p_tipo)
      RETURNING NUM_ENTRADA INTO p_num_entrada;
   END SP_INSERT_ENTRADA;

END pkg_lego_inserts_t;
/

CREATE OR REPLACE PACKAGE pkg_lego_deletes_t AS

   PROCEDURE SP_DELETE_PAIS(p_id_pais IN NUMBER DEFAULT NULL);
   PROCEDURE SP_DELETE_INSIDE_TOUR(p_f_inicio IN DATE DEFAULT NULL);
   PROCEDURE SP_DELETE_CLIENTE(p_id_cliente IN NUMBER DEFAULT NULL);
   PROCEDURE SP_DELETE_FAN(p_id_fan IN NUMBER DEFAULT NULL);
   PROCEDURE SP_DELETE_INSCRIPCION(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER);
   PROCEDURE SP_DELETE_ALL_INSCRIPCIONES(p_f_inicio IN DATE DEFAULT NULL);
   PROCEDURE SP_DELETE_INSCRITO(p_f_inicio IN DATE DEFAULT NULL, p_num_inscripcion IN NUMBER DEFAULT NULL, p_id_inscrito IN NUMBER DEFAULT NULL);
   PROCEDURE SP_DELETE_ENTRADA(p_f_inicio IN DATE DEFAULT NULL, p_num_inscripcion IN NUMBER DEFAULT NULL, p_num_entrada IN NUMBER DEFAULT NULL);

END pkg_lego_deletes_t;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY pkg_lego_deletes_t AS

   PROCEDURE SP_DELETE_PAIS(p_id_pais IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_id_pais IS NOT NULL THEN
         -- Cascade delete for CLIENTES_LEGO referencing this PAIS
         FOR r_cli IN (SELECT id_cliente FROM CLIENTES_LEGO WHERE nacimiento = p_id_pais OR residencia = p_id_pais) LOOP
            SP_DELETE_CLIENTE(r_cli.id_cliente);
         END LOOP;

         DELETE FROM PAISES WHERE ID_PAIS = p_id_pais;
      ELSE
         -- Delete all, requires emptying dependent tables first
         SP_DELETE_ENTRADA(NULL, NULL, NULL);
         SP_DELETE_INSCRITO(NULL, NULL, NULL);
         SP_DELETE_ALL_INSCRIPCIONES(NULL);
         SP_DELETE_FAN(NULL);
         SP_DELETE_CLIENTE(NULL);
         DELETE FROM PAISES;
      END IF;
   END SP_DELETE_PAIS;

   PROCEDURE SP_DELETE_INSIDE_TOUR(p_f_inicio IN DATE DEFAULT NULL) IS
   BEGIN
      IF p_f_inicio IS NOT NULL THEN
         SP_DELETE_ALL_INSCRIPCIONES(p_f_inicio);
         DELETE FROM INSIDE_TOURS WHERE F_INICIO = p_f_inicio;
      ELSE
         SP_DELETE_ALL_INSCRIPCIONES(NULL);
         DELETE FROM INSIDE_TOURS;
      END IF;
   END SP_DELETE_INSIDE_TOUR;

   PROCEDURE SP_DELETE_CLIENTE(p_id_cliente IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_id_cliente IS NOT NULL THEN
         -- Cascade delete for FANS_MENOR_LEGO and INSCRITOS
         FOR r_fan IN (SELECT id_fan FROM FANS_MENOR_LEGO WHERE id_representante = p_id_cliente) LOOP
            SP_DELETE_FAN(r_fan.id_fan);
         END LOOP;
         DELETE FROM INSCRITOS WHERE participante_mayor = p_id_cliente;
         DELETE FROM CLIENTES_LEGO WHERE ID_CLIENTE = p_id_cliente;
      ELSE
         SP_DELETE_FAN(NULL);
         DELETE FROM INSCRITOS WHERE participante_mayor IS NOT NULL;
         DELETE FROM CLIENTES_LEGO;
      END IF;
   END SP_DELETE_CLIENTE;

   PROCEDURE SP_DELETE_FAN(p_id_fan IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_id_fan IS NOT NULL THEN
         DELETE FROM INSCRITOS WHERE participante_menor = p_id_fan;
         DELETE FROM FANS_MENOR_LEGO WHERE ID_FAN = p_id_fan;
      ELSE
         DELETE FROM INSCRITOS WHERE participante_menor IS NOT NULL;
         DELETE FROM FANS_MENOR_LEGO;
      END IF;
   END SP_DELETE_FAN;

   PROCEDURE SP_DELETE_INSCRIPCION(p_f_inicio IN DATE, p_num_inscripcion IN NUMBER) IS
   BEGIN
      DELETE FROM ENTRADAS WHERE F_INICIO = p_f_inicio AND NUM_INSCRIPCION = p_num_inscripcion;
      DELETE FROM INSCRITOS WHERE F_INICIO = p_f_inicio AND NUM_INSCRIPCION = p_num_inscripcion;
      DELETE FROM INSCRIPCIONES_TOUR WHERE F_INICIO = p_f_inicio AND NUM_INSCRIPCION = p_num_inscripcion;
   END SP_DELETE_INSCRIPCION;

   PROCEDURE SP_DELETE_ALL_INSCRIPCIONES(p_f_inicio IN DATE DEFAULT NULL) IS
   BEGIN
      IF p_f_inicio IS NOT NULL THEN
         DELETE FROM ENTRADAS WHERE F_INICIO = p_f_inicio;
         DELETE FROM INSCRITOS WHERE F_INICIO = p_f_inicio;
         DELETE FROM INSCRIPCIONES_TOUR WHERE F_INICIO = p_f_inicio;
      ELSE
         SP_DELETE_ENTRADA(NULL, NULL, NULL);
         SP_DELETE_INSCRITO(NULL, NULL, NULL);
         DELETE FROM INSCRIPCIONES_TOUR;
      END IF;
   END SP_DELETE_ALL_INSCRIPCIONES;

   PROCEDURE SP_DELETE_INSCRITO(p_f_inicio IN DATE DEFAULT NULL, p_num_inscripcion IN NUMBER DEFAULT NULL, p_id_inscrito IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_f_inicio IS NOT NULL AND p_num_inscripcion IS NOT NULL AND p_id_inscrito IS NOT NULL THEN
         -- Delete a single record using the composite PK
         DELETE FROM INSCRITOS
         WHERE F_INICIO = p_f_inicio
           AND NUM_INSCRIPCION = p_num_inscripcion
           AND ID_INSCRITOS = p_id_inscrito;
      ELSE
         -- Delete all records if any part of the PK is null
         DELETE FROM INSCRITOS;
      END IF;
   END SP_DELETE_INSCRITO;

   PROCEDURE SP_DELETE_ENTRADA(p_f_inicio IN DATE DEFAULT NULL, p_num_inscripcion IN NUMBER DEFAULT NULL, p_num_entrada IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_f_inicio IS NOT NULL AND p_num_inscripcion IS NOT NULL AND p_num_entrada IS NOT NULL THEN
         -- Delete a single record using the composite PK
         DELETE FROM ENTRADAS
         WHERE F_INICIO = p_f_inicio
           AND NUM_INSCRIPCION = p_num_inscripcion
           AND NUM_ENTRADA = p_num_entrada;
      ELSE
         -- Delete all records if any part of the PK is null
         DELETE FROM ENTRADAS;
      END IF;
   END SP_DELETE_ENTRADA;

END pkg_lego_deletes_t;
/

CREATE OR REPLACE PACKAGE pkg_lego_updates_t AS

   PROCEDURE SP_UPDATE_PAIS(
      p_id_pais IN NUMBER,
      p_nombre IN VARCHAR2,
      p_nacionalidad IN VARCHAR2,
      p_union_europea IN NUMBER
   );

   PROCEDURE SP_UPDATE_INSIDE_TOUR(
      p_f_inicio IN DATE,
      p_precio_persona IN NUMBER,
      p_total_cupos IN NUMBER
   );

   PROCEDURE SP_UPDATE_CLIENTE(
      p_id_cliente IN NUMBER,
      p_p_nombre IN VARCHAR2,
      p_p_apellido IN VARCHAR2,
      p_s_apellido IN VARCHAR2,
      p_telefono IN VARCHAR2,
      p_residencia IN NUMBER,
      p_s_nombre IN VARCHAR2 DEFAULT NULL,
      p_num_pass IN VARCHAR2 DEFAULT NULL,
      p_f_ven_pass IN DATE DEFAULT NULL,
      p_email IN VARCHAR2 DEFAULT NULL
   );

   PROCEDURE SP_UPDATE_FAN(
      p_id_fan IN NUMBER,
      p_p_nombre IN VARCHAR2,
      p_p_apellido IN VARCHAR2,
      p_s_apellido IN VARCHAR2,
      p_s_nombre IN VARCHAR2 DEFAULT NULL,
      p_id_representante IN NUMBER DEFAULT NULL,
      p_num_pass IN VARCHAR2 DEFAULT NULL,
      p_f_ven_pass IN DATE DEFAULT NULL
   );

END pkg_lego_updates_t;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY pkg_lego_updates_t AS

   PROCEDURE SP_UPDATE_PAIS(p_id_pais IN NUMBER, p_nombre IN VARCHAR2, p_nacionalidad IN VARCHAR2, p_union_europea IN NUMBER) IS
   BEGIN
      UPDATE PAISES
      SET NOMBRE = p_nombre, NACIONALIDAD = p_nacionalidad, UNION_EUROPEA = p_union_europea
      WHERE ID_PAIS = p_id_pais;
   END SP_UPDATE_PAIS;

   PROCEDURE SP_UPDATE_INSIDE_TOUR(p_f_inicio IN DATE, p_precio_persona IN NUMBER, p_total_cupos IN NUMBER) IS
   BEGIN
      UPDATE INSIDE_TOURS
      SET PRECIO_PERSONA = p_precio_persona, TOTAL_CUPOS = p_total_cupos
      WHERE F_INICIO = p_f_inicio;
   END SP_UPDATE_INSIDE_TOUR;

   PROCEDURE SP_UPDATE_CLIENTE(p_id_cliente IN NUMBER, p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_residencia IN NUMBER, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL, p_email IN VARCHAR2 DEFAULT NULL) IS
   BEGIN
      UPDATE CLIENTES_LEGO
      SET P_NOMBRE = p_p_nombre, P_APELLIDO = p_p_apellido, S_APELLIDO = p_s_apellido, TELEFONO = p_telefono, RESIDENCIA = p_residencia, S_NOMBRE = p_s_nombre, NUM_PASS = p_num_pass, F_VEN_PASS = p_f_ven_pass, EMAIL = p_email
      WHERE ID_CLIENTE = p_id_cliente;
   END SP_UPDATE_CLIENTE;

   PROCEDURE SP_UPDATE_FAN(p_id_fan IN NUMBER, p_p_nombre IN VARCHAR2, p_p_apellido IN VARCHAR2, p_s_apellido IN VARCHAR2, p_s_nombre IN VARCHAR2 DEFAULT NULL, p_id_representante IN NUMBER DEFAULT NULL, p_num_pass IN VARCHAR2 DEFAULT NULL, p_f_ven_pass IN DATE DEFAULT NULL) IS
   BEGIN
      UPDATE FANS_MENOR_LEGO
      SET P_NOMBRE = p_p_nombre, P_APELLIDO = p_p_apellido, S_APELLIDO = p_s_apellido, S_NOMBRE = p_s_nombre, ID_REPRESENTANTE = p_id_representante, NUM_PASS = p_num_pass, F_VEN_PASS = p_f_ven_pass
      WHERE ID_FAN = p_id_fan;
   END SP_UPDATE_FAN;

END pkg_lego_updates_t;
/


-- INSERTS FOR TEST DATA
DECLARE ID_inserts_B number(5);
BEGIN
    -- PAISES
    -- 1. Sudáfrica
    pkg_lego_inserts_t.SP_INSERT_PAIS('Sudafrica', 'Sudafricana', 'AFRICA', 0, ID_inserts_B);

    -- 2. Filipinas
    pkg_lego_inserts_t.SP_INSERT_PAIS('Filipinas', 'Filipina', 'ASIA', 0, ID_inserts_B);

    -- 3. Irlanda (Es miembro de la UE)
    pkg_lego_inserts_t.SP_INSERT_PAIS('Irlanda', 'Irlandesa', 'EUROPA', 1, ID_inserts_B);

    -- 4. Chile
    pkg_lego_inserts_t.SP_INSERT_PAIS('Chile', 'Chilena', 'AMERICA', 0, ID_inserts_B);

    -- 5. Indonesia
    pkg_lego_inserts_t.SP_INSERT_PAIS('Indonesia', 'Indonesa', 'ASIA', 0, ID_inserts_B);

    -- 6. Corea del Sur
    pkg_lego_inserts_t.SP_INSERT_PAIS('Corea del Sur', 'Surcoreana', 'ASIA', 0, ID_inserts_B);

    COMMIT;

    -- INSIDE_TOURS
    -- TOUR 1: Año 2024 (Precio base 250.00 €)
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-10', 250.00, 20);

    -- TOUR 2: Año 2024.
    -- Fecha válida: El anterior terminó el 12 (10, 11, 12). Este empieza el 15.
    -- Precio: Debe ser IGUAL al anterior por ser del mismo año.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-15', 250.00, 25);

    -- TOUR 3: Año 2025 (Nuevo año, el precio sube a 300.50 €)
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-01', 300.50, 30);

    -- TOUR 4: Año 2025.
    -- Fecha válida: El anterior ocupó 1, 2 y 3 de mayo. Este empieza el 5 de mayo.
    -- Precio: Debe ser 300.50 (igual que el otro del 2025).
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-05', 300.50, 30);

    -- TOUR 5: Año 2025.
    -- Fecha límite: Empieza justo después del anterior (5, 6, 7 ocupados -> empieza el 8).
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-08', 300.50, 15);
    -- TOUR 6: Año 2026 (Nuevo precio anual: 350.00 €)
    -- Duración: 10, 11 y 12 de Marzo.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-10', 350.00, 20);

    -- TOUR 7: Año 2026
    -- Fecha: 20 de Marzo (No se solapa con el anterior que terminó el 12).
    -- Precio: Debe mantenerse en 350.00 por ser del mismo año 2026.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-20', 350.00, 15);

    COMMIT;

    -- CLIENTES_LEGO
    -- Cliente 1: Chileno viviendo en Chile
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('JUAN', 'SOTO', 'MUNOZ', DATE '1990-05-15', 'DOC-CH-001', '+98 7654321', 4, 4, 'CARLOS', 'PASS-001', DATE '2030-05-15', 'juan.soto@email.com', ID_inserts_B);

    -- Cliente 2: Irlandesa viviendo en Irlanda
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SIOBHAN', 'O-CONNOR', 'SMITH', DATE '1988-11-20', 'DOC-IR-022', '+44 5566778', 3, 3, NULL, 'PASS-002', DATE '2029-11-20', 'siobhan.oc@email.com', ID_inserts_B);

    -- Cliente 3: Indonesio viviendo en Corea del Sur
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('BUDI', 'SANTOSO', 'PUTRA', DATE '1995-02-10', 'DOC-IN-033', '+11 2233445', 5, 6, 'DARMA', 'PASS-003', DATE '2028-02-10', 'budi.santoso@email.com', ID_inserts_B);

    -- Cliente 4: Sudafricano viviendo en Filipinas
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('THABO', 'MOLEFE', 'ZULU', DATE '1982-07-30', 'DOC-SA-044', '+99 8877665', 1, 2, NULL, 'PASS-004', DATE '2027-07-30', 'thabo.mz@email.com', ID_inserts_B);

    -- Cliente 5: Filipina viviendo en Irlanda
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('MARIA', 'SANTOS', 'REYES', DATE '2000-12-05', 'DOC-PH-055', '+66 7788990', 2, 3, 'ISABEL', 'PASS-005', DATE '2032-12-05', 'maria.reyes@email.com', ID_inserts_B);

    COMMIT;


    --FANS_MENOR_LEGO
    -- Fan 1: Un niño de 10 años (Chile, ID 4). Representado por Cliente 1.
    pkg_lego_inserts_t.SP_INSERT_FAN('TOMAS', 'SOTO', 'DIAZ', 4, DATE '2015-06-01', 'DOC-FAN-CH-1', NULL, 1, 'PASS-FAN-01', DATE '2028-03-15', ID_inserts_B);

    -- Fan 2: Una joven de 19 años (Irlanda, ID 3). Es mayor de 18 pero menor de 21.
    -- Nota: Al ser > 18, el representante podría ser opcional, pero asignamos al Cliente 2.
    pkg_lego_inserts_t.SP_INSERT_FAN('CIARA', 'O-CONNOR', 'WALSH', 3, DATE '2006-03-15', 'DOC-FAN-IR-2', NULL, 2, 'PASS-FAN-02', DATE '2028-03-15', ID_inserts_B);

    -- Fan 3: Un niño de 7 años (Indonesia, ID 5). Representado por Cliente 3.
    pkg_lego_inserts_t.SP_INSERT_FAN('SARI', 'SANTOS', 'KUSUMA', 5, DATE '2018-09-09', 'DOC-FAN-IN-3', NULL, 3, 'PASS-FAN-03', DATE '2028-03-15', ID_inserts_B);

    -- Fan 4: Un adolescente de 16 años (Sudáfrica, ID 1). Representado por Cliente 4.
    pkg_lego_inserts_t.SP_INSERT_FAN('LEO', 'MOLEFE', 'KHUMALO', 1, DATE '2009-11-20', 'DOC-FAN-SA-4', NULL, 4, 'PASS-FAN-04', DATE '2029-11-20', ID_inserts_B);

    -- Fan 5: Joven surcoreano de 20 años (Nacido en 2005).
    -- Al ser mayor de 18, el campo ID_REPRESENTANTE puede ser NULL.
    pkg_lego_inserts_t.SP_INSERT_FAN('MIN-JI', 'KIM', 'LEE', 6, DATE '2005-06-15', 'DOC-FAN-KR-5', NULL, NULL, 'PASS-FAN-05', DATE '2035-06-15', ID_inserts_B);

    COMMIT;
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