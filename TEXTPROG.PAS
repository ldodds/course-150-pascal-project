{--------------------------------------------------------------------------}
{----------This program allows the user to input a screen of --------------}
{---------- text to include within other programs.           --------------}
{---------- Written on 2/3/92 by L.Dodds   Course 150        --------------}
{--------------------------------------------------------------------------}

PROGRAM text_file_writer (input,output,writing)  ;

CONST
  fin = 'finish';                     {The marker for the end of the text}

TYPE
  lines = text ;

VAR
  input : string [255];
  writing : lines;

BEGIN
  ClrScr;
  writeln ('***********Text writer program**********');
  writeln ('Please enter your text ...typing ''finish'' when finished');
  assign (writing , 'text.dat');
  rewrite (writing);                         {The program accepts text until}
  readln (input);                            {the word 'finish' is typed then}
  WHILE (input <> fin )  DO                  { writes it all to the disc  }
   BEGIN
     writeln ( writing,input);
     readln (input)
   END;
  writeln ('Now I shall write this to the disc');
  close (writing);
END.
