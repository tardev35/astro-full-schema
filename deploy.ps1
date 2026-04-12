param (
    [string]$Domain
)

# 🌟 1. ตั้งค่าเซิร์ฟเวอร์
$VPS_IP = "45.32.122.181"  
$VPS_USER = "root"

# 🌟 2. ตั้งค่า Cloudflare 
$CF_ZONE_ID = "เอา_ZONE_ID_มาใส่ตรงนี้"
$CF_API_TOKEN = "เอา_API_TOKEN_มาใส่ตรงนี้"

if (-not $Domain) {
    Write-Host "Error: Please provide a domain! Example: .\deploy.ps1 pigauto998.info" -ForegroundColor Red
    exit
}

Write-Host "[1/4] Building Astro project..." -ForegroundColor Cyan
npx astro build --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Build failed! Please check your code." -ForegroundColor Red
    exit
}

# 🌟 2. ท่าไม้ตาย Windows Turbo: รวบไฟล์เป็นก้อนเดียวแล้วโยนขึ้น VPS (เร็วปรี๊ด!)
Write-Host "[2/4] Compressing & Uploading to VPS ($Domain)..." -ForegroundColor Yellow

# 2.1 รวบไฟล์ในโฟลเดอร์ dist เป็นก้อนเดียวชื่อ deploy.tar.gz
tar -czf deploy.tar.gz -C dist .

# 2.2 โยนขึ้น VPS ก้อนเดียวจบ (ประหยัดเวลาส่งทีละไฟล์)
scp deploy.tar.gz "${VPS_USER}@${VPS_IP}:/var/www/${Domain}/"

# 2.3 สั่งให้เซิร์ฟเวอร์ ลบไฟล์เก่าทิ้ง -> แตกไฟล์ใหม่ใส่ -> ลบไฟล์ขยะทิ้ง
ssh "${VPS_USER}@${VPS_IP}" "mkdir -p /var/www/${Domain}/dist && rm -rf /var/www/${Domain}/dist/* && tar -xzf /var/www/${Domain}/deploy.tar.gz -C /var/www/${Domain}/dist/ && rm /var/www/${Domain}/deploy.tar.gz"

# ลบไฟล์ zip ก้อนก้อนนี้ในเครื่องคอมเราทิ้ง จะได้ไม่รก
Remove-Item -Path "deploy.tar.gz" -Force -ErrorAction SilentlyContinue

Write-Host "  -> Upload Complete!" -ForegroundColor Green

# --- สเต็ปปลดล็อกไฟล์อัตโนมัติ ---
Write-Host "[3/4] Fixing File Permissions..." -ForegroundColor Cyan
ssh "${VPS_USER}@${VPS_IP}" "chown -R www-data:www-data /var/www/${Domain} && chmod -R 755 /var/www/${Domain}"
Write-Host "  -> Permissions fixed!" -ForegroundColor Green

# --- สเต็ปสั่งล้างแคช Cloudflare อัตโนมัติ ---
Write-Host "[4/4] Cleaning Cloudflare Cache..." -ForegroundColor Cyan

if ($CF_ZONE_ID -eq "เอา_ZONE_ID_มาใส่ตรงนี้") {
    Write-Host "Success! Update Complete. (Please purge Cloudflare cache manually)" -ForegroundColor Green
    exit
}

$headers = @{
    "Authorization" = "Bearer $CF_API_TOKEN"
    "Content-Type"  = "application/json"
}
$body = '{"purge_everything":true}'
$apiUrl = "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/purge_cache"

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method POST -Headers $headers -Body $body
    if ($response.success) {
        Write-Host "Success! Cloudflare cache purged for $Domain!" -ForegroundColor Green
    } else {
        Write-Host "Warning: Uploaded, but Cache purge failed." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error: Cache purge failed - $_" -ForegroundColor Red
}