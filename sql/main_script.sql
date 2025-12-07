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
    CONSTRAINT CHK_HORA_FIN_FORMATO CHECK (REGEXP_LIKE(TO_CHAR(HORA_FIN, 'HH24:MI:SS'), '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$'))
);

CREATE TABLE JUGUETES (
    ID_JUGUETE           NUMBER(5)    PRIMARY KEY,
    ID_TEMA              NUMBER(4)    NOT NULL,
    NOMBRE_JUGUETE       VARCHAR2(100) NOT NULL,
    RANGO_EDAD           VARCHAR2(20) NOT NULL,
    NUMERO_PIEZAS        NUMBER(5)    NOT NULL 
        CONSTRAINT CHK_JUGUETE_NUM_PIEZAS CHECK (NUMERO_PIEZAS > 0),
    ES_SET               NUMBER(1)    NOT NULL
        CONSTRAINT CHK_JUGUETE_ES_SET CHECK (ES_SET IN (0,1)),
    ARCHIVO_INSTRUCCIONES VARCHAR2(255),
    RANGO_PRECIO         CHAR(1)      NOT NULL
        CONSTRAINT CHK_JUGUETE_RANGO_PRECIO CHECK (RANGO_PRECIO IN ('A','B','C','D')),
    DESCRIPCION          VARCHAR2(400) NOT NULL,
    CONSTRAINT FK_JUGUETE_TEMA FOREIGN KEY (ID_TEMA) REFERENCES TEMAS (ID_TEMA)
);

-- 12)
CREATE TABLE CATALOGO_PAIS (
    ID_PAIS NUMBER(4) NOT NULL,
    ID_JUGUETE NUMBER(5) NOT NULL,--SE COLOCARON 5 PORQUE EN LAS TIENDAS EL CODIGO SON 5 NUMEROS, PENDIENTE
    LIMITE_COMPRA NUMBER(4) NOT NULL,
    CONSTRAINT FK1_CATALOGO FOREIGN KEY (ID_PAIS) REFERENCES PAISES(ID_PAIS),
    CONSTRAINT FK2_CATALOGO FOREIGN KEY (ID_JUGUETE) REFERENCES JUGUETES(ID_JUGUETE),
    CONSTRAINT PK1_CATALOGO PRIMARY KEY (ID_PAIS, ID_JUGUETE)
);

CREATE TABLE TEMAS (
    ID_TEMA           NUMBER(4)      PRIMARY KEY,
    NOMBRE_TEMA       VARCHAR2(40)   NOT NULL,
    DESCRIPCION_TEMA  VARCHAR2(200)  NOT NULL,
    TIPO_TEMA         VARCHAR2(10)   NOT NULL,      -- 'TEMA' o 'SERIE'
    LICENCIA_EXTERNA  NUMBER(1),                   -- 1 = si, 0 = no

    CONSTRAINT CHK_TEMA_TIPO CHECK (TIPO_TEMA IN ('TEMA','SERIE')),
    CONSTRAINT CHK_TEMA_LIC_EXTERNA CHECK (LICENCIA_EXTERNA IN (0,1))
);


CREATE TABLE LOTES_INVENTARIO (
    NUMERO_LOTE  NUMBER(6)   NOT NULL,
    ID_TIENDA    NUMBER(4)   NOT NULL,
    ID_JUGUETE   NUMBER(5)   NOT NULL,
    CANTIDAD     NUMBER(6)   NOT NULL
        CONSTRAINT CHK_LOTE_CANTIDAD CHECK (CANTIDAD >= 0),
    CONSTRAINT FK_LOTE_TIENDA FOREIGN KEY (ID_TIENDA) REFERENCES TIENDAS (ID_TIENDA),
    CONSTRAINT FK_LOTE_JUGUETE FOREIGN KEY (ID_JUGUETE) REFERENCES JUGUETES (ID_JUGUETE),
    CONSTRAINT PK_LOTES_INVENTARIO PRIMARY KEY (NUMERO_LOTE,ID_TIENDA,ID_JUGUETE)
);

CREATE TABLE DESCUENTOS_INVENTARIO (
    ID_DESCUENTO  NUMBER(6)  PRIMARY KEY,
    ID_PAIS       NUMBER(4)  NOT NULL,
    ID_JUGUETE    NUMBER(5)  NOT NULL,
    FECHA         DATE       NOT NULL,
    CANTIDAD      NUMBER(6)  NOT NULL
        CONSTRAINT CHK_DESC_INV_CANTIDAD CHECK (CANTIDAD > 0),
    CONSTRAINT FK_DESC_INV_CATALOGO FOREIGN KEY (ID_PAIS, ID_JUGUETE) REFERENCES CATALOGO_PAIS (ID_PAIS, ID_JUGUETE)
);

CREATE TABLE HISTORICO_PRECIO (
    ID_JUGUETE    NUMBER(5)   NOT NULL,
    FECHA_INICIO  DATE        NOT NULL,
    PRECIO        NUMBER(8,2) NOT NULL
        CONSTRAINT CHK_HPRECIO_POSITIVO
            CHECK (PRECIO > 0),
    FECHA_FIN     DATE,
    CONSTRAINT PK_HISTORICO_PRECIO PRIMARY KEY (ID_JUGUETE, FECHA_INICIO),
    CONSTRAINT FK_HPRECIO_JUGUETE FOREIGN KEY (ID_JUGUETE) REFERENCES JUGUETES (ID_JUGUETE),
    CONSTRAINT CHK_HPRECIO_INTERVALO CHECK (FECHA_FIN IS NULL OR FECHA_FIN > FECHA_INICIO)
);

create table Factura_Fisica(
    id_tienda number(4) not null,
    num_factura number(6) not null,
    id_cliente number(4) not null,
    fecha_emision timestamp not null,
    total number(9,2),
    constraint Factura_Fisic_id_tienda foreign key (id_tienda) REFERENCES TIENDAS (ID_TIENDA),
    CONSTRAINT id_factura_fisica PRIMARY KEY (id_tienda,num_factura),
    CONSTRAINT Factura_Fisic_id_cliente foreign key (id_cliente) REFERENCES CLIENTES_LEGO(ID_CLIENTE)
);

create table Det_Factura_Fis(
    id_tienda number(4) not null,
    num_factura number(6) not null,
    id_det_fact number(6) not null,
    NUMERO_LOTE  NUMBER(6)   NOT NULL,
    ID_TIENDA    NUMBER(4)   NOT NULL,
    ID_JUGUETE   NUMBER(5)   NOT NULL,
    tipo_cliente varchar2(11) CONSTRAINT Det_Factura_Fis_tipo_cliente CHECK(tipo_cliente in ('NINNO', 'ADOLESCENTE', 'ADULTO')),
    constraint Det_Factura_Fis_id_Factura_Fisica FOREIGN KEY (id_tienda,num_factura) REFERENCES Factura_Fisica(id_tienda,num_factura),
    constraint id_Det_Factura_Fis PRIMARY KEY (id_tienda,num_factura,id_det_fact),
    CONSTRAINT Det_Factura_Fis_LOTES_INVENTARIO FOREIGN KEY (NUMERO_LOTE,ID_TIENDA,ID_JUGUETE) REFERENCES LOTES_INVENTARIO(NUMERO_LOTE,ID_TIENDA,ID_JUGUETE)
);

create table Factura_online(
    num_factura number(4) primary key,
    f_emision timestamp not null,
    id_cliente number(4) not null,
    puntos_acum_venta number(3) not null,
    gratis_lealtad boolean not null,
    total number(9,2),
    CONSTRAINT Factura_online_id_cliente foreign key (id_cliente) REFERENCES CLIENTES_LEGO(ID_CLIENTE)
);

create table Det_Factura_Onl(
    num_factura number(4) not null,
    id_det_fact number(6) not null,
    id_pais number(4) not null,
    id_juguete number(4) not null,
    cantidad number(2),
    CONSTRAINT Det_Factura_Onl_num_factura foreign key (num_factura) REFERENCES Factura_online(num_factura),
    CONSTRAINT id_Det_Factura_Onl primary key (num_factura,id_det_fact),
    CONSTRAINT Det_Factura_Onl_id_catalogo foreign key (id_pais,id_juguete) REFERENCES CATALOGO_PAIS (ID_PAIS,ID_JUGUETE)
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

-- TRIGGER: VERIFICA QUE LA HORA DE FIN SEA MAYOR A LA HORA DE INICIO
CREATE OR REPLACE TRIGGER TRG_HORARIOS_VALIDOS
BEFORE INSERT OR UPDATE ON HORARIOS
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.HORA_FIN <= :NEW.HORA_INICIO THEN
        RAISE_APPLICATION_ERROR(-20030, 'HORA_FIN debe ser mayor que HORA_INICIO');
    END IF;
END;
/

-- SEQUENCES

CREATE SEQUENCE S_PAISES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_CLIENTES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_FANS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_INSCRIPCIONES START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_INSCRITOS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE S_ENTRADAS START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- TYPES

CREATE OR REPLACE TYPE t_participant_doc_obj AS OBJECT (
    is_menor NUMBER(1),      -- 1 for FANS_MENOR_LEGO, 0 for CLIENTES_LEGO
    num_doc  VARCHAR2(50)    -- Document number to identify the person
);
/


CREATE OR REPLACE TYPE t_participant_doc_tab AS TABLE OF t_participant_doc_obj;
/


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

CREATE OR REPLACE PACKAGE pkg_lego_tours AS

   /**
    * @procedure SP_CREATE_INSCRIPCION_FLOW
    * @desc Handles the end-to-end process of creating a tour inscription.
    *       It validates tour capacity, registers participants, enforces age-related
    *       rules, calculates totals, and generates tickets.
    * @param p_f_inicio The start date of the INSIDE_TOUR.
    * @param p_participants An array of objects identifying the participants by their document number.
    * @param p_new_inscripcion_out Returns the generated NUM_INSCRIPCION for the new inscription.
    */
   PROCEDURE SP_CREATE_INSCRIPCION_FLOW(
      p_f_inicio            IN DATE,
      p_participants        IN t_participant_doc_tab,
      p_new_inscripcion_out OUT NUMBER
   );

   /**
    * @procedure SP_FINALIZE_PAYMENT
    * @desc Confirms payment for an existing inscription, updates its status
    *       to 'PAGO', and generates the corresponding tickets for all participants.
    * @param p_f_inicio The start date of the tour for the inscription.
    * @param p_num_inscripcion The inscription number to finalize.
    */
   PROCEDURE SP_FINALIZE_PAYMENT(
      p_f_inicio IN DATE,
      p_num_inscripcion IN NUMBER
   );
END pkg_lego_tours;
/

-- 4. Package Body
CREATE OR REPLACE PACKAGE BODY pkg_lego_tours AS

   PROCEDURE SP_CREATE_INSCRIPCION_FLOW(
      p_f_inicio            IN DATE,
      p_participants        IN t_participant_doc_tab,
      p_new_inscripcion_out OUT NUMBER
   ) IS
      -- Tour-related variables
      v_total_cupos      NUMBER;
      v_precio_persona   NUMBER(7, 2);
      v_tour_exists      NUMBER;

      -- Participant counting variables
      v_current_inscritos_count NUMBER;
      v_new_participant_count   NUMBER;

      -- Inscription and looping variables
      v_new_inscripcion_num NUMBER;
      v_inscrito_id         NUMBER;
      v_cliente_id          NUMBER;
      v_fan_id              NUMBER;
      v_fan_fecha_nac       DATE;
      v_fan_rep_id          NUMBER;
      v_rep_is_in_list      BOOLEAN;
      v_total_calculado     NUMBER(9, 2);

      -- Exception handling for participant logic
      e_participant_not_found EXCEPTION;
      PRAGMA EXCEPTION_INIT(e_participant_not_found, -20003);

      -- Error handling variables
      e_tour_not_found   EXCEPTION;
      e_no_capacity      EXCEPTION;
      PRAGMA EXCEPTION_INIT(e_tour_not_found, -20001);
      PRAGMA EXCEPTION_INIT(e_no_capacity, -20002);

   BEGIN
      -- =================================================================
      -- BLOCK 1: VERIFICATION
      -- Check if the tour exists and has enough capacity.
      -- =================================================================
      -- Lock the tour row to prevent race conditions on capacity checks
      BEGIN
         SELECT TOTAL_CUPOS, PRECIO_PERSONA
         INTO v_total_cupos, v_precio_persona
         FROM INSIDE_TOURS
         WHERE F_INICIO = p_f_inicio
         FOR UPDATE NOWAIT;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'El Inside Tour para la fecha ' || TO_CHAR(p_f_inicio, 'YYYY-MM-DD') || ' no existe.');
         WHEN OTHERS THEN
            IF SQLCODE = -54 THEN -- Resource busy
               RAISE_APPLICATION_ERROR(-20010, 'El registro del tour está siendo utilizado por otra transacción. Intente de nuevo.');
            ELSE
               RAISE;
            END IF;
      END;

      -- Use the existing function to count current participants for the tour
      v_current_inscritos_count := FN_COUNT_INSCRITOS_BY_DATE(p_f_inicio => p_f_inicio);

      -- Get the number of new participants from the input collection
      v_new_participant_count := p_participants.COUNT;

      -- Check for available capacity
      IF (v_current_inscritos_count + v_new_participant_count) > v_total_cupos THEN
         RAISE_APPLICATION_ERROR(-20002, 'No hay cupos suficientes para el tour. Cupos disponibles: ' || (v_total_cupos - v_current_inscritos_count));
      END IF;

      -- =================================================================
      -- BLOCK 2: CREATE INSCRIPTION & INSERT PARTICIPANTS
      -- Create the main inscription record and then insert each participant.
      -- =================================================================

      -- Create the main INSCRIPCIONES_TOUR record with 'PENDIENTE' status.
      -- We are using the modular insert procedure.
      pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(
         p_f_inicio          => p_f_inicio,
         p_status_conf       => 'PENDIENTE',
         p_num_inscripcion   => v_new_inscripcion_num
      );

      -- Assign the new inscription number to the OUT parameter
      p_new_inscripcion_out := v_new_inscripcion_num;

      -- Loop 1: Insert all adults (CLIENTES_LEGO, is_menor = 0)
      FOR i IN 1 .. p_participants.COUNT LOOP
         IF p_participants(i).is_menor = 0 THEN
            BEGIN
               -- Find the client's ID based on their document number
               SELECT ID_CLIENTE
               INTO v_cliente_id
               FROM CLIENTES_LEGO
               WHERE NUM_DOC = p_participants(i).num_doc;

               -- Insert into INSCRITOS using the modular procedure
               pkg_lego_inserts_t.SP_INSERT_INSCRITO(
                  p_f_inicio           => p_f_inicio,
                  p_num_inscripcion    => v_new_inscripcion_num,
                  p_participante_mayor => v_cliente_id,
                  p_id_out             => v_inscrito_id -- Not used here, but required by procedure
               );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20003, 'El participante adulto con NUM_DOC ' || p_participants(i).num_doc || ' no fue encontrado en CLIENTES_LEGO.');
            END;
         END IF;
      END LOOP;

      -- Loop 2: Insert all minors (FANS_MENOR_LEGO, is_menor = 1)
      -- The TRG_INSCRITOS_MINOR_REP_CHECK trigger will automatically validate
      -- that the representative for any minor under 18 is also being inscribed.
      FOR i IN 1 .. p_participants.COUNT LOOP
         IF p_participants(i).is_menor = 1 THEN
            BEGIN
               -- Find the fan's ID based on their document number
               SELECT ID_FAN
               INTO v_fan_id
               FROM FANS_MENOR_LEGO
               WHERE NUM_DOC = p_participants(i).num_doc;

               -- Insert into INSCRITOS using the modular procedure
               pkg_lego_inserts_t.SP_INSERT_INSCRITO(
                  p_f_inicio           => p_f_inicio,
                  p_num_inscripcion    => v_new_inscripcion_num,
                  p_participante_menor => v_fan_id,
                  p_id_out             => v_inscrito_id -- Not used here, but required by procedure
               );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20003, 'El participante menor con NUM_DOC ' || p_participants(i).num_doc || ' no fue encontrado en FANS_MENOR_LEGO.');
               WHEN OTHERS THEN
                  -- Catch potential errors from the trigger (e.g., -20026) and re-raise them
                  -- with a more user-friendly message if desired, or just re-raise.
                  IF SQLCODE = -20026 THEN
                     RAISE_APPLICATION_ERROR(-20026, 'Error de validación: El representante legal de un menor de 18 años debe estar incluido en la misma inscripción.');
                  ELSE
                     RAISE; -- Re-raise any other unexpected errors
                  END IF;
            END;
         END IF;
      END LOOP;

      -- =================================================================
      -- BLOCK 3: CALCULATE TOTAL & AWAIT PAYMENT
      -- Calculate the total cost and update the inscription.
      -- =================================================================

      -- Recalculate the number of participants for this specific inscription
      v_new_participant_count := FN_COUNT_INSCRITOS_BY_INSCRIPCION(
         p_f_inicio        => p_f_inicio,
         p_num_inscripcion => v_new_inscripcion_num
      );

      -- Calculate the total price
      v_total_calculado := v_new_participant_count * v_precio_persona;

      -- Update the inscription with the calculated total
      UPDATE INSCRIPCIONES_TOUR
      SET TOTAL = v_total_calculado
      WHERE F_INICIO = p_f_inicio
        AND NUM_INSCRIPCION = v_new_inscripcion_num;

      -- Display the message indicating the process is waiting for payment
      DBMS_OUTPUT.PUT_LINE('Esperando por pago');

      COMMIT;

   END SP_CREATE_INSCRIPCION_FLOW;

   PROCEDURE SP_FINALIZE_PAYMENT(
      p_f_inicio IN DATE,
      p_num_inscripcion IN NUMBER
   ) IS
   BEGIN
      -- =================================================================
      -- BLOCK 1: FINALIZE PAYMENT & GENERATE TICKETS
      -- Simulate payment confirmation and create tickets for all participants.
      -- =================================================================

      -- Update the status to 'PAGO'
      UPDATE INSCRIPCIONES_TOUR
      SET STATUS_CONF = 'PAGO'
      WHERE F_INICIO = p_f_inicio
        AND NUM_INSCRIPCION = p_num_inscripcion;

      -- Loop through the inscritos to generate an entrada for each
      FOR r_inscrito IN (SELECT PARTICIPANTE_MENOR, PARTICIPANTE_MAYOR FROM INSCRITOS WHERE F_INICIO = p_f_inicio AND NUM_INSCRIPCION = p_num_inscripcion) LOOP
         DECLARE
            v_tipo_entrada VARCHAR2(7) := CASE WHEN r_inscrito.PARTICIPANTE_MENOR IS NOT NULL THEN 'MENOR' ELSE 'REGULAR' END;
            v_num_entrada  NUMBER;
         BEGIN
            pkg_lego_inserts_t.SP_INSERT_ENTRADA(p_f_inicio, p_num_inscripcion, v_tipo_entrada, v_num_entrada);
         END;
      END LOOP;

      -- Display the final confirmation message
      DBMS_OUTPUT.PUT_LINE('Inscripcion paga');

      COMMIT;
   END SP_FINALIZE_PAYMENT;

END pkg_lego_tours;
/

--TE INDICA SI LA TIENDA ESTÁ ABIERTA
CREATE OR REPLACE FUNCTION TIENDA_ABIERTA(
    ID_TIENDA_TA IN NUMBER,
    FECHA_HORA_TA IN DATE
) RETURN VARCHAR2
IS
    DIA_SEMANA NUMBER;
    HORA_ACTUAL DATE;
    CONTADOR NUMBER;
BEGIN
    DIA_SEMANA := TO_CHAR(FECHA_HORA_TA, 'D');
    HORA_ACTUAL := TO_DATE(TO_CHAR(FECHA_HORA_TA, 'HH24:MI:SS'), 'HH24:MI:SS');
    SELECT COUNT(*)
    INTO CONTADOR
    FROM HORARIOS
    WHERE ID_TIENDA = ID_TIENDA_TA
      AND DIA = DIA_SEMANA
      AND HORA_ACTUAL >= HORA_INICIO
      AND HORA_ACTUAL <= HORA_FIN;
    IF CONTADOR > 0 THEN
        RETURN 'La tienda se encuentra ABIERTA, escoja los productos que desee';
    ELSE
        RETURN 'La tienda se encuentra CERRADA, no se premiten compras';
    END IF;
END;
/

-- VIEWS

-- =================================================================
-- V_CLIENTES_LEGO
-- A view to display client information in a user-friendly format,
-- replacing null values with '--' for better readability.
-- =================================================================
CREATE OR REPLACE VIEW V_CLIENTES_LEGO AS
SELECT
    c.p_nombre AS "Primer Nombre",
    NVL(c.s_nombre, '--') AS "Segundo Nombre",
    c.p_apellido AS "Primer Apellido",
    c.s_apellido AS "Segundo Apellido",
    TO_CHAR(c.fecha_nac, 'YYYY-MM-DD') AS "Fecha de Nacimiento",
    c.num_doc AS "Documento de Identidad",
    p.nombre AS "Pais de Nacimiento",
    r.nombre AS "Pais de Residencia",
    c.telefono AS "Telefono",
    NVL(c.num_pass, '--') AS "Pasaporte",
    NVL(TO_CHAR(c.f_ven_pass, 'YYYY-MM-DD'), '--') AS "Fecha de Vencimiento Pasaporte",
    NVL(c.email, '--') AS "Correo Electronico"
FROM
    CLIENTES_LEGO c, PAISES p, PAISES r
        WHERE c.nacimiento = p.id_pais
        AND c.residencia = r.id_pais;

COMMIT;

-- =================================================================
-- V_FANS_MENOR_LEGO
-- A view to display minor fan information, including details
-- about their legal representative from the CLIENTES_LEGO table.
-- =================================================================
CREATE OR REPLACE VIEW V_FANS_MENOR_LEGO AS
SELECT
    f.p_nombre AS "Primer Nombre",
    NVL(f.s_nombre, '--') AS "Segundo Nombre",
    f.p_apellido AS "Primer Apellido",
    f.s_apellido AS "Segundo Apellido",
    TO_CHAR(f.fecha_nac, 'YYYY-MM-DD') AS "Fecha de Nacimiento",
    f.num_doc AS "Documento de Identidad",
    p.nombre AS "Pais de Nacimiento",
    NVL(f.num_pass, '--') AS "Pasaporte",
    NVL(TO_CHAR(f.f_ven_pass, 'YYYY-MM-DD'), '--') AS "Fecha de Vencimiento Pasaporte",
    NVL(TRIM(c.p_nombre || ' ' || c.s_nombre || ' ' || c.p_apellido || ' ' || c.s_apellido), '--') AS "Nombre Representante",
    NVL(c.num_doc, '--') AS "Documento de Identidad Representante"
FROM
    FANS_MENOR_LEGO f, PAISES p, CLIENTES_LEGO c
        WHERE f.nacimiento = p.id_pais
        AND f.id_representante = c.id_cliente (+);

COMMIT;

-- =================================================================
-- V_INSIDE_TOURS_SUMMARY
-- A view to display a summary of each tour, including the end date
-- and the number of available slots remaining.
-- =================================================================
CREATE OR REPLACE VIEW V_INSIDE_TOURS_SUMMARY AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    it.precio_persona AS "Precio por Persona",
    (it.total_cupos - FN_COUNT_INSCRITOS_BY_DATE(it.f_inicio)) AS "Cupos Disponibles"
FROM
    INSIDE_TOURS it;

COMMIT;

-- =================================================================
-- V_TOUR_INSCRIPCIONES
-- A detailed view linking tours with their corresponding inscriptions.
-- Data is ordered by tour date and inscription number for clarity.
-- =================================================================
CREATE OR REPLACE VIEW V_TOUR_INSCRIPCIONES AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    ins.num_inscripcion AS "Numero de Inscripcion",
    TO_CHAR(ins.f_inscripcion, 'YYYY-MM-DD') AS "Fecha de Inscripcion",
    ins.total AS "Total a Pagar",
    ins.status_conf AS "Estatus de Confirmacion"
FROM
    INSIDE_TOURS it, INSCRIPCIONES_TOUR ins
        WHERE it.f_inicio = ins.f_inicio (+);

COMMIT;

-- =================================================================
-- V_INSCRITOS_DETALLE
-- A view to show details for each participant in an inscription,
-- identifying them as 'Mayor' or 'Menor' and pulling their name.
-- =================================================================
CREATE OR REPLACE VIEW V_INSCRITOS_DETALLE AS
SELECT
    i.num_inscripcion AS "Numero de Inscripcion",
    CASE
        WHEN i.participante_mayor IS NOT NULL THEN 'Mayor'
        ELSE 'Menor'
    END AS "Tipo",
    NVL(c.p_nombre, f.p_nombre) AS "Nombre",
    NVL(c.p_apellido, f.p_apellido) AS "Apellido"
FROM
    INSCRITOS i, CLIENTES_LEGO c, FANS_MENOR_LEGO f
WHERE
    i.participante_mayor = c.id_cliente (+)
    AND i.participante_menor = f.id_fan (+)
ORDER BY
    i.num_inscripcion, i.id_inscritos;

COMMIT;

-- =================================================================
-- V_ENTRADAS_DETALLE
-- A simple view to list all tickets associated with an inscription.
-- =================================================================
CREATE OR REPLACE VIEW V_ENTRADAS_DETALLE AS
SELECT
    num_inscripcion AS "Numero de Inscripcion",
    num_entrada AS "Numero de Entrada",
    tipo AS "Tipo de Entrada"
FROM
    ENTRADAS
ORDER BY
    num_inscripcion, num_entrada;

COMMIT;

-- =================================================================
-- V_TOUR_INSCRIPCIONES_CONVERSION
-- A detailed view for a specific inscription, showing the total
-- cost converted to multiple currencies.
-- =================================================================
CREATE OR REPLACE VIEW V_TOUR_INSCRIPCIONES_CONVERSION AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    ins.num_inscripcion AS "Numero de Inscripcion",
    TO_CHAR(ins.f_inscripcion, 'YYYY-MM-DD') AS "Fecha de Inscripcion",
    ins.total AS "Total Euros",
    FN_CALCULATE_CONVERSION(ins.total, 'D') AS "Total Dolares",
    FN_CALCULATE_CONVERSION(ins.total, 'C') AS "Total Coronas Danesas",
    ins.status_conf AS "Estatus de Confirmacion"
FROM
    INSIDE_TOURS it, INSCRIPCIONES_TOUR ins
        WHERE it.f_inicio = ins.f_inicio;

COMMIT;

--VIEW DE TODAS LAL TIENDAS CON SUS HORARIOS
CREATE OR REPLACE VIEW V_HORARIOS_TIENDAS AS
SELECT *
FROM (
    SELECT 
        J.NOMBRE AS JUGUETE,
        J.DESCRIPCION AS DESCRIPCION
    FROM JUGUETES J
    JOIN HORARIOS H ON T.ID_TIENDA = H.ID_TIENDA
)
PIVOT (-- DIVIDE LA COLUMNA DE LOS HORARIOS EN 7 COLUMNAS, UNA PARA CADA DIA
    MAX(HORARIO)
    FOR NUM_DIA_SEMANA IN (
        '2' AS LUNES,
        '3' AS MARTES,
        '4' AS MIERCOLES,
        '5' AS JUEVES,
        '6' AS VIERNES,
        '7' AS SABADO,
        '1' AS DOMINGO
    )
)
ORDER BY TIENDA;
--SE LE DA FORMATO A LAS COLUMNAS, PARA LA QUE INFORMACIÓN SE VEA "ORDENADA"
--MÁXIMO DE ESPACIO QUE OCUPA LA COLUMNA SON 35 CARACTERES
COLUMN TIENDA FORMAT A35
--MÁXIMO DE ESPACIO QUE OCUPAN LAS COLUMNAS SON 15 CARACTERES
COLUMN LUNES FORMAT A15
COLUMN MARTES FORMAT A15
COLUMN MIERCOLES FORMAT A15
COLUMN JUEVES FORMAT A15
COLUMN VIERNES FORMAT A15
COLUMN SABADO FORMAT A15
COLUMN DOMINGO FORMAT A15

SELECT * FROM V_HORARIOS_TIENDAS;

--UNA VEZ SE CREE JUGUETE, VERIFICAR ESTE, PARA LA TABLA Y EL ID
--VIEW DE CADA UNO DE LOS CATÁLOGOS POR SEPARADO, PORQUE SE NECESITA UNO POR CADA PAIS PARA TIENDA ONLINE
CREATE OR REPLACE VIEW V_CATALOGO_SUDAFRICA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 1  -- Sudáfrica tiene ID 1
ORDER BY J.NOMBRE;

CREATE OR REPLACE VIEW V_CATALOGO_FILIPINAS AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 2  -- Filipinas tiene ID 2
ORDER BY J.NOMBRE;

CREATE OR REPLACE VIEW V_CATALOGO_IRLANDA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 3  -- Irlanda tiene ID 3
ORDER BY J.NOMBRE;

CREATE OR REPLACE VIEW V_CATALOGO_CHILE AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 4  -- Chile tiene ID 4
ORDER BY J.NOMBRE;

CREATE OR REPLACE VIEW V_CATALOGO_INDONESIA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 5  -- Indonesia tiene ID 5
ORDER BY J.NOMBRE;

CREATE OR REPLACE VIEW V_CATALOGO_COREA_SUR AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 6  -- Corea del Sur tiene ID 6
ORDER BY J.NOMBRE;

-- INSERTS FOR TEST DATA
DECLARE
    -- Variables for IDs to manage foreign keys
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
    -- PAISES
    -- 1. Sudáfrica
    pkg_lego_inserts_t.SP_INSERT_PAIS('Sudafrica', 'Sudafricana', 'AFRICA', 0, v_id_pais_sa);

    -- 2. Filipinas
    pkg_lego_inserts_t.SP_INSERT_PAIS('Filipinas', 'Filipina', 'ASIA', 0, v_id_pais_ph);

    -- 3. Irlanda (Es miembro de la UE)
    pkg_lego_inserts_t.SP_INSERT_PAIS('Irlanda', 'Irlandesa', 'EUROPA', 1, v_id_pais_ie);

    -- 4. Chile
    pkg_lego_inserts_t.SP_INSERT_PAIS('Chile', 'Chilena', 'AMERICA', 0, v_id_pais_cl);

    -- 5. Indonesia
    pkg_lego_inserts_t.SP_INSERT_PAIS('Indonesia', 'Indonesa', 'ASIA', 0, v_id_pais_id);

    -- 6. Corea del Sur
    pkg_lego_inserts_t.SP_INSERT_PAIS('Corea del Sur', 'Surcoreana', 'ASIA', 0, v_id_pais_kr);

    COMMIT;

    -- INSIDE_TOURS
    -- TOUR 1: Año 2024 (Precio base 250.00 €)
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-10', 25.00, 25);

    -- TOUR 2: Año 2024.
    -- Fecha válida: El anterior terminó el 12 (10, 11, 12). Este empieza el 15.
    -- Precio: Debe ser IGUAL al anterior por ser del mismo año.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2024-01-15', 25.00, 25);

    -- TOUR 3: Año 2025 (Nuevo año, el precio sube a 300.50 €)
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-01', 30.50, 30);

    -- TOUR 4: Año 2025.
    -- Fecha válida: El anterior ocupó 1, 2 y 3 de mayo. Este empieza el 5 de mayo.
    -- Precio: Debe ser 300.50 (igual que el otro del 2025).
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-05', 30.50, 30);

    -- TOUR 5: Año 2025.
    -- Fecha límite: Empieza justo después del anterior (5, 6, 7 ocupados -> empieza el 8).
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2025-05-08', 30.50, 30);
    -- TOUR 6: Año 2026 (Nuevo precio anual: 350.00 €)
    -- Duración: 10, 11 y 12 de Marzo.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-10', 35.00, 20);

    -- TOUR 7: Año 2026
    -- Fecha: 20 de Marzo (No se solapa con el anterior que terminó el 12).
    -- Precio: Debe mantenerse en 350.00 por ser del mismo año 2026.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-03-20', 35.00, 20);

    -- TOUR 8: Año 2026
    -- Fecha: 1 de Abril (No se solapa con el anterior que terminó el 22 de marzo).
    -- Precio: Debe mantenerse en 350.00 por ser del mismo año 2026.
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-04-01', 35.00, 20);

    -- TOUR 9: Año 2026
    -- Fecha: 5 de Abril (No se solapa con el anterior que terminó el 3 de abril).
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(DATE '2026-04-05', 35.00, 20);

    COMMIT;

    -- CLIENTES_LEGO
    -- Cliente 1: Chileno viviendo en Chile
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('JUAN', 'SOTO', 'MUNOZ', DATE '1990-05-15', 'DOC-CH-001', '+98 7654321', v_id_pais_cl, v_id_pais_cl, 'CARLOS', 'PASS-001', DATE '2030-05-15', 'juan.soto@email.com', v_id_cliente_1);

    -- Cliente 2: Irlandesa viviendo en Irlanda
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SIOBHAN', 'O-CONNOR', 'SMITH', DATE '1988-11-20', 'DOC-IR-022', '+44 5566778', v_id_pais_ie, v_id_pais_ie, NULL, 'PASS-002', DATE '2029-11-20', 'siobhan.oc@email.com', v_id_cliente_2);

    -- Cliente 3: Indonesio viviendo en Corea del Sur
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('BUDI', 'SANTOSO', 'PUTRA', DATE '1995-02-10', 'DOC-IN-033', '+11 2233445', v_id_pais_id, v_id_pais_kr, 'DARMA', 'PASS-003', DATE '2028-02-10', 'budi.santoso@email.com', v_id_cliente_3);

    -- Cliente 4: Sudafricano viviendo en Filipinas
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('THABO', 'MOLEFE', 'ZULU', DATE '1982-07-30', 'DOC-SA-044', '+99 8877665', v_id_pais_sa, v_id_pais_ph, NULL, 'PASS-004', DATE '2027-07-30', 'thabo.mz@email.com', v_id_cliente_4);

    -- Cliente 5: Filipina viviendo en Irlanda
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('MARIA', 'SANTOS', 'REYES', DATE '2000-12-05', 'DOC-PH-055', '+66 7788990', v_id_pais_ph, v_id_pais_ie, 'ISABEL', 'PASS-005', DATE '2032-12-05', 'maria.reyes@email.com', v_id_cliente_5);

    -- Cliente 6: Sudafricano viviendo en Sudáfrica
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('JABULANI', 'DLAMINI', 'NKOSI', DATE '1975-03-25', 'DOC-SA-066', '+27 821234567', v_id_pais_sa, v_id_pais_sa, NULL, 'PASS-006', DATE '2028-08-15', 'jabulani.d@email.com', v_id_cliente_6);

    -- Cliente 7: Irlandés viviendo en Chile
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SEAN', 'MURPHY', 'KELLY', DATE '1992-08-12', 'DOC-IR-077', '+56 987654321', v_id_pais_ie, v_id_pais_cl, 'PATRICK', 'PASS-007', DATE '2031-01-20', 'sean.murphy@email.com', v_id_cliente_7);

    -- Cliente 8: Coreana viviendo en Corea del Sur
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('SOO-JIN', 'PARK', 'CHOI', DATE '1980-11-30', 'DOC-KR-088', '+82 1098765432', v_id_pais_kr, v_id_pais_kr, NULL, 'PASS-008', DATE '2026-11-30', 'soojin.park@email.com', v_id_cliente_8);

    -- Cliente 9: Indonesio viviendo en Indonesia
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('AGUNG', 'WIDODO', 'HIDAYAT', DATE '1989-01-18', 'DOC-IN-099', '+62 8123456789', v_id_pais_id, v_id_pais_id, 'DEWI', 'PASS-009', DATE '2029-05-22', 'agung.w@email.com', v_id_cliente_9);

    -- Cliente 10: Chilena viviendo en Irlanda
    pkg_lego_inserts_t.SP_INSERT_CLIENTE('CAMILA', 'ROJAS', 'VERGARA', DATE '1998-07-07', 'DOC-CL-101', '+353 876543210', v_id_pais_cl, v_id_pais_ie, NULL, 'PASS-010', DATE '2033-07-07', 'camila.rojas@email.com', v_id_cliente_10);

    COMMIT;


    --FANS_MENOR_LEGO
    -- Fan 1: Un niño de 10 años (Chile, ID 4). Representado por Cliente 1.
    pkg_lego_inserts_t.SP_INSERT_FAN('TOMAS', 'SOTO', 'DIAZ', v_id_pais_cl, DATE '2015-06-01', 'DOC-FAN-CH-1', NULL, v_id_cliente_1, 'PASS-FAN-01', DATE '2028-03-15', v_id_fan_1);

    -- Fan 2: Una joven de 19 años (Irlanda, ID 3). Es mayor de 18 pero menor de 21.
    -- Nota: Al ser > 18, el representante podría ser opcional, pero asignamos al Cliente 2.
    pkg_lego_inserts_t.SP_INSERT_FAN('CIARA', 'O-CONNOR', 'WALSH', v_id_pais_ie, DATE '2006-03-15', 'DOC-FAN-IR-2', NULL, v_id_cliente_2, 'PASS-FAN-02', DATE '2028-03-15', v_id_fan_2);

    -- Fan 3: Un niño de 7 años (Indonesia, ID 5). Representado por Cliente 3.
    pkg_lego_inserts_t.SP_INSERT_FAN('SARI', 'SANTOS', 'KUSUMA', v_id_pais_id, DATE '2018-09-09', 'DOC-FAN-IN-3', NULL, v_id_cliente_3, 'PASS-FAN-03', DATE '2028-03-15', v_id_fan_3);

    -- Fan 4: Un adolescente de 16 años (Sudáfrica, ID 1). Representado por Cliente 4.
    pkg_lego_inserts_t.SP_INSERT_FAN('LEO', 'MOLEFE', 'KHUMALO', v_id_pais_sa, DATE '2009-11-20', 'DOC-FAN-SA-4', NULL, v_id_cliente_4, 'PASS-FAN-04', DATE '2029-11-20', v_id_fan_4);

    -- Fan 5: Joven surcoreano de 20 años (Nacido en 2005).
    -- Al ser mayor de 18, el campo ID_REPRESENTANTE puede ser NULL.
    pkg_lego_inserts_t.SP_INSERT_FAN('MIN-JI', 'KIM', 'LEE', v_id_pais_kr, DATE '2005-06-15', 'DOC-FAN-KR-5', NULL, NULL, 'PASS-FAN-05', DATE '2035-06-15', v_id_fan_5);

    -- Fan 6: Niño de 5 años (Sudáfrica). Representado por Cliente 6.
    pkg_lego_inserts_t.SP_INSERT_FAN('AMARA', 'DLAMINI', 'SITHOLE', v_id_pais_sa, DATE '2020-02-20', 'DOC-FAN-SA-6', NULL, v_id_cliente_6, 'PASS-FAN-06', DATE '2030-02-20', v_id_fan_6);

    -- Fan 7: Joven de 19 años (Irlanda). Representado por Cliente 7.
    pkg_lego_inserts_t.SP_INSERT_FAN('AOIFE', 'MURPHY', 'BYRNE', v_id_pais_ie, DATE '2006-09-01', 'DOC-FAN-IR-7', NULL, v_id_cliente_7, 'PASS-FAN-07', DATE '2029-09-01', v_id_fan_7);

    -- Fan 8: Niña de 12 años (Corea del Sur). Representada por Cliente 8.
    pkg_lego_inserts_t.SP_INSERT_FAN('JI-HOO', 'PARK', 'KANG', v_id_pais_kr, DATE '2013-04-10', 'DOC-FAN-KR-8', NULL, v_id_cliente_8, 'PASS-FAN-08', DATE '2028-04-10', v_id_fan_8);

    -- Fan 9: Adolescente de 17 años (Indonesia). Representado por Cliente 9.
    pkg_lego_inserts_t.SP_INSERT_FAN('RATNA', 'WIDODO', 'LESTARI', v_id_pais_id, DATE '2008-12-24', 'DOC-FAN-IN-9', NULL, v_id_cliente_9, 'PASS-FAN-09', DATE '2027-12-24', v_id_fan_9);

    -- Fan 10: Joven de 20 años (Chile). Sin representante.
    pkg_lego_inserts_t.SP_INSERT_FAN('MATEO', 'ROJAS', 'SILVA', v_id_pais_cl, DATE '2005-11-11', 'DOC-FAN-CL-10', NULL, NULL, 'PASS-FAN-10', DATE '2034-11-11', v_id_fan_10);

    COMMIT;

    -- Disable triggers to insert historical data
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRIPCION_FECHA_INICIO DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_INSCRITO_FECHA_INICIO DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_ENTRADA_FECHA_INICIO DISABLE';

    -- INSCRIPCIONES, INSCRITOS, ENTRADAS

    -- Inscription 1 for Tour in 2024 (Cliente 1 y Fan 1)
    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2024-01-10', DATE '2023-12-01', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-10', v_num_inscripcion, NULL, v_id_cliente_1, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-10', v_num_inscripcion, v_id_fan_1, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2024-01-10';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2024-01-10' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-10', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-10', v_num_inscripcion, 'MENOR', v_num_entrada);

    -- Inscription 2 for Tour in 2024 (Cliente 2, Cliente 5, Fan 2)
    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2024-01-15', DATE '2023-12-10', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, NULL, v_id_cliente_2, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, NULL, v_id_cliente_5, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2024-01-15', v_num_inscripcion, v_id_fan_2, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2024-01-15';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 3) WHERE F_INICIO = DATE '2024-01-15' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2024-01-15', v_num_inscripcion, 'MENOR', v_num_entrada);

    -- Inscription 3 for Tour in 2025 (Cliente 3, Fan 3)
    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-01', DATE '2025-04-01', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-01', v_num_inscripcion, NULL, v_id_cliente_3, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-01', v_num_inscripcion, v_id_fan_3, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-01';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2025-05-01' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-01', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-01', v_num_inscripcion, 'MENOR', v_num_entrada);

    -- Inscription 4 for Tour in 2025 (Cliente 4, Fan 4)
    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-05', DATE '2025-04-15', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-05', v_num_inscripcion, NULL, v_id_cliente_4, v_inscrito_id);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-05', v_num_inscripcion, v_id_fan_4, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-05';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 2) WHERE F_INICIO = DATE '2025-05-05' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-05', v_num_inscripcion, 'REGULAR', v_num_entrada);
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-05', v_num_inscripcion, 'MENOR', v_num_entrada);

    -- Inscription 5 for Tour in 2025 (Fan 5 only)
    pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(DATE '2025-05-08', DATE '2025-04-20', 'PENDIENTE', 0, v_num_inscripcion);
    pkg_lego_inserts_t.SP_INSERT_INSCRITO(DATE '2025-05-08', v_num_inscripcion, v_id_fan_5, NULL, v_inscrito_id);
    SELECT PRECIO_PERSONA INTO v_precio_tour FROM INSIDE_TOURS WHERE F_INICIO = DATE '2025-05-08';
    UPDATE INSCRIPCIONES_TOUR SET STATUS_CONF = 'PAGO', TOTAL = (v_precio_tour * 1) WHERE F_INICIO = DATE '2025-05-08' AND NUM_INSCRIPCION = v_num_inscripcion;
    pkg_lego_inserts_t.SP_INSERT_ENTRADA(DATE '2025-05-08', v_num_inscripcion, 'MENOR', v_num_entrada);

    COMMIT;

    -- Re-enable triggers
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