
SET SERVEROUTPUT ON;
SET DEFINE OFF;

SELECT * FROM V_INSIDE_TOURS_SUMMARY;
/

DECLARE
    v_rep_id NUMBER;
    v_minor_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting test data for tours...');
    /*
    pkg_lego_inserts_t.SP_INSERT_INSIDE_TOUR(
        p_f_inicio       => TO_DATE('2025-12-25', 'YYYY-MM-DD'), -- Provide tour date
        p_total_cupos    => 20,
        p_precio_persona => 150.00
    );

    -- Example: Insert a new client (representative)
    pkg_lego_inserts_t.SP_INSERT_CLIENTE(
        'FirstName', 'LastName', 'SecondLastName', TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD'),
        'DOC-REP-XX', 'PhoneNumber', 1, 1, NULL, 'PassportNum',
        TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD'), 'email@example.com', v_rep_id
    );

    -- Example: Insert a new fan (minor)
    pkg_lego_inserts_t.SP_INSERT_FAN(
        'FirstName', 'LastName', 'SecondLastName', 1, TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD'),
        'DOC-MINOR-XX', NULL, v_rep_id, 'PassportNum',
        TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD'), v_minor_id
    );
    COMMIT;
    */
END;
/

DECLARE
    v_tour_date             DATE := TO_DATE('2025-12-25', 'YYYY-MM-DD'); 
    v_participants          t_participant_doc_tab;
    v_new_inscripcion_num   NUMBER;
BEGIN
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
    DBMS_OUTPUT.PUT_LINE('SUCCESS: Inscription created with NUM_INSCRIPCION: ' || v_new_inscripcion_num || '. Status: PENDIENTE.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

DECLARE
    v_tour_date             DATE := TO_DATE('2025-12-25', 'YYYY-MM-DD'); 
    v_inscripcion_to_pay    NUMBER := 1; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Calling SP_FINALIZE_PAYMENT for inscription #' || v_inscripcion_to_pay || '...');
    pkg_lego_tours.SP_FINALIZE_PAYMENT(
        p_f_inicio        => v_tour_date,
        p_num_inscripcion => v_inscripcion_to_pay
    );
    DBMS_OUTPUT.PUT_LINE('SUCCESS: Payment finalized and tickets generated.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

SELECT * FROM V_TOUR_INSCRIPCIONES_CONVERSION;

SELECT * FROM V_INSCRITOS_DETALLE;

SELECT * FROM V_ENTRADAS_DETALLE;