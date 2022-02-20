#!/bin/bash
function check_container() {
  container_present=`crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps  | grep $1 | awk {'print $1'} | head -1`
  if [[ -z $container_present ]]; then
        echo "false";
  else
        echo "true";
  fi
}

function fetch_image_tags() {
        tags=`crictl --runtime-endpoint unix:///run/containerd/containerd.sock images ls | grep $1 | awk {'print $2'}`
        echo "$tags"
}

function fetch_image_id() {
        iid=`crictl --runtime-endpoint unix:///run/containerd/containerd.sock image ls | grep $1 | grep $2 | awk {'print $3'}`
        echo "$iid"
}

function fetch_container_runi_sha() {
        runi_c=`crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps | grep $1 | awk {'print $1'} | head -1 | xargs crictl --runtime-endpoint unix:///run/containerd/containerd.sock inspect --output go-template --template '{{.status.imageRef}}'`
        echo "$runi_c"
}

function fetch_image_runi_sha() {
        runi_i=`crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock inspecti --output go-template --template '{{.status.repoDigests}}' $1 | tr -d '[' | tr -d ']'`
        echo "$runi_i"
}

for imagename in `crictl --runtime-endpoint unix:///run/containerd/containerd.sock image ls | awk {'print $1'} | tail -n +2 | grep 10.26 `
do
        imagetags=$(fetch_image_tags $imagename)
        for imagetag in $imagetags
        do
                imageid=$(fetch_image_id $imagename $imagetag)
                container_present=$(check_container $imageid)
                echo $imagename:$imagetag "has container" $container_present
                runi_c=$(fetch_container_runi_sha $imageid)
                runi_i=$(fetch_image_runi_sha $imageid)
                if [[ $imagetag != "latest"  ]]; then
                        if [[ $runi_c != $runi_i ]]; then
                                crictl --runtime-endpoint unix:///run/containerd/containerd.sock rmi $imagename:$imagetag
                                echo $imagename:$imagetag "deleted"
                        fi
                fi
        done
done