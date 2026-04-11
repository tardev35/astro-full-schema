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

Write-Host "[2/4] Uploading to VPS ($Domain)..." -ForegroundColor Yellow
scp -r dist\* "${VPS_USER}@${VPS_IP}:/var/www/${Domain}/dist/"

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
    # ลบอีโมจิออกแล้ว รันผ่านแน่นอน 100%
    Write-Host "Error: Cache purge failed - $_" -ForegroundColor Red
}