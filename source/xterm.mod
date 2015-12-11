IMPLEMENTATION MODULE XTerm;
FROM Strings IMPORT CAPS,Length;
FROM ComLine IMPORT commandLine;
FROM SYSTEM IMPORT BDOS,ADR,IORESULT;
FROM MathLib IMPORT Randomize;
FROM Terminal IMPORT ReadChar;
FROM Convert IMPORT StrToCard;
VAR Term:TERMTYPE;

PROCEDURE String2TermType(name:ARRAY OF CHAR):TERMTYPE;
BEGIN
  CAPS(name);
  IF name='VT100' THEN RETURN VT100;
  ELSIF name='ANSI' THEN RETURN ANSI;
  ELSIF name='KAYPRO' THEN RETURN KAYPRO;
  ELSIF name='ADM31' THEN RETURN ADM31;
  ELSIF name='C128' THEN RETURN C128;
  ELSE RETURN INVALID;
  END;
END String2TermType;

PROCEDURE PrintTermType(t:TERMTYPE);
BEGIN
  CASE t OF
    VT100:  WRITE('VT100  (B&W)') |
    ANSI:   WRITE('ANSI   (Color)') |
    KAYPRO: WRITE('KayPro (B&W)') |
    ADM31:  WRITE('ADM31  (B&W)') |
    C128:   WRITE('C128   (Color)') |
    INVALID: WRITE('INVALID')
  END;
END PrintTermType;

PROCEDURE GetTermType():TERMTYPE;
BEGIN
  RETURN Term;
END GetTermType;

PROCEDURE PrintLnTermType(t:TERMTYPE);
BEGIN
  PrintTermType(t);
  WRITELN();
END PrintLnTermType;

PROCEDURE PrintTermTypeList();
VAR i:TERMTYPE;
    j:CARDINAL;
BEGIN
  j:=1;
  FOR i:=INVALID TO C128 DO
    IF i<>INVALID THEN
      WRITE(j,') ');
      PrintLnTermType(i);
      j:=j+1;
    END;
  END;
END PrintTermTypeList;

PROCEDURE InitWithNoColors();
VAR i:ESCAPE;
BEGIN
  FOR i:=BLACK TO LIGHTGREY DO
    SEQ[i]:='';
  END;
END InitWithNoColors;

PROCEDURE CursorXYVT100(x,y:CARDINAL);
BEGIN
  WRITE(33C,'[',y:0,';',x:0,'H')
END CursorXYVT100;

PROCEDURE CursorXYKAYPRO(x,y:CARDINAL);
BEGIN
  WRITE(33C,'=',CHAR(y+31),CHAR(x+31))
END CursorXYKAYPRO;

PROCEDURE InitVT100base();
VAR i:ESCAPE;
    j:CARDINAL;
BEGIN
  CursorXY:=CursorXYVT100;
  SEQ[REVERSE]:='~[7m';
  SEQ[PLAIN]:='~[27m';
  SEQ[BLINK]:='~[5m';
  SEQ[NOBLINK]:='~[25m';
  SEQ[UNDERLINE]:='~[4m';
  SEQ[NOUNDERLINE]:='~[24m';
  SEQ[DARK]:='~[2m';
  SEQ[NODARK]:='~[22m';
  FOR i:=PLAIN TO NODARK DO SEQ[i][0]:=033C END;
  SEQ[BEEP]:='*'; SEQ[BEEP][0]:=7C;
  SEQ[CLS]:='~[2J~[H'; SEQ[CLS][0]:=33C; SEQ[CLS][4]:=33C;
  SEQ[HOME]:='~[H'; SEQ[HOME][0]:=33C;
  SEQ[CLREOL]:='~[K'; SEQ[CLREOL][0]:=33C;
  SEQ[INSLINE]:='~L'; SEQ[INSLINE][0]:=33C;
  SEQ[DELLINE]:='~M'; SEQ[DELLINE][0]:=33C;
  SEQ[CURSORON]:='~[?25h'; SEQ[CURSORON][0]:=33C;
  SEQ[CURSOROFF]:='~[?25l'; SEQ[CURSOROFF][0]:=33C;
  SEQ[TERMRESET]:='~[m'; SEQ[TERMRESET][0]:=33C;
END InitVT100base;

PROCEDURE InitVT100();
BEGIN
  InitWithNoColors();
  InitVT100base();
END InitVT100;

PROCEDURE InitANSI();
VAR i:ESCAPE;
BEGIN
  InitVT100base();
  SEQ[BLACK]:='~[30m~[2m';
  SEQ[WHITE]:='~[37m~[22m';
  SEQ[RED]:='~[31m~[2m';
  SEQ[CYAN]:='~[36m~[22m';
  SEQ[PURPLE]:='~[35m~[22m';
  SEQ[GREEN]:='~[32m~[2m';
  SEQ[BLUE]:='~[34m~[2m';
  SEQ[YELLOW]:='~[33m~[22m';
  SEQ[DARKPURPLE]:='~[35m~[2m';
  SEQ[BROWN]:='~[33m~[2m';
  SEQ[LIGHTRED]:='~[31m~[2m';
  SEQ[DARKGREY]:='~[37m~[2m';
  SEQ[DARKCYAN]:='~[36m~[2m';
  SEQ[LIGHTGREEN]:='~[32m~[22m';
  SEQ[LIGHTBLUE]:='~[34m~[22m';
  SEQ[LIGHTGREY]:='~[37m~[2m';
  FOR i:=BLACK TO LIGHTGREY DO SEQ[i][0]:=33C; SEQ[i][5]:=33C END;
END InitANSI;

PROCEDURE InitKayPro();
VAR i:ESCAPE;
    j:CARDINAL;
BEGIN
  CursorXY:=CursorXYKAYPRO;
  InitWithNoColors();
  SEQ[REVERSE]:='~B0';
  SEQ[PLAIN]:='~C0';
  SEQ[BLINK]:='~B2';
  SEQ[NOBLINK]:='~C2';
  SEQ[UNDERLINE]:='~B3';
  SEQ[NOUNDERLINE]:='~C3';
  SEQ[DARK]:='~B1';
  SEQ[NODARK]:='~C1';
  FOR i:=PLAIN TO NODARK DO SEQ[i][0]:=033C END;
  SEQ[BEEP]:='*'; SEQ[BEEP][0]:=7C;
  SEQ[CLS]:='*'; SEQ[CLS][0]:=32C;
  SEQ[HOME]:='*'; SEQ[HOME][0]:=36C;
  SEQ[CLREOL]:='*'; SEQ[CLREOL][0]:=30C;
  SEQ[INSLINE]:='~E'; SEQ[INSLINE][0]:=33C;
  SEQ[DELLINE]:='~R'; SEQ[DELLINE][0]:=33C;
  SEQ[CURSORON]:='~B4'; SEQ[CURSORON][0]:=33C;
  SEQ[CURSOROFF]:='~C4'; SEQ[CURSOROFF][0]:=33C;
  SEQ[TERMRESET]:='';
END InitKayPro;

PROCEDURE InitC128(withColors:BOOLEAN);
VAR i:ESCAPE;
    j:CARDINAL;
BEGIN
  CursorXY:=CursorXYKAYPRO;
  SEQ[REVERSE]:='~G4';
  SEQ[PLAIN]:='~G0';
  SEQ[BLINK]:='~G2';
  SEQ[NOBLINK]:='~G0';
  SEQ[UNDERLINE]:='~G3';
  SEQ[NOUNDERLINE]:='~G0';
  SEQ[DARK]:='~)';
  SEQ[NODARK]:='~(';
  FOR i:=PLAIN TO NODARK DO SEQ[i][0]:=033C END;
  SEQ[BEEP]:='*'; SEQ[BEEP][0]:=7C;
  SEQ[CLS]:='*'; SEQ[CLS][0]:=32C;
  SEQ[HOME]:='*'; SEQ[HOME][0]:=36C;
  SEQ[CLREOL]:='~T'; SEQ[CLREOL][0]:=33C;
  SEQ[INSLINE]:='~E'; SEQ[INSLINE][0]:=33C;
  SEQ[DELLINE]:='~R'; SEQ[DELLINE][0]:=33C;
  SEQ[CURSORON]:='';
  SEQ[CURSOROFF]:='';
  SEQ[TERMRESET]:='~G0'; SEQ[TERMRESET][0]:=33C;
  IF withColors THEN
    j:=0;
    FOR i:=BLACK TO LIGHTGREY DO
      SEQ[i]:='1234';
      SEQ[i][0]:=033C; SEQ[i][1]:=033C; SEQ[i][2]:=033C;
      SEQ[i][3]:=CHAR(32+j);
      j:=j+1;
    END
  ELSE
    InitWithNoColors();
  END;
END InitC128;

PROCEDURE SetTermType(t:TERMTYPE);
BEGIN
  Term:=t;
  CASE Term OF
    VT100: InitVT100() |
    ANSI: InitANSI() |
    KAYPRO: InitKayPro() |
    ADM31: InitC128(FALSE) |
    C128: InitC128(TRUE)
  END;
END SetTermType;

PROCEDURE AskTermType();
VAR s:ARRAY [0..79] OF CHAR;
    t:TERMTYPE;
    c:CARDINAL;
BEGIN
  READ(commandLine,s);
  IF Length(s)=1 THEN
    t:=TERMTYPE(INTEGER(s[0])-48)
  ELSE
    t:=String2TermType(s)
  END;
  IF t=INVALID THEN
    WRITELN('Select a terminal type (or specify it on command line):');
    WRITELN();
    PrintTermTypeList();
    WRITELN();
    REPEAT
      WRITE('>'); READ(c);
      t:=TERMTYPE(c);
    UNTIL t>INVALID;
  END;
  SetTermType(t);
END AskTermType;

PROCEDURE ResetTerm();
BEGIN
  WRITE(SEQ[TERMRESET]);
END ResetTerm;

PROCEDURE ShowCursor();
BEGIN
  WRITE(SEQ[CURSORON]);
END ShowCursor;

PROCEDURE HideCursor();
BEGIN
  WRITE(SEQ[CURSOROFF]);
END HideCursor;


PROCEDURE ClrScr();
BEGIN
  WRITE(SEQ[CLS]);
END ClrScr;

PROCEDURE Home();
BEGIN
  WRITE(SEQ[HOME]);
END Home;

PROCEDURE ClrEol();
BEGIN
  WRITE(SEQ[CLREOL]);
END ClrEol;

PROCEDURE InsLine();
BEGIN
  WRITE(SEQ[INSLINE]);
END InsLine;

PROCEDURE DelLine();
BEGIN
  WRITE(SEQ[DELLINE]);
END DelLine;

PROCEDURE PlotBox(x1,y1,x2,y2:CARDINAL;h,v:BOOLEAN);
VAR i,j:CARDINAL;
    s:ARRAY[0..79] OF CHAR;
BEGIN
  s:='                                                                                ';
  s[x2-x1+1]:=0C;
  WRITE(SEQ[REVERSE]);
  IF v THEN
    FOR i:=1 TO 2 DO
      FOR j:=y1 TO y2 DO
        IF i=1 THEN CursorXY(x1,j) ELSE CursorXY(x2,j) END;
        WRITE(' ');
      END;
    END;
  END;
  IF h THEN
    CursorXY(x1,y1); WRITE(s);
    CursorXY(x1,y2); WRITE(s);
  END;
  WRITE(SEQ[PLAIN]);
END PlotBox;

PROCEDURE Center(y:CARDINAL;s:ARRAY OF CHAR);
BEGIN
  CursorXY((80-Length(s)) DIV 2+1,y);WRITE(s);
END Center;

PROCEDURE RandomizeShuffle();
CONST GetDT=105; (* BDOS Function *)
VAR dat:ARRAY[0..1] OF CARDINAL;
BEGIN
  BDOS(GetDT,ADR(dat));
  Randomize(IORESULT+dat[0]+dat[1]);
END RandomizeShuffle;

PROCEDURE InputCardinal
          (x,y:CARDINAL;VAR num:CARDINAL;l:CARDINAL):BOOLEAN;
VAR i:CARDINAL;
    ch:CHAR;
    s:ARRAY[0..30] OF CHAR;
BEGIN
  i:=0;
  REPEAT
    CursorXY(x+i,y);
    ReadChar(ch);
    IF (ch>='0') AND (ch<='9') AND (i<l) THEN
      s[i]:=ch;
      s[i+1]:=0C;
      INC(i);
      WRITE(ch);
    ELSIF ((ch=10C) OR (ch=177C)) AND (i>0) THEN
      s[i]:=0C;
      DEC(i);
      CursorXY(x+i,y); WRITE(' ');
    ELSIF (ch=33C) OR (ch=3C) THEN
      s[0]:=0C;
    END;
  UNTIL (ch=33C) OR (ch=3C) OR ((ch=15C) AND (i>0));
  IF (ch=33C) OR (ch=3C) THEN RETURN FALSE END;
  RETURN StrToCard(s,num);
END InputCardinal;

BEGIN
  Term:=KAYPRO;
END XTerm.
