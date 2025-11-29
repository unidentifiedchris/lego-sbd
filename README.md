# lego-sbd
LEGO SBD
## TABLAS
## Independientes
### Pais
|id_pais|nombre|nacionadidad|continente|union_europea|
|---|---|---|---|---|
|PK||||||
|nn|nn|nn|nn|nn|nn|
||||check('AMERICA','AFRICA','ASIA','EUROPA','OCEANIA')||
|number(4)|varchar2|varchar2|varchar2(6)|boolean|

### Tema
|id_tema|nombre|descripcion|tipo|id_serie|licencia_esterna|
|---|---|---|---|---|---|
|Pk||||||
|nn|nn|nn|nn|||
||||check('TEMA','SERIE')|||
|||||Fk||
|number(4)|varchar2|varchar2|varchar2(5)|number(4)|boolean|

### Inside_Tour
  |f_inicio|precio_persona|total_cupos|
  |---|---|---|
  |nn|nn|nn|
  |Pk|||
  |date|number(7,2)|number(4)|
- precio del inside tour se guarda en euros en la base de datos
- todos los tour de un mismo anno tienen el mismo precio (verificar manualmente al insertar)
- precio se debe poder convertir a dolares y coronas danesas
- Tours tienen duracion de 3 dias, no se pueden sobrelapar

## Dependientes

### Juguete
|id_juguete|nombre|rango_edad|numero_piezas|set|rango_precio|descripcion|id_tema|archivo_instrucciones|id_set|
|---|---|---|---|---|---|---|---|---|---|
|Pk||||||||||
|nn|nn|nn|nn|nn|nn|nn|nn|||
||||||||Fk1||Fk2|
|||check('0 a 2', '3 a 4', '5 a 6', '7 a 8', '9 a 11', '12+', 'ADULTOS')|||check('A','B','C','D')|||||
|number(4)|varchar2|varchar2|number|boolean|char|varchar2|number(4)|varchar2|number(4)|
- chequear los rangos de edades y ponerlos
- al cambiar el precio del juguete el rango de precio debe ser actualizado segun donde este el nuevo valor 

### Estado
|id_pais|id_estado|nombre|
|---|---|---|
|Pk1|Pk1||
|nn|nn|nn|
|Fk|||
|number(4)|number(4)|varchar2|

### Ciudad
|id_pais|id_estado|id_ciudad|nombre|
|---|---|---|---|
|Pk1|Pk1|Pk1||
|n|nn|nn|nn|
|Fk1|Fk1|||
|number(4)|number(4)|number(4)|varchar2|

### Tienda
|id_tienda|id_pais|id_estado|id_ciudad|nombre(LegoStore+dir)|direccion|telefono_contacto|
|---|---|---|---|---|---|---|
|Pk|||||||
|nn|nn|nn|nn|nn|nn|nn|
||Fk1|Fk1|Fk1||||
|number(4)|number(4)|number(4)|number(4)|varchar2|varchar2|varchar2|
- telefono_contacto es un string de la forma '+000 000 00000000' (internacional - local - numero), se comprueba a traves de una regex ^(\+?\d{1,3})?[\s.-]?(\(?\d{1,4}\)?)?[\s.-]?(\d[\s.-]?){4,14}\d$

### Horario
|id_tienda|dia|hora_inicio|hora_fin|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|nn|nn|
||check(1,2,3,4,5,6,7)|||
|Fk||||
|number(4)|number(1)|date|date|
- el check es de los dias de la semana siendo 1 el domingo
- hora se guarda como tipo date, se asigna una fecha x (1 enero 1999), se agregan los datos de tiempo y se opera con el formato 'HH24:MI:SS'

### Historico_Precio
|id_juguete|fecha_inicio|precio|fecha_fin|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|nn||
|Fk||||
|number(4)|date|number(7,2)|date|
- no pueden existir dos historicos concurrentes del mismo producto, uno debe cerrar antes de abrir otro
- todos los precios se registran en euros en la base de datos
- precio se debe poder convertir a dolares

### Lote_Inventario
|id_tienda|id_juguete|num_lote|cantidad|
|---|---|---|---|
|Pk1|Pk1|Pk1||
|nn|nn|nn|nn|
|Fk1|Fk2|||
|number(4)|number(4)|serial|number|

### Descuento_Inventario
|id_tienda|id_juguete|num_lote|id_desc_inv|fecha|cantidad|
|---|---|---|---|---|----|
|Pk1|Pk1|Pk1|Pk1|||
|nn|nn|nn|nn|nn|nn|
|Fk|Fk|Fk||||
|number(4)|number(4)|serial|number(4)|date|number|
- fecha tiene el formato 'YYYY-MM-DD HH24:MI:SS'

### Catalogo_Pais
|id_pais|id_juguete|limite_compra|
|---|---|---|
|Pk1|Pk1||
|nn|nn|nn|
|Fk1|Fk2||
|number(4)|number(4)|number(2)|
- dudo que limite de compra pase de 2 digitos

### Producto_Relacion
|id_prod_1|id_prod_2|
|---|---|
|Pk1|Pk1|
|nn|nn|
|Fk1|Fk2|
|number(4)|number(4)|

### Factura_Fisica
|id_tienda|num_factura|id_cliente|fecha_emision|total|
|---|---|---|---|---|
|Pk1|Pk1||||
|nn|nn|nn|nn|nn|
|Fk1||Fk2|||
|number(4)|serial|number(4)|time-stamp with local time zone|number|
-buscar mejor tipo de dato para la fecha emision 

### Det_Factura_Fis
|id_tienda|num_factura|id_det_fact|tipo_cliente|
|---|---|---|---|
|Pk1|Pk1|Pk1||
|nn|nn|nn|nn|nn|
|Fk1|Fk1|||check('0 a 2', '3 a 4', '5 a 6', '7 a 8', '9 a 11', '12+', 'ADULTOS')|
|number(4)|serial|number(4)|varchar2|

### Cliente_Lego
|id_cliente|p_nombre|p_apellido|s_apellido|fecha_nac|num_doc|telefono|nacimiento|redicencia|s_nombre|num_pass|f_ven_pass|email|
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|nn|nn|nn|nn|nn|nn|nn|nn|nn|---|---|---|---|
|Pk|---|---|---|---|---|---|---|---|---|---|---|---|
||||||unique|||||unique|||
||||||||Fk1|Fk2|||||
|number(4)|varchar2|varchar2|varchar2|date|varchar2|number|number(4)|number(4)|varchar2|varchar2|date|varchar2|
- formato email '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}$'
- no puede haber nadie menor a 21 anno -- edad(fecha_nac)>20
- num_doc unique por pais

### Fan_Menor_Lego
|id_fan|nacimiento|p_nombre|p_apellido|s_apellido|f_nac|num_doc|num_pass|f_ven_pass|id_representante|
|---|---|---|---|---|---|---|---|---|---|
|Fk1|Fk1|||||||||
|nn|nn|nn|nn|nn|nn|nn||||
|||||||unique|unique|||
|number(4)|number(4)|varchar2|varchar2|varchar2|date|varchar2|varchar2|date|number(4)|
- si el fan es menor a 18 annos se requiere el id del id_representante -- edad(f_nac)<19 -> id_representante obligatorio
- un fan debe ser menor a 21 annos -- edad(f_nac)<21
- num_doc unique por pais

### Inscritos
|num_inscripcion|id_inscritos|participante_menor|participante_mayor|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|||
|Fk1||Fk2|Fk3|
|number(4)|number(4)|number(4)|number(4)|
- el participante_menor o participante_mayor deben estar insertados pero ambos no deben estar al mismo tiempo -- check(menor, mayor) if both null or both !null error
- total de inscritos por tour no debe exceder limite de cupos del tour
- si un menor <18 forma parte de una inscripcion, su representante debe formar parte de la misma

### Entrada
|num_inscripcion|num_entrada|tipo|
|---|---|---|
|Pk1|Pk1||
|nn|nn|nn|
|||check('MENOR','REGULAR')|
|Fk|||
|number(4)|number(4)|varchar2(7)|

### Inscripcion_Tour
|f_inicio|num_inscripcion|total|status_conf|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|nn|nn|
|Fk|||check('PENDIENTE', 'PAGO')|
|date|number(4)|number|varchar2|
- total es calculado

### Factura_online
|num_factura|f_emision|total|id_cliente|puntos_acum_venta|gratis_lealtad|
|---|---|---|---|---|---|
|Pk||||||
||||Fk|||
|serial|time-stamp with local time zone|number|number(4)|number(3)|boolean|
- total es calculado
- total: precio productos + recargo (5% UE, 15% el resto)
- puntos-acum-venta es calculado
- gratis lealtad true si acumulado en venta online anterior puntos_acum_venta => 500
- total en una venta gratis solo toma en cuenta el recargo de envio

### Det_Factura_Onl
|num_factura|id_det_fact|cantidad|id_catalog|id_pais|
|---|---|---|---|---|
|Pk1|Pk1||||
|nn|nn|nn|nn|nn|nn|
|Fk1|||Fk2|Fk2|
|serial|number(4)|number(2)|number(4)|number(4)|
