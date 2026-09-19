#!/usr/bin/env bash
# slash-redirect.sh [--apply] - ทำ 301 จาก URL แบบไม่มี / ท้าย ไปแบบมี / ให้ทุกไซต์ Astro บน VPS
#
#   scp tools/vps/slash-redirect.sh root@VPS_IP:/root/
#   ssh root@VPS_IP "bash /root/slash-redirect.sh"           # ดูอย่างเดียว
#   ssh root@VPS_IP "bash /root/slash-redirect.sh --apply"   # แก้จริง
#
# ปัญหาที่แก้: Astro สร้างหน้าเป็น /promotion/index.html และ canonical ในหน้าเขียนว่า
# /promotion/ แต่ vhost เสิร์ฟ /promotion ให้ด้วย try_files โดยไม่ redirect — หนึ่งหน้า
# จึงเปิดได้สอง URL ที่ตอบ 200 เท่ากัน Google เก็บได้ทั้งคู่แล้วแบ่งคะแนนกันเอง
# (ตรวจเจอที่ topgamevip-homepage.net 2026-09-19; ฝั่ง Cloudflare Worker เติม / ให้เองอยู่แล้ว)
#
# ⚠️ ทำไมแทรกในทุก vhost แทนที่จะวางไฟล์เดียวใน conf.d เหมือน www-redirect.sh:
# การ redirect นี้ต้องเกิดใน server block ของโดเมนนั้นเอง ส่วน server block แยกใน conf.d
# จะถูกเรียกเฉพาะตอนไม่มี vhost ชื่อตรงตัวมารับไปก่อน จึงไม่มีวันทำงาน
#
# ⚠️ แทรกด้วย `sed r` ไม่ใช่ `awk -v`: awk แปลง escape ในค่าที่ส่งผ่าน -v ทำให้ \? กลายเป็น ?
# แล้ว regex พังทั้งเครื่อง (เจอจริง 2026-09-19 — nginx -t ตีตกที่ pcre_compile)
#
# กติกาของ regex: ข้าม path ที่มีจุด (ไฟล์อย่าง .css .png .webmanifest) เพราะไฟล์ไม่ต้องมี /
# ท้าย, คง query string ไว้ครบ, ส่วน "/" เฉยๆ ไม่เข้าเงื่อนไขอยู่แล้วเพราะลงท้ายด้วย /
#
# สิ่งที่ทำ:
#   1. สำรอง sites-available ทั้งหมดเป็น .tar.gz
#   2. แทรก snippet ต่อจากบรรทัด index ของ vhost แบบ Astro static ที่ยังไม่มี
#   3. แก้ add-site.sh ให้ไซต์ใหม่ได้ snippet นี้ไปด้วย
#   4. nginx -t แล้วค่อย reload — ไม่ผ่านคือไม่ reload และกู้ทั้ง vhost และ add-site.sh คืน

set -u

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1

SA=/etc/nginx/sites-available
ADDSITE=/root/add-site.sh
STAMP=$(date +%F-%H%M%S)
BACKUP=/root/vhost-backup-slash-$STAMP.tar.gz
MARK="# slash-redirect: 301 ไป URL แบบมี / ท้าย"

SNIPFILE=$(mktemp)
cat > "$SNIPFILE" <<'SNIP_EOF'

    # slash-redirect: 301 ไป URL แบบมี / ท้าย
    if ($request_uri ~ "^([^.?]*[^/])(\?.*)?$") {
        return 301 https://$host$1/$2;
    }
SNIP_EOF

# คู่แฝดสำหรับ add-site.sh ซึ่งวาง config ไว้ใน heredoc แบบขยายตัวแปร จึงต้อง escape $
SNIPFILE_ESC=$(mktemp)
cat > "$SNIPFILE_ESC" <<'SNIP2_EOF'

    # slash-redirect: 301 ไป URL แบบมี / ท้าย
    if (\$request_uri ~ "^([^.?]*[^/])(\?.*)?\$") {
        return 301 https://\$host\$1/\$2;
    }
SNIP2_EOF

trap 'rm -f "$SNIPFILE" "$SNIPFILE_ESC"' EXIT

# เลือกเฉพาะ vhost ของ Astro static ที่ add-site.sh สร้าง — ข้ามตัวที่มี proxy_pass หรือ
# fastcgi เสมอ เพราะ 301 เปลี่ยน POST เป็น GET และทำ endpoint ที่ไม่มี / ท้ายพังได้
echo "=== vhost ที่จะแทรก ==="
FILES=()
SKIP_NOT_ASTRO=0
SKIP_PROXY=0
SKIP_DONE=0
for f in "$SA"/*; do
  [ -f "$f" ] || continue
  if ! grep -qF 'try_files $uri $uri/index.html $uri.html =404' "$f"; then SKIP_NOT_ASTRO=$((SKIP_NOT_ASTRO+1)); continue; fi
  if grep -qE 'proxy_pass|fastcgi_pass' "$f"; then SKIP_PROXY=$((SKIP_PROXY+1)); continue; fi
  if grep -qF "$MARK" "$f"; then SKIP_DONE=$((SKIP_DONE+1)); continue; fi
  FILES+=("$f")
done
echo "เจอ ${#FILES[@]} ไฟล์ จากทั้งหมด $(ls -1 "$SA" 2>/dev/null | wc -l)"
echo "ข้าม: ไม่ใช่ Astro static $SKIP_NOT_ASTRO · มี proxy/fastcgi $SKIP_PROXY · มี snippet แล้ว $SKIP_DONE"
for f in "${FILES[@]:0:5}"; do echo "  $(basename "$f")"; done
[ "${#FILES[@]}" -gt 5 ] && echo "  ... อีก $(( ${#FILES[@]} - 5 )) ไฟล์"

echo
echo "=== snippet ที่จะแทรก (ต่อจากบรรทัด index) ==="
cat "$SNIPFILE"

echo
echo "=== add-site.sh ==="
if [ -f "$ADDSITE" ]; then
  if grep -qF "$MARK" "$ADDSITE"; then echo "  มี snippet แล้ว"; else echo "  ยังไม่มี จะแทรกให้"; fi
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

echo "=== 2. อัปเกรด snippet รุ่นเก่า (redirect เป็น path เปล่า ทำให้เด้งซ้ำ http -> https) ==="
UPG=0
for f in $(grep -lF "$MARK" "$SA"/* 2>/dev/null) "$ADDSITE"; do
  [ -f "$f" ] || continue
  if grep -q 'return 301 $1/$2;' "$f"; then
    sed -i 's|return 301 $1/$2;|return 301 https://$host$1/$2;|' "$f"
    UPG=$((UPG+1))
  fi
done
echo "อัปเกรด $UPG ไฟล์"

echo "=== 3. แทรก snippet เข้า vhost ==="
for f in "${FILES[@]}"; do
  sed -i "/^[[:space:]]*index[[:space:]]/r $SNIPFILE" "$f"
done
echo "แทรกแล้ว $(grep -lF "$MARK" "$SA"/* 2>/dev/null | wc -l) ไฟล์"

echo "=== 4. add-site.sh ==="
if [ -f "$ADDSITE" ] && ! grep -qF "$MARK" "$ADDSITE"; then
  cp -p "$ADDSITE" "$ADDSITE.bak-$STAMP"
  sed -i "/^[[:space:]]*index[[:space:]]/r $SNIPFILE_ESC" "$ADDSITE"
  chmod +x "$ADDSITE"
  grep -qF "$MARK" "$ADDSITE" && echo "  แทรกแล้ว (สำรองไว้ที่ $ADDSITE.bak-$STAMP)"
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
  tar -xzf "$BACKUP" -C /etc/nginx
  [ -f "$ADDSITE.bak-$STAMP" ] && cp -p "$ADDSITE.bak-$STAMP" "$ADDSITE"
  nginx -t
  exit 1
fi
