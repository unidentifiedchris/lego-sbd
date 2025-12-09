-- =================================================================
-- flujo_facturas_online.sql
--
-- Plantilla para probar el procedimiento de registro de ventas online
-- y el sistema de puntos de lealtad (REGISTRAR_VENTA_LEGO_ONLINE).
--
-- Utiliza este script para simular una compra online, especificando
-- el cliente y los artículos (juguetes y cantidad) en el carrito.
-- El script está diseñado para no dejar datos de prueba en la base de datos.
-- =================================================================

SELECT * FROM V_CLIENTES_LEGO;
/


SET SERVEROUTPUT ON;

DECLARE
    -- =================================================================
    -- PARÁMETROS DE LA PRUEBA (MODIFICAR ESTOS VALORES)
    -- =================================================================
    p_id_cliente    CLIENTES_LEGO.ID_CLIENTE%TYPE := 1; -- << ID del cliente que realiza la compra
    p_items         T_VENTA_ITEM_TAB;                   -- << Colección de artículos en el carrito

BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('Iniciando prueba para REGISTRAR_VENTA_LEGO_ONLINE...');
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    -- =================================================================
    -- BLOQUE 1: (Opcional) Configuración de datos de prueba
    -- Descomenta y adapta este bloque si necesitas insertar datos
    -- temporales para tu prueba (clientes, juguetes, precios, etc.).
    -- =================================================================
    /*
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- SETUP: Insertando datos de prueba ---');
    -- Ejemplo: Crear un cliente de prueba
    -- pkg_lego_inserts_t.SP_INSERT_CLIENTE('Loyalty', 'Tester', 'Non-EU', DATE '1990-01-01', 'LOYALTY-TEST-9999', '+123456789', 4, 4, NULL, NULL, NULL, 'loyalty.test@test.com', p_id_cliente);
    */

    -- =================================================================
    -- BLOQUE 2: Ejecución de la Venta Online
    -- =================================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Registrando Venta Online ---');

    -- Define aquí los artículos del carrito de compras.
    -- Cada objeto representa un tipo de juguete y la cantidad deseada.
    p_items := T_VENTA_ITEM_TAB(
        T_VENTA_ITEM_OBJ(9019, 2), -- << Comprando 2 unidades del juguete con ID 9019
        T_VENTA_ITEM_OBJ(9018, 5)  -- << Comprando 5 unidades del juguete con ID 9018
    );

    DBMS_OUTPUT.PUT_LINE(' -> Comprando ' || p_items.COUNT || ' tipo(s) de juguete(s) para el cliente ' || p_id_cliente || '.');

    -- Llamada al procedimiento principal
    REGISTRAR_VENTA_LEGO_ONLINE(
        p_id_cliente   => p_id_cliente,
        p_items        => p_items
    );

    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: El procedimiento REGISTRAR_VENTA_LEGO_ONLINE se ejecutó.');

    -- =================================================================
    -- BLOQUE 3: Limpieza
    -- =================================================================
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


-- Aditional views
SELECT * FROM V_FACTURA_ONLINE_DETALLE_REF;
/
SELECT * FROM V_DETALLE_FACTURA_ONLINE_REF;
/