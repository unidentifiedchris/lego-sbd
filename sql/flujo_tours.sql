SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET ECHO OFF;

UNDEFINE p_num_doc
UNDEFINE p_p_nombre
UNDEFINE p_p_apellido
UNDEFINE p_s_apellido
UNDEFINE p_fecha_nac
UNDEFINE p_telefono
UNDEFINE p_nacimiento_id
UNDEFINE p_residencia_id
UNDEFINE p_s_nombre
UNDEFINE p_num_pass
UNDEFINE p_f_ven_pass
UNDEFINE p_email
UNDEFINE p_id_representante
UNDEFINE p_f_inicio
UNDEFINE p_num_inscripcion

SELECT * FROM V_INSIDE_TOURS_SUMMARY;
/


DECLARE
    v_num_doc           VARCHAR2(50) := UPPER('&p_num_doc');
    v_participant_id    NUMBER;
    v_source_table      NUMBER;
BEGIN

    SP_GET_PARTICIPANT_BY_DOC(v_num_doc, v_participant_id, v_source_table);

    IF v_participant_id IS NOT NULL THEN
        IF v_source_table = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Result: PARTICIPANTE ENCONTRADO EN LA TABLA LEGO_CLEINTES CON ID:: ' || v_participant_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Result: PARTICIPANTE ENCONTRADO EN LA TABLA FANS_LEGO_MENOR CON ID: ' || v_participant_id);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Result: NO SE ENCONTRÓ PARTICIPANTE CON DOCUMENTO:' || v_num_doc);
    END IF;
END;
/

DECLARE
    v_new_id NUMBER;
BEGIN

    pkg_lego_inserts_t.SP_INSERT_CLIENTE(
        p_p_nombre      => UPPER('&p_p_nombre'),
        p_p_apellido    => UPPER('&p_p_apellido'),
        p_s_apellido    => UPPER('&p_s_apellido'),
        p_fecha_nac     => TO_DATE('&p_fecha_nac', 'YYYY-MM-DD'),
        p_num_doc       => UPPER('&p_num_doc'),
        p_telefono      => '&p_telefono',
        p_nacimiento    => TO_NUMBER('&p_nacimiento_id'),
        p_residencia    => TO_NUMBER('&p_residencia_id'),
        p_s_nombre      => UPPER('&p_s_nombre'),
        p_num_pass      => UPPER('&p_num_pass'),
        p_f_ven_pass    => TO_DATE('&p_f_ven_pass', 'YYYY-MM-DD'),
        p_email         => LOWER('&p_email'),
        p_id_out        => v_new_id
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: NUEVO CLIENTE CREADO CON ID: ' || v_new_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: NO SE PUDO CREAR CLIENTE ' || SQLERRM);
        ROLLBACK;
END;
/

DECLARE
    v_new_id NUMBER;
BEGIN

    pkg_lego_inserts_t.SP_INSERT_FAN(
        p_p_nombre          => UPPER('&p_p_nombre'),
        p_p_apellido        => UPPER('&p_p_apellido'),
        p_s_apellido        => UPPER('&p_s_apellido'),
        p_nacimiento        => TO_NUMBER('&p_nacimiento_id'),
        p_fecha_nac         => TO_DATE('&p_fecha_nac', 'YYYY-MM-DD'),
        p_num_doc           => UPPER('&p_num_doc'),
        p_s_nombre          => UPPER('&p_s_nombre'),
        p_id_representante  => TO_NUMBER('&p_id_representante'),
        p_num_pass          => UPPER('&p_num_pass'),
        p_f_ven_pass        => TO_DATE('&p_f_ven_pass', 'YYYY-MM-DD'),
        p_id_out            => v_new_id
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: NUEVO FAN CREADO CON ID: ' || v_new_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: NO SE PUDO INSERTAR FAN ' || SQLERRM);
        ROLLBACK;
END;
/

DECLARE
    v_tour_date             DATE;
    v_participants          t_participant_doc_tab;
    v_new_inscripcion_num   NUMBER;
BEGIN
    -- Interactively build the list of participants
    DBMS_OUTPUT.PUT_LINE('--- Building Participant List for Inscription ---');
    v_tour_date := TO_DATE('&p_f_inicio', 'YYYY-MM-DD');

    v_participants := t_participant_doc_tab(
        t_participant_doc_obj(0, 'DOC-REP-01'),   
        t_participant_doc_obj(1, 'DOC-MINOR-01')  
    );

    DBMS_OUTPUT.PUT_LINE('Calling SP_CREATE_INSCRIPCION_FLOW...');
    pkg_lego_tours.SP_CREATE_INSCRIPCION_FLOW(
        p_f_inicio            => v_tour_date,
        p_participants        => v_participants,
        p_new_inscripcion_out => v_new_inscripcion_num
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: INSCRIPCION CREADA CON NUMERO DE INSCRIPCION: ' || v_new_inscripcion_num || '. Status: PENDIENTE.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Calling SP_FINALIZE_PAYMENT for inscription #&p_num_inscripcion...');
    pkg_lego_tours.SP_FINALIZE_PAYMENT(
        p_f_inicio        => TO_DATE('&p_f_inicio', 'YYYY-MM-DD'),
        p_num_inscripcion => TO_NUMBER('&p_num_inscripcion')
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: Payment finalized and tickets generated.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/


SELECT * FROM V_TOUR_INSCRIPCIONES_CONVERSION;
-- WHERE "Número de Inscripción" = &p_num_inscripcion;
/

SELECT * FROM V_INSCRITOS_DETALLE;
-- WHERE "Número de Inscripción" = &p_num_inscripcion;
/

SELECT * FROM V_ENTRADAS_DETALLE;
-- WHERE "Número de Inscripción" = &p_num_inscripcion;
/