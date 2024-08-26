# ask user to input domain name if $1 is not set
if [ -z "$1" ]; then
  echo "
  Please input your domain name:"
  read domain_name
else
  domain_name=$1
fi

# get ssl cert for v2fly
mkdir -p ~/cert

# get real path for ~/cert
cert_path=$(realpath ~/cert)

# check if acme.sh container not exists, then create it using 
if [ ! "$(docker ps -q -f name=acme.sh)" ]; then
  docker run -tid --name=acme.sh \
    --restart=always \
    -v ${cert_path}:/acme.sh \
    --net=host \
    neilpang/acme.sh daemon
else
    # if it does not run, then start it
  if [ "$(docker ps -aq -f status=exited -f name=acme.sh)" ]; then
    docker start acme.sh
  fi
fi

# check if account is registered, using grep to test `--update-account` output contains 'Account key not found' if not registered
if docker exec acme.sh --update-account 2>&1 | grep -q 'Account key not found'; then
  # if not registered, then register it
  docker exec acme.sh --register-account -m admin@${domain_name}
fi

# first to check if there is a cert for the domain and if it is expired
# to check the cert, use `--list`, the example output is:
# Main_Domain     KeyLength       SAN_Domains     CA      Created Renew
# example.com      "ec-256"        no      ZeroSSL.com     2023-18-25T98:59:19Z    2029-15-23T19:92:96Z
# check if the cert is expired using `--list` and compare the Renew column with current date, if the renew date is within 30 days, then renew it
# if the cert is still valid, then do nothing
# if there is no cert, then get a new cert using `--issue -d ${domain_name} --standalone`
if docker exec acme.sh --list | grep -q ${domain_name}; then
  # if the cert is expired, then renew it
  if [ $(date -d "$(docker exec acme.sh --list | grep ${domain_name} | awk '{print $6}')" +%s) -lt $(date -d "+30 days" +%s) ]; then
    docker exec acme.sh --renew
  fi
else
  # if there is no cert, then get a new cert
  docker exec acme.sh --issue -d ${domain_name} --standalone
fi

# run v2fly container

# copy config file
mkdir -p ~/config
cp config.json ~/config/config.json.template

# get real path for ~/config
config_path=$(realpath ~/config)

# check current config file for uuid using regex matching hex uuid and extract using regex, example line of config file:
# "id": "ffffffff-ffff-ffff-ffff-ffffffffffff",
# if uuid is not set, then generate a new uuid using `docker run --rm v2fly/v2fly-core uuid`
uuid=$(sed -n 's/.*"id": "\(.*\)".*/\1/p' ${config_path}/config.json)
if [ -z "$uuid" ]; then
  uuid=$(docker run --rm v2fly/v2fly-core uuid)

  # replace domain name and uuid in config file with envsubst
  (
    export uuid
    export domain_name
    envsubst '$uuid $domain_name' < ${config_path}/config.json.template > ${config_path}/config.json
  )
fi

# check if v2fly container not exists, then create it
if [ ! "$(docker ps -q -f name=v2fly)" ]; then
  docker run -tid --name v2fly \
    --restart=always \
    -v ${cert_path}/${domain_name}_ecc:/cert \
    -v ${config_path}:/etc/v2ray \
    -p 443:8880 v2fly/v2fly-core run -c /etc/v2ray/config.json
else
  # if it does not run, then start it
  if [ "$(docker ps -aq -f status=exited -f name=v2fly)" ]; then
    docker start v2fly
  fi
fi
