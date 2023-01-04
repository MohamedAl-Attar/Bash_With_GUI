#!/bin/bash
export PS3=">>"
export LC_COLLATE=C
shopt -s extglob

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

if [ -d "$PWD/Database" ]; then
    cd "$PWD/Database" || exit
else
    mkdir "$PWD/Database"
    cd "$PWD/Database" || exit
fi

showMenu() {
    choice=$(zenity --list \
      --column "Select Menu" \
      createDatabase \
      listDatabase \
      removeDatabase \
      connectDatabase \
      Exit
      )
    #select choice in createDatabase listDatabase removeDatabase connectDatabase Exit; do
        case $choice in
        createDatabase)
            createDB
            ;;
        listDatabase)
            res=$(ls -d */ | awk 'BEGIN{FS=" "} { print "- "$1 }')
            if [[ $res == "" ]]; then
                zenity --info \
                        --title "Databases found" \
                        --width 500 \
                        --height 100 \
                        --text "No Databases found"
                #echo "No Databases found"
            else
                zenity --info \
                        --title "Databases found" \
                        --width 500 \
                        --height 100 \
                        --text "$res"
                #echo $res
            fi
            showMenu
            ;;
        removeDatabase)
            #echo "removeDatabase"
            name=$(zenity --entry \
                --width 500 \
                --title "Remove Database" \
                --text "Enter the Database Name");
            #read -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                zenity --question \
                    --title "Info Message" \
                    --width 500 \
                    --height 100 \
                    --text "You are going to drop $name? Are you sure? [Y/N]: "
                #read -p "You are going to drop $name? Are you sure? [Y/N]: " check
                #if [[ $check = "Y" || $check = "y" ]]; then
                    sudo rm -r "$name"
                    zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name Database removed successfully!"
                    #echo "$name Database removed successfully!"
                #fi
            else
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name Database is not existed!"
                #echo "$name database is not existed!"
            fi
            showMenu
            ;;
        connectDatabase)
            pwd
            #echo "connectDatabase"
            name=$(zenity --entry \
                --width 500 \
                --title "Connect Database" \
                --text "`-p`Enter a name for the Database: " );
            #read -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                cd "$name" || exit
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Connected to $name database"
                #echo "Connected to $name database"
                . ../../connectDB.sh
            else
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name Database not exist,try another name"
                #echo "$name database not exist,try another name"
            fi
            showMenu
            ;;

        Exit)
            #echo "Exit"
            exit
            ;;
        *)
            zenity --info \
                --title "Info Message" \
                --width 500 \
                --height 100 \
                --text "wrong input select again"
            #echo "wrong input select again"
            showMenu
            ;;
        esac
    #done
}

createDB() {

    #echo "createDatabase"
    name=$(zenity --entry \
            --width 500 \
            --title "Create Database" \
            --text "`-p`Enter a name for the database: " );
    #read -p "Enter a name for the database: " name
    #echo "$name"
    if [[ -n $name ]]; then
        if [[ $name =~ $pat ]]; then
            if [[ -d "$name" ]]; then
                zenity --info \
                    --title "Info Message" \
                    --width 500 \
                    --height 100 \
                    --text "Database already exists,try another name"
                #echo 'Database already exists,try another name'
            else
                mkdir "$name"
                zenity --info \
                    --title "Info Message" \
                    --width 500 \
                    --height 100 \
                    --text "$name database created succsessfully!!!"
                #echo "$name" database created succsessfully!!!
            fi
        else
            zenity --info \
                --title "Info Message" \
                --width 500 \
                --height 100 \
                --text "Error naming the file, make sure to not start with number,special char and space,try another name"
            #echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
        fi
    else
        zenity --info \
            --title "Info Message" \
            --width 500 \
            --height 100 \
            --text "zero string,try another name"
        #echo "zero string,try another name"
    fi
    showMenu
}

showMenu