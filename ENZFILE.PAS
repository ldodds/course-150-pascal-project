{----------------------------------------------------------------------------}
{-----This program allows the user to create a file containing---------------}
{----- information on restriction enzymes.L.Dodds.Course 150  ---------------}
{----------------------------------------------------------------------------}

PROGRAM file_containing_enzyme_info (input,output);

 TYPE
   enzyme_record = RECORD
                     name_enzyme      : STRING [10];
                     name_organism    : STRING [30];
                     recognition_site : STRING [7];
                     cutting_distance : 1..7;        {The number of bases }
                   END;                              {from the beginning }
                                                     {of the recog site }
 VAR
   enzyme : enzyme_record;
   enzyme_file : text;
   counter : integer;


 BEGIN
   ASSIGN (enzyme_file ,'ENZYMES.DAT');
   rewrite (enzyme_file);
   WITH enzyme DO
    BEGIN
      FOR counter := 1 TO 14 DO                   {The counter runs 14 times}
       BEGIN                                      {because this is the number}
         ClrScr;                                  {of enzymes I used in my  }
         write ('name : ');                       {project.  L.Dodds.}
         readln (name_enzyme);
         write ('organism : ');
         readln (name_organism);
         write ('recognition site : ');
         readln (recognition_site);
         write ('cut distance : ');
         readln (cutting_distance);

         writeln (enzyme_file,name_enzyme);
         writeln (enzyme_file,name_organism);
         writeln (enzyme_file,recognition_site);
         writeln (enzyme_file,cutting_distance);
       END;
    END; {loop}
   write (counter);
   close (enzyme_file);
   writeln ('o.k.');

END.
