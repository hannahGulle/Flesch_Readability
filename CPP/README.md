Author: Hannah Gulle
Submitted For: CSC 330 Program 1: Text Parsing--Flesch Readability Index
Due: Monday, September 25th, 2017

Goal:
To create a text parsing program that will count the syllables, words, and
sentences of a given text file to compute the Flesch Readability Index and
the Flesch Kincaid Grade Index.

Input and Output Specifications:

Input:
The following command line specifications are necessary and sufficient for the
program to work as expected:
    1.) To compile: "c++ textEditor.cpp"
    2.) To Execute: ./a.out file.txt

Output:
The program outpus the number of syllables, words, and sentences of the given
text file, along with, the Flesch Readability Index to the ones place and the
Flesch Kincaid Grade Level to the tenths place.

Algorithm Used, Including Exception Handling:

Algorithm:
1.) The file is parsed character by character.
2.) When the current character is not a digit and is a vowel, and when the 
previous character is not a vowel, then the number of syllables increments and
a syllable is noted as FOUND.
3.) When the curent character is not a digit and not an end-of-sentence
punctuation, then the number of sentences, number of words, and number of
syllables is incremented.
4.) When the current character is not a digit, not a mid-sentence punctuation,
and the previous character is not an 'e', decrement the number of syllables.
5.) When the current character is not a digit, not a mid-sentence punctuation,
and the previous character is an alphabetical, increment the number of words
and the number of syllables.
6.) Set the previous character to the current character.

Exceptions:
A file not given at the command line produces an error.