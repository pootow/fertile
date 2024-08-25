# ask user to input domain name
echo "
Please input your domain name:"
read domain_name

# get ssl cert for v2fly
mkdir -p ~/cert

# get real path for ~/cert
cert_path=$(realpath ~/cert)

docker run -tid --name=acme.sh \
  --restart=always \
  -v ${cert_path}:/acme.sh \
  --net=host \
  neilpang/acme.sh daemon
docker exec acme.sh --register-account -m admin@${domain_name}
docker exec acme.sh --issue -d ${domain_name} --standalone

# copy config file
mkdir -p ~/config
cp config.json ~/config/config.json.template


# run v2fly container

# get real path for ~/config
config_path=$(realpath ~/config)

# replace domain name in config file with envsubst
envsubst '$uuid $domain_name' < ${config_path}/config.json.template > ${config_path}/config.json

# TODO replace uuid in config file
uuid=$(docker run --rm v2fly/v2fly-core uuid)
sed -i "s/uuid/${uuid}/g" ${config_path}/config.json

docker run -tid --name v2fly \
  --restart=always \
  -v ${cert_path}/${domain_name}_ecc:/cert \
  -v ${config_path}:/etc/v2ray \
  -p 443:8880 v2fly/v2fly-core run -c /etc/v2ray/config.json
