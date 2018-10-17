program lingArifmetics;

const
  max = 200;
  min = 3;

type
  dec = array [0..max + 1] of word;
  
  numbers = set of '0'..'7';
  
  longDecimal = dec;
  
  longReal = record
    nat: dec;
    frac: dec;
  end;

var
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
  err := '';
  readln(input, s);
  if s.Length < min then 
    err := 'Введенное число содержит на ' + (min - s.Length) + ' меньше знаков, чем допустимо';
  if s.Length > max then 
    err := 'Введенное число содержит на ' + (s.Length - max) + ' больше знаков, чем допустимо';
  if err = '' then err := checkEight(s);
  if err = '' then
  begin
    i := 0;
    while s[1] = '0' do
      delete(s, 1, 1);
    if (s.Length mod 3) <> 0 then
      if (s.Length mod 3) = 2 then
      begin
        i := i + 1;
        a[i] := StrToInt(Copy(s, 1, 2));
        a[0] := i;
        Delete(s, 1, 2);
      end
      else
      begin
        i := i + 1;
        a[i] := StrToInt(Copy(s, 1, 1));
        a[0] := i;
        Delete(s, 1, 1);
      end;
    while s.Length > 0 do
    begin
      i := i + 1;
      a[i] := StrToInt(Copy(s, 1, 3));
      a[0] := i;
      Delete(s, 1, 3);
    end
  end;
end;


procedure readLongReal(var input: text; var b: longReal; var err: string);
  
  procedure convertString(var s: string; var a: dec; t: byte);
  
  var
    i: integer;
  begin
    if s.Length < min then 
      err := 'Введенное число содержит на ' + (min - s.Length) + ' меньше знаков, чем допустимо';
    if s.Length > max then 
      err := 'Введенное число содержит на ' + (s.Length - max) + ' больше знаков, чем допустимо';
    if err = '' then err := checkEight(s);
    if err = '' then
    begin
      i := 0;
      if t = 1 then
        if (s.Length mod 3) <> 0 then
          if (s.Length mod 3) = 2 then
          begin
            i := i + 1;
            a[i] := StrToInt(Copy(s, 1, 2));
            a[0] := i;
            Delete(s, 1, 2);
          end
          else
          begin
            i := i + 1;
            a[i] := StrToInt(Copy(s, 1, 1));
            a[0] := i;
            Delete(s, 1, 1);
          end;
      while s.Length > 0 do
      begin
        i := i + 1;
        a[i] := StrToInt(Copy(s, 1, 3));
        a[0] := i;
        Delete(s, 1, 3);
      end
    end;
  end;

var
  i, dot: integer;
  s, sNat: string;
begin
  err := '';
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
    while sNat[1] = '0' do
      delete(sNat, 1, 1);
    convertString(sNat, b.nat, 1);
    if err <> '' then
      err := 'Ошибка в целой части числа: ' + err;
  end;
  if err = '' then
  begin
    while s[Length(s)] = '0' do
      Delete(s, Length(s), 1);
    convertString(s, b.frac, 2);
    if err <> '' then
      err := 'Ошибка в дробной части числа: ' + err
  end;  
end;

procedure printLong(const a: dec);
var
  i: integer;
begin
  for i := 1 to a[0] do
    write(a[i]);
  writeln();
end;

procedure printLongReal(const a: longReal);
var
  i: integer;
begin
  for i := 1 to a.nat[0] do
    write(a.nat[i]);
  write(',');
  for i := 1 to a.frac[0] do
    write(a.frac[i]);
  writeln();
end;

procedure invertArr(var arr: dec);
var
  i, k: integer;
  temp: word;
begin
  k := arr[0] div 2;
  for i := 1 to k do
  begin
    temp := arr[i];
    arr[i] := arr[arr[0] + 1 - i];
    arr[arr[0] + 1 - i] := temp;
  end;
end;




var
  a, c: longDecimal;
  b, d: longReal;
  err: string;
  input, output: text;

begin
  assign(input, 'input.txt');
  reset(input);
  readLongDec(input, a, err);
  if err <> '' then 
    Writeln(err);
  readLongReal(input, b, err);
  if err <> '' then 
    Writeln(err);
  Close(input);
  printLong(a);
  printLongReal(b);
end.