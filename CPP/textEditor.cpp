// Hannah Gulle
// August 28, 2017
// Text parsing program to compute the Flesch Readability Index and the Flesch
// Kincaid Grade Level Index using c++.

#include<iostream>
#include<fstream>
#include<iomanip>
#include<ctype.h>
using namespace std;

bool isDelim(char letter);
bool isPunct(char letter);
bool isVowel(char letter);
bool isSpace(char letter);
bool isLetter(char letter);
float computeFlesch(int num_Syllables, int num_Words, int num_Sentences);
float computeFleschKincaid(int num_Syllables, int num_Words, int num_Sentences);

int main(int argc, char *argv[]){

	int num_Words = 0;
	int num_Syllables = 0;
	int num_Sentences = 0;
	
	ifstream infile;
	char* filename = argv[1];

	if(argc ==2){
		infile.open(filename);
	}
	else{
		cerr << "Error: File Not Found" << endl;
	}

	char curr, prev;
	bool syllFound = false;//All words must be at least one syllable
	while(infile.get(curr)){
		if(!isdigit(curr)){
			if(!isVowel(prev) && isVowel(curr)){
				num_Syllables++;
				syllFound = true;
			}
			else if(isPunct(curr)){
				num_Sentences++;
				num_Words++;
				if(!syllFound){//If a word or sentence is found and
					num_Syllables++;// a syllable hasnt been recorded,
				}			// record 1 syllable.
			}
			else if((prev == 'e') && (isDelim(curr))){
				num_Syllables--;
			}
			else if(isalpha(prev) && isDelim(curr)){
				num_Words++;
				if(!syllFound){
					num_Syllables++;
				}
			}
			prev = curr;	
		}	
	}
	infile.close();

	cout << "Words: " << num_Words << endl;
	cout << "Syllables: " << num_Syllables << endl;
	cout << "Sentences: " << num_Sentences << endl;

	float flesch = computeFlesch(num_Syllables, num_Words, num_Sentences);
	float fleschKincaid = computeFleschKincaid(num_Syllables, num_Words, num_Sentences);
	
	cout << "Flesch: " << fixed << setprecision(0) << flesch << endl;
	cout << "Flesch-Kincaid: "<< fixed << setprecision(1) << fleschKincaid << endl;
	
	return 0;
}
// End of Sentences Punctuation
bool isPunct(char letter){
	string punct = ".:;?!";//possible end of sentence punctuation
	return (punct.find(letter) != -1);
}
// Mid-sentence Punctuation
bool isDelim(char letter){
	string delim = " ,]";
	return(delim.find(letter) != -1);
}

bool isVowel(char letter){
	string vowel = "aeiouy";//possible vowels
	return (vowel.find(letter) != -1);
}

float computeFlesch(int num_Syllables, int num_Words, int num_Sentences){
	float alpha = float(num_Syllables)/float(num_Words);
	float beta = float(num_Words)/float(num_Sentences);
	//Index = 206.835 - 84.6Alpha - 1.015Beta
	return (206.835 - (84.6*alpha) - (1.015*beta));
}

float computeFleschKincaid(int num_Syllables, int num_Words, int num_Sentences){
	float alpha = float(num_Syllables)/float(num_Words);
	float beta = float(num_Words)/float(num_Sentences);
	//Grade = 11.8Alpha + 0.39Beta - 15.59
	return ((11.8*alpha) + (0.39*beta) - 15.59);
}
