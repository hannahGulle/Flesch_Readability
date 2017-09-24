-- Hannah Gulle --
-- Text Editor to compute the Flesch Readability Index --
-- and Flesch Kincaid Grade Index using ADA. --
-- August 30, 2017 --

with Ada.Text_IO;
use Ada.Text_IO;
with Ada.IO_Exceptions;
use Ada.IO_Exceptions;
with Ada.Strings.Maps;
use Ada.Strings.Maps;
with Ada.Characters.Handling;
use Ada.Characters.Handling;
with Ada.Float_Text_IO;
use Ada.Float_Text_IO;

procedure texteditor is
	curr: Character;
	prev: Character;
	infile : File_Type;		
	
	syllables: Integer;
	words	 : Integer;
	sentences: Integer;

	fleschVal: Integer;
	fkincaidVal : Float;
	alpha : float;
	beta : float;

	syllFound : Integer; -- Boolean True(1) False(0)

	function is_Vowel (curr: Character) return Boolean is
	begin
	return (if(curr='a' or else curr='i' or else curr='e' or else curr='o' or else curr='u' or else curr='y') then True else False);
	end is_Vowel;

	-- Punctuation = End of Sentences Punctuation
	function is_Punct (curr: Character) return Boolean is
	begin
	return (if(curr='.' or else curr=':' or else curr='?' or else curr='!' or else curr=';') then True else False);
	end is_Punct;
	
	-- Deliminator = Mid-sentence punctuation (Does not end sentence)
	function is_Delim (curr: Character) return Boolean is
	begin
	return (if(curr=' ' or else curr=',' or else curr=']')then True else False);
	end is_Delim;
	
begin
	syllables := 0;
	words := 0;
	sentences := 0;

	syllFound := 0;
	prev := '~'; -- Random insignificant character

	Open(File => infile, Mode => Ada.Text_IO.In_File, Name=>"KJV.txt");
	while not End_Of_File(infile) loop
		Get(File => infile, Item => curr);
	
		-- Skip all numeric digits
		if(not Is_Digit(curr)) then
			if(not is_Vowel(prev) and is_Vowel(curr)) then
				syllables := syllables + 1;
				syllFound := 1;
			elsif(is_Punct(curr)) then
				sentences := sentences + 1;
				words := words + 1;
				if(syllFound = 0) then -- Record 1 syllable for all
					syllables := syllables + 1;--words and sentences
				end if;			--with no syllables recorded yet.
			elsif(prev = 'e') then
				if(is_Punct(curr) or else is_Delim(curr)) then
					syllables := syllables - 1;
				end if;
			elsif(Is_Letter(prev) and is_delim(curr))then
				words := words + 1;
				if(syllFound = 0) then
					syllables := syllables + 1;
				end if;
			end if;
		prev := curr;
		end if;
	end loop;

	Exception
		when Ada.IO_Exceptions.END_ERROR => Ada.Text_IO.Close(File => infile);

	alpha := (Float(syllables)/Float(words));
	beta := (Float(words)/Float(sentences));
	fleschVal := Integer(206.835 - (84.6*alpha) - (1.015*beta));
	fkincaidVal :=((11.8*alpha) + (0.39*beta) -15.59);

	Put_Line("Syllables: " & natural'image(syllables));
	Put_Line("Words: " & natural'image(words));
	Put_Line("Sentences: " & natural'image(sentences));
	Put_Line("Flesch: " & natural'image(fleschVal));

	Put("Flesch-Kincaid: ");
	Put(fkincaidVal, 2,1,0);
	NEW_LINE;
end texteditor;
