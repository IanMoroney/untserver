#!/bin/bash

exit_handler() {
    # Execute the  shutdown commands
    echo "[INFO] Stopping Unturned Server"
    su-exec untserver /home/untserver/untserver stop
    echo "[INFO] Unturned Server has been stopped"
    exit 0
}

# Trap specific signals and forward to the exit handler
trap exit_handler SIGINT SIGTERM

set -eu

# Print info
echo "
        =======================================================================
        USER INFO:

        UID: $PUID
        GID: $PGID

        MORE INFO:

        If you have permission problems remember to use same user UID and GID.
        Check it with "id" command
        If problem persist check:
        https://https://github.com/IanMoroney/untserver/blob/master/README.md
        =======================================================================
"

# Set user and group ID to untserver user
groupmod -o -g "$PGID" untserver  > /dev/null 2>&1
usermod -o -u "$PUID" untserver  > /dev/null 2>&1

# Locale, Timezone
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

# Apply owner to the folder to avoid errors
chown -R untserver:untserver /home/untserver

# Start cron
service cron start

# Change user to untserver
su-exec untserver bash /home/untserver/install.sh &
# If bash is waiting for a command to complete and receives a signal for which a trap has been set, the trap will not be executed until the command completes.
# When bash is waiting for an asynchronous command via the wait builtin,
# the reception of a signal for which a trap has been set will cause the 'wait' builtin to return immediately with an exit status greater than 128,
# immediately after which the trap is executed.
wait $!