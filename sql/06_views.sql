-- Views

-- V_CLIENTES_LEGO
CREATE OR REPLACE VIEW V_CLIENTES_LEGO AS
SELECT
    c.p_nombre AS "Primer Nombre",
    NVL(c.s_nombre, '--') AS "Segundo Nombre",
    c.p_apellido AS "Primer Apellido",
    c.s_apellido AS "Segundo Apellido",
    TO_CHAR(c.fecha_nac, 'YYYY-MM-DD') AS "Fecha de Nacimiento",
    c.num_doc AS "Documento de Identidad",
    p.nombre AS "Pais de Nacimiento",
    r.nombre AS "Pais de Residencia",
    c.telefono AS "Telefono",
    NVL(c.num_pass, '--') AS "Pasaporte",
    NVL(TO_CHAR(c.f_ven_pass, 'YYYY-MM-DD'), '--') AS "Fecha de Vencimiento Pasaporte",
    NVL(c.email, '--') AS "Correo Electronico"
FROM CLIENTES_LEGO c, PAISES p, PAISES r
WHERE c.nacimiento = p.id_pais
  AND c.residencia = r.id_pais;
/

-- V_FANS_MENOR_LEGO
CREATE OR REPLACE VIEW V_FANS_MENOR_LEGO AS
SELECT
    f.p_nombre AS "Primer Nombre",
    NVL(f.s_nombre, '--') AS "Segundo Nombre",
    f.p_apellido AS "Primer Apellido",
    f.s_apellido AS "Segundo Apellido",
    TO_CHAR(f.fecha_nac, 'YYYY-MM-DD') AS "Fecha de Nacimiento",
    f.num_doc AS "Documento de Identidad",
    p.nombre AS "Pais de Nacimiento",
    NVL(f.num_pass, '--') AS "Pasaporte",
    NVL(TO_CHAR(f.f_ven_pass, 'YYYY-MM-DD'), '--') AS "Fecha de Vencimiento Pasaporte",
    NVL(TRIM(c.p_nombre || ' ' || c.s_nombre || ' ' || c.p_apellido || ' ' || c.s_apellido), '--') AS "Nombre Representante",
    NVL(c.num_doc, '--') AS "Documento de Identidad Representante"
FROM FANS_MENOR_LEGO f, PAISES p, CLIENTES_LEGO c
WHERE f.nacimiento = p.id_pais
  AND f.id_representante = c.id_cliente (+);
/

-- V_INSIDE_TOURS_SUMMARY
CREATE OR REPLACE VIEW V_INSIDE_TOURS_SUMMARY AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    it.precio_persona AS "Precio por Persona",
    (it.total_cupos - FN_COUNT_INSCRITOS_BY_DATE(it.f_inicio)) AS "Cupos Disponibles"
FROM INSIDE_TOURS it;
/

-- V_TOUR_INSCRIPCIONES
CREATE OR REPLACE VIEW V_TOUR_INSCRIPCIONES AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    ins.num_inscripcion AS "Numero de Inscripcion",
    TO_CHAR(ins.f_inscripcion, 'YYYY-MM-DD') AS "Fecha de Inscripcion",
    ins.total AS "Total a Pagar",
    ins.status_conf AS "Estatus de Confirmacion"
FROM INSIDE_TOURS it, INSCRIPCIONES_TOUR ins
WHERE it.f_inicio = ins.f_inicio (+);
/

-- V_INSCRITOS_DETALLE
CREATE OR REPLACE VIEW V_INSCRITOS_DETALLE AS
SELECT
    i.num_inscripcion AS "Numero de Inscripcion",
    CASE WHEN i.participante_mayor IS NOT NULL THEN 'Mayor' ELSE 'Menor' END AS "Tipo",
    NVL(c.p_nombre, f.p_nombre) AS "Nombre",
    NVL(c.p_apellido, f.p_apellido) AS "Apellido"
FROM INSCRITOS i, CLIENTES_LEGO c, FANS_MENOR_LEGO f
WHERE i.participante_mayor = c.id_cliente (+)
  AND i.participante_menor = f.id_fan (+)
ORDER BY i.num_inscripcion, i.id_inscritos;
/

-- V_ENTRADAS_DETALLE
CREATE OR REPLACE VIEW V_ENTRADAS_DETALLE AS
SELECT
    num_inscripcion AS "Numero de Inscripcion",
    num_entrada AS "Numero de Entrada",
    tipo AS "Tipo de Entrada"
FROM ENTRADAS
ORDER BY num_inscripcion, num_entrada;
/

-- V_TOUR_INSCRIPCIONES_CONVERSION
CREATE OR REPLACE VIEW V_TOUR_INSCRIPCIONES_CONVERSION AS
SELECT
    TO_CHAR(it.f_inicio, 'YYYY-MM-DD') AS "Fecha de Inicio",
    TO_CHAR(it.f_inicio + 2, 'YYYY-MM-DD') AS "Fecha de Fin",
    ins.num_inscripcion AS "Numero de Inscripcion",
    TO_CHAR(ins.f_inscripcion, 'YYYY-MM-DD') AS "Fecha de Inscripcion",
    ins.total AS "Total Euros",
    FN_CALCULATE_CONVERSION(ins.total, 'D') AS "Total Dolares",
    FN_CALCULATE_CONVERSION(ins.total, 'C') AS "Total Coronas Danesas",
    ins.status_conf AS "Estatus de Confirmacion"
FROM INSIDE_TOURS it, INSCRIPCIONES_TOUR ins
WHERE it.f_inicio = ins.f_inicio;
/

-- V_HORARIOS_TIENDAS (note: requires revisiting aliases/columns before use)
CREATE OR REPLACE VIEW V_HORARIOS_TIENDAS AS
SELECT *
FROM (
    SELECT 
        J.NOMBRE AS JUGUETE,
        J.DESCRIPCION AS DESCRIPCION
    FROM JUGUETES J
    JOIN HORARIOS H ON T.ID_TIENDA = H.ID_TIENDA
)
PIVOT (
    MAX(HORARIO)
    FOR NUM_DIA_SEMANA IN (
        '2' AS LUNES,
        '3' AS MARTES,
        '4' AS MIERCOLES,
        '5' AS JUEVES,
        '6' AS VIERNES,
        '7' AS SABADO,
        '1' AS DOMINGO
    )
)
ORDER BY TIENDA;
/

-- V_CATALOGO_SUDAFRICA
CREATE OR REPLACE VIEW V_CATALOGO_SUDAFRICA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 1
ORDER BY J.NOMBRE;
/

-- V_CATALOGO_FILIPINAS
CREATE OR REPLACE VIEW V_CATALOGO_FILIPINAS AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 2
ORDER BY J.NOMBRE;
/

-- V_CATALOGO_IRLANDA
CREATE OR REPLACE VIEW V_CATALOGO_IRLANDA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 3
ORDER BY J.NOMBRE;
/

-- V_CATALOGO_CHILE
CREATE OR REPLACE VIEW V_CATALOGO_CHILE AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 4
ORDER BY J.NOMBRE;
/

-- V_CATALOGO_INDONESIA
CREATE OR REPLACE VIEW V_CATALOGO_INDONESIA AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 5
ORDER BY J.NOMBRE;
/

-- V_CATALOGO_COREA_SUR
CREATE OR REPLACE VIEW V_CATALOGO_COREA_SUR AS
SELECT 
    J.NOMBRE AS JUGUETE,
    CP.LIMITE_COMPRA AS "Límite de Compra"
FROM CATALOGO_PAIS CP
JOIN JUGUETES J ON CP.ID_JUGUETE = J.ID_JUGUETE
WHERE CP.ID_PAIS = 6
ORDER BY J.NOMBRE;
/
