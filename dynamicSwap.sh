minFreeRAM=7                #Minimum free GB RAM before enabling swap
swapTriggerUp=20            #Max swap GB used before enabling secondary swap partition
swapTriggerDown=4           #Do not disable 1st swap partition (nvme0n1p3 in my case) if swap GB used is > than this variable
swap1=/dev/nvme0n1p3        #Prioritqry swap file or partition (Faster one, nvme ssd in my case)
swap2=/dev/sda              #Secondary swap (slower, SD card swap partition in my case)

while true
do
        sleep 0.5
        
        freeRAM=`free --giga | awk 'NR==2 {print $4}'` #Get free RAM memory in GB
        if (($freeRAM < $minFreeRAM))
        then                                 #if low free RAM, enable 1st swap
                swapon $swap1
        fi

        usedSWAP=`free --giga | awk 'NR==3 {print $3}'` #Get swap usage in GB

        if (($usedSWAP > $swapTriggerUp))
        then                                #enable 2nd swap if swap usage hit $swapTriggerUp
                swapon $swap2
        else                                #Disable 2nd swap if useless
                swapoff $swap2
        fi

        if (($freeRAM > $minFreeRAM)) && (($usedSWAP < $swapTriggerDown))
        then                                #Disable swap if free GB ram is > $minFreeRAM and if swap GB used is < $swapTriggerDown
                swapoff $swap1
        fi

done
