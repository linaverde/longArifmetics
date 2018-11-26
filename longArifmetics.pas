program longArifmetics;

const
  max = 20;

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
  if s.Length > max * 3 then 
    err := 'Введенное число содержит на ' + (s.Length - max * 3) + ' больше знаков, чем допустимо';
  if err = '' then err := checkEight(s);
  if err = '' then
  begin
    i := 0;
    while (s[1] = '0') and (s.Length > 1)  do
      delete(s, 1, 1);
    while s.Length > 3 do
    begin
      i := i + 1;
      a[i] := StrToInt(Copy(s, s.Length - 2, 3));
      a[0] := i;
      Delete(s, s.Length - 2, 3);
    end;
    i := i + 1;
    a[i] := StrToInt(Copy(s, 1, 3));
    a[0] := i;
    Delete(s, 1, 3);
  end;
end;

procedure readLongReal(var input: text; var b: longReal; var err: string);
  
  procedure convertString(var s: string; var a: dec; t: byte);
  
  var
    i: integer;
  begin
    if s.Length > max * 3 then 
      err := 'Введенное число содержит на ' + (s.Length - max * 3) + ' больше знаков, чем допустимо';
    if err = '' then
    begin
      i := 0;
      if t = 1 then
      begin
        while s.Length > 3 do
        begin
          i := i + 1;
          a[i] := StrToInt(Copy(s, s.Length - 2, 3));
          a[0] := i;
          Delete(s, s.Length - 2, 3);
        end;
        i := i + 1;
        a[i] := StrToInt(Copy(s, 1, 3));
        a[0] := i;
        Delete(s, 1, 3);
      end
      else
      begin
        while s.Length >= 3 do
        begin
          i := i + 1;
          a[i] := StrToInt(Copy(s, 1, 3));
          a[0] := i;
          Delete(s, 1, 3);
        end;
        while (s.Length < 3) and (s.Length > 0) do
          s := s + '0';
        if s.Length > 0 then
        begin
          i := i + 1;
          a[i] := StrToInt(Copy(s, 1, 3));
          a[0] := i;
          Delete(s, 1, 3);
        end;
      end;
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
    if (s[i] <> ',') and not (s[i] in num) then
      dot := -1
    else if (dot = 0) and (s[i] = ',') then
      dot := i
    else if (dot <> 0) and (dot <> -1) and (s[i] = ',') then
      err := 'В записи вещественного числа не может быть двух запятых';
  if (dot = -1) then 
    err := 'Содержит недопустимые для восьмеричной системы символы'
  else if (dot = 0) or (dot = 1) or (dot = s.Length) then
    err := 'Не является вещественным числом';
  if err = '' then
  begin
    sNat := Copy(s, 1, dot - 1);
    Delete(s, 1, dot);
    while (sNat[1] = '0') and (sNat.Length > 1) do
      delete(sNat, 1, 1);
    convertString(sNat, b.nat, 1);
    if err <> '' then
      err := 'Ошибка в целой части числа: ' + err;
  end;
  if err = '' then
  begin
    while (s[s.Length] = '0') and (s.Length > 1) do
      Delete(s, s.Length, 1);
    convertString(s, b.frac, 2);
    if err <> '' then
      err := 'Ошибка в дробной части числа: ' + err
  end;  
end;

procedure printLong(const a: dec);
var
  i: integer;
begin
  for i := a[0] downto 1 do
    if i <> a[0] then
      if a[i] < 10 then
        write(0, 0, a[i])
      else 
      if a[i] < 100 then
        write(0, a[i])
      else
        write(a[i])
    else 
      write(a[i]);
  writeln();
  
end;

procedure printLongReal(const a: longReal);
var
  i: integer;
begin
  for i := a.nat[0] downto 1 do
    if i <> a.nat[0] then
      if a.nat[i] < 10 then
        write(0, 0, a.nat[i])
      else 
      if a.nat[i] < 100 then
        write(0, a.nat[i])
      else
        write(a.nat[i])
    else
      write(a.nat[i]);
  write(',');
  for i := 1 to a.frac[0] - 1 do
    if a.frac[i] < 10 then
      write(0, 0, a.frac[i])
    else 
    if a.frac[i] < 100 then
      write(0, a.frac[i])
    else
      write(a.frac[i]);
  i := i + 1; //последнее число
  if a.frac[i] < 10 then
      write(0, 0, a.frac[i])
    else 
    if a.frac[i] < 100 then
      if (a.frac[i] mod 10 = 0) then
        write(0, a.frac[i] div 10)
      else
        write(0, a.frac[i])
    else
    begin
      if (a.frac[i] mod 100 = 0) then
        write(a.frac[i] div 100)
      else
      if(a.frac[i] mod 10 = 0) then
        write(a.frac[i] div 10)
      else
        write(a.frac[i]);
    end;
  writeln();
end;

function addLong(a: longDecimal; b: longReal): longDecimal;

var
  i, j, m: integer;
  c: longDecimal;
  next, temp: word;

begin
  if a[0] < b.nat[0] then 
    m := a[0]
  else
    m := b.nat[0];
  if (b.frac[1] div 100) >= 5 then 
    next := 1
  else
    next := 0;
  for i := 1 to m do
  begin
    //складывание единиц 
    temp := (a[i] mod 10) + (b.nat[i] mod 10) + next;
    if temp >= 8  then
    begin
      temp := temp mod 8;
      next := 1;
    end
    else 
      next := 0;
    c[i] := temp + c[i];
    //складывание десятков
    temp := (a[i] mod 100 div 10) + (b.nat[i] mod 100 div 10) + next;
    if temp >= 8  then
    begin
      temp := temp mod 8;
      next := 1;
    end
    else 
      next := 0;
    c[i] := temp * 10 + c[i];
    //складывание сотен
    temp := (a[i] div 100) + (b.nat[i] div 100) + next;
    if temp >= 8  then
    begin
      temp := temp mod 8;
      next := 1;
    end
    else 
      next := 0;
    c[i] := temp * 100 + c[i];
    //c[i+1] := next;
    c[0] := c[0] + 1;
  end;
  //прибавление остатка
  if a[0] > m then
    for i := m + 1 to a[0] do
    begin
      c[i] := c[i] + a[i] + next;
      next := 0;
      if ((c[i] mod 10) >= 8) then
        c[i] := c[i] + 2;
      if ((c[i] div 10 mod 10) >= 8) then
        c[i] := c[i] + 20;
      if ((c[i] div 100) >= 8) then
      begin
        c[i] := c[i] - 800;
        next := 1;
      end;
      c[0] := c[0] + 1
    end
  else
    for i := m + 1 to b.nat[0] do
    begin
      c[i] := c[i] + b.nat[i] + next;
      next := 0;
      if ((c[i] mod 10) >= 8) then
        c[i] := c[i] + 2;
      if ((c[i] div 10 mod 10) >= 8) then
        c[i] := c[i] + 20;
      if ((c[i] div 100) >= 8) then
      begin
        c[i] := c[i] - 800;
        next := 1;
      end;
      c[0] := c[0] + 1;
    end;
  if next = 1 then 
  begin
    c[0] := c[0] + 1;
    c[c[0]] := next;
  end;
  result := c;
end;

function subLong(a: longDecimal; b: longReal): longReal;

var
  i, temp, next: integer;
  fl: boolean;
  d: longReal;
begin
  //два случая: a > b (true) и b > a (false)
  if a[0] > b.nat[0]  then 
    fl := true
  else if b.nat[0] > a[0] then 
    fl := false
  else if a[0] = b.nat[0] then
  begin
    i := a[0];
    while (a[i] - b.nat[i] = 0) and (i > 0) do
      i := i - 1;
    if i = 0 then 
      fl := false //целые части равны
    else if a[i] - b.nat[i] > 0 then
      fl := true
    else if a[i] - b.nat[i] < 0 then
      fl := false;
  end;
  if fl then // a > b
  begin//вычитание дробной части
    d.frac[0] := b.frac[0];
    for i := b.frac[0] downto 1 do
    begin
      temp := - (b.frac[i] mod 10 + next);
      if temp < 0 then
      begin
        d.frac[i] := temp + 8;
        next := 1;
      end
      else
      begin
        d.frac[i]:= temp;
        next := 0;
      end;
      temp := - (b.frac[i] div 10 mod 10 + next);
      if temp < 0 then
      begin
        d.frac[i] := d.frac[i] + (temp + 8)*10;
        next := 1;
      end
      else
      begin
        d.frac[i]:= d.frac[i] + temp*10;
        next := 0;
      end;
      temp := - (b.frac[i] div 100 + next);
      if temp < 0 then
      begin
        d.frac[i] := d.frac[i] + (temp + 8)*100;
        next := 1;
      end
      else
      begin
        d.frac[i]:= d.frac[i] + temp*100;
        next := 0;
      end;
    end;
    for i := 1 to a[0] do //вычитание целой части
    begin
      temp := (a[i] mod 10 - b.nat[i] mod 10 - next);
      if temp < 0 then 
      begin
        next := 1;
        d.nat[i] := temp + 8;
      end
      else
      begin
        next := 0;
        d.nat[i] := temp;
      end;
      temp := (a[i] div 10 mod 10 - b.nat[i] div 10 mod 10 - next);
      if temp < 0 then 
      begin
        next := 1;
        d.nat[i] := d.nat[i] + (temp + 8) * 10;
      end
      else
      begin
        next := 0;
        d.nat[i] := d.nat[i] + temp * 10;
      end;
      temp := (a[i] div 100 - b.nat[i] div 100 - next);
      if temp < 0 then 
      begin
        next := 1;
        d.nat[i] := d.nat[i] + (temp + 8) * 100;
      end
      else
      begin
        next := 0;
        d.nat[i] := d.nat[i] + temp * 100;
      end;
    end;
    temp := a[0];
      for i := a[0] downto 1 do
        if d.nat[i] = 0 then
          temp := temp - 1;
      d.nat[0] := temp;
  end
  else //b > a;
  begin
    d.frac := b.frac;
    next := 0;
    for i := 1 to b.nat[0] do
    begin
      temp := (b.nat[i] mod 10) - (a[i] mod 10 + next);
      if temp < 0 then
      begin
        next := 1;
        d.nat[i] := temp + 8;
      end
      else
      begin
        next := 0;
        d.nat[i] := temp;
      end;
      temp := (b.nat[i] div 10 mod 10) - (a[i] div 10 mod 10 + next);
      if temp < 0 then
      begin
        next := 1;
        d.nat[i] := d.nat[i] + (temp + 8) * 10;
      end
      else
      begin
        next := 0;
        d.nat[i] := d.nat[i] + temp * 10;
      end;
      temp := (b.nat[i] div 100) - (a[i] div 100 + next);
      if temp < 0 then
      begin
        next := 1;
        d.nat[i] := d.nat[i] + (temp + 8) * 100;
      end
      else
      begin
        next := 0;
        d.nat[i] := d.nat[i] + temp * 100;
      end;
    end;
    d.nat[0] := b.nat[0];
  end;
  result := d;
end;

var
  a, c: longDecimal;
  b, d: longReal;
  err: string;

begin
  assign(input, 'input.txt');
  assign(output, 'output.txt');
  readLongDec(input, a, err);
  if err <> '' then 
    Writeln(err)
  else
    Writeln('Считывание числа успешно');
  readLongReal(input, b, err);
  if err <> '' then 
    Writeln(err)
  else
    Writeln('Считывание числа успешно');
  if err = '' then
  begin
    printLong(a);
    printLongReal(b);
    c := addLong(a, b);
    printLong(c);
    d := subLong(a, b);
    printLongReal(d);
  end;
end.