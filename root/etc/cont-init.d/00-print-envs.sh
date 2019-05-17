#!/usr/bin/with-contenv sh

# Display variables for troubleshooting
echo -e "*** ENV set:\\n\
PUID=${PUID}\\n\
PGID=${PGID}\\n\
TZ=${TZ}\\n\
MOUNT_PATH=${MOUNT_PATH}"
echo $(env)
