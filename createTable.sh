#!/usr/bin/bash
pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"
pat2="^[0-9]+"
#echo "createTable"
name=$(zenity --entry \
                --width 500 \
                --title "Create Table" \
                --text "`-p`Enter Table Name");
#read -p "Enter a name for the table: " name
if [[ -z $name ]]; then
    zenity --info \
        --title "Info Message" \
        --width 500 \
        --height 100 \
        --text "zero string,try another name"
    #echo "zero string,try again"
    showMenu
fi
if [[ $name =~ $pat ]]; then
    if [[ -f "$name" ]]; then
        zenity --info \
            --title "Info Message" \
            --width 500 \
            --height 100 \
            --text "table already existed ,choose another name"
        #echo "table already existed ,choose another name"
        showMenu
    fi
    columnNumbers=$(zenity --entry \
        --width 500 \
        --title "Create Table" \
        --text "`-p`Enter number of Columns");
    #read -p "Enter number of Columns: " columnNumbers
    if [[ $columnNumbers =~ $pat2 ]]; then
        sep=":"
        primarykeycheck="0"
        metaData="Field${sep}Type${sep}key\n"

        for ((i = 1; i <= columnNumbers; i++)); do
            columnName=$(zenity --entry \
                --width 500 \
                --title "Create Table" \
                --text "`-p`Enter name of Column $i");
            #read -p "Enter name of Column $i: " columnName
            if [[ -n $columnName ]]; then
                if [[ $columnName =~ $pat ]]; then
                    #echo "Enter type of Column $columnName"
                    choice=$(zenity --list \
                        --column "Enter type of Column $columnName" \
                            "int" \
                            "str" \
                            )
                    #select choice in "int" "str"; do
                        case $choice in
                        int)
                            columnType="int"
                            break
                            ;;
                        str)
                            columnType="str"
                            break
                            ;;
                        *)
                            echo "Wrong Choice,try again"
                            ;;
                        esac
                    #done
                    if [[ $primarykeycheck=="0" ]]; then
                        #echo "Make PrimaryKey ?"
                        choice=$(zenity --list \
                        --column "Make PrimaryKey ?" \
                            "yes" \
                            "no" \
                            )
                        #select choice in "yes" "no"; do
                            case $choice in
                            yes)
                                primarykeycheck="1"
                                columnKey="PK"
                                metaData+="$columnName$sep$columnType$sep$columnKey\n"
                                break
                                ;;
                            no)
                                columnKey="FK"
                                metaData+="$columnName$sep$columnType$sep$columnKey\n"
                                break
                                ;;
                            *) echo "Wrong Choice" ;;
                            esac
                        #done
                    else
                        columnKey="FK"
                        metaData+="$columnName$sep$columnType$sep$columnKey\n"
                    fi
                    if [[ $i == $columnNumbers ]]; then
                        temp+=$columnName
                    else
                        temp+=$columnName$sep
                    fi
                else
                    zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Error naming the file, make sure to not start with number,special char and space,try another name"
                    #echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
                    . ../../connectDB
                fi
            else
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "zero string,try another name"
                #echo "zero string,try another name"
                . ../../connectDB
            fi

        done

        touch .$name
        echo -e $metaData >>.$name
        touch $name
        echo -e $temp >>$name
        if [[ $? == 0 ]]; then
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Table $name Created Successfully"
            #echo "Table $name Created Successfully"
            showMenu
        else
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Error Creating Table $name"
            #echo "Error Creating Table $name"
            showMenu
        fi

    else
        pwd
        zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "invalid data type, use int only"
        #echo "invalid data type, use int only"
        . ../../connectDB.sh
    fi

else
    zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Error naming the file, make sure to not start with number,special char and space,try another name"
    #echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
    showMenu
fi
