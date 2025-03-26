test=`free --giga | awk 'NR==2 {print $4}'`
max=7
swapTrigger=20
swapTriggerDown=4

while true
do
        sleep 0.5
        test=`free --giga | awk 'NR==2 {print $4}'`
        if (($test < $max))
        then
                swapon /dev/nvme0n1p3
        fi

        test2=`free --giga | awk 'NR==3 {print $3}'`

        if (($test2 > $swapTrigger))
        then
                swapon /dev/sda
        else
                swapoff /dev/sda
        fi

        if (($test > $max)) && (($test2 < $swapTriggerDown))
        then
                swapoff /dev/nvme0n1p3
        fi

done
