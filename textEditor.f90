! Hannah Gulle
! September 28, 2017
! Text parsing program to compute the Flesch Readability Index and the
! Flesch Kincaid Grade Level index using Fortran 90

program texteditor

integer::filesize

! -----------------------------
! read_file interface
! ----------------------------
interface
subroutine read_file(filesize)
integer::filesize
end subroutine read_file
end interface


call read_file(filesize)
end program texteditor

! -------------------------------------------------------------------------------
! read_file subroutine
! ------------------------------------------------------------------------------

subroutine read_file(filesize)
logical::syllFound
integer::syllables,words,sentences
character(LEN=1)::input
character(LEN=1)::curr,prev
integer::counter, filesize
real*8::fkincaid
integer::flesch
real*4::aVal,bVal
syllables = 0
words = 0
sentences = 0


! get number of characters in file
open(unit=5,status="old",access="direct",form="unformatted",recl=1,file="KJV.txt")

! put file in string of correct number of characters
counter = 1
prev = '~'
syllFound = .false.
100 read(5,rec=counter,err=200)input
        curr=input

        if( isDigit(curr) == 0) then
                if( (isVowel(prev) == 0) .and. (isVowel(curr) /= 0)) then
                        syllables = syllables+1
                        syllFound = .true.
                elseif( isPunct(curr) /= 0) then
                        sentences = sentences +1
                        words = words+1
                        if( syllFound .eqv. .false.) then
                                syllables = syllables+1
                        endif
                elseif( (index("e",prev) /= 0) .and. (index(" ,].:;?!",curr) /= 0)) then
                                syllables = syllables-1
                elseif( isAlpha(prev) /= 0 .and. (index(" ,]",curr) /= 0)) then
                        words = words +1
                        if(syllFound .eqv. .false.)then
                                syllables = syllables+1
                        endif
                endif
                prev = curr
        endif
        counter = counter + 1
        goto 100
200 continue
close(5)

print*, "Syllables ",syllables
print*, "Words ", words
print*, "sentences ", sentences

aVal = real(syllables)/real(words)
bVal = real(words)/real(sentences)

flesch = computeFlesch( aVal, bVal)
fkincaid = computefKincaid( aVal, bVal )

write(*,20) "Flesch: ",flesch
20 format(a,i3)

write(*,30) "FleschKincaid: ",fkincaid
30 format(a,f3.1)

end subroutine read_file

function computeFlesch(alpha, beta)
real*4::alpha,beta
computeFlesch = ((206.835 - (84.6*alpha)) - (1.015*beta));
return
end function computeFlesch

function computefKincaid(alpha,beta)
real*4::alpha,beta
computefKincaid = ( ((11.8*alpha) + (0.39*beta)) - 15.59)
return
end function computefKincaid

function isVowel(curr)
character(LEN=1)::curr
character(LEN=6)::vowels
vowels = "aeiouy"
isVowel = ( index(vowels, curr) )
return
end function isVowel

function isPunct(curr)
character(LEN=1)::curr
character(LEN=5)::punct
punct = ".:;?!"
isPunct = (index(punct, curr) )
return
end function isPunct

function isDigit(curr)
character(LEN=1)::curr
character(LEN=10)::digit
digit = "0123456789"
isDigit = (index(digit,curr) )
return 
end function isDigit

function isAlpha(curr)
character(LEN=1)::curr
character(LEN=52)::alpha
alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
isAlpha = (index(alpha,curr) )
return
end function isAlpha
