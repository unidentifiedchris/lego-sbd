SELECT * FROM V_CLIENTES_LEGO;
/

SELECT * FROM V_PRODUCTOS_POR_TIENDA;
/

select * from catalogo_pais;


SELECT * FROM CLIENTES_LEGO;
SET SERVEROUTPUT ON;

DECLARE
    p_id_cliente    CLIENTES_LEGO.ID_CLIENTE%TYPE := 5;
    p_items         T_VENTA_ITEM_TAB;                  

BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('Iniciando prueba para REGISTRAR_VENTA_LEGO_ONLINE...');
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Registrando Venta Online ---');
    p_items := T_VENTA_ITEM_TAB(
        T_VENTA_ITEM_OBJ(11203, 2)
    );

    DBMS_OUTPUT.PUT_LINE(' -> Comprando ' || p_items.COUNT || ' tipo(s) de juguete(s) para el cliente ' || p_id_cliente || '.');
    REGISTRAR_VENTA_LEGO_ONLINE(
        p_id_cliente   => p_id_cliente,
        p_items        => p_items
    );

    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: El procedimiento REGISTRAR_VENTA_LEGO_ONLINE se ejecutó.');

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=================================================================');
    DBMS_OUTPUT.PUT_LINE('Prueba finalizada. Revirtiendo todos los cambios.');
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rollback completado.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: La prueba falló inesperadamente.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

SELECT * FROM V_FACTURA_ONLINE_DETALLE_REF;
/
SELECT * FROM V_DETALLE_FACTURA_ONLINE_REF;
/