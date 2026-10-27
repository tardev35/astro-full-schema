// Local Domain Manager — a tiny web UI to add a domain on the hosting VPS by
// running `./add-site.sh <domain>` over SSH. It authenticates with a PASSWORD
// (from .env via node-ssh), so a machine that has NO SSH key to the server
// (e.g. a freshly cloned dev Windows Server) can still add domains — no key
// setup required.
//
// Kept as its OWN tool, separate from the asset uploader, on purpose: this one
// holds a root password and can run a root command on the server, so it must
// never ride along with (or be hosted like) the uploader.
//
// Since 2026-08-13 the uploader's ส่วนที่ 7 can also deploy to this VPS, and it
// reads THIS folder's .env rather than keeping its own copy — one file to
// gitignore, one password to rotate. The separation that still holds is the
// hosting rule above: neither tool may be exposed beyond localhost, and the
// uploader must stay unhosted for exactly the reason this file was split out.
//
// Run:  node --env-file=tools/domain-manager/.env tools/domain-manager/server.mjs
//       (or double-click start-domain-manager.cmd). Binds localhost only.

import express from "express";
import { NodeSSH } from "node-ssh";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";
import { existsSync } from "node:fs";
import { homedir } from "node:os";

const __dirname = dirname(fileURLToPath(import.meta.url));

const HOST = process.env.HOST || "127.0.0.1";
const PORT = Number(process.env.PORT) || 3000;
const VPS_HOST = process.env.VPS_HOST || "45.32.122.181";
const VPS_USER = process.env.VPS_USER || "root";
const VPS_PASSWORD = process.env.VPS_PASSWORD || "";
const VPS_KEY = process.env.VPS_KEY || "";

// Key first when this machine has one (the owner's machines do), password
// from .env second (the dev team's Windows Servers have no key). Each attempt
// is reported by name so a wrong password and a missing key read differently.
function authAttempts() {
  const out = [];
  const keys = [VPS_KEY, join(homedir(), ".ssh", "id_ed25519"), join(homedir(), ".ssh", "id_rsa")].filter(Boolean);
  for (const k of keys) {
    if (existsSync(k) && !out.some((a) => a.privateKeyPath === k)) out.push({ label: "SSH key " + k, privateKeyPath: k });
  }
  if (VPS_PASSWORD) out.push({ label: "รหัสผ่านจาก .env", password: VPS_PASSWORD });
  return out;
}

async function connectVps(ssh) {
  const attempts = authAttempts();
  if (!attempts.length) {
    throw new Error("เครื่องนี้ไม่มี SSH key (~/.ssh/id_ed25519) และยังไม่ได้ตั้ง VPS_PASSWORD ใน tools/domain-manager/.env");
  }
  const failed = [];
  for (const a of attempts) {
    const { label, ...opts } = a;
    try {
      await ssh.connect({ host: VPS_HOST, username: VPS_USER, readyTimeout: 20000, ...opts });
      return label;
    } catch (error) {
      failed.push(label + ": " + error.message);
    }
  }
  throw new Error(
    "ต่อ " + VPS_USER + "@" + VPS_HOST + " ไม่ได้ ลองแล้ว " + attempts.length + " วิธี\n" + failed.join("\n") +
    "\nถ้าใช้รหัสผ่าน: ตรวจ VPS_PASSWORD ใน tools/domain-manager/.env ว่าตรงกับรหัส root ปัจจุบัน (เครื่องอื่นที่รหัสถูกต้องยังเข้าได้)",
  );
}

// add-site.sh runs as root, so the domain MUST be validated before it is placed
// in the remote command. This strict whitelist (a-z 0-9 . -, real TLD) blocks
// every shell metacharacter (space ; & | $ backtick ' ") that could smuggle an
// extra command onto the server — the difference between "add a site" and
// "run anything as root".
const DOMAIN_RE = /^(?=.{1,253}$)([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,}$/;

const app = express();
app.use(express.json());
app.use(express.static(join(__dirname, "public")));

app.post("/api/add-site", async (req, res) => {
  const domain = String(req.body?.domain ?? "").trim().toLowerCase();
  if (!domain) {
    return res.status(400).json({ success: false, error: "กรุณากรอกชื่อโดเมน" });
  }
  if (!DOMAIN_RE.test(domain)) {
    return res.status(400).json({ success: false, error: `โดเมนไม่ถูกต้อง: '${domain}' (เช่น mybrand-review.com)` });
  }
  const ssh = new NodeSSH();
  try {
    const via = await connectVps(ssh);
    console.log("[add-site] " + domain + " via " + via);
    // domain is whitelisted above, so this interpolation is safe.
    const result = await ssh.execCommand(`./add-site.sh ${domain}`);
    return res.json({ success: true, output: result.stdout, errorOutput: result.stderr });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  } finally {
    ssh.dispose();
  }
});

app.listen(PORT, HOST, () => {
  console.log(`\n  Domain manager: http://localhost:${PORT}   (bind ${HOST})`);
  console.log(`  Target VPS: ${VPS_USER}@${VPS_HOST}`);
  console.log(`  auth: ${authAttempts().map((a) => a.label).join(" → ") || "ไม่มีทั้ง SSH key และ VPS_PASSWORD"}`);
  console.log("");
});
