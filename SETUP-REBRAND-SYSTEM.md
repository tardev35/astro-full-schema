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
| repo ใหม่ของทีม | `gitlab.com/tardev-group/<ชื่อ-repo-ใหม่>` |
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

# ภาค A — สร้าง repo ใหม่แล้วยกโค้ดขึ้น (ทำครั้งเดียว โดยคนที่ถือ repo)

ข้ามภาคนี้ไปเลยถ้ามีคนทำให้แล้ว — dev ที่มารับเครื่องเริ่มที่ **ภาค B**

### A1. สร้าง project เปล่าใน GitLab

GitLab → **New project** → **Create blank project**

| ช่อง | ค่า |
|---|---|
| Project name | ชื่อที่ทีมเข้าใจ เช่น `astro-rebrand-system` |
| Project URL | เลือก group `tardev-group` |
| Visibility | **Private** |
| Initialize repository with a README | **ไม่ต้องติ๊ก** ⚠️ ติ๊กแล้วจะชนกับโค้ดที่กำลังจะ push |

> ถ้า group จริงชื่อ `tar-group` ไม่ใช่ `tardev-group` ให้เปลี่ยนตามของจริง
> — เช็กชื่อที่ถูกได้จาก `git remote -v` ในเครื่องที่มีโค้ดอยู่แล้ว

### A2. ยก `rebrand-ufayes-cf` ขึ้นเป็น `main` ของ repo ใหม่

ทำจาก**โฟลเดอร์ต้นแบบ** — โฟลเดอร์ที่มีโค้ด `astro-full-schema` อยู่ในเครื่องคุณ

**ยังไม่มีโฟลเดอร์นั้นเลย?** ดึงลงมาก่อนด้วย `git clone` — **มันสร้างโฟลเดอร์ให้เอง
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

**จากนั้นยกขึ้น repo ใหม่ — 2 คำสั่ง:**

```powershell
# 1) ตั้งชื่อเล่นให้ repo ใหม่ (ชื่ออะไรก็ได้ อยู่แค่ในเครื่องคุณ GitLab ไม่รู้จัก)
git remote add newrepo git@gitlab.com:tardev-group/<ชื่อ-repo-ใหม่>.git

# 2) ส่งขึ้นไปโดยใช้ชื่อ main บนนั้น
git push newrepo rebrand-ufayes-cf:main
```

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

> **ทำไมเปลี่ยนชื่อเป็น `main`** — ใน repo ใหม่ โค้ดชุดนี้*คือ*ตัวหลัก ไม่ใช่ branch ทดลอง
> การคง `rebrand-ufayes-cf` ไว้เป็นแกนจะทำให้คนใหม่เข้าใจผิดว่านี่คืองานของแบรนด์ UFAYES
> — ทั้งที่มันคือระบบกลาง

### A2.1 อัปเดต repo ของทีมรอบถัดไป

เวลามีของใหม่ในต้นแบบ ยิงคำสั่งเดิมซ้ำได้เลย ไม่ต้องตั้ง remote ใหม่:

```powershell
git push newrepo rebrand-ufayes-cf:main
```

**กติกาข้อเดียวที่ทำให้คำสั่งนี้ปลอดภัยตลอด:**

> `main` ของทุก repo ปลายทางคือ**กระจกเงาของต้นแบบ ห้ามใครคอมมิตลงไปตรงๆ**
> ทุกคนต้องแตก branch ของตัวเองเสมอ

ถ้ามีคนเผลอคอมมิตลง `main` จริง คำสั่งข้างบนจะ**ถูกปฏิเสธ ไม่ทับงานเขา** — นั่นคือ
branch protection ทำหน้าที่ถูกแล้ว **อย่าแก้ด้วย `--force`** ให้ไปคุยกับเจ้าตัวก่อน

### A3. เชิญทีมเข้า project

**Project → Manage → Members → Invite members**
ให้สิทธิ์ **Developer** (พอสำหรับ push branch ของตัวเอง แต่แตะ `main` ไม่ได้ถ้าตั้ง protect ไว้)

---

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

```powershell
cd C:\Users\<ชื่อผู้ใช้>\Desktop
git clone git@gitlab.com:tardev-group/<ชื่อ-repo-ใหม่>.git
cd <ชื่อ-repo-ใหม่>
```

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
cd C:\Users\<ชื่อผู้ใช้>\Desktop
git clone git@gitlab.com:tardev-group/<ชื่อ-repo-ใหม่>.git
cd <ชื่อ-repo-ใหม่>
npm install
npx wrangler login       # ข้ามได้ถ้าไม่ deploy จากเครื่องนี้
npx wrangler whoami

# --- ทดสอบว่าพร้อม (ครบ 4 ข้อ) ---
npm run dev              # 1) เปิด localhost:8888 → Ctrl+C
npm run rebrand:upload   # 2) เปิด localhost:4000
                         # 3) การ์ด 6 → กด 🧪 ทดสอบท่อ → ต้องเขียว
                         # 4) การ์ด 7 → แถวบัญชี Cloudflare ต้องขึ้นอีเมล
```
