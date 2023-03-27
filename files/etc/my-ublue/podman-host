#!/bin/bash
set -x
if [ "$1" == "exec" ]; then
 # Remove 'exec' from $@
 shift
 script='
     result_command="podman exec"
        for i in $(printenv | grep "=" | grep -Ev " |\"" |
            grep -Ev "^(HOST|HOSTNAME|HOME|PATH|SHELL|USER|_)"); do

            result_command=$result_command --env="$i"
     done

        exec ${result_command} "$@"
    '
 exec flatpak-spawn --host sh -c "$script" - "$@"
else
 exec flatpak-spawn --host podman "$@"
fi
