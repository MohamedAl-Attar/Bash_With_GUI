#!/usr/bin/bash
#echo "insertTable"
name=$(zenity --entry \
    --width 500 \
    --title "Insert Data In Table" \
    --text "`-p`Enter Table Name");
#read -p "Enter a name for the table: " name
if [[ -f "$name" ]]; then
    colsNum=$(awk 'END{print NR}' ."$name")
    for ((i = 2; i <= colsNum - 1; i++)); do
        colName=$(awk 'BEGIN{FS=":"}{ if(NR=='$i') print $1}' ."$name")
        colType=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' ."$name")
        colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ."$name")
        data=$(zenity --entry \
            --width 500 \
            --title "Insert Data In Table" \
            --text "`-p`Enter value for $colName = ");
        #read -p "Enter value for $colName = " data
        # ValidateDatatype
        if [[ $colType == "int" && $colKey == "PK" ]]; then
            duplicateData="1"
            while ! [[ $data =~ ^[0-9]+$ && $duplicateData == "0" ]]; do
                if [[ $data =~ ^[0-9]+$ ]]; then
                    duplicateData=$(awk '
                                BEGIN{
                                    FS=":"
                                }
                                {
                                    if(VARIABLE == $1){
                                        print 1;
                                        exit
                                    }
                                }
                                ' VARIABLE=$data $name)
                    if [[ $duplicateData == 1 ]]; then
                        zenity --info \
                            --title "Databases found" \
                            --width 500 \
                            --height 100 \
                            --text "The data you enter is not unique"
                        #echo "The data you enter is not unique"
                        data=$(zenity --entry \
                            --width 500 \
                            --title "Insert Data In Table" \
                            --text "`-p`Enter value for $colName = ");
                        #echo "Enter value for $colName = "
                        #read data
                    else
                        duplicateData="0"
                    fi
                else
                    zenity --info \
                        --title "Databases found" \
                        --width 500 \
                        --height 100 \
                        --text "invalid DataType !!"
                    #echo "invalid DataType !!"
                    data=$(zenity --entry \
                        --width 500 \
                        --title "Insert Data In Table" \
                        --text "`-p`Enter value for $colName = ");
                    #echo "Enter value for $colName = "
                    #read data
                fi
            done
        elif [[ $colType == "int" ]]; then
            while ! [[ $data =~ ^[0-9]*$ ]]; do
                zenity --info \
                    --title "Databases found" \
                    --width 500 \
                    --height 100 \
                    --text "invalid DataType !!"
                #echo "invalid DataType !!"
                data=$(zenity --entry \
                    --width 500 \
                    --title "Insert Data In Table" \
                    --text "$colName ($colType) = \c");
                #echo "$colName ($colType) = \c"
                #read data
            done
        fi

        if [[ $i == $((colsNum - 1)) ]]; then
            row="$row$data"
        else
            row="$row$data:"
        fi
    done
    echo "$row" >>"$name"
    if [[ $? == 0 ]]; then
        zenity --info \
            --title "Databases found" \
            --width 500 \
            --height 100 \
            --text "Data Inserted Successfully"
        #echo "Data Inserted Successfully"
    else
        zenity --info \
            --title "Databases found" \
            --width 500 \
            --height 100 \
            --text "Error Inserting Data into Table $name"
        #echo "Error Inserting Data into Table $name"
    fi
    row=""
else
    zenity --info \
        --title "Databases found" \
        --width 500 \
        --height 100 \
        --text "$name table not exist,try another name"
    #echo "$name table not exist,try another name"
fi
showMenu
