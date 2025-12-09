-- =================================================================
-- flujo_tours.sql
--
-- This script provides templates for testing the tour inscription
-- and payment finalization flows separately.
-- =================================================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

-- 1. (Optional) View available tours to get a valid F_INICIO
SELECT * FROM V_INSIDE_TOURS_SUMMARY;
/
-- 2. (Optional) Use this block to insert new test data if needed.
-- Ensure the data is rolled back or cleaned up after testing.
DECLARE
    v_rep_id NUMBER;
    v_minor_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting test data for tours...');
    -- Example: Insert a new tour
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

-- =================================================================
-- BLOCK 3: Create a new Inscription
-- =================================================================
DECLARE
    v_tour_date             DATE := TO_DATE('2025-12-25', 'YYYY-MM-DD'); -- << SET TOUR DATE
    v_participants          t_participant_doc_tab;
    v_new_inscripcion_num   NUMBER;
BEGIN
    -- Define the list of participants for this inscription
    v_participants := t_participant_doc_tab(
        -- Add participants here using their document numbers
        -- t_participant_doc_obj(is_menor, num_doc)
        -- is_menor: 0 for adult (CLIENTES_LEGO), 1 for minor (FANS_MENOR_LEGO)
        t_participant_doc_obj(0, 'DOC-REP-01'),   -- << SET Representative Document
        t_participant_doc_obj(1, 'DOC-MINOR-01')  -- << SET Minor Document
    );

    -- Call the procedure to create the inscription
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

-- =================================================================
-- BLOCK 4: Finalize Payment for an Inscription
-- =================================================================
DECLARE
    v_tour_date             DATE := TO_DATE('2025-12-25', 'YYYY-MM-DD'); -- << SET TOUR DATE
    v_inscripcion_to_pay    NUMBER := 1; -- << SET INSCRIPTION NUMBER TO PAY
BEGIN
    -- Call the procedure to finalize payment and generate tickets
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


-- ADITIONAL VIEWS

--Inscripciones + precios
SELECT * FROM V_TOUR_INSCRIPCIONES_CONVERSION;
--WHERE "Numero de Inscripción" = 1;

--Inscripciones + participantes
SELECT * FROM V_INSCRITOS_DETALLE;

--Inscripciones + entradas
SELECT * FROM V_ENTRADAS_DETALLE;