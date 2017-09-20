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
	
	syllables: Float;
	words	 : Float;
	sentences: Float;

	fleschVal: Float;
	fkincaidVal : Float;
	alpha : float;
	beta : float;

	syllFound : Integer;

	function is_Vowel (curr: Character) return Boolean is
	begin
	return (if(curr='a' or else curr='i' or else curr='e' or else curr='o' or else curr='u' or else curr='y') then True else False);
	end is_Vowel;

	function is_Punct (curr: Character) return Boolean is
	begin
	return (if(curr='.' or else curr=':' or else curr='?' or else curr='!' or else curr=';') then True else False);
	end is_Punct;
	
begin
	syllables := 0.0;
	words := 0.0;
	sentences := 0.0;

	syllFound := 0;
	prev := '~';

	Open(File => infile, Mode => Ada.Text_IO.In_File, Name=>"KJV.txt");
	while not End_Of_File(infile) loop
		Get(File => infile, Item => curr);
	--	Put(Item => curr);
	
		if(not Is_Digit(curr)) then
			if(not is_Vowel(prev) and is_Vowel(curr)) then
				syllables := syllables + 1.0;
				syllFound := 1;
			elsif(curr='.' or else curr=':' or else curr='?' or else curr='!' or else curr=';') then
				sentences := sentences + 1.0;
				words := words + 1.0;
				if(syllFound = 0) then
					syllFound := 0;
					syllables := syllables + 1.0;
				end if;
			elsif(prev = 'e') then
				if(is_Punct(curr) or else curr=' ' or else curr=',' or else curr=']') then
					syllables := syllables - 1.0;
				end if;
			elsif(Is_Letter(prev))then
				if(curr=' ' or else curr=',' or else curr=']')then
					words := words + 1.0;
					if(syllFound = 0) then
						syllFound := 0;
						syllables := syllables + 1.0;
					end if;
				end if;
			end if;
		prev := curr;
		end if;
	end loop;

	Exception
		when Ada.IO_Exceptions.END_ERROR => Ada.Text_IO.Close(File => infile);

	alpha := (syllables/words);
	beta := (words/sentences);
	fleschVal := (206.835 - (84.6*alpha) - (1.015*beta));
	fkincaidVal :=((11.8*alpha) + (0.39*beta) -15.59);

	Put("Syllables: ");
	Put(syllables, 10, 0, 0);
	NEW_LINE;

	Put("Words: ");
	Put(words,10,0,0);
	NEW_LINE;

	Put("Sentences: ");
	Put(sentences,10,0,0);
	NEW_LINE;

	Put("Flesch: ");
	Put(fleschVal,4,4,0);
	NEW_LINE;

	Put("Flesch-Kincaid: ");
	Put(fkincaidVal, 2,4,0);
	NEW_LINE;
end texteditor;