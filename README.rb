= DESCRIPTION:

Provision Jenkins CI with authentication and predefined users.

= REQUIREMENTS:

= ATTRIBUTES:

= USAGE:

Generate password hash using openssl:

echo secret | (SALT=$(openssl rand -hex 4); read PASS; echo "$SALT:$(echo -n "$PASS{$SALT}" | openssl dgst -sha256 | sed -e 's/(.* //')")

Add 'jenkins' to 'groups' attribute of user and password hash as 'jenkins_password'

