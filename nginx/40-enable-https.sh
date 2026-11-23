#!/bin/sh
set -eu

cert_dir=/etc/letsencrypt/live/odns-data.netd.cs.tu-dresden.de
tls_config=/etc/nginx/conf.d/odnsapi.conf

certificate_version() {
    [ -s "$cert_dir/fullchain.pem" ] && [ -s "$cert_dir/privkey.pem" ] &&
        stat -Lc '%i:%s:%y' "$cert_dir/fullchain.pem" "$cert_dir/privkey.pem"
}

active_version=$(certificate_version) || active_version=
if [ -n "$active_version" ]; then
    ln -sf /etc/nginx/odnsapi.prod.conf "$tls_config"
else
    rm -f "$tls_config"
fi

# The nginx master stays in the foreground and owns its own reloads.
(
    while sleep 30; do
        version=$(certificate_version) || continue
        [ "$version" != "$active_version" ] || continue

        ln -sf /etc/nginx/odnsapi.prod.conf "$tls_config"
        if nginx -t && nginx -s reload; then
            active_version=$version
        elif [ -z "$active_version" ]; then
            rm -f "$tls_config"
        fi
    done
) &
