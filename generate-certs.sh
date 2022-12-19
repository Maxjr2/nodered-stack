#!/bin/bash

# Set the domains to create SSL certificates for
domains=(automation01.local node-red.automation01.local status.automation01.local manage.automation01.local)
dirs=(host_certs host_privates)

# Create folders to store the SSL certificates and keys
for dir in "${dirs[@]}";
do
  if [[ ! -e $dir ]]; then
      mkdir $dir
  fi
done

# Set the country, state, and company information
read -p "Enter country: " country
read -p "Enter state or province: " state
read -p "Enter company name: " company

# Create a loop to generate the SSL certificates and keys for each domain
for domain in "${domains[@]}";
do
  # Extract the subdomain from the domain name
  subdomain=$(echo "$domain" | cut -d'.' -f1)

  # Set the file name for the SSL certificate and key
  if [ "$subdomain" = "automation01" ]; then
    file_name="$company-root-selfsigned"
  else
    file_name="$company-$subdomain-selfsigned"
  fi
  #hi
  # Generate an SSL certificate and key for the domain
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$file_name.key" -out "$file_name.crt" -subj "/C=$country/ST=$state/O=$company/CN=$domain"
  
  # Move the SSL certificate and key to the appropriate folders
  mv "$file_name.crt" "host_certs/$file_name.crt"
  mv "$file_name.key" "host_privates/$file_name.key"
done

# Display a message indicating that the SSL certificates and keys have been created
echo "SSL certificates and keys created for ${#domains[@]} domains"
