#!/bin/bash
function check_container() {
has_container="false"
for containerid in `crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps | awk {'print $1'} | tail -n +2`
do
        image_id=`crictl --runtime-endpoint unix:///run/containerd/containerd.sock inspect --output go-template --template '{{.info.config.image.image}}' $containerid`
        if [[ $image_id == $1 ]]; then
                has_container="true"
                break;
        fi
done
echo "$has_container"
}

for imageid in `crictl --runtime-endpoint unix:///run/containerd/containerd.sock images --no-trunc | grep 10.26 | awk {'print $3'}`
do
        container_present=$(check_container $imageid)
        echo $imageid "has container" $container_present
        if [[ $container_present == "false" ]]; then
                crictl --runtime-endpoint unix:///run/containerd/containerd.sock rmi $imageid
                echo $imageid "deleted"
        else
                echo $imageid "not deleted"
        fi
done