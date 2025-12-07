-- User-defined types
CREATE OR REPLACE TYPE t_participant_doc_obj AS OBJECT (
    is_menor NUMBER(1),
    num_doc  VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE t_participant_doc_tab AS TABLE OF t_participant_doc_obj;
/
