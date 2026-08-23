param (
    [Parameter(Mandatory=$true, HelpMessage="Domain of the site as it exists in aaPanel (e.g. sclass88-member.com)")]
    [string]$Domain,
    [string]$VpsIp = "187.52.122.249",
    [string]$VpsUser = "root",
    [switch]$SkipBuild,
    [switch]$FilesOnly,
    [switch]$DryRun
)

$Domain = $Domain.Trim().ToLower()
$domainPattern = '^(?=.{1,253}$)([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,}$'
if ($Domain -notmatch $domainPattern) {
    Write-Host "Error: '$Domain' is not a valid domain. Example: sclass88-member.com" -ForegroundColor Red
    exit 1
}

$WebRoot    = "/www/wwwroot/$Domain"
$ExtDir     = "/www/server/panel/vhost/nginx/extension/$Domain"
$Tarball    = "dist.tar.gz"
$LocalConf  = "tools/aapanel-astro.conf"
$RemoteTar  = "/tmp/$Domain.dist.tar.gz"
$RemoteConf = "/tmp/$Domain.astro.conf"
# aaPanel sets chattr +i on .user.ini, so chown/chmod on it fail as root and
# would abort the whole remote script. Kept files are skipped by every step.
$Keep       = @(".user.ini", ".htaccess", "502.html")

function Get-RemoteCommand {
    $keepExpr = ($Keep | ForEach-Object { "! -name '$_'" }) -join " "
    $lines = @(
        "set -e",
        "test -d '$WebRoot' || { echo MISSING_SITE; exit 9; }",
        "find '$WebRoot' -mindepth 1 -maxdepth 1 $keepExpr -exec rm -rf {} +",
        "tar -xzf '$RemoteTar' -C '$WebRoot/'",
        "rm -f '$RemoteTar'",
        "find '$WebRoot' -mindepth 1 $keepExpr -exec chown www:www {} +",
        "find '$WebRoot' -mindepth 1 $keepExpr -type d -exec chmod 755 {} +",
        "find '$WebRoot' -mindepth 1 $keepExpr -type f -exec chmod 644 {} +",
        "chmod 755 '$WebRoot'"
    )
    if (-not $FilesOnly) {
        $lines += @(
            "mkdir -p '$ExtDir'",
            "mv -f '$RemoteConf' '$ExtDir/astro.conf'",
            "chmod 644 '$ExtDir/astro.conf'",
            "nginx -t",
            "nginx -s reload",
            "echo NGINX_RELOADED"
        )
    }
    $lines += "echo DEPLOY_OK"
    return ($lines -join "; ")
}

Write-Host "========================================" -ForegroundColor Magenta
Write-Host "DEPLOY TO aaPANEL: $Domain" -ForegroundColor Yellow
Write-Host "  $VpsUser@$VpsIp  ->  $WebRoot" -ForegroundColor DarkGray
Write-Host "========================================" -ForegroundColor Magenta

if ($DryRun) {
    Write-Host "`n[DryRun] would run:" -ForegroundColor DarkYellow
    Write-Host "  npm run build"
    Write-Host "  tar -czf $Tarball -C dist ."
    Write-Host "  scp $Tarball ${VpsUser}@${VpsIp}:$RemoteTar"
    if (-not $FilesOnly) { Write-Host "  scp $LocalConf ${VpsUser}@${VpsIp}:$RemoteConf" }
    Write-Host "`n  ssh ${VpsUser}@${VpsIp} <<" -ForegroundColor DarkYellow
    Write-Host ("    " + (Get-RemoteCommand)) -ForegroundColor DarkGray
    exit 0
}

if ($SkipBuild) {
    if (-not (Test-Path "dist/index.html")) {
        Write-Host "Error: -SkipBuild was given but dist/index.html does not exist. Build first." -ForegroundColor Red
        exit 1
    }
    Write-Host "`n[1/4] Skipping build (-SkipBuild), using the existing dist/" -ForegroundColor DarkYellow
} else {
    Write-Host "`n[1/4] Building (npm run build runs verify-build afterwards)..." -ForegroundColor Cyan
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: build or verify failed. Nothing was uploaded." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n[2/4] Compressing dist..." -ForegroundColor Cyan
if (Test-Path $Tarball) { Remove-Item $Tarball -Force }
tar -czf $Tarball -C dist .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: tar failed. Nothing was uploaded." -ForegroundColor Red
    exit 1
}

Write-Host "`n[3/4] Uploading to $VpsIp ..." -ForegroundColor Cyan
scp $Tarball "${VpsUser}@${VpsIp}:${RemoteTar}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: upload failed. Check the IP, the SSH key, or the root password." -ForegroundColor Red
    Remove-Item $Tarball -Force
    exit 1
}

if (-not $FilesOnly) {
    if (-not (Test-Path $LocalConf)) {
        Write-Host "Error: $LocalConf is missing - cannot configure nginx. Re-run with -FilesOnly to skip that step." -ForegroundColor Red
        Remove-Item $Tarball -Force
        exit 1
    }
    scp $LocalConf "${VpsUser}@${VpsIp}:${RemoteConf}"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: uploading the nginx snippet failed." -ForegroundColor Red
        Remove-Item $Tarball -Force
        exit 1
    }
}

Write-Host "`n[4/4] Installing on the server..." -ForegroundColor Cyan
ssh "${VpsUser}@${VpsIp}" (Get-RemoteCommand)
$sshExit = $LASTEXITCODE
Remove-Item $Tarball -Force

if ($sshExit -eq 9) {
    Write-Host "`nError: $WebRoot does not exist on the server." -ForegroundColor Red
    Write-Host "Create the site in aaPanel first: Website -> Add site -> $Domain (PHP version: Static)." -ForegroundColor Yellow
    Write-Host "Do NOT create it through WP Toolkit - that installs WordPress on the domain." -ForegroundColor Yellow
    exit 1
}
if ($sshExit -ne 0) {
    Write-Host "`nError: install failed on the server (exit $sshExit)." -ForegroundColor Red
    Write-Host "If nginx -t failed, the old config is still live and was NOT reloaded." -ForegroundColor Yellow
    exit $sshExit
}

Write-Host "`nDONE. https://$Domain" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Magenta
