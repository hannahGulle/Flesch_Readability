#!/usr/bin/perl
# Hannah Gulle
# Text editor to compute the Flesch Readability Index 
# and the Flesch Kincaid Grade Level Index using Perl.
# August 30, 2017

# Opening File Now
my $infile = 'KJV.txt';
open(my $infile, '<:encoding(UTF-8)', $infile) or die "Yo No File Son";
read $infile, $file_string, -s $infile;		# -s is length of file
close $infile;

$syllables = 0.0;
$words = 0.0;
$sentences = 0.0;
$syllFound = 0;

foreach $curr (split //, $file_string){
	if(not isDigit($curr)){
		if( (not isVowel($prev))  & isVowel($curr)){
			$syllables++;
			$syllFound = 1;		
		}
		elsif( isPunct($curr) ){
			$sentences++;
			$words++;
			if($syllFound == 0){
				$syllFound = 0;
				$syllables++;
			}
		}
		elsif( $prev eq 'e'){
			if( (isPunct($curr)) || ($curr eq' ') || $curr eq ',' || ($curr eq ']')){
				$syllables--;
			}
		}
		elsif( isAlpha($prev) ){
			if( $curr eq' ' || $curr eq',' || $curr eq']'){
				$words++;
				if($syllFound == 0){
					$syllFound = 0;
					$syllables++;
				}
			}
		}
		$prev = $curr;
	}
}
print "Syllables: $syllables \n";
print "Words: $words \n";
print "Sentences: $sentences \n";

$alpha = ($syllables/$words);
$beta = ($words/$sentences);
$flesch = flesch($syllables, $words, $sentences);
$fkincaid = fkincaid($syllables, $words, $sentences);

print "\n alpha: $alpha \n";
print "beta: $beta \n";
print "flesch: $flesch \n";
print "fkincaid: $fkincaid \n";

sub flesch{
	my($syllables, $words, $sentences) = @_;
	$alpha = ($syllables/$words);
	$beta = ($words/$sentences);
	return(206.835 - ($alpha*84.6) - ($beta*1.015));
}

sub fkincaid{
	my($syllables, $words, $sentences) = @_;
	$alpha = ($syllables/$words);
	$beta = ($words/$sentences);
	return((11.8*$alpha) + ($beta*.39) - 15.59);
}

sub isVowel{
	my($curr) = @_;
	$vowels = "aeiouy";
	return(index($vowels, $curr) != -1);
}

sub isPunct{
	my($curr) = @_;
	$punct = ".:;?!";
	return(index($punct, $curr) != -1);
}

sub isDigit{
	my($curr) = @_;
	$digits = "0123456789";
	return(index($digits, $curr) != -1);
}

sub isAlpha{
	my($curr) = @_;
	$alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return(index($alpha, $curr) != -1);
}