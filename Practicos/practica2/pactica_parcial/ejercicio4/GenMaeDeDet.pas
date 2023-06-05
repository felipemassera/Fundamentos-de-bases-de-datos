{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}


program ej4;
const
    valor_alto = 999;
    df =5;
type
  reg = record
    cod_usuario:integer;
    fecha:integer;
    tiempo_sesion:integer;
  end;
  archivo = file of reg;
  v_detalle = array [1..df] of archivo;
  v_registro = array [1..df] of reg;

procedure leer(var a : archivo; var r:reg);
begin
    if (not eof(a)) then
      read(a,r)
    else
      r.cod_usuario := valor_alto;
end;

procedure asignar(var maestro:archivo ; var v_det:v_detalle ; var v_reg:v_registro)
var
    i:integer;
    iString:string;
begin
    for i:=1 to df do begin
        str(i, iString);
        assign(v_det[i], 'detalle'+iString+'.bin');
        reset(v_det[i]);
        leer(v_det[i], v_reg[i]);
    end;
    assign(mae, 'var/log');
    Rewrite(mae);
end;

procedure minimo(var v_det: v_detalle ; var v_reg: v_registro; var min :reg);
var
    i, pos:integer;
begin
    min.cod_usuario:= valor_alto;
    for i:=1 to df do 
      if (v_reg[i].cod_usuario<min.cod_usuario) or ((v_reg[i].cod_usuario = min.cod_usuario) and (v_reg[i].fecha < min.fecha)) then begin
        pos:=i;
        min:= v_reg[i];
      end;
    if (min.cod_usuario<>valor_alto)then
      leer(v_det[pos],v_reg[pos]);
end;

procedure merge(var m: archivo; var v_det: v_detalle; v_reg: v_detalle);
var 
  min : reg;
  actual:reg;
begin
  minimo(v_det, v_reg, min);
  while(min.cod_usuario <> valor_alto) do begin
    actual.cod_usuario:= min.cod_usuario;
    while (actual.cod_usuario = min.cod_usuario) do begin
      actual.fecha:= min.fecha;
      while (actual.fecha = min.fecha) do begin
        actual.tiempo_sesion:= actual.tiempo_sesion + min.tiempo_sesion;
        minimo(v_det, v_reg, min);
    end;
    write(m,actual);
    end;
  end;

end;  


VAR
    v_det:v_detalles;
    v_reg:v_registro;
    mae:archivo;
    i:integer;
BEGIN
    asignar(v_det, v_reg);
    merge(mae, v_det, v_reg);
    for i:=1 to df do
      close(v_det[i]);
    close(mae);
END.
