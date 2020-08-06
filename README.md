# RTL_Binary_Encryption_Game
ENIGMA: Encryption Binary Math Game implemented on FPGA
This game is password protected and can be played by multiusers (Total 5 players can play this game, where 4 are dedicated players and one is the guest player). The game has 3 levels depending on the level of difficulty. Here we are making use of encrypted symbols for each digits (0-9) and these encrypted symbol will be displayed by seven segment display. To start with the game, player has to enter correct user ID and password. On successful password authentication player can start with the game else he/she cannot. 

Level 1: 

This level is training level session where score and timer will not be allotted to player. Encrypted symbol and its corresponding number will be shown on seven segment display. These number will show in sequential manner. To complete the level 1, player 1 has to come till number 9. If it covers till 9 then player is eligible to start with level 2. 

Level 2: 

This level is basically test for player to check how much he knows and trained from level 1. This level has timer of 90 sec and provides score on correct guess. The encrypted symbol for a number will be shown (symbol generation is random) on seven segment display and player has to guess the correct corresponding digit for it. If player enters correct number then player will get the score and he/she can play as many turns he/she wants within this 90 sec.  

Level 3:  

This level is also timer based and has timer of 60 sec and provides score on correct guess. The two encrypted symbols will be shown on seven segment display. Player has to detect those two numbers and compute the sum and enter the correct sum result using toggle switch. If the sum is correct then player will get score. Player can play as many turns he/she wants within this 60 sec.  

During this whole game play, player has chance to pause, resume or logout in between. 
