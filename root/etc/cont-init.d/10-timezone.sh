#!/usr/bin/with-contenv sh

echo "*** set timezone to: $TZ"
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
