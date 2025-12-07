-- Triggers

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
    IF :NEW.FECHA_NAC <= ADD_MONTHS(SYSDATE, -12*21) THEN
        RAISE_APPLICATION_ERROR(-20102, 'Fan must be younger than 21 years old');
        DBMS_OUTPUT.PUT_LINE('FAN DEBE SER MENOR A 21 AÑOS');
    END IF;

    IF :NEW.FECHA_NAC > ADD_MONTHS(SYSDATE, -12*18) AND :NEW.ID_REPRESENTANTE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20103, 'Fan under 18 must have a representative (ID_REPRESENTANTE)');
        DBMS_OUTPUT.PUT_LINE('FAN MENOR A 18 AÑOS REQUIERE REPRESENTANTE');
    END IF;

    BEGIN
        SELECT UNION_EUROPEA INTO v_union_europea FROM PAISES WHERE ID_PAIS = :NEW.NACIMIENTO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_union_europea := 1;
    END;

    IF v_union_europea = 0 THEN
        IF :NEW.NUM_PASS IS NULL OR :NEW.F_VEN_PASS IS NULL THEN
            RAISE_APPLICATION_ERROR(-20104, 'Para nacionalidades fuera de la Union Europea, se requieren NUM_pass y F_VEN_PASS');
        END IF;
    END IF;
END;
/

-- Prevent new INSIDE_TOURS from starting within 3 days of another tour
CREATE OR REPLACE TRIGGER TRG_INSIDE_TOURS_NO_OVERLAP
BEFORE INSERT ON INSIDE_TOURS
FOR EACH ROW
DECLARE
    v_conflicts NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_conflicts
    FROM INSIDE_TOURS t
    WHERE (t.F_INICIO BETWEEN :NEW.F_INICIO -2 AND :NEW.F_INICIO + 2);

    IF v_conflicts > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'INSIDE_TOURS overlap: F_INICIO en conflicto con otro tour planificado');
    END IF;
END;
/

-- Ensure legal representative is part of same INSCRIPCION_TOUR when inserting a minor
CREATE OR REPLACE TRIGGER TRG_INSCRITOS_MINOR_REP_CHECK
BEFORE INSERT ON INSCRITOS
FOR EACH ROW
DECLARE
    v_fan_fecha DATE;
    v_rep_id NUMBER(4);
    v_rep_exists NUMBER;
BEGIN
    IF :NEW.PARTICIPANTE_MENOR IS NOT NULL THEN
        BEGIN
            SELECT FECHA_NAC, ID_REPRESENTANTE INTO v_fan_fecha, v_rep_id
            FROM FANS_MENOR_LEGO
            WHERE ID_FAN = :NEW.PARTICIPANTE_MENOR;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20024, 'Fan referenciado no exite');
        END;

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
    IF :NEW.F_INICIO < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20030, 'No se puede crear una entrada para un tour cuya fecha de inicio ya ha pasado.');
    END IF;
END;
/

COMMIT;

-- Verifica que la HORA_FIN sea mayor a HORA_INICIO
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
