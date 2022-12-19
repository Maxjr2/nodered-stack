#!/bin/bash

# Generate a root certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/root.key -out /etc/ssl/certs/root.crt -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$ROOT_CN"

# Generate certificates for each domain
domains=(manage.automation01.local node-red.automation01.local status.automation01.local automation01.local)

for domain in "${domains[@]}"; do
  openssl req -new -newkey rsa:2048 -nodes -out "/etc/ssl/certs/${domain}.csr" -keyout "/etc/ssl/private/${domain}.key" -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=${domain}"
  openssl x509 -req -in "/etc/ssl/certs/${domain}.csr" -CA /etc/ssl/certs/root.crt -CAkey /etc/ssl/private/root.key -CAcreateserial -out "/etc/ssl/certs/${domain}.crt" -days 365
done
