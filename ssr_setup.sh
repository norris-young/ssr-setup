#!/bin/sh

echo 'cloning shadowsocksr from github...'
git clone https://github.com/norris-young/shadowsocksr.git
cd shadowsocksr
git checkout -b dev origin/dev

echo 'modifing user config file...'
bash initcfg.sh
#modify user-config.json
cp config.json user-config.json
ip_addr=`hostname -I | awk '{print $1}'`
sed -i 's/"server": ".*"/"server": "'"${ip_addr}"'"/g' user-config.json
sed -i 's/"server_port": .*,/"server_port": 6969,/g' user-config.json
password=`</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16; echo ""`
sed -i 's/"password": ".*"/"password": "'"${password}"'"/g' user-config.json
sed -i 's/"method": ".*"/"method": "chacha20-ietf"/g' user-config.json

echo 'starting server...'
cd shadowsocks
./logrun.sh
#./tail.sh
echo 'server started(server: ${ip_addr} port: 6969 password: ${password} ). enjoy it!'