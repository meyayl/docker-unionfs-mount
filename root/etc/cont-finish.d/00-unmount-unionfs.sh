#!/usr/bin/with-contenv sh
echo "$( date +'%Y/%m/%d %H:%M:%S' ) Unmounting $MOUNT_PATH"
fusermount -uz $MOUNT_PATH
if [[ $? -eq 0 ]]; then
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) INFO: Successfully unmounted."
else
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) ERROR: please check your host path for 'Transport endpoint is not connected' errors."
fi
