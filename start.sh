#! /bin/bash

DEFAULT_PATH_CERT=(`ls *.crt`)
DEFAULT_PATH_KEY=(`ls *.key`)

#　https://www.delftstack.com/howto/linux/remove-file-extension-using-shell/#issues-when-removing-file-extension-in-bash
DOMAIN=`echo ${DEFAULT_PATH_KEY[*]} | rev | cut -f 2- -d '.' | rev`
SERVER="test.${DOMAIN}"

# echo ${DEFAULT_PATH_CERT[*]}
# echo ${DEFAULT_PATH_KEY[*]}
# echo $DOMAIN
# echo $SERVER

# update nginx configuration 
sed -e "s/server_name.*/server_name ${SERVER};/g" \
    -e "s/ssl_certificate .*/ssl_certificate \/etc\/nginx\/certs\/${DEFAULT_PATH_CERT[*]};/g" \
    -e "s/ssl_certificate_key .*/ssl_certificate_key \/etc\/nginx\/certs\/${DEFAULT_PATH_KEY[*]};/g" \
    ./nginx-template.conf > ./nginx.conf


# run nginx container 
docker run -d --rm -v `pwd`:/etc/nginx/certs -v `pwd`/nginx.conf:/etc/nginx/conf.d/nginx.conf -v `pwd`/site-content:/etc/nginx/html/  -p 80:80 -p 443:443 nginx


# show mesage 

echo "add  '127.0.0.1    $SERVER' in /etc/hosts"


