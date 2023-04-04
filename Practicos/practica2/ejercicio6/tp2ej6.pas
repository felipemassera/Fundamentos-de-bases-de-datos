Program tp2ej6;
Const 
  valorAlto = 9999;
  df = 10;
Type 
  reporteD = Record
    codigoLocalidad: integer;
    codigoCepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  reporteM = Record
    codigoLocalidad: integer;
    nombreLocalidad: string[30];
    codigoCepa: integer;
    nombreCepa: string[30];
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  End;
  detalle = file Of reporteD;
  maestro = file Of reporteM;
  vDetalle = array [1..10] Of detalle;
  vRegistro = array [1..10] Of reporteD;

Procedure leer (Var det: detalle; Var aux : reporteD);
Begin
  If (Not eof(det)) Then
    read(det, aux)
  Else
    aux.codigoLocalidad := valorAlto;
End;
Procedure minimo( Var vDet: vDetalle ; Var vReg : vRegistro ; Var min: reporteD);
Var 
  i,pos: integer;
Begin
  min.codigoLocalidad := valorAlto;
  min.codigoCepa := valorAlto;
  pos := 0;
  For i:= 1 To df Do
    Begin
      If (vReg[i].codigoLocalidad <= min.codigoLocalidad)And(vReg[i].codigoCepa
         <=min.codigoCepa) Then
        Begin
          min := vReg[i];
          pos := i;
        End;
      If min.codigoLocalidad<>valorAlto Then
        leer(vDet[pos],vReg[pos]);

    End;
End;


procedure verMaestro (var mae: maestro);
var
  regMae: reporteM;
begin
  writeln('');
  writeln('');
  assign(mae, 'maestro');
  reset(mae);
  While (Not eof(mae)) Do
    Begin
      read(mae,regMae);
      writeln('nombreLocalidad: ', regMae.codigoLocalidad, ' codigoCepa: ',
              regMae.codigoCepa);
      writeln('Nuevos: ', regMae.cantNuevos, ' Fallecidos: ', regMae.
              cantFallecidos);
      writeln('Recuperados: ', regMae.cantRecuperados, ' Activos: ',regMae.
              cantActivos);
    End;
  close(mae);
end;
  //ASIGNAR MAESTRO Y DETALLES
  procedure asignarMyD(var mae: maestro; vDet:vDetalle; var vReg:vRegistro);
  var 
    i:integer;
    iString:string[30];
  begin  
  For i:= 1 To df Do
    Begin
      Str(i, iString);
      assign(vDet[i], 'detalle'+iString);
      reset(vDet[i]);
      leer(vDet[i], vReg[i]);
    End;
  assign(mae,'maestro');
  reset(mae);
  end;

Var 
  vDet: vDetalle;
  vReg: vRegistro;
  mae: maestro;
  min: reporteD;
  regMae: reporteM;
  i: integer;
  iString: String;
Begin
  verMaestro(mae);
  asignarMyD(mae,vDet,vReg);

  //ACTUALIZAR MAESTRO
    minimo(vDet, vReg, min);

  While (min.codigoLocalidad <> valorAlto) Do
    Begin
    
      read(mae, regMae);
      
      While (regMae.codigoLocalidad <> min.codigoLocalidad) and (regMae.codigoCepa<>min.codigoCepa)Do begin
        read(mae,regMae);
        end;

      While (regMae.codigoLocalidad = min.codigoLocalidad) Do
        Begin

            while (regMae.codigoCepa = min.codigoCepa) do
            begin
                regMae.cantFallecidos := regMae.cantFallecidos + min.cantFallecidos;
                regMae.cantRecuperados := regMae.cantRecuperados + min.cantRecuperados;
                regMae.cantActivos := min.cantActivos;
                regMae.cantNuevos := min.cantNuevos;
                minimo(vDet, vReg, min);
            end;
            seek(mae, filePos(mae)-1);
            write(mae, regMae);
        End;
    End;


  //CLOSE DE MAESTRO Y DETALLES
  For i:=1 To 10 Do
    close(vDet[i]);
  close(mae);

End.
