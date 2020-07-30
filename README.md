# Collection of Security Tools.

This is a collection of tools and shell script required by system administrators, devops, and devsecops and is pretty much a work in progress.

## Converting .pfx files to .pem format.
Often we are issued with Personal Information Exchange Format (PFX) and are left to convert them to Privacy Enhanced Mail (PEM) files. To make matters worse, we have to extract the cacert chain from pfx files.
This script `extract-certs.sh` does just that. I have tried and tested this script on Git Bash and Linux.

```
$ sh extract-certs.sh mycert.pfx
Enter Import Password:
Enter Import Password:
Enter Import Password:
Certificate CA: mycert-cacert.pem and Certificate: mycert-cert.pem verification
mycert-cert.pem: OK
Certificate mycert-cert.pem modulus matches with Key mycert-key.pem modulus: OK
```

## Work in progress
- Validating a cacert chain.
- Docs to for quickly testing openssl certs for mutual tls.


