SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET ECHO OFF;

SELECT * FROM V_CLIENTES_LEGO;
/

SELECT * FROM V_PRODUCTOS_POR_TIENDA;
/

SELECT * FROM V_CATALOGO_CHILE;
/

SELECT * FROM V_CATALOGO_COREA_SUR;
/

SELECT * FROM V_CATALOGO_FILIPINAS;
/

SELECT * FROM V_CATALOGO_INDONESIA;
/

SELECT * FROM V_CATALOGO_IRLANDA;
/

SELECT * FROM V_CATALOGO_SUDAFRICA;
/

SELECT 
    J.NOMBRE_JUGUETE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP, JUGUETES J
WHERE CP.ID_JUGUETE = J.ID_JUGUETE AND CP.ID_PAIS = &pais_cat
ORDER BY J.NOMBRE_JUGUETE;

DECLARE
    p_id_cliente    CLIENTES_LEGO.ID_CLIENTE%TYPE := &id_cliente;
    p_items         T_VENTA_ITEM_TAB;                  

BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Registrando Venta Online ---');
    p_items := T_VENTA_ITEM_TAB(
        T_VENTA_ITEM_OBJ(11203, 2),
        T_VENTA_ITEM_OBJ(11204, 1)
    );

    DBMS_OUTPUT.PUT_LINE(' -> Comprando ' || p_items.COUNT || ' tipo(s) de juguete(s) para el cliente ' || p_id_cliente || '.');
    REGISTRAR_VENTA_LEGO_ONLINE(
        p_id_cliente   => p_id_cliente,
        p_items        => p_items
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: El procedimiento REGISTRAR_VENTA_LEGO_ONLINE se ejecutó.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Se produjo un error inesperado.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

SELECT * FROM V_FACTURA_ONLINE_DETALLE_REF;
-- WHERE "Numero de Factura" = &num_factura_online;
/

SELECT * FROM V_DETALLE_FACTURA_ONLINE_REF;
-- WHERE "Numero de Factura" = &num_factura_online;
/