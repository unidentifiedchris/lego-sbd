-- Functions and Packages

CREATE OR REPLACE FUNCTION FN_CALCULATE_CONVERSION(
    p_value IN NUMBER,
    p_operation_type IN VARCHAR2
) RETURN NUMBER IS
BEGIN
    CASE UPPER(p_operation_type)
        WHEN 'D' THEN
            RETURN p_value * 1.16;
        WHEN 'C' THEN
            RETURN p_value * 7.47;
        ELSE
            RAISE_APPLICATION_ERROR(-20050, 'Tipo de operación inválido. Use ''D'' o ''C''.');
    END CASE;
END FN_CALCULATE_CONVERSION;
/

CREATE OR REPLACE FUNCTION FN_COUNT_INSCRITOS_BY_DATE(
    p_f_inicio IN DATE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM INSCRITOS WHERE F_INICIO = p_f_inicio;
    RETURN v_count;
END FN_COUNT_INSCRITOS_BY_DATE;
/

CREATE OR REPLACE FUNCTION FN_COUNT_INSCRIPCIONES_BY_DATE(
    p_f_inicio IN DATE
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM INSCRIPCIONES_TOUR WHERE F_INICIO = p_f_inicio;
    RETURN v_count;
END FN_COUNT_INSCRIPCIONES_BY_DATE;
/

CREATE OR REPLACE FUNCTION FN_COUNT_INSCRITOS_BY_INSCRIPCION(
    p_f_inicio IN DATE,
    p_num_inscripcion IN NUMBER
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
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

CREATE OR REPLACE PACKAGE BODY pkg_lego_deletes_t AS
   PROCEDURE SP_DELETE_PAIS(p_id_pais IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_id_pais IS NOT NULL THEN
         FOR r_cli IN (SELECT id_cliente FROM CLIENTES_LEGO WHERE nacimiento = p_id_pais OR residencia = p_id_pais) LOOP
            SP_DELETE_CLIENTE(r_cli.id_cliente);
         END LOOP;
         DELETE FROM PAISES WHERE ID_PAIS = p_id_pais;
      ELSE
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
         DELETE FROM INSCRITOS
         WHERE F_INICIO = p_f_inicio
           AND NUM_INSCRIPCION = p_num_inscripcion
           AND ID_INSCRITOS = p_id_inscrito;
      ELSE
         DELETE FROM INSCRITOS;
      END IF;
   END SP_DELETE_INSCRITO;

   PROCEDURE SP_DELETE_ENTRADA(p_f_inicio IN DATE DEFAULT NULL, p_num_inscripcion IN NUMBER DEFAULT NULL, p_num_entrada IN NUMBER DEFAULT NULL) IS
   BEGIN
      IF p_f_inicio IS NOT NULL AND p_num_inscripcion IS NOT NULL AND p_num_entrada IS NOT NULL THEN
         DELETE FROM ENTRADAS
         WHERE F_INICIO = p_f_inicio
           AND NUM_INSCRIPCION = p_num_inscripcion
           AND NUM_ENTRADA = p_num_entrada;
      ELSE
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
   PROCEDURE SP_CREATE_INSCRIPCION_FLOW(
      p_f_inicio            IN DATE,
      p_participants        IN t_participant_doc_tab,
      p_new_inscripcion_out OUT NUMBER
   );

   PROCEDURE SP_FINALIZE_PAYMENT(
      p_f_inicio IN DATE,
      p_num_inscripcion IN NUMBER
   );
END pkg_lego_tours;
/

CREATE OR REPLACE PACKAGE BODY pkg_lego_tours AS
   PROCEDURE SP_CREATE_INSCRIPCION_FLOW(
      p_f_inicio            IN DATE,
      p_participants        IN t_participant_doc_tab,
      p_new_inscripcion_out OUT NUMBER
   ) IS
      v_total_cupos      NUMBER;
      v_precio_persona   NUMBER(7, 2);
      v_tour_exists      NUMBER;
      v_current_inscritos_count NUMBER;
      v_new_participant_count   NUMBER;
      v_new_inscripcion_num NUMBER;
      v_inscrito_id         NUMBER;
      v_cliente_id          NUMBER;
      v_fan_id              NUMBER;
      v_fan_fecha_nac       DATE;
      v_fan_rep_id          NUMBER;
      v_rep_is_in_list      BOOLEAN;
      v_total_calculado     NUMBER(9, 2);
      e_participant_not_found EXCEPTION;
      PRAGMA EXCEPTION_INIT(e_participant_not_found, -20003);
      e_tour_not_found   EXCEPTION;
      e_no_capacity      EXCEPTION;
      PRAGMA EXCEPTION_INIT(e_tour_not_found, -20001);
      PRAGMA EXCEPTION_INIT(e_no_capacity, -20002);
   BEGIN
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
            IF SQLCODE = -54 THEN
               RAISE_APPLICATION_ERROR(-20010, 'El registro del tour está siendo utilizado por otra transacción. Intente de nuevo.');
            ELSE
               RAISE;
            END IF;
      END;

      v_current_inscritos_count := FN_COUNT_INSCRITOS_BY_DATE(p_f_inicio => p_f_inicio);
      v_new_participant_count := p_participants.COUNT;

      IF (v_current_inscritos_count + v_new_participant_count) > v_total_cupos THEN
         RAISE_APPLICATION_ERROR(-20002, 'No hay cupos suficientes para el tour. Cupos disponibles: ' || (v_total_cupos - v_current_inscritos_count));
      END IF;

      pkg_lego_inserts_t.SP_INSERT_INSCRIPCION(
         p_f_inicio          => p_f_inicio,
         p_status_conf       => 'PENDIENTE',
         p_num_inscripcion   => v_new_inscripcion_num
      );

      p_new_inscripcion_out := v_new_inscripcion_num;

      FOR i IN 1 .. p_participants.COUNT LOOP
         IF p_participants(i).is_menor = 0 THEN
            BEGIN
               SELECT ID_CLIENTE INTO v_cliente_id FROM CLIENTES_LEGO WHERE NUM_DOC = p_participants(i).num_doc;
               pkg_lego_inserts_t.SP_INSERT_INSCRITO(
                  p_f_inicio           => p_f_inicio,
                  p_num_inscripcion    => v_new_inscripcion_num,
                  p_participante_mayor => v_cliente_id,
                  p_id_out             => v_inscrito_id
               );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20003, 'El participante adulto con NUM_DOC ' || p_participants(i).num_doc || ' no fue encontrado en CLIENTES_LEGO.');
            END;
         END IF;
      END LOOP;

      FOR i IN 1 .. p_participants.COUNT LOOP
         IF p_participants(i).is_menor = 1 THEN
            BEGIN
               SELECT ID_FAN INTO v_fan_id FROM FANS_MENOR_LEGO WHERE NUM_DOC = p_participants(i).num_doc;
               pkg_lego_inserts_t.SP_INSERT_INSCRITO(
                  p_f_inicio           => p_f_inicio,
                  p_num_inscripcion    => v_new_inscripcion_num,
                  p_participante_menor => v_fan_id,
                  p_id_out             => v_inscrito_id
               );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20003, 'El participante menor con NUM_DOC ' || p_participants(i).num_doc || ' no fue encontrado en FANS_MENOR_LEGO.');
               WHEN OTHERS THEN
                  IF SQLCODE = -20026 THEN
                     RAISE_APPLICATION_ERROR(-20026, 'Error de validación: El representante legal de un menor de 18 años debe estar incluido en la misma inscripción.');
                  ELSE
                     RAISE;
                  END IF;
            END;
         END IF;
      END LOOP;

      v_new_participant_count := FN_COUNT_INSCRITOS_BY_INSCRIPCION(
         p_f_inicio        => p_f_inicio,
         p_num_inscripcion => v_new_inscripcion_num
      );

      v_total_calculado := v_new_participant_count * v_precio_persona;

      UPDATE INSCRIPCIONES_TOUR
      SET TOTAL = v_total_calculado
      WHERE F_INICIO = p_f_inicio
        AND NUM_INSCRIPCION = v_new_inscripcion_num;

      DBMS_OUTPUT.PUT_LINE('Esperando por pago');

      COMMIT;
   END SP_CREATE_INSCRIPCION_FLOW;

   PROCEDURE SP_FINALIZE_PAYMENT(
      p_f_inicio IN DATE,
      p_num_inscripcion IN NUMBER
   ) IS
   BEGIN
      UPDATE INSCRIPCIONES_TOUR
      SET STATUS_CONF = 'PAGO'
      WHERE F_INICIO = p_f_inicio
        AND NUM_INSCRIPCION = p_num_inscripcion;

      FOR r_inscrito IN (SELECT PARTICIPANTE_MENOR, PARTICIPANTE_MAYOR FROM INSCRITOS WHERE F_INICIO = p_f_inicio AND NUM_INSCRIPCION = p_num_inscripcion) LOOP
         DECLARE
            v_tipo_entrada VARCHAR2(7) := CASE WHEN r_inscrito.PARTICIPANTE_MENOR IS NOT NULL THEN 'MENOR' ELSE 'REGULAR' END;
            v_num_entrada  NUMBER;
         BEGIN
            pkg_lego_inserts_t.SP_INSERT_ENTRADA(p_f_inicio, p_num_inscripcion, v_tipo_entrada, v_num_entrada);
         END;
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('Inscripcion paga');

      COMMIT;
   END SP_FINALIZE_PAYMENT;
END pkg_lego_tours;
/

-- Indicates if a store is open at a given datetime
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
