//Hannah Gulle
//August 28, 2017
//Text parsing program to compute the Flesch Readability Index and the Flesch
//Kincaid Grade Level Index using Java.
import java.io.FileReader;
import java.io.IOException;
import java.lang.Character;

public class textEditor{
	public static void main(String[] args) throws IOException{
	
	int num_Syllables = 0;
	int num_Words = 0;
	int num_Sentences = 0;


	//Open file for parsing
	FileReader infile = null;
	try{
		infile = new FileReader("KJV.txt");		

		int ch;
		char prev = '~';
		boolean syllFound = false;
		while( (ch = infile.read()) != -1){
			char curr = ( (char) ch);
			if(!isDigit(curr)){
				if(!isVowel(prev) && isVowel(curr)){
					num_Syllables++;
					syllFound = true;
				}

				else if(isPunct(curr)){
					num_Sentences++;
					num_Words++;
					if(!syllFound){
						syllFound = false;
						num_Syllables++;
					}
				}

				else if(prev == 'e'){
					if(isPunct(curr) || isSpace(curr) || curr == ',' || curr == ']'){
						num_Syllables--;
					}
				}

				else if(isAlpha(prev)){
					if(isSpace(curr) || curr == ',' || curr == ']'){
						num_Words++;	
						if(!syllFound){
							syllFound = false;
							num_Syllables++;
						}
					}
				}	
				prev = curr;
			}
		}	
	}	
	catch(IOException ex){
		System.out.println("File Not Found");
	}
	
	if(infile != null){
		infile.close();
	}

	System.out.println("Words: " + num_Words);
	System.out.println("Syllables: " + num_Syllables);
	System.out.println("Sentences: " + num_Sentences);

	System.out.println("alpha: " + (num_Syllables/num_Words));
	System.out.println("beta: " + (num_Words/num_Sentences));

	double flesch = computeFlesch(num_Syllables, num_Words, num_Sentences);
	double fleschKincaid = computeFleschKincaid(num_Syllables, num_Words, num_Sentences);
	
	System.out.println("Flesch: " + String.format("%.3f",flesch));
	System.out.println("Flesch-Kincaid: " + String.format("%.3f",fleschKincaid));
	}

	public static boolean isVowel(char letter){
		String vowels = "aeiouy";
		return(vowels.indexOf(letter) != -1);
	}

	public static boolean isDigit(char letter){
		String digit = "1234567890";
		return(digit.indexOf(letter) != -1);
	}

	public static boolean isAlpha(char letter){
		String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		return(alpha.indexOf(letter) != -1);
	}

	public static boolean isPunct(char letter){
		String punct = ".:;?!";
		return(punct.indexOf(letter) != -1);
	}

	public static boolean isSpace(char letter){
		return(letter == ' ');
	}

	public static double computeFlesch(int num_Syllables, int num_Words, int num_Sentences){
		double alpha = (double)num_Syllables/(double)num_Words;
		double beta = (double)num_Words/(double)num_Sentences;
		//Index = 206.835 - 84.6Alpha - 1.015Beta
		return(206.835 - (84.6*alpha) - (1.015*beta));
	}

	public static double computeFleschKincaid(int num_Syllables, int num_Words, int num_Sentences){	
		double alpha = (double)num_Syllables/(double)num_Words;
		double beta = (double)num_Words/(double)num_Sentences;
		//Grade = 11.8alpha + 0.39beta - 15.59
		return( (11.8*alpha) + (0.39*beta) - 15.59);
	}

}