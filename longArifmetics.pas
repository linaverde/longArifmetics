program lingArifmetics;

const
  max = 200;
  min = 3;

type
  dec = array [1..max + 1] of string[3];
  
  numbers = set of '0'..'7';
  
  longDecimal =  dec;
  
  longReal = record
    nat: dec;
    frac: dec;
  end;

var
  f: Text;
  num := ['0'..'7'];

function checkEight(s: string): string;
var
  i: integer;
begin
  for i := 1 to s.Length do
    if not (s[i] in num) then
      checkEight := 'Встречен недопустимый для восьмеричной системы символ';
end;

procedure readLongDec(var input: text; var a: longDecimal; var err: string);
var
  i: integer;
  s: string;
begin
  readln(input, s);
  if s.Length < min then 
    err := 'Введенное число содержит на ' + (min - s.Length) + ' меньше знаков, чем допустимо';
  if s.Length > max then 
    err := 'Введенное число содержит на ' + (s.Length - max) + ' больше знаков, чем допустимо';
  if err = '' then err := checkEight(s);
  if err = '' then
    while s.Length > 0 do
    begin
      i := i + 1;
      a[i + 1] := Copy(s, 1, 3);
      a[1] := IntToStr(i);
      Delete(s, 1, 3);
    end
end;


procedure readLongReal(var input: text; var b: longReal; var err: string);

procedure convertString(var s: string; var a: dec);

  var
    i: integer;
begin
  if s.Length < min then 
    err := 'Введенное число содержит на ' + (min - s.Length) + ' меньше знаков, чем допустимо';
  if s.Length > max then 
    err := 'Введенное число содержит на ' + (s.Length - max) + ' больше знаков, чем допустимо';
  if err = '' then err := checkEight(s);
  if err = '' then
    while s.Length > 0 do
    begin
      i := i + 1;
      a[i + 1] := Copy(s, 1, 3);
      a[1] := IntToStr(i);
      Delete(s, 1, 3);
    end
end;

var
  i, dot: integer;
  s, sNat: string;
begin
  readln(input, s);
  dot := 0;
  for i := 1 to s.Length do
    if (dot = 0) and (s[i] = ',') then
      dot := i
    else if (dot <> 0) and (s[i] = ',') then
      err := 'В записи вещественного числа не может быть двух запятых';
  if (dot = 0) then
    err := 'Не является вещественным числом';
  if err = '' then
  begin
    sNat := Copy(s, 1, dot - 1);
    Delete(s, 1, dot);
    convertString(sNat, b.nat);
    if err <> '' then
      err := 'Ошибка в целой части числа: ' + err;
  end;
  if err = '' then
  begin
    convertString(s, b.frac);
    if err <> '' then
      err := 'Ошибка в дробной части числа: ' + err
  end;  
  
end;

var
  a: longDecimal;
  b: longReal;
  err: string;
  input, output: text;

begin
  assign(input, 'input.txt');
  reset(input);
  readLongDec(input, a, err);
  if err <> '' then 
    Writeln (err);
  readLongReal(input, b, err);
  if err <> '' then 
    Writeln (err);
  Close(input);
end.