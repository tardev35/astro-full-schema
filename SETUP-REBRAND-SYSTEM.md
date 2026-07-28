# ติดตั้งระบบ Rebrand ทั้งชุด บนเครื่อง dev

คู่มือนี้พาตั้งค่า **เครื่อง dev 1 เครื่อง** ตั้งแต่ยังไม่มีอะไรเลย จนถึงกดรีแบรนด์
และกดขึ้นเว็บจริงบน Cloudflare ได้จากหน้าเว็บเดียว

> 📌 **มี 3 คู่มือในโปรเจกต์นี้ อย่าสลับกัน**
>
> | ไฟล์ | ใช้เมื่อ |
> |---|---|
> | [`README.md`](README.md) | ทำงานรีแบรนด์รายแบรนด์ (1 repo ต่อ 1 แบรนด์) + คู่มือ Git |
> | [`DEPLOY-CLOUDFLARE.md`](DEPLOY-CLOUDFLARE.md) | เอาเว็บขึ้น Cloudflare + สลับบัญชี + แก้ปัญหา DNS |
> | **ไฟล์นี้** | **ตั้งเครื่อง dev ใหม่ให้ใช้ระบบทั้งชุดได้** |
>
> [`SETUP-NEW-MACHINE.md`](SETUP-NEW-MACHINE.md) เป็นรุ่นก่อนหน้าของไฟล์นี้
> ชี้ไป branch เก่าที่ยังไม่มีส่วน Cloudflare — **ใช้ไฟล์นี้แทน**

**ปลายทางที่จะได้:**

| ของ | ค่า |
|---|---|
| โค้ดต้นทาง | `gitlab.com/tardev-group/astro-full-schema` branch `rebrand-ufayes-cf` |
| repo ที่คุณทำงาน | `gitlab.com/tardev-group/astro-<ชื่อคุณ>` (คนละอันต่อคน) |
| branch ที่ทำงาน | `main` |
| หน้าเว็บ dev | http://localhost:8888 |
| หน้า uploader | http://localhost:4000 |
| หน้า preview หลังรีแบรนด์ | http://localhost:4321 |

---

## 0. ระบบนี้มีอะไรบ้าง (อ่าน 1 นาทีก่อนลงมือ)

ต่างจากรุ่นก่อนตรงที่มันไม่ใช่แค่ "อัปโหลดรูป" อีกแล้ว — มี 4 ส่วนที่ต้องมีของครบถึงจะทำงาน

| ส่วน | ทำอะไร | ต้องติดตั้งอะไร |
|---|---|---|
| เว็บ Astro | ตัวเว็บลูกค้า | Node.js |
| Rebrand Uploader | หน้า UI ที่ `localhost:4000` รับไฟล์ + ยิงคำสั่ง | Node.js (ใช้ `sharp` ย่อรูป) |
| Claude Code CLI | ตัวที่ลงมือรีแบรนด์จริงตอนกดปุ่ม | **Claude CLI + login** |
| Cloudflare (wrangler) | ปุ่มขึ้นเว็บจริง + ปุ่มสลับบัญชี | **`wrangler login`** |

**ขาดข้อ 3 = ปุ่ม "เริ่ม Rebrand" กดแล้วไม่มีอะไรเกิด**
**ขาดข้อ 4 = ปุ่ม "ขึ้นเว็บจริง" ล้มตอนยิง**

สองข้อนี้คือของใหม่ที่คู่มือรุ่นก่อนไม่มี และเป็นข้อที่คนลืมบ่อยที่สุด

---

# ภาค A — เปิด repo ให้เพื่อน (คนที่ถือต้นแบบทำ)

> **dev ที่มารับเครื่อง ข้ามภาคนี้ทั้งภาค ไปเริ่มที่ [ภาค B](#ภาค-b--ตั้งเครื่อง-dev-ทำทุกเครื่อง)**
> ทุกอย่างในภาคนี้เจ้าของต้นแบบทำให้เสร็จก่อนส่งมอบแล้ว

## โครงที่ใช้อยู่

```
astro-full-schema / rebrand-ufayes-cf     ← ต้นแบบ มีคนเดียวที่แตะ
        │
        ├──> astro-bas    (บาส)
        ├──> astro-tud    (ตุ๊ด)
        └──> astro-aoy    (อ้อย)
```

**หนึ่งคน หนึ่ง repo** ทุก repo ปลายทางมี `main` เป็นสำเนาของต้นแบบ แล้วเจ้าตัวแตก branch
ของตัวเองทำงานบนนั้น

**เพื่อนไม่ต้องมีสิทธิ์เข้าถึง `astro-full-schema` เลยแม้แต่ครั้งเดียว** เขาเห็นแค่ repo
ของตัวเอง — ขั้นตอนที่พลาดง่ายทั้งหมดอยู่ฝั่งคุณ ทำครั้งเดียวต่อคน

> **ทำไมยังต้องมีต้นแบบ ในเมื่อทุกคนมี repo ของตัวเอง** — เพราะมันเป็นที่เดียวที่รวมงาน
> จากทุกคนแล้วส่งกลับให้ทุกคนได้ ถ้าไม่มีจุดรวม สิ่งที่ตุ๊ดแก้จะไม่มีทางไปถึงอ้อยเลย

---

## A1. สร้าง project เปล่าใน GitLab

GitLab → **New project** → **Create blank project**

| ช่อง | ค่า |
|---|---|
| Project name | `astro-<ชื่อคน>` เช่น `astro-tud` |
| Project URL | group `tardev-group` |
| Visibility | **Private** |
| Initialize repository with a README | **ห้ามติ๊ก** ⚠️ ติ๊กแล้ว repo จะไม่ว่าง แล้วจะชนกับที่กำลังจะ push |

จากนั้น **Manage → Members → Invite members** เชิญเจ้าตัวเข้ามา ให้สิทธิ์ **Developer**
(push branch ตัวเองได้ แต่แตะ `main` ที่ถูก protect ไม่ได้ — ซึ่งเป็นสิ่งที่เราต้องการพอดี)

## A2. ยกโค้ดขึ้น repo นั้น — 2 คำสั่ง

ทำจาก**โฟลเดอร์ต้นแบบ** คือโฟลเดอร์ `astro-full-schema` ในเครื่องคุณ

**ยังไม่มีโฟลเดอร์นั้น?** ดึงลงมาก่อนด้วย `git clone` — **มันสร้างโฟลเดอร์ให้เอง
ไม่ต้องไปสร้างโฟลเดอร์เปล่ารอไว้** ทำครั้งเดียวจบ:

```powershell
cd $HOME\Desktop        # แค่บอกว่าจะให้โฟลเดอร์ไปโผล่ที่ไหน
git clone git@gitlab.com:tardev-group/astro-full-schema.git
cd astro-full-schema
git switch rebrand-ufayes-cf
```

> `clone` กับ `pull` ไม่ใช่ตัวเดียวกัน — `clone` ใช้ตอน**ยังไม่มีโค้ดในเครื่องเลย**
> ดึงมาทั้งก้อนพร้อมสร้างโฟลเดอร์ ส่วน `pull` ใช้กับโฟลเดอร์ที่**เป็น repo อยู่แล้ว**
> เพื่อดึงเฉพาะของใหม่ โฟลเดอร์เปล่าที่สร้างเองใน File Explorer ยัง `pull` ไม่ได้
> เพราะ git ยังไม่รู้จักมันว่าเป็น repo

**มีโฟลเดอร์อยู่แล้ว?** เข้าไปแล้วดึงของล่าสุดมาก่อน:

```powershell
cd path\ไปยัง\astro-full-schema
git switch rebrand-ufayes-cf
git pull
```

**แล้วยกขึ้น repo ของเพื่อน:**

```powershell
# 1) ตั้งชื่อเล่นให้ repo ของเขา — ทำครั้งเดียวต่อคน
git remote add tud git@gitlab.com:tardev-group/astro-tud.git

# 2) ส่งขึ้นไปโดยใช้ชื่อ main บนนั้น
git push tud rebrand-ufayes-cf:main
```

จบ — เพื่อน clone ได้เลย

> **`tud` เป็นชื่อเล่นที่คุณตั้งเอง** อยู่แค่ในไฟล์ `.git/config` ของโฟลเดอร์นี้
> GitLab ไม่รู้จักชื่อนี้ ส่วนที่เป็นของจริงคือ URL ตั้งชื่อให้รู้ว่าใครเป็นใคร
> (`tud`, `aoy`, `bas`) ดีกว่าชื่อกลางๆ อย่าง `newrepo` เพราะพอมี 5 คนจะจำไม่ได้

> 🚨 **`:main` ท้ายคำสั่งคือหัวใจ ห้ามตกหล่น** แปลว่า "เอา branch ในเครื่องชื่อนี้
> ขึ้นไปใช้ชื่อ `main` บน remote" — ชื่อสองฝั่งไม่จำเป็นต้องตรงกัน
>
> **ถ้าลืมใส่** branch จะไปโผล่ชื่อ `rebrand-ufayes-cf` และเพราะเป็น branch แรกของ repo
> เปล่า มันจะกลายเป็น default branch อัตโนมัติ + ถูก GitLab ป้องกันทันที การจะแก้ทีหลัง
> ต้องไล่เปลี่ยน default → ปลด protection → ลบ branch เก่า สามขั้นในหน้าเว็บ
> **เคยพลาดมาแล้วกับ `astro-bas`**
>
> **และอย่าใส่ `-u`** ในโฟลเดอร์ต้นแบบ มันจะล็อกให้ `git push` เฉยๆ วิ่งไป repo นั้นที่เดียว
> ทั้งที่โฟลเดอร์นี้ผูกหลาย repo — สั่งชื่อ remote ตรงๆ ทุกครั้งปลอดภัยกว่า

> **ทำไมเปลี่ยนชื่อเป็น `main`** — ใน repo ของเขา โค้ดชุดนี้*คือ*ตัวหลัก ไม่ใช่ branch ทดลอง
> การคง `rebrand-ufayes-cf` ไว้เป็นแกนจะทำให้เขาเข้าใจผิดว่านี่คืองานของแบรนด์ UFAYES
> — ทั้งที่มันคือระบบกลาง

## A3. ส่งอะไรให้เพื่อน

ส่ง 2 บรรทัดนี้พอ:

```
git clone git@gitlab.com:tardev-group/astro-tud.git
```
> แล้วอ่าน `SETUP-REBRAND-SYSTEM.md` ในโฟลเดอร์ เริ่มที่ **ภาค B** (ข้ามภาค A)

เขาจะได้ `main` เป็น default, `git push` เฉยๆ ใช้ได้ทันที ไม่ต้อง `switch` ไม่ต้องรู้จัก
คำว่า `rebrand-ufayes-cf` ด้วยซ้ำ

**⚠️ อย่าส่งคำสั่งของภาค A ให้เพื่อนรัน** — คำสั่งอย่าง `git push tud rebrand-ufayes-cf:main`
ใช้ได้เฉพาะโฟลเดอร์ต้นแบบ เพราะเครื่องเขาไม่มีทั้ง remote ชื่อ `tud` และ branch ชื่อ
`rebrand-ufayes-cf` จะขึ้น `src refspec ... does not match any` **เคยพลาดมาแล้ว**

| | โฟลเดอร์ต้นแบบ (คุณ) | เครื่องเพื่อน |
|---|---|---|
| remote | `origin` = astro-full-schema, `tud`/`aoy`/`bas` = ของแต่ละคน | `origin` = repo ตัวเองอันเดียว |
| branch | `rebrand-ufayes-cf` | `main` |
| ทิศทาง | ส่งออก | รับเข้า + push branch ตัวเอง |

## A4. เวลาต้นแบบมีของใหม่ → กระจายออก

```powershell
git push bas rebrand-ufayes-cf:main
git push tud rebrand-ufayes-cf:main
git push aoy rebrand-ufayes-cf:main
```

`git remote add` ทำครั้งเดียวตอนเปิด repo ครั้งต่อๆ ไปเหลือแค่บรรทัด `push`
เพื่อนแต่ละคนแค่ `git switch main` แล้ว `git pull`

**กติกาข้อเดียวที่ทำให้คำสั่งนี้ปลอดภัยตลอด:**

> **`main` ของทุก repo ปลายทางคือกระจกเงาของต้นแบบ ห้ามคอมมิตลงไปตรงๆ**
> ทุกคนต้องแตก branch ของตัวเองเสมอ

ถ้ามีคนเผลอคอมมิตลง `main` จริง คำสั่งข้างบนจะ**ถูกปฏิเสธ ไม่ทับงานเขา** — นั่นคือ
branch protection ทำหน้าที่ถูกแล้ว **อย่าแก้ด้วย `--force`** ให้ไปคุยกับเจ้าตัวก่อน

## A5. เวลางานของเพื่อนดี อยากเก็บเข้าต้นแบบ

```powershell
# ในโฟลเดอร์ต้นแบบ
git fetch tud
git switch rebrand-ufayes-cf
git merge tud/ชื่อ-branch-ของเขา     # แก้ conflict ถ้ามี
git push origin rebrand-ufayes-cf     # เข้าต้นแบบก่อน
```

แล้วค่อยกระจายออกทุกคนตาม **A4** — จากนั้นลบ branch ของเขาทิ้งได้

```powershell
git push tud --delete ชื่อ-branch-ของเขา
```

> **ถามตัวเองก่อนรับเข้า: อันนี้ควรมีผลกับทุกคนจริงไหม** งานบางอย่างเป็นการแก้ให้เข้ากับ
> เครื่องตัวเอง เช่นเปลี่ยนพอร์ตเพราะพอร์ตเดิมชนกับโปรแกรมอื่น — แบบนั้นให้เก็บไว้ใน
> repo ของเขาเอง อย่าลากทุกคนไปด้วย


# ภาค B — ตั้งเครื่อง dev (ทำทุกเครื่อง)

## B1. ติดตั้ง Node.js + Git

1. **Node.js** — https://nodejs.org เลือก **LTS** กด Next รวด
2. **Git** — https://git-scm.com/download/win กด Next รวดตาม default

เช็ก (เปิด **PowerShell ใหม่** หลังติดตั้ง):

```powershell
node --version    # ต้องได้ v20 ขึ้นไป (เครื่องที่พัฒนาใช้ v22)
npm --version
git --version
```

> ⚠️ **ต้องเปิดหน้าต่างใหม่** โปรแกรมที่เพิ่งลงจะยังไม่อยู่ใน PATH ของหน้าต่างเก่า

## B2. ติดตั้ง Claude Code CLI ⭐

เปิด **cmd.exe** (ไม่ใช่ PowerShell):

```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd
```

**เปิดหน้าต่างใหม่** แล้วเช็ก:

```powershell
claude --version
```

### login ให้เรียบร้อย — ข้อที่คนลืมบ่อยที่สุด

```powershell
claude
```

ทำตามที่ถามบนหน้าจอจน login เสร็จ แล้วพิมพ์ `/exit`

> ปุ่ม "เริ่ม Rebrand" ยิง `claude -p` แบบไม่มีหน้าจอให้ตอบคำถาม
> **ถ้ายังไม่ login มันจะค้างเงียบๆ โดยไม่มี error ที่อ่านรู้เรื่อง**
> ต้อง login ให้จบในหน้าต่างปกติก่อนอย่างน้อย 1 ครั้ง

## B3. ตั้งชื่อ-อีเมล Git + SSH key

```powershell
git config --global user.name "ชื่อจริง"
git config --global user.email "อีเมลที่ใช้สมัคร GitLab"
```

ถ้ายังไม่เคยตั้ง SSH key ให้ทำตาม [README หัวข้อ 2](README.md) แล้วกลับมาต่อ

เช็กว่า key ใช้ได้:

```powershell
ssh -T git@gitlab.com
```

## B4. โคลนโค้ด

ใช้ URL ของ **repo ตัวเอง** ที่ได้รับมา (เช่น `astro-tud`) — ไม่ใช่ `astro-full-schema`

```powershell
cd $HOME\Desktop
git clone git@gitlab.com:tardev-group/astro-<ชื่อคุณ>.git
cd astro-<ชื่อคุณ>
```

`clone` สร้างโฟลเดอร์ให้เอง ไม่ต้องสร้างรอไว้ก่อน

> **ไม่ต้อง `git switch` อะไรทั้งนั้น** — repo ของคุณมี `main` เป็น branch หลักอยู่แล้ว
> และ `git push` เฉยๆ ใช้ได้ตั้งแต่วินาทีแรก ถ้าเห็นคู่มือเก่าบอกให้สลับไป
> `rebrand-ufayes-cf` แปลว่าอ่านผิดไฟล์

## B5. ติดตั้ง dependencies

```powershell
npm install
```

ครั้งแรกใช้เวลาสักพัก — `sharp` (ตัวย่อรูปของ uploader) ต้องดาวน์โหลด binary ของ Windows มาด้วย

## B6. `wrangler login` — ผูกกับ Cloudflare ⭐ ของใหม่

```powershell
npx wrangler login
```

- ครั้งแรกถามว่าจะติดตั้ง `wrangler` ไหม → ตอบ **y**
- เบราว์เซอร์เปิดหน้า Cloudflare ให้กด **Allow**

เช็ก:

```powershell
npx wrangler whoami
```

ต้องขึ้นอีเมล + ตาราง Account ID **ถ้าขึ้นว่ายังไม่ได้ login ให้ทำซ้ำ**

> - ไม่ต้อง `npm i -g wrangler` — มันอยู่ใน `devDependencies` แล้ว `npx` หยิบตัวในโปรเจกต์ให้เอง
> - เครื่อง dev ที่ไม่ต้อง deploy เอง **ข้ามข้อนี้ได้** ทุกอย่างอื่นทำงานปกติ
>   แค่ปุ่ม "ขึ้นเว็บจริง" กับแถวบัญชีในการ์ด 7 จะใช้ไม่ได้
> - รายละเอียดเรื่องบัญชี/โดเมน/ปัญหาที่เจอจริง อยู่ใน [`DEPLOY-CLOUDFLARE.md`](DEPLOY-CLOUDFLARE.md)

## B7. ตรวจว่าเครื่องพร้อมจริง — อย่าข้าม

4 ข้อนี้ตรงกับ 4 ส่วนของระบบพอดี ทำให้ครบก่อนบอกว่าเสร็จ

**1) เว็บขึ้นไหม**

```powershell
npm run dev
```

เปิด http://localhost:8888 ต้องเห็นเว็บ → `Ctrl+C` ปิด

**2) uploader ขึ้นไหม**

```powershell
npm run rebrand:upload
```

เปิด http://localhost:4000 ต้องเห็นการ์ด 1-7
(หรือดับเบิลคลิก `tools\rebrand-uploader\start-uploader.cmd` ก็ได้ ไม่ต้องเปิด VS Code)

**3) uploader ต่อกับ Claude ได้ไหม** ⭐ ข้อที่ตัดสินว่าติดตั้งสำเร็จหรือไม่

ในหน้า uploader → การ์ด 6 → กดปุ่ม **🧪 ทดสอบท่อ**

ใช้เวลาไม่กี่วินาที ไม่แตะไฟล์อะไร **ถ้าขึ้นเขียว = ครบแล้ว** ถ้าค้างหรือแดง กลับไปดู B2

**4) Cloudflare ต่อได้ไหม** (ข้ามได้ถ้าไม่ deploy จากเครื่องนี้)

ในหน้า uploader → การ์ด 7 → ดูแถว **บัญชี Cloudflare**
ต้องขึ้นอีเมลกับชื่อบัญชี **ถ้าขึ้น "ยังไม่ได้ login" ให้กลับไปทำ B6**

---

# ภาค C — ค่าที่ผูกกับแบรนด์ ต้องถูกก่อนกด "ขึ้นเว็บจริง"

ระบบยิงขึ้นเว็บจริงได้ในปุ่มเดียว **ผิดที่ไหนก็ทับของจริงที่นั่น** สี่จุดนี้ต้องเป็นของแบรนด์นี้

| ไฟล์ | ค่า | ถ้าผิดจะเกิดอะไร |
|---|---|---|
| `wrangler.toml` | `name` | 🚨 **ทับ Worker ของแบรนด์อื่น เว็บนั้นหายทันที** |
| `wrangler.toml` | `account_id` | ไปโผล่ในบัญชีที่ไม่มีใครดูอยู่ |
| `astro.config.mjs` | `site:` | canonical / sitemap / og:image ชี้ผิดโดเมน |
| `src/pages/index.astro` | `webSiteSchema.url` | JSON-LD ชี้ผิดโดเมน |

**ไม่ต้องแก้ `account_id` ด้วยมือ** — กดปุ่ม **🔑 สลับบัญชี** ในการ์ด 7 มันเขียนให้
(ดู [`DEPLOY-CLOUDFLARE.md`](DEPLOY-CLOUDFLARE.md) → "สลับบัญชีเมื่อบัญชีเดิมครบจำนวน")

ส่วนอีกสามจุด Claude แก้ให้ตอนรีแบรนด์ **ถ้าใส่ URL จริงในการ์ด 6**
ถ้าเว้นว่างไว้ มันจะไม่แตะโดเมนเดิมโดยตั้งใจ

**หน้าต่างยืนยันก่อน deploy บอกชื่อ Worker กับบัญชีให้อ่านทุกครั้ง — อ่านก่อนกด**

---

# ภาค D — งานประจำวันหลังจากนี้

```powershell
git switch -c ชื่องานที่จะทำ      # แตก branch ก่อนเสมอ อย่าทำบน main
npm run rebrand:upload            # เปิด uploader
# ...อัปโหลดไฟล์ → กดเริ่ม Rebrand → กดทดสอบหน้าเว็บ → ติ๊ก 5 ข้อ → ขึ้นเว็บจริง...
git status                        # ดูว่าแก้อะไรไป
git add -A
git commit -m "ข้อความ"
git push -u origin ชื่องานที่จะทำ
```

คำสั่ง Git ที่จำเป็นทั้งหมดพร้อมตัวอย่าง อยู่ใน [README หัวข้อ 6.2](README.md)

**เช็กว่ายืนอยู่ branch ไหน:**

```powershell
git branch --show-current
```

---

# ภาค E — ปัญหาบ่อย

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| `claude` ไม่รู้จักคำสั่ง | ยังไม่เปิดหน้าต่างใหม่หลังติดตั้ง | ปิด PowerShell แล้วเปิดใหม่ |
| กด "เริ่ม Rebrand" แล้วค้างเงียบ | ยังไม่ได้ `claude` login | ทำ B2 ให้จบ แล้วกด 🧪 ทดสอบท่อ |
| `npm install` ล้มที่ `sharp` | Node เก่าเกินไป | ลง Node LTS ใหม่ |
| อัปโหลดรูปแล้วขึ้น error เขียนไฟล์ไม่ได้ | `npm run dev` เปิดค้างอยู่ จับไฟล์ไว้ | `Ctrl+C` ปิด dev server ก่อนอัปโหลด |
| ปุ่ม Rebrand เป็นสีจาง กดไม่ได้ | ยังอัปโหลดไม่ครบ | อัปโหลดให้เสร็จ ปุ่มจะสว่างเอง |
| ปุ่ม "ขึ้นเว็บจริง" กดไม่ได้ | ยังไม่ได้ทดสอบหน้าเว็บ / ติ๊กไม่ครบ 5 ข้อ | กดทดสอบหน้าเว็บก่อน แล้วติ๊กให้ครบ |
| `wrangler` บอกว่าไม่ได้ login | ยังไม่ทำ B6 หรือเพิ่งกดสลับบัญชีแล้วยกเลิก | `npx wrangler login` ใหม่ |
| deploy สำเร็จแต่เปิดเว็บไม่ได้ | DNS ค้าง / ยังไม่ผูก Custom Domain | [`DEPLOY-CLOUDFLARE.md`](DEPLOY-CLOUDFLARE.md) ขั้นที่ 0 และปัญหา ⑤ |

---

# สรุปคำสั่งทั้งหมด (เครื่องใหม่ ไล่จากบนลงล่าง)

```powershell
# --- ครั้งเดียวต่อเครื่อง ---
# 1) ลง Node.js LTS + Git จากเว็บ (B1)
# 2) ลง Claude CLI ใน cmd.exe:
#    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd
# 3) เปิดหน้าต่างใหม่ แล้ว login:
claude          # login ให้เสร็จ แล้วพิมพ์ /exit
git config --global user.name "ชื่อจริง"
git config --global user.email "อีเมล GitLab"
ssh -T git@gitlab.com

# --- ตั้ง repo ---
cd $HOME\Desktop
git clone git@gitlab.com:tardev-group/astro-<ชื่อคุณ>.git
cd astro-<ชื่อคุณ>
npm install
npx wrangler login       # ข้ามได้ถ้าไม่ deploy จากเครื่องนี้
npx wrangler whoami

# --- ทดสอบว่าพร้อม (ครบ 4 ข้อ) ---
npm run dev              # 1) เปิด localhost:8888 → Ctrl+C
npm run rebrand:upload   # 2) เปิด localhost:4000
                         # 3) การ์ด 6 → กด 🧪 ทดสอบท่อ → ต้องเขียว
                         # 4) การ์ด 7 → แถวบัญชี Cloudflare ต้องขึ้นอีเมล
```
