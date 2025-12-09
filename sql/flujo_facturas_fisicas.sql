-- =================================================================
-- flujo_facturas_fisicas.sql
--
-- Plantilla para probar el procedimiento de registro de ventas físicas
-- (REGISTRAR_VENTA_LEGO_FISICA).
--
-- Utiliza este script para simular una compra en una tienda física,
-- especificando el cliente, la tienda y los juguetes a comprar.
-- El script está diseñado para no dejar datos de prueba en la base de datos.
-- =================================================================

SELECT * FROM V_HORARIOS_TIENDAS;
/

SELECT * FROM V_CLIENTES_LEGO;
/

SELECT * FROM V_PRODUCTOS_POR_TIENDA;
/

SELECT FN_CALCULAR_STOCK_NETO(1, 9022) AS "Stock Neto Calculado" FROM DUAL;
/

SET SERVEROUTPUT ON;

DECLARE
    -- =================================================================
    -- PARÁMETROS DE LA PRUEBA (MODIFICAR ESTOS VALORES)
    -- =================================================================
    p_id_tienda      TIENDAS.ID_TIENDA%TYPE      := 1; -- << ID de la tienda donde se realiza la compra
    p_id_cliente     CLIENTES_LEGO.ID_CLIENTE%TYPE := 1; -- << ID del cliente que realiza la compra
    p_ids_juguete    T_NUMBER_ARRAY;                      -- << Colección de IDs de juguetes a comprar

BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('Iniciando prueba para REGISTRAR_VENTA_LEGO_FISICA...');
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    -- =================================================================
    -- BLOQUE 1: (Opcional) Configuración de datos de prueba
    -- Descomenta y adapta este bloque si necesitas insertar datos
    -- temporales para tu prueba (juguetes, precios, inventario).
    -- =================================================================
    /*
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- SETUP: Insertando datos de prueba ---');
    -- Ejemplo: Añadir inventario para un juguete existente (ID 1) en la tienda de prueba (ID 1)
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (S_LOTES.nextval, p_id_tienda, 1, 5); -- Añadir 5 unidades del juguete 1
    */

    -- =================================================================
    -- BLOQUE 2: Ejecución de la Venta
    -- =================================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- EJECUCIÓN: Registrando Venta ---');

    -- Define aquí la lista de juguetes que se van a comprar.
    -- Cada ID en el array representa un artículo individual en el carrito.
    p_ids_juguete := T_NUMBER_ARRAY(
        1, -- << ID del primer juguete
        1, -- << ID del segundo juguete (puede ser el mismo)
        2  -- << ID del tercer juguete
    );

    DBMS_OUTPUT.PUT_LINE(' -> Comprando ' || p_ids_juguete.COUNT || ' juguete(s) para el cliente ' || p_id_cliente || ' en la tienda ' || p_id_tienda || '.');

    -- Llamada al procedimiento principal
    REGISTRAR_VENTA_LEGO_FISICA(
        p_id_cliente  => p_id_cliente,
        p_id_tienda   => p_id_tienda,
        p_ids_juguete => T_NUMBER_ARRAY(v_id_juguete_1, v_id_juguete_1, v_id_juguete_2)
    );

    DBMS_OUTPUT.PUT_LINE(' -> ÉXITO: El procedimiento REGISTRAR_VENTA_LEGO_FISICA se ejecutó.');

    -- =================================================================
    -- BLOQUE 3: Limpieza
    -- =================================================================
    --DBMS_OUTPUT.PUT_LINE(CHR(10) || '=================================================================');
    --DBMS_OUTPUT.PUT_LINE('Prueba finalizada. Revirtiendo todos los cambios.');
    --ROLLBACK;
    --DBMS_OUTPUT.PUT_LINE('Rollback completado.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: La prueba falló inesperadamente.');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE || ', SQLERRM: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ADITIONAL VIEWS

--Facturas físicas con total y referencia
SELECT * FROM V_FACTURA_FISICA_DETALLE_REF;
-- WHERE "Numero de Factura" = 1;
/

--Facturas fisicas con sus detalles de compra y subtotales
SELECT * FROM V_DETALLE_FACTURA_FISICA_REF;