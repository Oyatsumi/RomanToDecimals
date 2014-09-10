unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls;


type
    //declarando o registro que vai conter o decimal e a sua representação em romano equivalente.
   registro = record
            decimal : integer;
            romano : string
   end;
   //declarando um array que vai conter os 'números' de 1 e 5 com sua representação em romano.
   t_dominio = 1..2;
   romanosvar = array [t_dominio] of registro;


  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end; 

var
  Form1: TForm1;
  //mais um array que representa a 'casa decimal', ou seja, 1 é unidades, 2 dezenas, 3 centenas, etc.
  tabela : array [1..7] of romanosvar;
  tabela2 : array [1..7] of romanosvar;



implementation

function buscarromano (caracter:string; var heranca,valordecimal: integer):boolean;
var
i,j : integer;
begin
buscarromano := false;
     for i:= 1 to 7 do
     begin
          for j:= 1 to 2 do
          begin

              if caracter = tabela2[i][j].romano then
              begin
                   valordecimal := tabela2[i][j].decimal;
                   heranca := i + j;
                   buscarromano := true;
              end;

          end;
     end;
end;

function romanoparadecimal (romano: string):integer;
var
resultado, heranca, herancaantes, valordecimal, valordecimalantes : integer;
letradavez, antesdavez, parenteses, varaux, antiga : string;
simounao, passar : boolean;
i,contagem: integer;
begin
resultado := 0;

//transformar os parênteses da variável romano:
passar := false;
parenteses := romano;
romano := '';
contagem := 0;
for i:= 1 to length(parenteses) do
begin
     varaux := parenteses;
     delete(varaux, 1, (length(varaux) - 1));
     delete(parenteses, length(parenteses), 1);



     if (varaux = ')') or (passar = true) then
     begin
         passar := true;
         if varaux = 'I' then varaux := '!';
         if varaux = 'V' then varaux := '@';
         if varaux = 'X' then varaux := '#';
         if varaux = 'L' then varaux := '$';
         if varaux = 'C' then varaux := '%';
         if varaux = 'D' then varaux := '}';
         if varaux = 'M' then varaux := '{';
         if varaux = ')' then varaux := '';
     end;

     if varaux = 'M' then varaux := '!';
     if varaux = '(' then varaux := '';

     if antiga = varaux then begin contagem := contagem + 1; end else begin contagem := 0 end;
     antiga := varaux;
     if contagem = 3 then
     begin
          romano := ''; //abortando por ter 4 algorimos iguais no número romano.
          ShowMessage('Houve um erro no número em romanos, há 4 algorismos repetidos.');
          varaux := '';
          resultado := 0;
     end;

     romano := concat(varaux, romano);
end;
//fim da transformação.


     while length(romano) <> 0 do
     begin
         letradavez := romano;
         delete(letradavez, 1, (length(letradavez) - 1));
         delete(romano, length(romano), 1);
         antesdavez := romano;
         delete(antesdavez, 1, length(antesdavez) - 1);

         simounao := buscarromano(letradavez, heranca, valordecimal);
         if simounao = false then begin valordecimal := 0; heranca := 0 end;

         simounao := buscarromano(antesdavez, herancaantes, valordecimalantes);
         if simounao = false then begin valordecimalantes := 0; herancaantes := 1000 end;

         if herancaantes < heranca then
         begin
              resultado := resultado + valordecimal;
              resultado := resultado - valordecimalantes;
              delete(romano, length(romano), 1);
         end
         else
         begin
              resultado := resultado + valordecimal;
         end;

     end;

     romanoparadecimal := resultado;

end;

function decimalpararomano(numero: integer):string;
var
casadecimal  : integer;
resultado, ultnumero, numerousar, encher : string;
ativar : boolean;
begin
    numerousar := inttostr(numero);
    casadecimal := 1;
    resultado := '';
    ativar := false;
    while length(numerousar) <> 0 do
    begin
         ultnumero := numerousar;
         delete(ultnumero, 1, (length(numerousar) - 1));
         delete(numerousar, length(numerousar), 1);

         //para colocar o parênteses nos números com traço em cima.
         if (casadecimal = 4) and (strtoint(ultnumero) >= 4) and (ativar = false) then
         begin
              if (strtoint(ultnumero) > 5) and (strtoint(ultnumero) < 9) then
              begin
                    encher := ')';
                    tabela[casadecimal][1].romano := 'M';
              end
              else
              begin
                   resultado := concat(')',resultado);
                   tabela[casadecimal][1].romano := 'I';
                   encher := '';
              end;
              ativar := true;
         end;
         if (casadecimal >= 5) and (ativar = false) then
         begin
              resultado := concat(')',resultado);
              ativar := true;
         end;
         if (casadecimal >= 5) then tabela[4][1].romano := 'I';
         //fim parênteses


         if ultnumero = '1' then resultado := concat(tabela[casadecimal][1].romano,resultado);
         if ultnumero = '2' then resultado := concat(tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,resultado);
         if ultnumero = '3' then resultado := concat(tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,resultado);
         if ultnumero = '4' then resultado := concat(tabela[casadecimal][1].romano,tabela[casadecimal][2].romano,resultado);
         if ultnumero = '5' then resultado := concat(tabela[casadecimal][2].romano,resultado);
         if ultnumero = '6' then resultado := concat(tabela[casadecimal][2].romano,encher,tabela[casadecimal][1].romano,resultado);
         if ultnumero = '7' then resultado := concat(tabela[casadecimal][2].romano,encher,tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,resultado);
         if ultnumero = '8' then resultado := concat(tabela[casadecimal][2].romano,encher,tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,tabela[casadecimal][1].romano,resultado);
         if ultnumero = '9' then resultado := concat(tabela[casadecimal][1].romano,tabela[casadecimal + 1][1].romano,encher,resultado);

         casadecimal := casadecimal + 1;
         encher := '';
    end;

    if ativar = true then resultado := concat ('(', resultado);

    decimalpararomano := resultado;
    tabela[4][1].romano := 'M';
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     //tabela[1][9].romano := 'teste';
     //edit1.text := tabela[1][9].romano;

     //Iniciando o 'banco de dados' dos caracteres romanos:
     //legenda: tabela.[posição decimal][número, 1,2,3,4...].se é a representação romana ou numeral.
     tabela[1][1].romano := 'I';
     tabela[1][2].romano := 'V';
     tabela[2][1].romano := 'X';
     tabela[2][2].romano := 'L';
     tabela[3][1].romano := 'C';
     tabela[3][2].romano := 'D';
     tabela[4][1].romano := 'M';
     tabela[4][2].romano := 'V';//esse tem traço em cima, a partir daqui
     tabela[5][1].romano := 'X';
     tabela[5][2].romano := 'L';
     tabela[6][1].romano := 'C';
     tabela[6][2].romano := 'D';
     tabela[7][1].romano := 'M';


     //tabela usada na conversão do romano para o decimal
     tabela2[1][1].romano := 'I'; tabela2[1][1].decimal := 1;
     tabela2[1][2].romano := 'V'; tabela2[1][2].decimal := 5;
     tabela2[2][1].romano := 'X'; tabela2[2][1].decimal := 10;
     tabela2[2][2].romano := 'L'; tabela2[2][2].decimal := 50;
     tabela2[3][1].romano := 'C'; tabela2[3][1].decimal := 100;
     tabela2[3][2].romano := 'D'; tabela2[3][2].decimal := 500;
     tabela2[4][1].romano := '!'; tabela2[4][1].decimal := 1000; tabela2[4][2].decimal := 5000;
     tabela2[4][2].romano := '@';//esse tem traço em cima, a partir daqui
     tabela2[5][1].romano := '#'; tabela2[5][1].decimal := 10000;
     tabela2[5][2].romano := '$'; tabela2[5][2].decimal := 50000;
     tabela2[6][1].romano := '%'; tabela2[6][1].decimal := 100000;
     tabela2[6][2].romano := '}'; tabela2[6][2].decimal := 500000;
     tabela2[7][1].romano := '{'; tabela2[7][1].decimal := 1000000;


end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  edit2.text := inttostr(romanoparadecimal(edit2.text));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    edit2.text := decimalpararomano(strtoint(edit2.text));
end;

procedure TForm1.FormShow(Sender: TObject);
begin

end;

initialization
  {$I unit1.lrs}

end.

