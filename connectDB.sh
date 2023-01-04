#!/usr/bin/bash

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

function showTables {
    res=$(ls | awk 'BEGIN{FS=" "} { print "- "$1 }')
    if [[ $res == "" ]]; then
        zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "No Tables found"
        #echo "No Tables found"
    else
        zenity --info \
            --title "Tables Found" \
            --width 500 \
            --height 100 \
            --text "$res"
        #echo $res
    fi
    showMenu
}

function dropTable {
    name=$(zenity --entry \
        --width 500 \
        --title "check user" \
        --text "`-p` Enter Table Name: " );
    #read -p "Enter Table Name: " name
    if [ -f "$name" ]; then
        zenity --question \
                    --title "Info Message" \
                    --width 500 \
                    --height 100 \
                    --text "`-p`You are going to drop table $name? Are you sure? [Y/N]: "
        #read -p "You are going to drop table $name? Are you sure? [Y/N]: " check
        #if [[ $check = "Y" || $check = "y" ]]; then
            rm $name
            rm .$name
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Table Dropped Successfully"
            #echo "Table Dropped Successfully"
        #fi
    else
        zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name table is not existed!"
        #echo "$name table is not existed!"
    fi
    showMenu

}

function showMenu() {
    choice=$(zenity --list \
      --column "Select Menu" \
      createTable \
      listTable \
      dropTable \
      insertTable \
      selectTable \
      removeFromTable \
      updateTable \
      "Go back to main menu"
      )
    #select choice in createTable listTable dropTable insertTable selectTable removeFromTable updateTable "Go back to main menu"; do
        case $choice in
        createTable)
            . ../../createTable.sh
            ;;
        listTable)
            pwd
            echo "listTable"
            showTables
            showMenu
            ;;
        dropTable)
            echo "dropTable"
            dropTable
            ;;
        insertTable)
            . ../../insertTable.sh
            ;;
        selectTable)
            echo "selectTable"
            . ../../selectTable.sh
            ;;
        removeFromTable)
            echo "removeFromTable"
            . ../../deleteDataFromTable.sh
            ;;
        updateTable)
            echo "updateTable"
            . ../../updateTable.sh
            ;;
        "Go back to main menu")
            cd ../..
            . main.sh
            break
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

showMenu
