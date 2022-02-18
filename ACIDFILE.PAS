{--------------------------------------------------------------------------}
{---------This program allows the user to create a file for----------------}
{--------- the genetic coding of each amino acid           ----------------}
{--------- Written on 9/3/92 by L.Dodds Course 150         ----------------}
{--------------------------------------------------------------------------}

PROGRAM amino_acid_records (input,output);

 TYPE
   base        = (u,c,a,g);
   amino_acids = RECORD
                   array_position_1 : base;        {these are the positions}
                   array_position_2 : base;        {in the array in the main}
                   array_position_3 : base;        {program. L.Dodds }
                   acid             : STRING [3];
                 END;

 VAR
   acid_record : amino_acids;
   amino_file  : file of amino_acids;
   counter     : integer;
   position1,position2,position3 :base;


 BEGIN
   ASSIGN (amino_file,'AMINOACID.DAT');
   rewrite (amino_file);
   seek (amino_file,1);                    {This form of looping allows}
   WITH acid_record DO                    {the data to be entered easily}
    BEGIN                                 {from the table present in many}
      FOR position3 := u TO g DO            { text books.  L.Dodds }
       BEGIN
         FOR position2 := u TO g DO
          BEGIN
            FOR position1 := u TO g DO
             BEGIN
               writeln (ord(position1),ord(position2),ord(position3));
               writeln ('Enter the amino acid');
               readln (acid);
               array_position_1 := position1;
               array_position_2 := position2;
               array_position_3 := position3;
               write (amino_file,acid_record)
             END;     { of loop 1 }
          END;        { of loop 2 }
        END;          { of loop 3 }
    END;
   Writeln ('This task is completed');
   close (amino_file);
 END.