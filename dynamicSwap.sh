test=`free --giga | awk 'NR==2 {print $4}'`
max=6
swapTrigger=20
swapTriggerDown=2

while true
do
        sleep 0.5
        test=`free --giga | awk 'NR==2 {print $4}'`
        if (($test < $max))
        then
                echo $test
                swapon /dev/nvme0n1p3
        else
                echo no $test
        fi

        test2=`free --giga | awk 'NR==3 {print $3}'`
        echo
        echo $test
        echo $test2
        if (($test2 > $swapTrigger))
        then
                swapon /dev/sda
        else
                swapoff /dev/sda
        fi

        if (($test > $max))
        then
                if (($test2 < $swapTriggerDown))
                then
                        swapoff /dev/nvme0n1p3
                fi
        fi

done
