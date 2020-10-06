# !/bin/bash
# create by : ./LazyBoy - JavaGhost Team
# usage : bash ur_file.sh ur_list.txt

# color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

# start
# just info
echo -e "\t\t[ Mass Check Limit AWS ${red}- ${green}Max24HourSend${white} ]\n"

# create file
touch aws_good.txt

# check file
if [[ ! -e $1 ]]; then
        echo -e "${white}[ ${red}! ${white}] ${red}Error file not found in ur directory${white}"
        exit
else
        echo -e "${white}[ ${green}+ ${white}] Total list ${red}: ${green}$(< $1 wc -l)${white}"
fi

# input list just like this : AWS_KEY|AWS_SECRET_KEY|REGION
for list_data in $(cat $1); do
        # command for change aws_key + aws_scret + aws_region
        sed -i "2c aws_access_key_id = $(echo $list_data | cut -d "|" -f1)" ~/.aws/credentials
        sed -i "3c aws_secret_access_key = $(echo $list_data | cut -d "|" -f2)" ~/.aws/credentials
        sed -i "2c region = $(echo $list_data | cut -d "|" -f3)" ~/.aws/config
        # Note : for output, iam set default json.

        # check the key is valid or not
        if [[ $(aws ses get-send-quota 2>/dev/null; echo $?) =~ "0" ]]; then
                limit=$(aws ses get-send-quota | awk -F '[:,]' '/"Max24HourSend"/ {gsub("[[:blank:]\"]+", "", $2); print $2}')
                echo -e "\n${white}[ ${green}WORK ${red}-${green} $list_data ${white}]\n${white}[ ${green}+ ${white}] AWS_KEY${red} = ${white}$(echo $list_data | cut -d "|" -f1)\n${white}[ ${green}+ ${white}] AWS_SECRET_KEY${red} = ${white}$(echo $list_data | cut -d "|" -f2)\n${white}[ ${green}+ ${white}] AWS_REGION${red} = ${white}$(echo $list_data | cut -d "|" -f3)\n${white}[ ${green}+ ${white}] LIMIT ${red}:${green} ${limit}${white}"
                echo "${list_data} - Limit send : ${limit}" >> aws_good.txt
        else
                echo -e "\n${white}[ ${red}ERROR ${white}] ${red}- ${white}$list_data ${red}"
        fi
done

# check you have good aws key or not XD
if [[ ! -e aws_good.txt ]]; then
        echo -e "${white}[ ${red}! ${white}] You don't have any good aws key for this time boy\n"
else
        echo -e "\n${white}[ ${green}+ ${white}] Total good AWS key ${red}: ${green}$(< aws_good.txt wc -l)${white}"
fi
# finish