python pytest_container_manager.py -a up -n ${NUM_WORKERS} \
-t ${TASK_NAME} \
-s ${SUBNET} \
-sg ${SECURITY_GROUP}

ip_list=$(<pytest_container_ip_list.txt)
num_ip_addresses=$(wc -w <<< $ip_list)

count=0
for ip in $ip_list
do
    cmd=$cmd"ssh ubuntu@$ip 'cd /edx/app/edxapp/edx-platform; git pull; git checkout ${CI_BRANCH}'"
    (( count++ ))
    if [ $count -ne $num_ip_addresses ] ; then
        cmd=$cmd" & "
    fi
done

eval $cmd
