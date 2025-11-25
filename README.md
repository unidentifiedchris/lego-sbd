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
  |Pk|||
  |date|number|number|

## Dependientes

### Juguete
|id_juguete|nombre|rango_edad|numero_piezas|set|rango_precio|descripcion|id_tema|archivo_instrucciones|id_set|
|---|---|---|---|---|---|---|---|---|---|
|Pk||||||||||
|nn|nn|nn|nn|nn|nn|nn|nn|||
||||||||Fk1||Fk2|
|||check(edades)|||check('A','B','C','D')|||||
|number(4)|varchar2|varchar2|number|boolean|char|varchar2|number(4)|varchar2|number(4)|
- chequear los rangos de edades y ponerlos


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
|number(4)|number(4)|number(4)|number(4)|varchar2|varchar2|number|
- Verificar el tipo de dato de telefono_contacto

### Horario
|id_tienda|dia|hora_inicio|hora_fin|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|nn|nn|
||check(1,2,3,4,5,6,7)|||
|Fk||||
|number(4)|number(1)|time|time|
- el check es de los dias de la semana siendo 1 el domingo
- los datos time hay que averiguar cual es el tipo de dato que nos conviene mas lo puse mientras

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
- buscar el mejor tipo de dato para esta fecha

### Catalogo_Pais
|id_pais|id_juguete|limite_compra|
|---|---|---|
|Pk1|Pk1||
|nn|nn|nn|
|Fk1|Fk2||
|number(4)|number(4)|number(2)|
- dudo que limite de compra pase de 2 digitos

### Producto_Relacion
- no se como hacer esta tabla

### Factura_Fisica
|id_tienda|num_factura|id_cliente|fecha_emision|total|
|---|---|---|---|---|
|Pk1|Pk1||||
|nn|nn|nn|nn|nn|
|Fk1||Fk2|||
|number(4)|serial|number(4)|time-stamp|number|
-buscar mejor tipo de dato para la fecha emision

### Det_Factura_Fis
|id_tienda|num_factura|id_det_fact|tipo_cliente|
|---|---|---|---|
|Pk1|Pk1|Pk1||
|nn|nn|nn|nn|nn|
|Fk1|Fk1||||
|number(4)|serial|number(4)|---|
- que va en tipo cliente

### Cliente_Lego
|id_cliente|nacimiento|redicencia|p_nombre|p_apellido|s_apellido|fecha_nac|num_doc|telefono|s_nombre|num_pass|f_ven_pass|email|
|---|---|---|---|---|---|---|---|---|---|---|---|---|
|nn|nn|nn|nn|nn|nn|nn|nn|nn|---|---|---|---|
|Fk1|Fk1|Fk1|---|---|---|---|---|---|---|---|---|---|
||||||||unique|||unique|||
||Fk1|Fk2|||||||||||
|number(4)|number(4)|number(4)|varchar2|varchar2|varchar2|date|varchar2|number|varchar2|varchar2|date|varchar2|
- revisar los fk, esta raro
- formatear el email
- no puede ver nadie menor a 21 anno

### Fan_Menor_Lego
|id_fan|nacimiento|p_nombre|p_apellido|s_apellido|f_nac|num_doc|num_pass|f_ven_pass|id_representante|
|---|---|---|---|---|---|---|---|---|---|
|Fk1|Fk1|||||||||
|nn|nn|nn|nn|nn|nn|nn||||
|||||||unique|unique|||
|number(4)|number(4)|varchar2|varchar2|varchar2|date|varchar2|varchar2|date|number(4)|
- si el fan es menor a 18 annos se requiere el id del participante

### Inscritos
|num_inscripcion|id_inscritos|participante_menor|participante_mayor|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|||
|Fk1||Fk2|Fk3|
|number(4)|number(4)|number(4)|number(4)|
- el participante_menor o participante_menor deben estar insertados pero ambos no deben estar al mismo tiempo

### Entrada
|num_inscripcion|num_entrada|tipo|
|---|---|---|
|Pk1|Pk1||
|nn|nn|nn|
|||check('MENOR','REGULAR)|
|Fk|||
|number(4)|number(4)|varchar2(7)|

### Inscripcion_Tour
|f_inicio|num_inscripcion|total|status_conf|
|---|---|---|---|
|Pk1|Pk1|||
|nn|nn|nn|nn|
|Fk|||check(status)|
|date|number(4)|number|varchar2|
- confirmar cuales son los status de inscripcion
- total es calculado

### Factura_online
|num_factura|f_emision|total|id_cliente|puntos_acum_venta|gratis_lealtad|
|---|---|---|---|---|---|
|Pk||||||
||||Fk|||
|serial|date|number|number(4)|boolean|number|
- toatl es calculado
- puntos-acum-venta es calculado
