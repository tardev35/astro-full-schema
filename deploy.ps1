param (
    [Parameter(Mandatory=$true, HelpMessage="Enter your domain name (e.g., finnbet-vip.com)")]
    [string]$Domain
)

# 🌟 1. ตั้งค่าเซิร์ฟเวอร์
$VPS_IP = "45.32.122.181"  
$VPS_USER = "root"

# 🌟 2. ตั้งค่า Cloudflare 
$CF_ZONE_ID = "เอา_ZONE_ID_มาใส่ตรงนี้"
$CF_API_TOKEN = "เอา_API_TOKEN_มาใส่ตรงนี้"

Write-Host "========================================" -ForegroundColor Magenta
Write-Host "🚀 ULTIMATE DEPLOYMENT: $Domain" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Magenta

# --- สเต็ปที่ 1: Build ---
Write-Host "`n[1/4] 🔨 Building Astro project..." -ForegroundColor Cyan
npx astro build --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: Build failed! Please check your code." -ForegroundColor Red
    exit
}

# --- สเต็ปที่ 2: มัดรวมไฟล์ (Fast Tar) ---
Write-Host "`n[2/4] 📦 Compressing files for hyper-speed upload..." -ForegroundColor Cyan
if (Test-Path "dist.tar.gz") { Remove-Item "dist.tar.gz" }
tar -czf dist.tar.gz -C dist .

# --- สเต็ปที่ 3: อัปโหลด + แตกไฟล์ + แก้สิทธิ์ (ทำทุกอย่างใน SSH เดียว) ---
Write-Host "`n[3/4] ⚡ Uploading & Configuring Server..." -ForegroundColor Cyan
scp dist.tar.gz "${VPS_USER}@${VPS_IP}:/var/www/${Domain}/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: Upload failed! Check your connection." -ForegroundColor Red
    Remove-Item "dist.tar.gz"
    exit
}

# รวบคำสั่ง: ลบของเก่า -> แตกไฟล์ -> ลบ zip -> แก้สิทธิ์ ให้ทำงานรวดเดียว
$sshCommand = "
    rm -rf /var/www/${Domain}/dist/* &&
    tar -xzf /var/www/${Domain}/dist.tar.gz -C /var/www/${Domain}/dist/ &&
    rm /var/www/${Domain}/dist.tar.gz &&
    chown -R www-data:www-data /var/www/${Domain} &&
    chmod -R 755 /var/www/${Domain}
"
ssh "${VPS_USER}@${VPS_IP}" $sshCommand

# ลบไฟล์ zip ในคอมเราทิ้งเพื่อความสะอาด
Remove-Item "dist.tar.gz"
Write-Host "  -> ✅ Files updated and permissions fixed!" -ForegroundColor Green

# --- สเต็ปที่ 4: ล้างแคช Cloudflare ---
Write-Host "`n[4/4] ☁️ Cleaning Cloudflare Cache..." -ForegroundColor Cyan

if ($CF_ZONE_ID -eq "เอา_ZONE_ID_มาใส่ตรงนี้" -or $CF_API_TOKEN -eq "เอา_API_TOKEN_มาใส่ตรงนี้") {
    Write-Host "  -> ⚠️ CF Keys not set. (Please purge Cloudflare cache manually)" -ForegroundColor DarkYellow
} else {
    $headers = @{
        "Authorization" = "Bearer $CF_API_TOKEN"
        "Content-Type"  = "application/json"
    }
    $body = '{"purge_everything":true}'
    $apiUrl = "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/purge_cache"

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method POST -Headers $headers -Body $body
        if ($response.success) {
            Write-Host "  -> ✅ Cloudflare cache purged successfully!" -ForegroundColor Green
        } else {
            Write-Host "  -> ⚠️ Cache purge failed." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  -> ❌ Error: Cache purge failed - $_" -ForegroundColor Red
    }
}

Write-Host "`n🎉 DEPLOYMENT COMPLETE! Your site is live and blazing fast." -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta