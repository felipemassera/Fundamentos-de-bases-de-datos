
{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}

Program tp3ej6;

Const 
  valor_alto = 9999;

Type 
  prenda = Record
    cod_prenda: integer;
    descripcion: string;
    color: string;
    tipo_prenda: string;
    stock: integer;
    precio: integer;
  End;

  archivo = file Of prenda;
  detalle = file Of integer;

Procedure leer(Var a:archivo; Var p :prenda);
Begin
  If (Not eof(a)) Then
    read(a,p)
  Else
    p.cod_prenda := valor_alto;
End;

Procedure listarArchivo(Var a:archivo);
Var 
  aux: prenda;
Begin
  reset(a);
  While Not eof(a) Do
    Begin
      read(a,aux);
      WriteLn('Codigo: ',aux.cod_prenda,', Descripcion: ', aux.descripcion, ' Stock: ', aux.stock);
    End;
  close(a);
  WriteLn('### Fin Listar Archivo ###');
End;

Procedure actualizar (Var a:archivo ; Var d:detalle);
    Procedure baja(Var a:archivo; cod: integer);

    Var 
    cabecera, aux: prenda;
    swap: integer;
    Begin
    reset(a);
    If Not eof (a) Then read(a,cabecera);
    leer(a,aux);
    While ((aux.cod_prenda<>valor_alto) And (aux.cod_prenda<>cod)) Do
        leer(a,aux);
    If (aux.cod_prenda = cod) Then
        Begin
        swap := ((filepos(a)-1) * -1);          //me guardo la posicion donde vamos a borrar de forma logica.
        seek(a,filepos(a)-1);                 //nos posicionamos en donde esta el archivo que queremos pisar, con el mismo registro, pero con 
        aux.stock := cabecera.stock;          //actualizamos el valor de la posicion de cabecera. 
        write(a,aux);
        cabecera.stock := swap;               //actualizamos hacia adonde apunta la cabecera
        seek(a,0);
        write(a,cabecera);
        End;
    close(a);
    End;
Var 
  cod: Integer;
Begin
  reset(d);
  While Not eof(d) Do
    Begin
      read(d,cod);
      baja(a,cod);
    End;
  close(d);
  WriteLn('***Actualizacion realizada con exito***');
End;

Procedure compactar(Var a: archivo);
Var 
  aux: prenda;
  aux_arch: archivo;
  ok: boolean;
Begin
    Assign(aux_arch,'tp3ej6_mae_compacto');
    reset(a);
    ok:=true;
    Rewrite(aux_arch);
    if not eof(a) then begin  
        while not eof(a) do begin
            read(a,aux);
            if aux.stock > 0 then write(aux_arch,aux);
        end;
    end else begin 
        WriteLn('**** Archivo vacio ****');
        ok:=false;
    end;
    if ok then writeln('*****Archivo compactado con exito*****');
    close(a);
    close(aux_arch);
    //WriteLn('**** LISTAR archivo original ****');              //muestro el archivo antes de borrarlo
    //listarArchivo(a);
    
    erase(a);
    rename(aux_arch,'tp3ej6_mae');
    
    WriteLn('**** LISTAR archivo compactado ****');
    listarArchivo(aux_arch);
end;

Procedure crearArchivos(Var a : archivo; Var d :detalle);
Var 
  t: Text;
  aux: prenda;
  num: integer;
Begin
  assign(t,'tp3ej6_mae.txt');
  reset(t);
  Rewrite(a);
  While Not eof(t) Do
    Begin
      readln(t,aux.cod_prenda,aux.descripcion);
      ReadLn(t, aux.stock,aux.color);
      readln(t,aux.precio,aux.tipo_prenda);
      write(a,aux);
    End;
  close(a);
  close(t);
  assign(t,'tp3ej6_det.txt');
  reset(t);
  Rewrite(d);
  While Not eof (t) Do
    Begin
      readln(t,num);
      write(d,num);
    End;
  close(t);
  close(d);
  writeln('*****Archivo creado con exito*****');
End;



Var 
  a: archivo;
  d: detalle;
Begin
  Assign(a,'tp3ej6_mae');
  Assign(d,'tp3ej6_det');
  crearArchivos(a,d);
  actualizar(a,d);
  compactar(a);
End.
