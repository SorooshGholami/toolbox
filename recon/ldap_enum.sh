#!/bin/bash
# Queries an LDAP server and optionally extracts a single attribute value.
#
# Usage:
#   LDAP_HOST=ldap://server:389 LDAP_USER='cn=config' LDAP_PASS='secret' \
#     ./ldap_enum.sh "(uid=person)" mail
#
# If LDAP_HOST / LDAP_USER / LDAP_PASS are not set as environment variables,
# the script will prompt for them interactively. Credentials are never
# hardcoded in this file.
#
# Requires: ldapsearch (openldap-clients)

: "${LDAP_HOST:=}"
: "${LDAP_USER:=}"
: "${LDAP_PASS:=}"

if [[ -z "$LDAP_HOST" ]]; then
    read -p "LDAP host (e.g. ldap://server:389): " LDAP_HOST
fi
if [[ -z "$LDAP_USER" ]]; then
    read -p "Bind DN (e.g. cn=config): " LDAP_USER
fi
if [[ -z "$LDAP_PASS" ]]; then
    read -s -p "Bind password: " LDAP_PASS
    echo
fi

filter="$1"
attr="$2"

if [[ -z "$filter" ]]; then
    echo "Usage: $0 \"<ldap-filter>\" [attribute]"
    exit 1
fi

if [[ -z "$attr" ]]; then
    ldapsearch -H "$LDAP_HOST" -D "$LDAP_USER" -w "$LDAP_PASS" -ZZ "$filter"
else
    ldapsearch -H "$LDAP_HOST" -D "$LDAP_USER" -w "$LDAP_PASS" -ZZ "$filter" "$attr" \
        | sed -n "/^ /{H;d};/$attr:/x;\$g;s/\n *//g;s/$attr: //gp"
fi
