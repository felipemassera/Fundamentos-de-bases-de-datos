

{18 . Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
nombre_hospital, fecha y cantidad de casos positivos detectados.
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
NombreHospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.}

Program tp2ej18;
Const 
  valor_alto = 9999;
Type 
  registro = Record
    cod_loc: integer;
    nombre_loc: String;
    cod_muni: integer;
    nombre_muni: String;
    cod_hosp: integer;
    nombre_hosp: String;
    fecha: integer;
    positivos: integer;
  End;
  maestro = file Of registro;

Procedure leer(Var m:maestro;Var aux: registro);
Begin
  If (Not eof (m))Then
    read(m,aux)
  Else
    aux.cod_loc := valor_alto;
End;

procedure cumpleCondicion(reg : registro; tot: integer;var txt:Text);
begin
  if (tot>1500) then begin
    writeln(txt, reg.nombre_loc);
    writeln(txt, reg.nombre_muni);
    Writeln(txt, tot);
  end;
end;

Procedure procesarMae(Var m:maestro);
Var 
  aux,actual: registro;
  totProv,totLoc,totMuni,totHosp: integer;
  txt:text;
Begin
  //orden: localidad, luego por municipio y luego por hospital
  assign(txt,'reporte.txt');
  Rewrite(txt);
  assign(m,'maestro.bin');
  reset(m);
  leer(m,aux);
  totProv := 0;
  While aux.cod_loc<>valor_alto Do
    Begin
      actual.cod_loc := aux.cod_loc;
      actual.nombre_loc := aux.nombre_loc;
      totLoc := 0;
      WriteLn('Localidad: ', actual.nombre_loc);
      While (aux.cod_loc = actual.cod_loc) Do Begin
          actual.cod_muni := aux.cod_muni;
          actual.nombre_muni := aux.nombre_muni;
          WriteLn('Municipio: ',actual.nombre_muni);
          totMuni := 0;
          While ((aux.cod_loc = actual.cod_loc) And (aux.cod_muni=actual.cod_muni)) Do Begin
              actual.cod_hosp := aux.cod_hosp;
              actual.nombre_hosp := aux.nombre_hosp;
              WriteLn('Hospital: ',actual.nombre_hosp);
              totHosp := 0;
              While ((aux.cod_loc = actual.cod_loc) And (aux.cod_muni=actual.cod_muni)And (aux.cod_hosp = actual.cod_hosp)) Do Begin
                  totHosp := totHosp + aux.positivos;
                  leer(m,aux);
                End;
              WriteLn(' Cantidad de casos Hospital ',actual.nombre_hosp,': ',totHosp);
              totMuni := totMuni + totHosp;
            End;
          WriteLn('Cantidad de casos Municipio ',actual.nombre_muni,': ',totMuni );
          cumpleCondicion(actual,totMuni,txt);
          totLoc := totLoc + totMuni;
        End;
      totProv := totProv + totLoc;
      WriteLn('Cantidad de casos Localidad ',actual.nombre_loc,': ',totLoc);
    End;
   WriteLn('Cantidad de casos de la Provincia',totProv);
   close(m);
   close(txt);
End;

procedure crearBin(var m:maestro);
var
    txt :Text;
    aux:registro;
begin
    assign(txt,'maestro.txt');
    reset(txt);
    assign(m,'maestro.bin');
    Rewrite(m);
    while (not eof(txt)) do begin
        readln(txt,aux.cod_loc,aux.nombre_loc);
        readln(txt, aux.cod_muni,aux.nombre_muni);
        readln(txt, aux.cod_hosp, aux.nombre_hosp);
        readln(txt, aux.fecha,aux.positivos);
        write(m,aux);
    end;
    close(m);
    close(txt);
    WriteLn('Maestro creado con exito');
end;
Var 
  m: maestro;
Begin
  crearBin(m);
  procesarMae(m);
End.