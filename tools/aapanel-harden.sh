#!/bin/sh
set -e

VHOST=/www/server/panel/vhost/nginx
NGXCONF=/www/server/nginx/conf

echo "== 1. self-signed cert for the catch-all =="
if [ ! -f "$NGXCONF/catchall.crt" ]; then
  openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout "$NGXCONF/catchall.key" -out "$NGXCONF/catchall.crt" \
    -subj "/CN=unmatched-host" >/dev/null 2>&1
  chmod 600 "$NGXCONF/catchall.key"
  echo "created"
else
  echo "already there"
fi

echo "== 2. shared per-site rules =="
cat > "$NGXCONF/common-site.conf" <<'CONF'
if ($host ~* ^www\.(.+)$) {
    return 301 https://$1$request_uri;
}
CONF
echo "wrote $NGXCONF/common-site.conf"

echo "== 3. 443 catch-all =="
cat > "$VHOST/0.catchall_ssl.conf" <<'CONF'
server {
    listen 443 ssl default_server;
    http2 on;
    server_name _;
    ssl_certificate     /www/server/nginx/conf/catchall.crt;
    ssl_certificate_key /www/server/nginx/conf/catchall.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    if ($host ~* ^www\.(.+)$) {
        return 301 https://$1$request_uri;
    }

    return 404;
}
CONF
echo "wrote $VHOST/0.catchall_ssl.conf"

echo "== 4. stamp helper =="
cat > /root/stamp-site.sh <<'CONF'
#!/bin/sh
set -e
d="$1"
[ -n "$d" ] || { echo "usage: stamp-site.sh <domain>"; exit 1; }
[ -d "/www/wwwroot/$d" ] || { echo "no such site: $d"; exit 1; }
dir="/www/server/panel/vhost/nginx/extension/$d"
mkdir -p "$dir"
ln -sf /www/server/nginx/conf/common-site.conf "$dir/00-common.conf"
nginx -t
nginx -s reload
echo "stamped: $d"
CONF
chmod +x /root/stamp-site.sh
echo "wrote /root/stamp-site.sh"

echo "== 5. stamp every existing site =="
for f in "$VHOST"/*.conf; do
  b=$(basename "$f" .conf)
  case "$b" in
    0.*|phpmyadmin|phpfpm_status|speed|waf2monitor_data) continue ;;
  esac
  [ -d "/www/wwwroot/$b" ] || continue
  mkdir -p "$VHOST/extension/$b"
  ln -sf "$NGXCONF/common-site.conf" "$VHOST/extension/$b/00-common.conf"
  echo "  stamped $b"
done

echo "== 6. nginx -t =="
nginx -t
