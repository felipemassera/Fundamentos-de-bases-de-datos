{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información. 
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

{SE USARAN 5 detalles  de nac y 5 de fall para crear el maestro dado que crear los bin de prueba 
no tiene sentido}

program  tp2ej5;
const
    df = 50;
    valor_alto= 9999;
type
    strini= String[30];
    dire = record
        calle: integer;
        nro: integer;
        piso: integer;
        depto: integer;
        ciudad: strini;
    end;
    reg_nac = record
        nro_partida : integer;
        nombre : strini;
        apellido: strini;
        direccion : dire;
        mat_medico: integer;
        nombre_madre: strini;
        apellido_madre: strini;
        dni_madre: integer;
        nombre_padre: strini;
        apellido_padre: strini;
        dni_padre: integer;
    end;
    reg_fallecido= record
        nro_partida :Integer;
        DNI : integer;
        nombre : strini;
        apellido : strini;
        mat_medico : Integer;
        fecha_fallece : string [8];
        hora_deceso : string[5];
        lugar_deceso : strini;
    end;
    reg_maestro =record
        nro_partida :Integer;
        nombre : strini;
        apellido : strini;
        direccion : dire;        
        DNI : integer;
        mat_medico_nac : Integer;
        nombre_madre: strini;
        apellido_madre: strini;
        dni_madre: integer;
        nombre_padre: strini;
        apellido_padre: strini;
        dni_padre: integer;
        mat_medico_fal : Integer;
        fecha_fallece : string [8];
        hora_deceso : string[5];
        lugar_deceso : strini;
    end;
    det_nac= file of reg_nac;
    det_fal= file of reg_fallecido;
    mae_bin= file of reg_maestro;
    Vec_nac = array [1..df] of reg_nac;
    Vec_fal = array [1..df] of reg_fallecido;

 procedure leerN(var det : det_nac; var aux: reg_nac);
  begin
      if not eof (det)then 
        read(det,aux)
      else aux.nro_partida:= valor_alto;  
  end;
  procedure leerF(var det : det_fal; var aux: reg_fallecido);
  begin
      if not eof (det)then 
        read(det,aux)
      else aux.nro_partida:= valor_alto;  
 end;
 procedure verMaestro(var mae:mae_bin);
        procedure datos(aux: reg_maestro);
        begin
          WriteLn('Reg Nro',aux.nro_partida);
          Writeln(' Nombre: ',aux.nombre,' Apellido: ',aux.apellido, ' Dni: ',aux.DNI);
          WriteLn(' Direccion: ',aux.direccion.calle,' NRO: ',aux.direccion.nro);
          WriteLn(' PISO: ',aux.direccion.piso);
          WriteLn(' dTO: ',aux.direccion.depto);
          WriteLn(' Ciudad: ',aux.direccion.ciudad);
          WriteLn('-----------Datos de Nacimiento-----------');
          WriteLn(' Matricula medico del acta de nacimiento',aux.mat_medico_nac);
          WriteLn(' Nombre Madre: ',aux.nombre_madre,' Apellido madre: ',aux.dni_madre,' DNI Madre: ',aux.dni_madre);
          WriteLn(' Nombre padre: ',aux.nombre_padre,' Apellido Padre: ',aux.apellido_padre,' DNI Padre: ',aux.dni_padre);
          if (aux.mat_medico_fal <> 0) then
          begin
            writeLn('---------------Si fallecio-------------- ');
            writeln(' Matricula Medico del acta de fallecimiento: 'aux.mat_medico_fal);
             writeln(' Fecha Fallecimiento: ',aux.fecha_fallece,' Hora: ',aux.hora_deceso,' donde Fallece: ',aux.lugar_deceso);
          end else WriteLn('No fallecio');
        end;
  var
    aux: reg_maestro;
  begin
    reset(mae);
    while not eof (mae)do begin
        read(mae, aux);
        datos(aux);
      end;
 end;

 procedure 

var

begin
  
End.