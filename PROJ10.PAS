{---------------------------------------------------------------------------}
{------------------DNA MANIPULATION PROGRAM---------------------------------}
{---------------------------------------------------------------------------}
{--PURPOSE : To allow the user to manipulate DNA quickly and efficiently----}
{--AUTHOR  : Leigh Dodds     2nd year undergraduate.                    ----}
{---------------------------------------------------------------------------}
{---------COMPUTING AND NUMERICAL BIOLOGY COURSE PROJECT--------------------}
{-----------Completed on :   19/5/92                           --------------------}
{---------------------------------------------------------------------------}

PROGRAM DNA_manipulator (input,output,enzyme_file,amino_file,text_file);


TYPE
 base =  (u,c,a,g,t);
 strand = STRING [255];
 codon = STRING [3];
 aminoacid = STRING [3];
 enzyme_record = RECORD                         {will contain enzyme info}
                   name_enzyme : STRING [10];
                   name_organism : STRING [30];
                   recognition_site : STRING [7];
                   cutting_distance : 1..7
                 END;
VAR
  dna_sequence,rna_sequence ,mutant_seq : strand;
  count : integer;
  temp_var : strand;
  amino_array  : array [u..g,u..g,u..g] of aminoacid;
  enzyme_array : array [1..14] of enzyme_record;
  dummy : char;
  manipulated_strand : strand;            {the strand currently manipulated}
{-----------------------------------------------------------------------------}
{------------This procedure reads in the amino acid data into an array--------}
{-----------------------------------------------------------------------------}
PROCEDURE initialise_amino_acid_array ;

 TYPE
   amino_acid = RECORD
                  array_position_1 : base;
                  array_position_2 : base;
                  array_position_3 : base;
                  acid             : aminoacid;
                END;
 VAR

    amino_record : amino_acid;
    amino_file   : file of amino_acid;

 BEGIN
   ASSIGN (amino_file,'AMINOACID.DAT');
   reset (amino_file);
   WHILE not eof (amino_file) DO
    BEGIN
      read (amino_file,amino_record);
      WITH amino_record DO
       BEGIN
         amino_array [array_position_1,
                      array_position_2,
                      array_position_3] := acid;
       END;
    END;
   close (amino_file);
 END;      {end of initialise array}
{----------------------------------------------------------------------------}
{--------This procedure reads in the enzyme information into an array--------}
{----------------------------------------------------------------------------}
PROCEDURE initialise_enzyme_array;

 VAR
   enzyme : enzyme_record;
   enzyme_file : text;

   counter : integer;

 BEGIN
   ASSIGN (enzyme_file, 'ENZYMES.DAT');
   reset (enzyme_file);
   WITH enzyme DO
    BEGIN
      FOR counter := 1 TO 14 DO
       BEGIN
         readln (enzyme_file,name_enzyme);
         readln (enzyme_file,name_organism);
         readln (enzyme_file,recognition_site);
         readln (enzyme_file,cutting_distance);
         enzyme_array [counter] := enzyme;
       END;  {loop}
    END;
  close (enzyme_file)
END;       {end of procedure}
{----------------------------------------------------------------------------}
{--This is the main program procedure.The header is here to widen its scope--}
{----------------------------------------------------------------------------}
PROCEDURE menu ;

{----------------------------------------------------------------------------}
{-------This procedure compares the DNA and mutant strands in memory---------}
{----------------------------------------------------------------------------}

  PROCEDURE sequence_comparison ;

    VAR
      number_similar_bases : integer;

    {----------------------------------------------------------------------}
       FUNCTION compare (seq_1,seq_2 : strand) : integer;

         VAR
           length_loop : integer;
           no_similar  : integer;
           length_1,length_2 : integer;
           end_loop    : integer;

         BEGIN
           no_similar := 0;
           length_1 := ord (seq_1 [0]);
           length_2 := ord (seq_2 [0]);
           IF (length_1 < length_2) THEN

                       end_loop := length_1
           ELSE
                       end_loop := length_2;
           FOR length_loop := 1 TO end_loop DO
            BEGIN
              IF seq_1 [length_loop] = seq_2 [length_loop] THEN

                         no_similar := no_similar + 1;
            END;
           compare := no_similar ;
         END;                               {---end of function--}
    {------------------------------------------------------------------------}

    BEGIN                                   {---begin procedure--}
      ClrScr;
      writeln ('***********SEQUENCE COMPARISON***********');
      writeln ('This option allows you to compare the mutant and normal DNA');
      writeln;writeln;
      writeln ('This is the normal DNA strand :');
      writeln (dna_sequence);
      writeln;writeln;
      writeln ('..and this is the mutant DNA strand :');
      writeln (mutant_seq);
      number_similar_bases := compare (dna_sequence,mutant_seq);
      writeln ('The sequences have ',number_similar_bases,' bases in common');
      writeln;writeln;
      writeln ('Press any key to return to the menu...');
      readln (dummy);
      menu;
    END;
{-----------------------------------------------------------------------------}
{---This procedure allows the user to choose which strand to use--------------}
{-----------------------------------------------------------------------------}

  PROCEDURE choose_strand_to_be_manipulated;

    VAR
      user_choice : char;

    BEGIN
      IF  (mutant_seq = '') THEN
                                      manipulated_strand := dna_sequence
      ELSE
       BEGIN
         writeln ('Which strand do you wish to manipulate ?');
         writeln ('A : The DNA strand currently in memory');
         writeln ('B : The mutant strand currently in memory');
         readln (user_choice);
         IF  (user_choice = 'a') THEN
                                      manipulated_strand := dna_sequence
         ELSE
                                      manipulated_strand := mutant_seq;
       END;
    END;

{-----------------------------------------------------------------------------}
{-----This procedure contains the transription and translation options--------}
{-----------------------------------------------------------------------------}

  PROCEDURE transcribe_and_translate;

  {-------------------------------------------------------------------------}
    PROCEDURE transcribe (sequence : strand);

      VAR
        mRNA : strand;
        counter : integer;

       BEGIN
         mRNA[0] := sequence[0];
         mRNA :='';
         FOR counter := 1 TO ord ( sequence [0] ) DO
          BEGIN
            CASE sequence [counter] OF
             'a'         : mRNA  := mRNA + 'u';   {using the case means that}
             'g'         : mRNA  := mRNA + 'c';   {anything other than these}
             'c'         : mRNA  := mRNA + 'g';  {bases is ignored.Error check}
             't'         : mRNA  := mRNA + 'a';
            END;
          END;
         rna_sequence := mRNA;
       END ;                                             {end of transcribe}

{----------------------------------------------------------------------------}

    FUNCTION base_type (b : char ) : base ;

      BEGIN
        CASE b OF          {this converts the string to the defined type base}
         'u'   : base_type := u;
         'g'   : base_type := g;
         'a'   : base_type := a;
         'c'   : base_type := c
        END                                    {end of the case}

      END;                                     {end of function}

{----------------------------------------------------------------------------}

    FUNCTION  chaingrowth (pos : integer ) : aminoacid  ;

      VAR
        codon_base1,codon_base2,codon_base3 : base;

      BEGIN          {this reads the array to find out the amino acid}
        codon_base1 := base_type (rna_sequence [pos]);
        codon_base2 := base_type (rna_sequence [pos + 1]);
        codon_base3 := base_type (rna_sequence [pos + 2]);
        chaingrowth := amino_array [codon_base1,codon_base2,codon_base3];

      END;                                     {end of function}

{----------------------------------------------------------------------------}

    FUNCTION translation (seq : strand ) : strand;

      VAR
       position_counter : integer;
        length           : integer;
        temp_strand      : strand;
        extra_bases      : integer;

      BEGIN
        length := ord (rna_sequence[0]);
        extra_bases := length mod 3;             {this removes any bases}
        length := length - extra_bases;          {that are short of a codon}
        position_counter := 1;
        temp_strand := '-' ;
        WHILE (position_counter <= length) DO
         BEGIN
           IF chaingrowth (position_counter) = '***' THEN

                    position_counter := length
           ELSE
            BEGIN
             temp_strand := temp_strand + chaingrowth (position_counter) + '-';
             position_counter := position_counter + 3
            END;
          END;
        translation := temp_strand;
      END;                                            {end of translation}
  {---------------------------------------------------------------------------}

  BEGIN         {beginning of trancribe_and_translate}
    ClrScr;
    writeln ('***********TRANSCRIPTION AND TRANSLATION************');
    choose_strand_to_be_manipulated;
    writeln;writeln;
    writeln ('The DNA strand currently being manipulated is  :');
    writeln (manipulated_strand);
    writeln;writeln;
    writeln ('Once transcribed , the strand will form this mRNA strand : ');
    writeln;writeln;
    transcribe (manipulated_strand);
    writeln (rna_sequence);
    writeln;writeln;
    writeln ('The polypeptide chain that this codes for is :');
    temp_var := translation (rna_sequence);
    writeln (temp_var);
    writeln;writeln;
    writeln ('Press any key to return to the menu ...');
    readln (dummy);
    menu
  END;

{---------------------------------------------------------------------------}
{----This procedure contains the restriction option-------------------------}
{---------------------------------------------------------------------------}
PROCEDURE restriction ;

  VAR
    chosen_enzyme : enzyme_record;

  {-----------------------------------------------------------------------}

   PROCEDURE choice_of_enzyme;

     VAR
       loop : integer;
       choice : 1..14;

     BEGIN
       writeln ('Here is the list of enzymes :');
       writeln;
       FOR loop := 1 TO 14 DO
        BEGIN
          writeln (loop, ' : ',enzyme_array [loop].name_enzyme);
        END;
       writeln ('Please enter your choice (1-14)');
       readln (choice);
       chosen_enzyme := enzyme_array [choice];
     END;
  {-------------------------------------------------------------------------}

    PROCEDURE  generate_fragments (recog_site : strand;
                                   cut_site   : integer;
                                   DNA_strand : strand  );

       VAR
         fragment_count : integer;
         frag_strand    : strand;

       {-------------------------------------------------------}
        FUNCTION cut ( VAR dna_strand : strand) : strand;

           VAR
             attachment_base_no : integer;
             cutting_base       : integer;
             fragment           : strand;
             nu_strand          : strand;

           BEGIN
             attachment_base_no := POS (recog_site , DNA_strand );
             IF (attachment_base_no = 0 ) THEN

                          fragment := ''

             ELSE
              BEGIN
                fragment := copy (DNA_strand , 1 ,
                                  attachment_base_no + cut_site -1);
                nu_strand := copy (DNA_strand ,attachment_base_no + cut_site,
                                   ord (DNA_strand [0]) );
                DNA_strand := nu_strand;
              END;
             cut := fragment ;
           END;                 {end of cut function}
       {---------------------------------------------------------------------}

       BEGIN                    {begin of generate_fragments procedure}
         fragment_count :=  1 ;
         frag_strand := cut (DNA_strand);
         IF  ( frag_strand = '' ) THEN

                      writeln (fragment_count , ' : ' ,DNA_sequence)
         ELSE
          BEGIN
            writeln (fragment_count , ' : ' ,frag_strand);
            WHILE ( ord (DNA_strand [0]) <> 0 )  AND
                  ( frag_strand <> '' )  DO
             BEGIN
               frag_strand := cut (DNA_strand);
               IF ( frag_strand <> '') THEN
                           writeln (fragment_count , ' : ' ,frag_strand);
               fragment_count := fragment_count + 1;
             END;
            writeln (fragment_count, ' : ' ,DNA_strand)
          END;
       END;         {end of generate fragments procedure}

   {-----------------------------------------------------------------------}

   BEGIN   {Start of the RESTRICTION PROCEDURE }
     ClrScr;
     writeln ('************RESTRICTION ENZYME EXPERIMENT***********');
     writeln;
     choose_strand_to_be_manipulated;
     choice_of_enzyme;
     WITH chosen_enzyme DO
      BEGIN
        writeln (name_enzyme , ' was isolated from the organism - ',
                 name_organism );
        writeln (' The recognition site for ',name_enzyme,' is ',
                 recognition_site );
        writeln ('This is the current DNA strand being manipulated is :');
        writeln (manipulated_strand);
        writeln (name_enzyme , ' will cut the strand into these fragments :');
        generate_fragments (recognition_site,cutting_distance,dna_sequence);
        writeln;writeln;
        writeln ('Press any key to return to menu ');
        readln (dummy);
        menu;
      END;
     END;
{---------------------------------------------------------------------------}
{-----This procedure contains the mutation option---------------------------}
{---------------------------------------------------------------------------}

PROCEDURE mutation  (dna_strand : strand);

  VAR
    random_position : integer;
    length_seq : integer;
    user_input : char;
    choice  : char;

  {------------------------------------------------------------------------}

  FUNCTION deletion (seq : strand) : strand;

    VAR
      pre_deletion_seq : strand;
      post_deletion_seq : strand;

    BEGIN
      pre_deletion_seq := copy (seq , 1 , (random_position -1) );
      post_deletion_seq := copy (seq , (random_position + 1) ,
                                       (length_seq - random_position) );
      deletion := pre_deletion_seq + post_deletion_seq
    END;
  {-------------------------------------------------------------------------}

  FUNCTION duplication (seq : strand ) : strand;

    CONST
      length_of_mutation = 1;

    VAR
      duplicated_base : STRING [length_of_mutation];

    BEGIN
      duplicated_base := copy (seq , random_position , length_of_mutation);
      insert (duplicated_base , seq , random_position );
      duplication := seq
    END;
  {-------------------------------------------------------------------------}

  FUNCTION translocation (seq : strand) : strand;

    CONST
      length_of_mutation = 3;

    VAR
      translocated_codon : codon ;
      nu_position : integer;
      pre_trans_seq , post_trans_seq : strand ;
      temp_seq : strand ;

    BEGIN
      nu_position := random (length_seq) + 1;
      translocated_codon := copy (seq, random_position , length_of_mutation);
      pre_trans_seq := copy ( seq , 1, random_position - 1 );
      post_trans_seq := copy ( seq , random_position + 3 ,
                                    (length_seq - random_position) );
      temp_seq := pre_trans_seq + post_trans_seq;
      insert (translocated_codon, temp_seq , nu_position);
      translocation := temp_seq
    END;
  {--------------------------------------------------------------------------}

  FUNCTION inversion (seq : strand ) : strand;


    VAR
      inversion_codon : codon;
      temp_seq : strand;

    BEGIN
      IF  ( ord (seq [0])  < 3 ) THEN
         inversion := seq
      ELSE
       BEGIN
         temp_seq := seq;
         inversion_codon := copy (seq , random_position , 3);
         temp_seq [random_position] := inversion_codon [3];
         temp_seq [random_position + 2] := inversion_codon [1];
         inversion := temp_seq
       END;
    END;

  {--------------------------------------------------------------------------}

  BEGIN      {Start of the MUTATION PROCEDURE }
    ClrScr;
    length_seq := length (dna_strand);
    random_position := random (length_seq) + 1;
    writeln ('**********DNA MUTATION EXPERIMENT************');
    writeln;writeln;
    writeln ('The DNA strand being manipulated for mutation is : ');
    writeln (manipulated_strand);
    writeln;writeln;
    writeln ('Here is the list of possible mutations : ' );
    writeln (' ( see instructions for more information ');
    writeln ('   A : DELETION  ');
    writeln ('   B : DUPLICATION ');
    writeln ('   C : TRANSLOCATION ');
    writeln  ('   D : INVERSION ');
    writeln ('Choose which mutation the strand is to be subjected to :');
    readln (user_input);
    CASE user_input OF
      'a' : mutant_seq := deletion (dna_strand);
      'b'  : mutant_seq := duplication (dna_strand);
      'c' : mutant_seq := translocation (dna_strand);
      'd' : mutant_seq := inversion (dna_strand)
     END;
    writeln ('The mutation occured at base number ',random_position);
    writeln ('The new strand is :');
    writeln;writeln (mutant_seq);
    writeln ('Do you wish to mutate this strand further ?');
    REPEAT
      readln (choice)
     UNTIL choice in ['y','n'];
    IF (choice = 'y') THEN
                           mutation (mutant_seq)
    ELSE
                           menu;

  END;


{---------------------------------------------------------------------------}
{------This procedure writes up a text file to the screen-------------------}
{---------------------------------------------------------------------------}
PROCEDURE screen_text (screen_num : integer );

 VAR
   text_file : text;
   text_input : STRING [255];

 BEGIN
   ClrScr;
   CASE screen_num OF
     1   :   ASSIGN (text_file, 'TRANSINFO.DAT');
     2   :   ASSIGN (text_file, 'MUTINFO.DAT');
     3   :   ASSIGN (text_file, 'RESINFO.DAT')
    END;  {end of case}
   reset (text_file);
   WHILE not eof (text_file) DO
    BEGIN
      readln (text_file,text_input);
      writeln (text_input)
    END;
   readln (dummy);
   close (text_file);
   menu
 END;
{----------------------------------------------------------------------------}
{-----This procedure allows the user to call the instructions.see above------}
{----------------------------------------------------------------------------}

PROCEDURE instructions;

 VAR
   choice : integer;

 BEGIN
   ClrScr;
   writeln ('-------------INSTRUCTION MENU----------------');
   writeln ;writeln;writeln;
   writeln ('Which of the features do you want information on ? :');
   writeln ('1 : Transcription and translation ');
   writeln ('2 : The mutations ');
   writeln ('3 : The restriction enzymes ');
   readln (choice);
   screen_text (choice);
  END;
{----------------------------------------------------------------------------}
{------This procedure allows the user to enter the DNA strand----------------}
{----------------------------------------------------------------------------}
PROCEDURE input_dna_strand ;

VAR
  user_input : char;

BEGIN
  ClrScr;
  writeln ('Please enter the DNA strand to be manipulated.');
  writeln ('Include only the bases c , a , g , t (up to 126) ');
  readln (dna_sequence);
  writeln ('Is the strand entered correctly ? This cannot be corrected later');
  writeln ('Enter (Y)es or (N)o : ');
  REPEAT
    readln (user_input);
   UNTIL user_input in ['y','n'];
  IF (user_input = 'y' ) THEN
                                menu
                         ELSE
                                input_dna_strand;


END ; {---end of the input procedure---}
{----------------------------------------------------------------------------}
{---------This procedure contains the exit program option--------------------}
{----------------------------------------------------------------------------}

PROCEDURE exit_program;

 VAR
   u_input : char;

 BEGIN
   ClrScr;
   writeln ('Are you sure you wish to exit the program ? Y or N ');
   REPEAT
     readln (u_input)
    UNTIL u_input in ['y','n'];
   IF (u_input = 'n') THEN
                             menu
                      ELSE
                             writeln ('o.k.');
 END;
{----------------------------------------------------------------------------}
{-------------This is the beginning of the MENU PROCEDURE--------------------}
{----------------------------------------------------------------------------}

VAR
  menu_choice : integer;

BEGIN
  ClrScr;
  writeln ('150 COMPUTER PROJECT.LEIGH DODDS 1992. DNA MANIPULATOR');
  writeln ('------------------MAIN MENU-----------------------');
  writeln;writeln;writeln;
  writeln ('1 : User instructions ');
  writeln ('2 : Change current DNA strand ');
  writeln ('3 : Transcribe and Translate DNA strand ');
  writeln ('4 : Mutate DNA strand ');
  writeln ('5 : Restriction enzyme experiment ');
  writeln ('6 : Compare 2 DNA strands ');
  writeln ('7 : EXIT the program');
  write ('Enter choice (1-7) : ');
  REPEAT
    readln (menu_choice);
   UNTIL menu_choice in [1..7];
  CASE menu_choice OF
    1 : instructions;
    2 : input_dna_strand;
    3 : transcribe_and_translate;
    4 : BEGIN                              {Placing the choice of strand}
          choose_strand_to_be_manipulated; {here allows the mutation procedure}
          mutation (manipulated_strand)    {to call itself without continually}
                                           {having to choose a strand.}
        END;
    5 : restriction ;
    6 : sequence_comparison;
    7 : exit_program;

   END;

END; {---end of the menu procedure--}

{----------------------------------------------------------------------------}
{--------------This is the start of the main program.------------------------}
{----------------------------------------------------------------------------}

BEGIN
  dna_sequence := '';
  rna_sequence := '';
  mutant_seq := '';
  manipulated_strand := '';
  initialise_amino_acid_array;
  initialise_enzyme_array;
  menu
END.