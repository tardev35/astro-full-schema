#!/usr/bin/env bash
# www-redirect.sh [--apply] - ทำ 301 จาก www -> non-www ให้ทุกไซต์บน VPS (nginx แบบ sites-enabled)
#
#   scp tools/vps/www-redirect.sh root@VPS_IP:/root/
#   ssh root@VPS_IP "bash /root/www-redirect.sh"           # ดูอย่างเดียว
#   ssh root@VPS_IP "bash /root/www-redirect.sh --apply"   # แก้จริง
#
# ปัญหาที่แก้: vhost ทุกตัวเขียน `server_name DOMAIN www.DOMAIN;` ซึ่งแปลว่า
# ทั้งสองชื่อเสิร์ฟเนื้อหาเดียวกัน ไม่ได้ redirect หากัน — Google เห็นเป็นสองเว็บ
# ที่เนื้อหาซ้ำกันและแบ่งน้ำหนักลิงก์ออกเป็นสองทาง
#
# ⚠️ ทำไมต้องถอด www ออกจาก server_name ด้วย ไม่ใช่แค่เพิ่ม server block ใหม่:
# nginx จับคู่ชื่อแบบ "ตรงตัว" ก่อน "regex" เสมอ ตราบใดที่ www.DOMAIN ยังเป็นชื่อตรงตัว
# ใน vhost เดิม server block ที่ดัก www แบบ regex จะไม่มีวันทำงาน
#
# สิ่งที่ทำ:
#   1. สำรอง sites-available ทั้งหมดเป็น .tar.gz
#   2. วาง /etc/nginx/conf.d/000-www-redirect.conf (ดัก www.* ทุกโดเมนด้วย regex)
#   3. ถอด ` www.DOMAIN` ออกจากบรรทัด server_name ของทุก vhost
#   4. แก้ add-site.sh ให้ไซต์ใหม่ไม่ใส่ www เข้ามาอีก
#   5. nginx -t แล้วค่อย reload — ไม่ผ่านคือไม่ reload และกู้ไฟล์คืนอัตโนมัติ

set -u

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

SA=/etc/nginx/sites-available
SE=/etc/nginx/sites-enabled
CONF=/etc/nginx/conf.d/000-www-redirect.conf
ADDSITE=/root/add-site.sh
STAMP=$(date +%F-%H%M%S)
BACKUP=/root/vhost-backup-$STAMP.tar.gz

# origin เป็น HTTP ล้วน (Cloudflare ถือ TLS) จึง listen 80 อย่างเดียว
# ปลายทาง redirect เป็น https:// เพราะนั่นคือที่ที่ผู้ใช้ควรไปจบ
read -r -d '' CATCHER <<'CONF_EOF'
# ดัก www.* ของทุกโดเมนบนเครื่องนี้แล้วส่งไป non-www
# ตั้งใจใช้ regex เพื่อให้ครอบคลุมทุกไซต์ด้วยไฟล์เดียว ไม่ต้องเพิ่มทีละโดเมน
# ใช้ได้ก็ต่อเมื่อ vhost เดิมถอด www.DOMAIN ออกจาก server_name แล้วเท่านั้น
server {
    listen 80;
    server_name ~^www\.(?<apex>.+)$;
    return 301 https://$apex$request_uri;
}
CONF_EOF

echo "=== ไซต์ที่ server_name ยังมี www ==="
mapfile -t FILES < <(grep -lE '^\s*server_name\s+[^;]*\bwww\.' "$SA"/* 2>/dev/null)
echo "เจอ ${#FILES[@]} ไฟล์"

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "ไม่มีอะไรต้องแก้"
else
  echo
  echo "ตัวอย่าง 3 ไฟล์แรก — บรรทัด server_name ก่อน/หลัง:"
  for f in "${FILES[@]:0:3}"; do
    b=$(grep -m1 -E '^\s*server_name ' "$f")
    a=$(echo "$b" | sed -E 's/ www\.[^ ;]+//g')
    printf '  %s\n    ก่อน: %s\n    หลัง: %s\n' "$(basename "$f")" "${b# }" "${a# }"
  done
fi

echo
echo "=== conf.d catcher ==="
[ -f "$CONF" ] && echo "มีอยู่แล้ว: $CONF" || echo "ยังไม่มี จะสร้าง: $CONF"

echo
echo "=== add-site.sh ==="
if [ -f "$ADDSITE" ]; then
  grep -nE '^\s*server_name ' "$ADDSITE" | sed 's/^/  /'
else
  echo "  ไม่พบ $ADDSITE"
fi

if [ "$APPLY" = "0" ]; then
  echo
  echo "— ดูอย่างเดียว ยังไม่ได้แก้อะไร — รันซ้ำด้วย --apply เพื่อแก้จริง"
  exit 0
fi

echo
echo "=== 1. สำรอง ==="
tar -czf "$BACKUP" -C /etc/nginx sites-available && echo "$BACKUP"

echo "=== 2. วาง catcher ==="
printf '%s\n' "$CATCHER" > "$CONF"
echo "$CONF"

echo "=== 3. ถอด www ออกจาก server_name ==="
for f in "${FILES[@]}"; do
  sed -i -E '/^\s*server_name /s/ www\.[^ ;]+//g' "$f"
done
echo "แก้ไป ${#FILES[@]} ไฟล์"

echo "=== 4. add-site.sh ==="
if [ -f "$ADDSITE" ] && grep -qE '^\s*server_name .*www\.' "$ADDSITE"; then
  cp -p "$ADDSITE" "$ADDSITE.bak-$STAMP"
  sed -i -E '/^\s*server_name /s/ www\.\$DOMAIN//' "$ADDSITE"
  grep -nE '^\s*server_name ' "$ADDSITE" | sed 's/^/  /'
else
  echo "  ไม่ต้องแก้"
fi

echo "=== 5. nginx -t ==="
if nginx -t; then
  systemctl reload nginx
  echo
  echo "reload แล้ว — สำรองอยู่ที่ $BACKUP"
else
  echo
  echo "!! nginx -t ไม่ผ่าน — กู้ไฟล์คืนและไม่ reload"
  rm -f "$CONF"
  tar -xzf "$BACKUP" -C /etc/nginx
  nginx -t
  exit 1
fi
