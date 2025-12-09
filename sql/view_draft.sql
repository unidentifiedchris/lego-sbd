CREATE OR REPLACE VIEW V_FACTURA_FISICA_DETALLE_REF AS
SELECT
    t.NOMBRE AS "Tienda",
    ff.num_factura AS "Numero de Factura",
    c.p_nombre || ' ' || c.p_apellido AS "Nombre del Cliente",
    c.num_doc AS "Documento de Identidad",
    TO_CHAR(ff.fecha_emision, 'YYYY-MM-DD HH24:MI:SS') AS "Fecha de Emision",
    CASE
        -- El País de Residencia del Cliente (c.RESIDENCIA) apunta a PAISES (p.ID_PAIS).
        WHEN p.UNION_EUROPEA = 1 THEN
            ff.total
        -- Uso de la función con el total si no es de la UE.
        ELSE
            FN_CALCULATE_CONVERSION(ff.total, 'D')
    END AS "Total"
FROM
    Factura_Fisica ff,
    TIENDAS t,
    CLIENTES_LEGO c,
    PAISES p
WHERE
    -- Relación: Factura_Fisica (ID_TIENDA) -> TIENDAS (ID_TIENDA)
    ff.id_tienda = t.ID_TIENDA AND
    -- Relación: Factura_Fisica (ID_CLIENTE) -> CLIENTES_LEGO (ID_CLIENTE)
    ff.id_cliente = c.ID_CLIENTE AND
    -- Relación: CLIENTES_LEGO (RESIDENCIA) -> PAISES (ID_PAIS)
    c.RESIDENCIA = p.ID_PAIS;

COMMIT;


DECLARE
    v_id_tema       NUMBER;
    v_id_juguete_1  NUMBER;
    v_total_euro    NUMBER := 50.00;
    v_total_usd     NUMBER;
    -- IDs de clientes y tiendas ya existentes
    v_id_cliente_ue     NUMBER := 2; -- Cliente 2, Residencia: Irlanda (UE=1)
    v_id_cliente_noue   NUMBER := 4; -- Cliente 4, Residencia: Filipinas (UE=0)
    v_id_tienda_ue      NUMBER := 3; -- Tienda 3, Dublín (UE)
    v_id_tienda_noue    NUMBER := 4; -- Tienda 4, Talcahuano (Non-UE)
    
    v_carrito_1 t_number_array := t_number_array();
    v_carrito_2 t_number_array := t_number_array();

BEGIN
    -- 1. Insert TEMAS
    SELECT S_TEMAS.nextval INTO v_id_tema FROM DUAL;
    INSERT INTO TEMAS (ID_TEMA, NOMBRE_TEMA, DESCRIPCION_TEMA, TIPO_TEMA, LICENCIA_EXTERNA)
    VALUES (v_id_tema, 'City', 'Temas de la vida cotidiana en la ciudad.', 'TEMA', 0);

    -- 2. Insert JUGUETES
    SELECT S_JUGUETES.nextval INTO v_id_juguete_1 FROM DUAL;
    INSERT INTO JUGUETES (ID_JUGUETE, ID_TEMA, NOMBRE_JUGUETE, RANGO_EDAD, NUMERO_PIEZAS, ES_SET, RANGO_PRECIO, DESCRIPCION)
    VALUES (v_id_juguete_1, v_id_tema, 'City Police Car', '5+', 94, 1, 'B', 'Un coche de policía compacto y rápido.');

    -- 3. Insertar HISTORICO_PRECIO (Precio actual: 50.00 €)
    INSERT INTO HISTORICO_PRECIO (ID_JUGUETE, FECHA_INICIO, PRECIO, FECHA_FIN)
    VALUES (v_id_juguete_1, TRUNC(SYSDATE) - 30, v_total_euro, NULL);

    -- 4. Insertar LOTES_INVENTARIO
    -- Tienda UE (Irlanda - ID 3)
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (S_LOTES.nextval, v_id_tienda_ue, v_id_juguete_1, 5);
    
    -- Tienda Non-UE (Chile - ID 4)
    INSERT INTO LOTES_INVENTARIO (NUMERO_LOTE, ID_TIENDA, ID_JUGUETE, CANTIDAD)
    VALUES (S_LOTES.nextval, v_id_tienda_noue, v_id_juguete_1, 5);

    -- 5. Venta 1: Cliente UE (ID 2) en Tienda UE (ID 3). 
    v_carrito_1.EXTEND(1);
    v_carrito_1(1) := v_id_juguete_1;
    REGISTRAR_VENTA_LEGO_FISICA(v_id_cliente_ue, v_id_tienda_ue, v_carrito_1);

    -- 6. Venta 2: Cliente Non-UE (ID 4) en Tienda Non-UE (ID 4).
    v_carrito_2.EXTEND(1);
    v_carrito_2(1) := v_id_juguete_1;
    REGISTRAR_VENTA_LEGO_FISICA(v_id_cliente_noue, v_id_tienda_noue, v_carrito_2);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al generar datos de prueba: ' || SQLERRM);
END;
/
-- Consulta la vista para mostrar los resultados de las inserciones de prueba
SELECT * FROM V_FACTURA_FISICA_DETALLE_REF;


CREATE OR REPLACE VIEW V_FACTURA_ONLINE_DETALLE_REF AS
SELECT
    'Online' AS "Canal de Venta",
    fo.num_factura AS "Numero de Factura",
    c.p_nombre || ' ' || c.p_apellido AS "Nombre del Cliente",
    c.num_doc AS "Documento de Identidad",
    TO_CHAR(fo.f_emision, 'YYYY-MM-DD HH24:MI:SS') AS "Fecha de Emision",
    CASE
        -- Se une a PAISES a través de la residencia del cliente.
        WHEN p.UNION_EUROPEA = 1 THEN
            fo.total
        -- Si no es miembro de la UE (UNION_EUROPEA = 0), convierte el total a Dólares.
        ELSE
            FN_CALCULATE_CONVERSION(fo.total, 'D')
    END AS "Total"
FROM
    Factura_Online fo,
    CLIENTES_LEGO c,
    PAISES p
WHERE
    -- Relación: Factura_Online (ID_CLIENTE) -> CLIENTES_LEGO (ID_CLIENTE)
    fo.id_cliente = c.ID_CLIENTE AND
    -- Relación: CLIENTES_LEGO (RESIDENCIA) -> PAISES (ID_PAIS)
    c.RESIDENCIA = p.ID_PAIS;

COMMIT;



DECLARE
    v_id_juguete_1      NUMBER;
    -- IDs de clientes y sus residencias
    v_id_cliente_ue     NUMBER := 2;   -- Cliente Siobhan O'Connor
    v_residencia_ue     NUMBER := 3;   -- Residencia Irlanda (UE=1)
    v_id_cliente_noue   NUMBER := 4;   -- Cliente Thabo Molefe
    v_residencia_noue   NUMBER := 2;   -- Residencia Filipinas (Non-UE=0)

    -- Variables para la venta
    v_items_1 T_VENTA_ITEM_TAB := T_VENTA_ITEM_TAB();
    v_items_2 T_VENTA_ITEM_TAB := T_VENTA_ITEM_TAB();
    
    v_total_online_1    NUMBER;
    v_total_online_2    NUMBER;
    v_total_online_2_usd NUMBER;

BEGIN
    -- 1. Recuperar el ID del juguete insertado previamente
    -- Se asume que 'City Police Car' (con precio) ya existe de la prueba anterior.
    SELECT ID_JUGUETE INTO v_id_juguete_1 FROM JUGUETES WHERE NOMBRE_JUGUETE = 'City Police Car' FETCH FIRST 1 ROWS ONLY;

    -- 2. INSERCIÓN CRÍTICA: Asegurar que el juguete esté en el CATALOGO_PAIS 
    --    para los países de residencia de los clientes (3: Irlanda, 2: Filipinas).
    
    -- Para Cliente UE (Residencia ID 3: Irlanda)
    -- Si el registro ya existe, ignorar el error o usar lógica de upsert (aquí se asume que no existe o se limpia).
    INSERT INTO CATALOGO_PAIS (ID_PAIS, ID_JUGUETE, LIMITE_COMPRA) 
    VALUES (v_residencia_ue, v_id_juguete_1, 10);
    
    -- Para Cliente Non-UE (Residencia ID 2: Filipinas)
    INSERT INTO CATALOGO_PAIS (ID_PAIS, ID_JUGUETE, LIMITE_COMPRA) 
    VALUES (v_residencia_noue, v_id_juguete_1, 10);

    -- 3. Venta 1: Cliente UE (ID 2). Total con impuestos: 52.50
    v_items_1.EXTEND;
    v_items_1(1) := T_VENTA_ITEM_OBJ(v_id_juguete_1, 1);
    REGISTRAR_VENTA_LEGO_ONLINE(v_id_cliente_ue, v_items_1);
    
    -- 4. Venta 2: Cliente Non-UE (ID 4). Total con impuestos: 57.50
    v_items_2.EXTEND;
    v_items_2(1) := T_VENTA_ITEM_OBJ(v_id_juguete_1, 1);
    REGISTRAR_VENTA_LEGO_ONLINE(v_id_cliente_noue, v_items_2);

    -- Cálculos esperados
    v_total_online_1 := 50.00 * 1.05; 
    v_total_online_2 := 50.00 * 1.15;
    v_total_online_2_usd := ROUND(FN_CALCULATE_CONVERSION(v_total_online_2, 'D'), 2);

    DBMS_OUTPUT.PUT_LINE('--- DATOS GENERADOS ---');
    DBMS_OUTPUT.PUT_LINE('Total esperado Factura 1 (Cliente UE): ' || v_total_online_1 || ' (Euros)');
    DBMS_OUTPUT.PUT_LINE('Total esperado Factura 2 (Cliente Non-UE convertido): ' || v_total_online_2_usd || ' (Dólares, ' || v_total_online_2 || ' * 1.16)');

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error al generar datos de prueba online: ' || SQLERRM);
END;
/
-- Consulta la vista para mostrar los resultados de las inserciones de prueba
SELECT * FROM V_FACTURA_ONLINE_DETALLE_REF;


CREATE OR REPLACE VIEW V_DETALLE_FACTURA_FISICA_REF AS
SELECT
    ff.num_factura AS "Numero de Factura",
    TO_CHAR(ff.fecha_emision, 'YYYY-MM-DD HH24:MI:SS') AS "Fecha de Emision",
    j.nombre_juguete AS "Juguete",
    hp.precio AS "Subtotal"
FROM
    Factura_Fisica ff,
    Det_Factura_Fis dff,
    JUGUETES j,
    HISTORICO_PRECIO hp
WHERE
    -- 1. Factura_Fisica a Det_Factura_Fis
    ff.id_tienda = dff.id_tienda 
    AND ff.num_factura = dff.num_factura
    -- 2. Det_Factura_Fis a JUGUETES
    AND dff.id_juguete = j.ID_JUGUETE
    -- 3. JUGUETES/Det_Factura_Fis a HISTORICO_PRECIO (por juguete)
    AND dff.id_juguete = hp.ID_JUGUETE
    -- 4. Condición clave para el rango de precio histórico
    AND ff.fecha_emision >= hp.FECHA_INICIO
    AND (
        hp.FECHA_FIN IS NULL 
        OR ff.fecha_emision <= hp.FECHA_FIN
    )
ORDER BY
    ff.num_factura, dff.id_det_fact;

COMMIT;

select * from v_detalle_factura_fisica_ref;

CREATE OR REPLACE VIEW V_DETALLE_FACTURA_ONLINE_REF AS
SELECT
    fo.num_factura AS "Numero de Factura",
    TO_CHAR(fo.f_emision, 'YYYY-MM-DD HH24:MI:SS') AS "Fecha de Emision",
    j.nombre_juguete AS "Juguete",
    dfo.cantidad AS "Cantidad", -- Nueva columna solicitada
    hp.precio AS "Subtotal Unitario"
FROM
    Factura_online fo,
    Det_Factura_Onl dfo,
    JUGUETES j,
    HISTORICO_PRECIO hp
WHERE
    -- 1. Factura_Online a Det_Factura_Onl
    fo.num_factura = dfo.num_factura
    -- 2. Det_Factura_Onl a JUGUETES (por el ID del juguete)
    AND dfo.id_juguete = j.ID_JUGUETE
    -- 3. JUGUETES/Det_Factura_Onl a HISTORICO_PRECIO (por juguete)
    AND dfo.id_juguete = hp.ID_JUGUETE
    -- 4. Condición clave para el rango de precio histórico
    -- La fecha de emisión de la factura debe ser mayor o igual a la fecha de inicio del precio
    AND fo.f_emision >= hp.FECHA_INICIO
    AND (
        -- Y la fecha de emisión debe ser menor o igual a la fecha de fin del precio (si existe)
        hp.FECHA_FIN IS NULL 
        OR fo.f_emision <= hp.FECHA_FIN
    )
ORDER BY
    fo.num_factura, dfo.id_det_fact;

COMMIT;

select * from v_detalle_factura_online_ref;