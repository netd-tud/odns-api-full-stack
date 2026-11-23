#!/bin/sh
set -eu

domain=odns-data.netd.cs.tu-dresden.de
webroot=/var/www/certbot
renewal_config="/etc/letsencrypt/renewal/$domain.conf"

trap 'exit 0' INT TERM

while :; do
    delay=43200

    if [ -f "$renewal_config" ]; then
        certbot renew --cert-name "$domain" --webroot --webroot-path "$webroot" \
            --webroot-map '{}' --quiet --no-directory-hooks --max-log-backups 10 || delay=300
    elif [ -n "${CERTBOT_EMAIL:-}" ]; then
        certbot certonly --webroot --webroot-path "$webroot" --cert-name "$domain" -d "$domain" \
            --non-interactive --agree-tos --email "$CERTBOT_EMAIL" \
            --no-directory-hooks --max-log-backups 10 || delay=300
    else
        echo 'Set CERTBOT_EMAIL in .env to request the first certificate.' >&2
    fi

    sleep "$delay" &
    wait "$!"
done
