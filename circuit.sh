#! /bin/bash
PSQL="psql -U postgres -d circuit --tuples-only -c"
echo -e "\n ~~~~2024 Cirtcuit Party Registration~~~~ \n"

# clear tables & restart primary key sequence to 1
# echo $($PSQL "truncate rsvp,attendees;alter sequence rsvp_rsvp_id_seq restart with 1;update tickets set count=300 where ticket_id < 4")


RSVP_INFO(){
    # rsvp information
    echo -e "\n~~~~ RSVP information center ~~~~"
    if [[ $1 ]]
        then echo -e "\n$1"
    fi
    CURRENT_TICKET_COUNT=$($PSQL "select count from tickets where ticket_id=$TICKET_SELECTED")
    COUNTER=1
    ATTENDEE_ID=$($PSQL "select attendee_id from attendees where phone='$ATTENDEE_PHONE'")
    NAME_RETRIEVED=$($PSQL "select name from attendees where phone='$ATTENDEE_PHONE'")

    sleep .5
    # obtain customer price from the ticket ID they selected.
    PRICE=$($PSQL "select price from tickets where ticket_id=$TICKET_SELECTED")
    echo -e "\nYou must pay me $PRICE."
    CURRENT_CHARGE=$($PSQL "select price from tickets where ticket_id = $TICKET_SELECTED")
    # read payment
    read CUSTOMER_PAYMENT
    # if payment is insufficient 
    if [[ "$(echo "$CUSTOMER_PAYMENT < $PRICE" | bc)" = 1 ]]
        then
        # echo not enough
        echo -e "\nInsufficient Amount."
        #delete customer
        DROP_CUSTOMER=$($PSQL "delete from attendees where attendee_id = '$ATTENDEE_ID'")
        echo -e "\n$(echo "$NAME_RETRIEVED" | sed -E 's/^\s+|\s+$//') has been dropped from attendees table."
    else
        # if payment is over
        if [[ "$(echo "$CUSTOMER_PAYMENT > $PRICE" | bc)" = 1 ]]
            CHANGE_BACK=$(echo $CUSTOMER_PAYMENT-$PRICE | bc)
            then            
            #give change back
            echo -e "\n$(echo "$NAME_RETRIEVED" | sed -E 's/^\s+|\s+$//'), you overpayed, so your change back is: \$$CHANGE_BACK."
            sleep .5
            #insert RSVP
            INSERT_RSVP=$($PSQL "insert into rsvp(ticket_id,attendee_id,customer_payment,customer_change) values($TICKET_SELECTED,$ATTENDEE_ID,'$CUSTOMER_PAYMENT','$CHANGE_BACK')")
            DEC_TICKET_COUNT=$($PSQL "update tickets set count=$(echo `expr $CURRENT_TICKET_COUNT - $COUNTER`) where ticket_id=$TICKET_SELECTED")
            echo -e "\nRSVP inserted for $(echo "$NAME_RETRIEVED" | sed -E 's/^\s+|\s+$//')."
        fi
    fi
}

ATTENDEE_INFO(){
    TICKET_SELECTED=$1
    TICKET_TYPE=$($PSQL "select type from tickets where ticket_id=$TICKET_SELECTED")

    if [[ $2 ]]
    then
    ATTENDEE_PHONE=$2
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
                    # exit the program
                    echo -e "\nYou are underage by approximately $YEARS_UNTUL_21 years."

                    # if age is 21 and over
                    else
                    # what is your name?
                    echo -e "\nWhat is your name?"
                    read ATTENDEE_NAME
                    # insert customer information
                    sleep 1
                    ATTENDEE_PHONE=$(echo "$ATTENDEE_PHONE" | sed -E 's/[\.|-]//g')
                    INSERT_ATTENDEE=$($PSQL "insert into attendees(name,age,phone) values('$ATTENDEE_NAME',$ATTENDEE_AGE,'$ATTENDEE_PHONE')")
                    RSVP_INFO "\n$ATTENDEE_NAME, your rsvp is setup for$TICKET_TYPE.\nSee you there!"
                fi
        else
                    # if phone number is matched with customer by ID
                    echo -e "\n~~~~ $(echo $NAME_RETRIEVED | sed 's/^\s+//'), welcome back ~~~~\n"
                    sleep .5
                    # menu option for returnee
                    echo -e "\nWhat do you want to do?"
                    sleep .5
                    echo -e "\n1. Purchase Tickets for friends/family\n2. Donate\n3. Exit"
                    read MENU_SELECTION

                    case $MENU_SELECTION in 
                    1) PURCHASE_MENU ;;
                    2) DONATE_MENU ;;
                    3) EXIT ;;
                    esac
        fi
    else
    # phone numbers
        echo -e "\nWhat is your phone number?"
        # read phone number
        read ATTENDEE_PHONE
        NAME_RETRIEVED=$($PSQL "select name from attendees where phone='$ATTENDEE_PHONE'")
        # phone number not valid
        if [[ ! $ATTENDEE_PHONE =~ ^(1)?([-|.])?[0-9]{3}([-|.])?[0-9]{3}([-|.])?[0-9]{4}$ ]]
        then
        # invalid phone number
        echo -e "\nInvalid phone number."
        MENU
        else
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
                        # exit the program
                        echo -e "\nYou are underage by approximately $YEARS_UNTUL_21 years."

                        # if age is 21 and over
                        else
                        # what is your name?
                        echo -e "\nWhat is your name?"
                        read ATTENDEE_NAME
                        # insert customer information
                        sleep 1
                        ATTENDEE_PHONE=$(echo "$ATTENDEE_PHONE" | sed -E 's/[\.|-]//g')
                        INSERT_ATTENDEE=$($PSQL "insert into attendees(name,age,phone) values('$ATTENDEE_NAME',$ATTENDEE_AGE,'$ATTENDEE_PHONE')")
                        RSVP_INFO "\n$ATTENDEE_NAME, your rsvp is setup for$TICKET_TYPE.\nSee you there!"
                    fi
            else
                        # if phone number is matched with customer by ID
                        echo -e "\n~~~~ $(echo $NAME_RETRIEVED | sed 's/^\s+//'), welcome back ~~~~\n"
                        sleep .5
                        # menu option for returnee
                        echo -e "\nWhat do you want to do?"
                        sleep .5
                        echo -e "\n1. Purchase Tickets for friends/family\n2. Donate\n3. Exit"
                        read MENU_SELECTION

                        case $MENU_SELECTION in 
                        1) PURCHASE_MENU ;;
                        2) DONATE_MENU ;;
                        3) EXIT ;;
                        esac
            fi
        fi  
    fi


}
MENU(){
    sleep .5
    if [[ $1 ]]
    then echo -e "\n$1"
    fi

    # phone numbers
    echo -e "\nWhat is your phone number?"
    # read phone number
    read ATTENDEE_PHONE
    NAME_RETRIEVED=$($PSQL "select name from attendees where phone='$ATTENDEE_PHONE'")
    # phone number not valid
    if [[ ! $ATTENDEE_PHONE =~ ^(1)?([-|.])?[0-9]{3}([-|.])?[0-9]{3}([-|.])?[0-9]{4}$ ]]
        then
        # invalid phone number
        echo -e "\nInvalid phone number."
        MENU
    else
        # if phone number is not matched with a customer by ID
        if [[ $NAME_RETRIEVED ]]
        then
        # if phone number is matched with customer by ID
            echo -e "\n~~~~ $(echo $NAME_RETRIEVED | sed 's/^\s+//'), welcome back ~~~~\n"
            sleep .5
            # menu option for returnee
            echo -e "\nWhat do you want to do?"
            sleep .5
            echo -e "\n1. Purchase Tickets for friends/family\n2. Donate\n3. Exit"
            read MENU_SELECTION

            case $MENU_SELECTION in 
            1) PURCHASE_MENU ;;
            2) DONATE_MENU ;;
            3) EXIT ;;
            esac
        else
            echo -e "\n1. Purchase Tickets\n2. Donate\n3. Exit"
            read MENU_SELECTION

            case $MENU_SELECTION in 
            1) PURCHASE_MENU $ATTENDEE_PHONE ;;
            2) DONATE_MENU ;;
            3) EXIT ;;
            esac  
        fi
    fi  
}
# purchase menu
PURCHASE_MENU(){
    # purchase variables
    AVAILABLE_TICKETS=$($PSQL "select ticket_id,type,price,description from tickets where available=true order by ticket_id asc")
    AVAILABLE_VIP=$($PSQL "select * from tickets where available=true and type='VIP'")
    AVAILABLE_GA=$($PSQL "select * from tickets where available=true and type='GA'")
    ATTENDEE_PHONE=$1
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
                    # continue with ATTENDEE_INFOrmation
                    ATTENDEE_INFO $TICKET_SELECTED $ATTENDEE_PHONE
            fi

            else
                # continue with ATTENDEE_INFOrmation
                ATTENDEE_INFO $TICKET_SELECTED $ATTENDEE_PHONE
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
