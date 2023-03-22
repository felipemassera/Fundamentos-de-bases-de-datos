{5. Realizar un programa para una tienda de celulares, que presente un menú con
  opciones para:
  a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
  ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
  correspondientes a los celulares, deben contener: código de celular, el nombre,
  descripción, marca, precio, stock mínimo y el stock disponible.
  b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
  stock mínimo.
  c. Listar en pantalla los celulares del archivo cuya descripción contenga una
  cadena de caracteres proporcionada por el usuario.
  d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
  “celulares.txt” con todos los celulares del mismo. El archivo de texto generado
  podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
  debería respetar el formato dado para este tipo de archivos en la NOTA 2.
  NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
  NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
  tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
  marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
  nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
  “celulares.txt”
  }
program ejercicio5;
 type
    celular = record
        cod : Integer;
        nombre : String[30];
        descripcion: String;
        marca: String[20];
        precio : double;
        stock_min: integer;
        stock_disponible: Integer; 
    end;
    archivo = file of celular;


 procedure crearBin(var arch : archivo; nombre: String); //INCISO A
  var
    lista : Text;
    aux : celular;
  begin
    Assign(arch, nombre);
    Rewrite(arch);
    Assign(lista, 'celulares.txt');
    Reset(lista);
    while not eof (lista) do begin
      with aux do begin
       readln(lista, cod, precio, marca);
       readln(lista, stock_disponible, stock_min, descripcion);
       readln(lista, nombre);
      end;
       write(arch,aux);
    end;
    WriteLn('Archivo Bin creado con exito');
    close(arch); 
    close(lista);
  end;
 procedure listarMin(var arch : archivo; nombre: String);
  var
    aux :celular;
    ok: Boolean;
  begin
    ok:= False;
    Assign(arch,nombre);
    reset(arch);
    WriteLn(' Listado de celulares con stock menor al minimo: ');
    while not eof (arch) do begin
      read(arch,aux);
      if (aux.stock_disponible < aux.stock_min) then begin
        with aux do 
          WriteLn('Cod: ',cod, ' nombre: ', nombre, ' marca: ',marca,' precio: ',precio:2:2,' descipcion:',descripcion,' Stock min: ',stock_min,' stock disponible: ', stock_disponible);
          ok:= true;
        end;
    end;
    if  ok then WriteLn('Listado creado con exito')
    else WriteLn('No se encontraron celulares por debajo del stock minimo');
    close(arch);
  end;
  procedure buscarD(var arch : archivo; nombre: String);
  var
    aux :celular;
    ok: Boolean;
    txt: string;
  begin
    ok:= False;
    Assign(arch,nombre);
    reset(arch);
    WriteLn(' Ingrese el la descripcion del celular que desea buscar: ');
    read(txt);
    while not eof (arch) do begin
      read(arch,aux);
      if (pos(txt,aux.descripcion)<>0) then begin
        with aux do 
          WriteLn('Cod: ',cod, ' nombre: ', nombre, ' marca: ',marca,' precio: ',precio:2:2,' descipcion:',descripcion,' Stock min: ',stock_min,' stock disponible: ', stock_disponible);
          ok:=true;
        end;
    end;
    if ok then WriteLn('Listado creado con exito')
    else WriteLn('No se encontraron celulares con la descripcion ingresada');
    close(arch);
  end;
 procedure Exportar(var arch : archivo; nombre: String);
  var
    lista : Text;
    aux : celular;
  begin
    Assign(arch, nombre);
    Assign(lista, 'celulares.txt');
    Rewrite(lista);
    Reset(arch);
    while not eof (arch) do begin
      read(arch, aux);
      with aux do begin
       WriteLn(lista, cod,' ', precio,' ', marca);
       WriteLn(lista, stock_disponible,' ', stock_min,' ', descripcion);
       WriteLn(lista, nombre);
      end;
    end;
    WriteLn('Archivo Exportado con exito');
    close(arch); 
    close(lista);
  end;

 procedure menu();
  var
    opcion:integer;
    arch : archivo;
    nombre: string[30];
  begin
    WriteLn('ingrese el nombre del achivo Bin que desea crear: ');
    readln(nombre);
    repeat
      WriteLn('__________________________________________________________________');
      WriteLn('Buenas tardes que tarea desea realizar?'); 
      WriteLn('1-crear binario de celulares ');
      WriteLn('2-Listar celulares con stock menor al minimo'); 
      WriteLn('3-Buscar por descripcion ');
      WriteLn('4-Exportar archivo celulares.txt'); 
      WriteLn('5- salir');
      readln(opcion);
      WriteLn('__________________________________________________________________');
      case opcion of
        1: crearBin(arch,nombre);
        2: listarMin(arch,nombre);
        3: buscarD(arch,nombre);
        4: Exportar(arch,nombre);        
        5: WriteLn('saliste');
        else WriteLn('opcion incorrecta, intentelo nuevamente');
      end;
    until (opcion = 5 );
  end;  
    
begin
  menu();
end.
