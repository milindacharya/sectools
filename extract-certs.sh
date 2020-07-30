#!/bin/bash
#set -x

# This script will convert pfx certificates to pem format and
# generate *-cacert.pem, *-key.pem, and *-cert.pem 

if [[ $# -eq 0 ]] ; then
    echo "Usage: $0 <certificate.pfx>"
    exit 0
fi

# extract base name
pfxname=$1
dname=`dirname $pfxname`

# Convert the certificate to lower name
lowerpfxname=`echo "$pfxname" | awk '{print tolower($0)}'`
pfxname=$lowerpfxname
fname=`basename -s .pfx $pfxname`

function gitbash_openssl {
	# extract public and private keys in pem format
	winpty openssl pkcs12 -in $pfxname -clcerts -nodes -nokeys -chain -out $fname-cert.pem
	winpty openssl pkcs12 -in $pfxname -cacerts -nodes -nokeys -out $fname-cacert.pem
	winpty openssl pkcs12 -in $pfxname -nocerts -nodes -out $fname-key.pem

	# verify cacert and cert
	echo "Certificate CA: $fname-cacert.pem and Certificate: $fname-cert.pem verification"
	openssl verify -CAfile  $fname-cacert.pem $fname-cert.pem

	# verify certificate and key pair for modulus
	certmodulus=`openssl x509 -noout -modulus -in $fname-cert.pem | openssl md5`
	keymodulus=`openssl rsa -noout -modulus -in $fname-key.pem | openssl md5`
	if [[ $certmodulus == $keymodulus ]]
	then
		echo "Certificate $fname-cert.pem modulus matches with Key $fname-key.pem modulus: OK"
	else
		echo "Certificate $fname-cert.pem modulus $certmodulus does not match with key  $fname-key.pem modulus $keymodulus"
	fi
}

function linux_openssl {
	# extract public and private keys in pem format
	openssl pkcs12 -in $pfxname -clcerts -nodes -nokeys -chain -out $fname-cert.pem
	openssl pkcs12 -in $pfxname -cacerts -nodes -nokeys -out $fname-cacert.pem
	openssl pkcs12 -in $pfxname -nocerts -nodes -out $fname-key.pem

	# verify cacert and cert
	echo "Certificate CA: $fname-cacert.pem and Certificate: $fname-cert.pem verification"
	openssl verify -CAfile  $fname-cacert.pem $fname-cert.pem

	# verify certificate and key pair for modulus
	certmodulus=`openssl x509 -noout -modulus -in $fname-cert.pem | openssl md5`
	certmodulus=`openssl x509 -noout -modulus -in $fname-cert.pem | openssl md5`
	keymodulus=`openssl rsa -noout -modulus -in $fname-key.pem | openssl md5`
	if [[ $certmodulus == $keymodulus ]]
	then
		echo "Certificate $fname-cert.pem modulus matches with Key $fname-key.pem modulus: OK"
	else
		echo "Certificate $fname-cert.pem modulus $certmodulus does not match with key  $fname-key.pem modulus $keymodulus"
	fi
}

if [[ $OS == 'Windows_NT' ]]
then
	gitbash_openssl
else
	linux_openssl
fi
