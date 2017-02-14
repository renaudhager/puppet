#!/bin/bash

# TODO: do something more secure. But needed for now to sign cert for
# puppetmaster with dns alt.
csr=$(< /dev/stdin)
certname=$1

if echo "${csr}" | openssl req -noout -text | grep -q 'X509v3 Subject Alternative Name'; then
	/opt/puppetlabs/bin/puppet cert --allow-dns-alt-names sign ${certname}
fi

exit 0
