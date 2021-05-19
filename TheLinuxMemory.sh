#!/bin/bash
#Written by Frederik Heck, Julien Burdet, Urs Mezenen, David Maerki. Tested on Ubunutu, Debian and Fedora.
arrayGameInformation=("Player1" "Player2" "ScorePlayer1" "ScorePlayer2" "turn" "userInput1" "userInput2" "count") #last one is count initalized with 0 for while loop
arrayInit=("UBUNTU " "UBUNTU " " MINT  " " MINT  " "FEDORA " "FEDORA " "DEBIAN " "DEBIAN " " ARCH  " " ARCH  " " SUSE  " " SUSE  " " KALI  " " KALI  " "GENTOO " "GENTOO " "MANJARO" "MANJARO" "RASPIAN" "RASPIAN")
declare -a arrayGame arrayRevealed
setupGame (){  #prepare the new game
    arrayRevealed=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ) #reset all fields
    arrayGameInformation=(${arrayGameInformation[0]} ${arrayGameInformation[1]} 0 0 ${arrayGameInformation[4]} "userInput1" "userInput2" 0) #reset the gameInformations for a new game (except the player names and the actual turn)
    # shuffle the cards and create the new board
    length=${#arrayInit[@]}
    arrayTemp=("${arrayInit[@]}")
    for i in {1..20}; do
        r=$((1 + RANDOM % $length))
        name=${arrayTemp[$r-1]}
        while [[ -z "${name// }" ]]; do
            r=$((1 + RANDOM % $length))
            name=${arrayTemp[$r-1]}
        done
        arrayGame[$i-1]=$name
        arrayTemp[$r-1]=""
    done
}
printFunction(){  #print the board
  declare -a arrayPrintName
  arrayPrintNumber=("   1   " "   2   " "   3   " "   4   " "   5   " "   6   " "   7   " "   8   " "   9   " "  10   " "  11   " "  12   " "  13   " "  14   " "  15   " "  16   " "  17   " "  18   " "  19   " "  20   " )
  for j in {1..20}; do  #check if the cards are...
    if [ ${arrayRevealed[$j-1]} -eq 0 ]; then arrayPrintName[$j-1]=" Linux " #... unrevealed
    elif [ ${arrayRevealed[$j-1]} -eq 2 ]; then #... finally revealed
        arrayPrintNumber[$j-1]="       "
        arrayPrintName[$j-1]=${arrayGame[$j-1]}
    else arrayPrintName[$j-1]=${arrayGame[$j-1]} #... temporary revealed
    fi
  done
  clear
  if [ ${arrayGameInformation[5]} -le 9 2>/dev/null ]; then arrayPrintNumber[${arrayGameInformation[5]}-1]=" --${arrayGameInformation[5]}-- " #mark the temporary revealed cards with --x--
  elif [ ${arrayGameInformation[5]} -gt 9 2>/dev/null ] ; then arrayPrintNumber[${arrayGameInformation[5]}-1]="--${arrayGameInformation[5]}-- "
  fi
  if [ ${arrayGameInformation[6]} -le 9 2>/dev/null ]; then arrayPrintNumber[${arrayGameInformation[6]}-1]=" --${arrayGameInformation[6]}-- "
  elif [ ${arrayGameInformation[6]} -gt 9 2>/dev/null ]; then arrayPrintNumber[${arrayGameInformation[6]}-1]="--${arrayGameInformation[6]}-- "
  fi
  echo -e "\n██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗    ██████╗  █████╗ ███╗   ███╗\n██║     ██║████╗  ██║██║   ██║╚██╗██╔╝    ██╔══██╗██╔══██╗████╗ ████║\n██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝     ██████╔╝███████║██╔████╔██║\n██║     ██║██║╚██╗██║██║   ██║ ██╔██╗     ██╔══██╗██╔══██║██║╚██╔╝██║\n███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗    ██║  ██║██║  ██║██║ ╚═╝ ██║\n╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝\n\n\n${arrayGameInformation[0]}  ${arrayGameInformation[2]} : ${arrayGameInformation[3]}  ${arrayGameInformation[1]}\n\n---------------------------------------------------------\n|| ${arrayPrintNumber[0]} || ${arrayPrintNumber[1]} || ${arrayPrintNumber[2]} || ${arrayPrintNumber[3]} || ${arrayPrintNumber[4]} ||\n|| ${arrayPrintName[0]} || ${arrayPrintName[1]} || ${arrayPrintName[2]} || ${arrayPrintName[3]} || ${arrayPrintName[4]} ||\n---------------------------------------------------------\n|| ${arrayPrintNumber[5]} || ${arrayPrintNumber[6]} || ${arrayPrintNumber[7]} || ${arrayPrintNumber[8]} || ${arrayPrintNumber[9]} ||\n|| ${arrayPrintName[5]} || ${arrayPrintName[6]} || ${arrayPrintName[7]} || ${arrayPrintName[8]} || ${arrayPrintName[9]} ||\n---------------------------------------------------------\n|| ${arrayPrintNumber[10]} || ${arrayPrintNumber[11]} || ${arrayPrintNumber[12]} || ${arrayPrintNumber[13]} || ${arrayPrintNumber[14]} ||\n|| ${arrayPrintName[10]} || ${arrayPrintName[11]} || ${arrayPrintName[12]} || ${arrayPrintName[13]} || ${arrayPrintName[14]} ||\n---------------------------------------------------------\n|| ${arrayPrintNumber[15]} || ${arrayPrintNumber[16]} || ${arrayPrintNumber[17]} || ${arrayPrintNumber[18]} || ${arrayPrintNumber[19]} ||\n|| ${arrayPrintName[15]} || ${arrayPrintName[16]} || ${arrayPrintName[17]} || ${arrayPrintName[18]} || ${arrayPrintName[19]} ||\n---------------------------------------------------------\n" #print the board
}
userInput(){  #get the userinput and validate it. Must call the function with parameter 8 or 9
    echo ${arrayGameInformation[${arrayGameInformation[4]}]}", please install a distribution:"
    read num #get number
    if [ $num -ge 1 2>/dev/null ] && [ $num -le 20 ]; then #check if its between 1 and 20
    	if [ ${arrayRevealed[$num -1 ]} -ge 1  ]; then #check if the card is already revealed
    	    echo "Sorry, this distribution is already installed!"
    	    userInput $1 #get input again because invalid
    	else
    	    arrayGameInformation[$1]=$num #save the input in the correct place of the array, decided by the parameter 8 or 9
    	    arrayRevealed[$num -1 ]=1 # turn the card
    	    printFunction
    	fi
    else
    	echo "PAGE FAULT: Chose a memory-fragment by entering a number between 1 and 20!"
    	userInput $1 #get input again because invalid
    fi
}
checkCouple(){   #check if the selected cards match
    if [ ${arrayGame[${arrayGameInformation[5]}-1]} = ${arrayGame[${arrayGameInformation[6]}-1]} ]; then
    	let arrayGameInformation[${arrayGameInformation[4]}+2]+=1 #get the actual player and increment his score (works only with this arraystructure)
    	let arrayGameInformation[7]+=1 #increment count
      arrayRevealed[${arrayGameInformation[5]}-1]=2 # marks the card of the couple as found
      arrayRevealed[${arrayGameInformation[6]}-1]=2 # marks the card of the couple as found
    	printFunction #print the field to show the match
      echo -e "Congratulation! The distribution file was successfully repaired and installed on the server."
    	read -p "Press enter to fix another one."
    else
    	printFunction #print field before turning the cards back up
    	read -p "Permission denied! Logout with enter. "
    	arrayRevealed[${arrayGameInformation[5]}-1]=0 #turn frist card back up
    	arrayRevealed[${arrayGameInformation[6]}-1]=0 #turn second card back up
    	let arrayGameInformation[4]=!${arrayGameInformation[4]} #switch turn
    fi
}
# main routine
clear; echo -e "\n██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗    ██████╗  █████╗ ███╗   ███╗\n██║     ██║████╗  ██║██║   ██║╚██╗██╔╝    ██╔══██╗██╔══██╗████╗ ████║\n██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝     ██████╔╝███████║██╔████╔██║\n██║     ██║██║╚██╗██║██║   ██║ ██╔██╗     ██╔══██╗██╔══██║██║╚██╔╝██║\n███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗    ██║  ██║██║  ██║██║ ╚═╝ ██║\n╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝\n\nTHE LINUX RANDOM ACCESS MEMORY\n\n\nWe received an important message from the Linux distribution server.\nIt seems like all installation files were corrupted and are spread over the whole memory. The system needs a qualified administrator, to bring back the order.\n\nPlease open two user profiles, from which the algorithm will determine the best capable administrator for the server. Challenge a colleague to proof your skills. Only a real Linux crack can handle this mission.\n\n\nEnter a name to allocate memory for user profile 1 [Please no blanks]:"; read arrayGameInformation[0]
echo -e "\nEnter a name to allocate memory for user profile 2 [Please no blanks]:"; read arrayGameInformation[1]
clear; echo -e "\n██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗    ██████╗  █████╗ ███╗   ███╗\n██║     ██║████╗  ██║██║   ██║╚██╗██╔╝    ██╔══██╗██╔══██╗████╗ ████║\n██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝     ██████╔╝███████║██╔████╔██║\n██║     ██║██║╚██╗██║██║   ██║ ██╔██╗     ██╔══██╗██╔══██║██║╚██╔╝██║\n███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗    ██║  ██║██║  ██║██║ ╚═╝ ██║\n╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝\n\nTHE LINUX RANDOM ACCESS MEMORY\n\n\n[Authors]\nFrederik Heck, Julien Burdet, Urs Mezenen, David Maerki\n\n\n[Instructions]\nThe system could recover 20 memory-fragments. If your user profile is online, try to find the two fragments that belong together. You can access them by entering the associated memory-address (Try it with numbers between 1 and 20). If you have chosen two memory addresses the system will join them and starts an installation attempt.\n\nDon’t wait! Time is running out...";read
arrayGameInformation[4]=$((1+ RANDOM % 2 -1)) #generate turn
while true; do
  setupGame           #generate the map
  while [ ${arrayGameInformation[7]} -lt 10 ]; do #while loop until all cards are turned up
    printFunction       #print the map
    userInput 5; userInput 6 #get the two user inputs (the numbers give the indices of arrayGameInformation)
    checkCouple #check if they match
    arrayGameInformation[5]="actualFiedl1"; arrayGameInformation[6]="actualField2"  #reset the just turned cards to look normal again
  done
  if [ ${arrayGameInformation[2]} -gt ${arrayGameInformation[3]} ]; then #decide who won the game
      echo ${arrayGameInformation[0]}" could fix the most distribution files. What a crack! You now have root access! "
      arrayGameInformation[4]=0
  elif [ ${arrayGameInformation[3]} -gt ${arrayGameInformation[2]} ]; then
      echo ${arrayGameInformation[1]}" could fix the most distribution files. What a crack! You now have root access! "
      arrayGameInformation[4]=1
  else
      echo -e "\nROOT ACCESS DENIED! The system couldn't determine a worthy system administrator."
  fi
  read -p "Press enter to format the system."
done
