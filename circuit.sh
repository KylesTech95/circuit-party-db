#! /bin/bash
PSQL="psql -U postgres -d circuit --tuples-only -c"
echo -e "\n ~~~~2024 Cirtcuit Party Registration~~~~ \n"

# clear tables & restart primary key sequence to 1
# echo $($PSQL "truncate tickets,rsvp,attendees;alter sequence tickets_ticket_id_seq restart with 1;alter sequence rsvp_rsvp_id_seq restart with 1;alter sequence attendees_attendee_id_seq restart with 1;")



CUSTOMER_INFO(){
    TICKET_SELECTED=$1
    TICKET_TYPE=$($PSQL "select type from tickets where ticket_id=$TICKET_SELECTED")
    # phone number
    echo -e "\nWhat is your phone number?"
    # read phone number
    read ATTENDEE_PHONE
    NAME_RETRIEVED=$($PSQL "select name from attendees where phone='$ATTENDEE_PHONE'")
    # if phone number is not matched with a customer by ID
    if [[ -z $NAME_RETRIEVED ]]
        # How old are you ? 
        then
        echo -e "\nHow old are you?"
        read ATTENDEE_AGE
            # if age is under 21
            if [[ $ATTENDEE_AGE -lt 21 ]]
                then
                # send to MENU "\nYou are underage."
                LIMIT=21
                YEARS_UNTUL_21=$(echo `expr $LIMIT - $ATTENDEE_AGE`)
                echo -e "\nYou are underage by approximately $YEARS_UNTUL_21 years."
                # if age is 21 and over
                else
                # what is your name?
                echo -e "\nWhat is your name?"
                read ATTENDEE_NAME
                #insert customer information
                INSERT_ATTENDEE=$($PSQL "insert into attendees(name,age,phone) values('$ATTENDEE_NAME',$ATTENDEE_AGE,'$ATTENDEE_PHONE')")
                MENU "\n$ATTENDEE_NAME, your rsvp is setup for$TICKET_TYPE.\nSee you there!"
            fi
    else
    # if phone number is matched with customer by ID
        echo -e "\n$(echo $NAME_RETRIEVED | sed 's/^\s+//'), welcome back."
        sleep .5
        # would you like to purchase for family/friends? (The user is simply buying a ticket for someone else.)
        echo -e "\nWould you like to purchase for a friend/family member? [y|n](case-insensivite)"
        sleep .5
        read OPTION
            # no option makes sense
            if [[ ! $OPTION =~ [y|Y|n|N] ]]
                then
                MENU
            # if yes
            else
                if [[ $OPTION =~ [y|Y] ]]
                    then
                    # list tickets options
                    echo -e "\nWelcome to purchase"
                    sleep .5
                    echo "$AVAILABLE_TICKETS" | while read TICKET_ID BAR TYPE BAR PRICE BAR DESCRIPTION
                    do
                    echo -e "\n$TICKET_ID) Ticket Type: $TYPE ($DESCRIPTION) - Price: $PRICE"
                    done
                    read TICKET_SELECTED
                    TICKET_MATCH=$($PSQL "select ticket_id from tickets where ticket_id='$TICKET_SELECTED'")
                    # their phone number
                    # read phone number
                    # if phone number is not matched with a customer by ID
                        # How old are they ? 
                            # if age is under 21
                                # send to MENU "\nThey are underage."
                            # if age is 21 and over
                                # what is their name?
                                #insert customer information
                else
                    # if no
                    # send user rsvp information.
                    echo -e "\n ~~~~RSVP INFORMATION ~~~~\n"
                    sleep .5
                    MENU "\n$(echo $NAME_RETRIEVED | sed 's/^\s+//'), your rsvp is setup for$TICKET_TYPE.\nSee you there!"
                    # MENU
                fi
            
            fi
            

            
    fi


}
MENU(){
    sleep .5
    if [[ $1 ]]
    then echo -e "\n$1"
    fi

    echo -e "\n1. Purchase Tickets\n2. Donate\n3. Exit"
    read MENU_SELECTION

    case $MENU_SELECTION in 
    1) PURCHASE_MENU ;;
    2) DONATE_MENU ;;
    3) EXIT ;;
    esac
}
# purchase menu
PURCHASE_MENU(){
    # purchase variables
    AVAILABLE_TICKETS=$($PSQL "select ticket_id,type,price,description from tickets where available=true")
    AVAILABLE_VIP=$($PSQL "select * from tickets where available=true and type='VIP' ")
    AVAILABLE_GA=$($PSQL "select * from tickets where available=true and type='GA' ")

    # if no tickts are available
    if [[ -z $AVAILABLE_TICKETS ]]
    then
        echo -e "\nSorry we are sold out. See you next year!"
        
    else
        # list tickets options
        echo -e "\nWelcome to purchase"
        sleep .5
        echo "$AVAILABLE_TICKETS" | while read TICKET_ID BAR TYPE BAR PRICE BAR DESCRIPTION
        do
        echo -e "\n$TICKET_ID) Ticket Type: $TYPE ($DESCRIPTION) - Price: $PRICE"
        done
        read TICKET_SELECTED
        TICKET_MATCH=$($PSQL "select ticket_id from tickets where ticket_id='$TICKET_SELECTED'")
        #if user does not choose within the listed options
        if [[ -z $TICKET_MATCH ]]
            then
            echo -e "\n$TICKET_SELECTED is not a valid option.\nTry again."
            sleep .5
            # list tickets options
            echo "$AVAILABLE_TICKETS" | while read TICKET_ID BAR TYPE BAR PRICE BAR DESCRIPTION
            do
            echo -e "\n$TICKET_ID) Ticket Type: $TYPE ($DESCRIPTION) - Price: $PRICE"
            done
            read TICKET_SELECTED
            TICKET_MATCH=$($PSQL "select ticket_id from tickets where ticket_id='$TICKET_SELECTED'")
            # if user still gets this wrong
            if [[ -z $TICKET_MATCH ]]
                then
                MENU "\n#$TICKET_SELECTED is not a valid option.\nWelcome to menu"
                else
                    # continue with customer_information
                    CUSTOMER_INFO $TICKET_SELECTED
            fi

            else
                # continue with customer_information
                CUSTOMER_INFO $TICKET_SELECTED
        fi
        


    fi  

}
DONATE_MENU(){
    echo -e "\nWelcome to donate" 
}
EXIT(){
    echo -e "\nThank you for visiting"
  sleep 1 
}

MENU
