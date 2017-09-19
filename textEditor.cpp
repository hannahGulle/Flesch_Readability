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

	int num_Words = 0; //word count
	int num_Syllables = 0; // syllable count
	int num_Sentences = 0; // sentence count
	
	//Open File
	ifstream infile;
	char* filename = argv[1];

	if(argc ==2){
		infile.open(filename); //file opened
	}
	else{
		cerr << "File Not Found" << endl;
	}

	char curr, prev;
	bool syllFound = false;
	while(infile.get(curr)){//read the file char by char
		if(!isdigit(curr)){//skip the curr char if it is a number
			if(!isVowel(prev) && isVowel(curr)){// Ex: " ant"
				num_Syllables++;//Vowel starting a word is
				syllFound = true;//a syllable
			}
			else if(isPunct(curr)){
				num_Sentences++;//it counts a sentence
				num_Words++;//and a word
				if(!syllFound){
					num_Syllables++;
				}
			}
			else if((prev == 'e')&&(isDelim(curr))){//if prev char was an 'e'
					num_Syllables--;//and curr char ends a word
				//the 'e' syllable doesn't count. EX: "e." || "e " || "e,"
			}
			else if(isalpha(prev)){//If the prev char is any letter
				if(isDelim(curr)){//and the curr char is a 
					num_Words++;//space or comma
					if(!syllFound){
						num_Syllables++;
					}
				}// and restarts the syllable bool Ex: "bool " && "int,"
			}
			prev = curr;	
		}	
	}

	cout << "Words: " << num_Words << endl;
	cout << "Syllables: " << num_Syllables << endl;
	cout << "Sentences: " << num_Sentences << endl;

	infile.close();//file closed
	float flesch = computeFlesch(num_Syllables, num_Words, num_Sentences);
	float fleschKincaid = computeFleschKincaid(num_Syllables, num_Words, num_Sentences);
	cout << "alpha: " << (num_Syllables/num_Words) << endl;
	cout << "beta: " << (num_Words/num_Sentences) << endl;
	cout << "Flesch: " << fixed << setprecision(3) << flesch << endl;// print to 1 decimal place
	cout << "Flesch-Kincaid: "<< fixed << setprecision(3) << fleschKincaid << endl;
	
	return 0;
}
bool isPunct(char letter){
	string punct = ".:;?!";//possible end of sentence punctuation
	return (punct.find(letter) != -1);
}
bool isDelim(char letter){
	string delim = " ,]";
	return(delim.find(letter) != -1);
}
bool isSpace(char letter){
	return (letter == ' ');
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
