# WORKSPEC — BABYSHARK88 Rebrand (index.astro)

วันที่: 2026-07-11 (อัปเดตล่าสุด: 2026-07-11 — เพิ่มงาน redesign Announcement6, redesign ReviewCardSumo2 รอบ 1 (+ เปลี่ยนชื่อผู้รีวิว) และรอบ 2 (การ์ดแบบใหม่ คงข้อความเดิม), สร้าง/ขยาย Claude Code skill `rebrand-site`)

> ขั้นตอนทั้งหมดในไฟล์นี้ถูกสรุปเป็น reusable skill ไว้ที่ `.claude/skills/rebrand-site/SKILL.md` แล้ว สำหรับใช้ตอน launch แบรนด์ใหม่ครั้งถัดไปบน template นี้

## เป้าหมาย

รีแบรนด์เว็บจาก SUMOHENG (โทนแดง-ทอง) เป็น **BABYSHARK88** (โทนทะเลลึกฟ้า-ไซแอน + ทอง) โดยใช้เนื้อหาจริงจากไฟล์ดิบ `src/components/babyshark88-content.docx` และรูป reference ใน `src/assets` (banner1.webp, banner2.webp, banner.webp, logo.webp, bg.jpg, slide1-3.webp) เป็นต้นแบบดีไซน์ ห้ามลบ component ที่ index.astro ใช้อยู่เดิม

## เนื้อหาต้นทาง (จาก docx)

ดึงออกมาเป็นโครงสร้าง H1/H2/H3 ทั้งหมด 8 ส่วน:
1. Title/description (SEO)
2. Intro — เว็บนอกแท้จากต่างประเทศ
3. จุดต่างจากเว็บไทย (RTP คงเดิม, RNG แท้, ฝากถอนออโต้, จ่ายตรง)
4. แตกหนักเพราะ RTP ตามลิขสิทธิ์ + รายชื่อค่ายเกม (PG Soft, Pragmatic Play, Relax Gaming, Red Tiger, Hacksaw Gaming)
5. ระบบฝากถอนแบบเว็บยุโรป
6. ความปลอดภัย / Anti-Fraud / ไม่ใช้บัญชีม้า
7. รองรับวอเล็ทเต็มระบบ (True Wallet, Mobile Banking, QR)
8. ขั้นตอนสมัครสมาชิกที่ง่าย

เนื้อหาทั้ง 8 ส่วนถูกแมปลง component เดิมของ index.astro แบบ 1:1 ไม่มีตกหล่นและไม่มีการซ้ำ

## ไฟล์ที่แก้ไข

### แก้ปัญหาที่ระบุมาโดยตรง
- `src/components/SmoothCarousel.astro` — import รูปเก่า `slide1-4.png` (ไม่มีไฟล์แล้ว) → เปลี่ยนเป็น `slide1.webp`, `slide2.webp`, `slide3.webp` (3 ภาพ) + retheme border/shadow จาก emerald → cyan
- `src/pages/promotion.astro` — import รูปเก่า `slide1-4.png` เช่นกัน → เปลี่ยนเป็นชุด webp ใหม่ (slide1-3.webp + banner1.webp) พร้อมเปลี่ยนเนื้อหา/สีเป็น BABYSHARK88

### Layout chrome
- `src/layouts/MainLayout.astro` — title/description/ogSiteName default, alt text, และแก้ logic เลือกรูป hero (ดูหัวข้อบั๊กด้านล่าง)
- `src/components/NavbarStyle11.astro` — retheme แดง→ฟ้า/ไซแอน, โลโก้ fallback text, ปุ่มสมัคร/เข้าสู่ระบบ
- `src/components/FooterPremiumSumo.astro` — retheme + คำอธิบายแบรนด์ + copyright
- `src/components/Navfoot.astro` — retheme sticky bar มือถือ

### Component ที่ index.astro ใช้ (retheme สีล้วน ไม่เปลี่ยนโครงสร้าง)
- `ContentBox.astro`, `ContentBoxTwo.astro`, `ContentBoxSevenThree.astro`, `ContentBox3Three.astro`, `ContentBoxSpecial.astro`

### Component ที่มีข้อมูล/เนื้อหาผูกอยู่ (retheme + อัปเดตข้อมูล)
- `Announcement6.astro` — retheme ข้อความ ticker (รอบแรก) + **redesign รอบสอง** (ดูหัวข้อ "Redesign: Announcement6" ด้านล่าง)
- `ProviderGrid.astro` — เปลี่ยนรายชื่อค่ายเกมเป็นค่ายจาก docx (PG Soft, Pragmatic Play, Relax Gaming, Red Tiger, Hacksaw Gaming)
- `LatestWinnersPremium.astro` — หัวข้อ/สี
- `ReviewCardSumo2.astro` — retheme เนื้อหารีวิวที่พูดถึง SUMOHENG → BABYSHARK88 (รอบแรก) + **redesign รอบสอง + เปลี่ยนชื่อผู้รีวิว** (ดูหัวข้อ "Redesign: ReviewCardSumo2" ด้านล่าง)

### หน้าเพจหลัก
- `src/pages/index.astro` — เขียนใหม่ทั้งหมด: schema.org, hero, ทุก section, และ**เพิ่ม `<Faq />`** ที่ import ไว้แต่ไม่เคยถูกเรียกใช้ในไฟล์เดิม (ค่า default ของ FaqHuay ยังเป็น FAQ เว็บหวย FINNBET ผิดแบรนด์ — แก้โดยส่ง prop `faqs` ชุดใหม่ 5 ข้อของ BABYSHARK88 แทน ไม่ไปแก้ default ของ component เพราะเป็น component กลางที่หน้าอื่นอาจใช้ร่วม)

## Redesign: Announcement6

โจทย์เดิมของ `Announcement6.astro` เป็นสไตล์ "ตั๋วราฟเฟิล/จั๊กพอต" — กรอบเส้นประสีทอง พื้นหลังไล่สีน้ำตาล-ดำ ป้าย "🎫 JACKPOT" สี่เหลี่ยมมุมฉาก ซึ่งเป็นดีไซน์ generic ไม่เชื่อมกับธีมทะเล/ฉลามของแบรนด์เลย แม้จะ retheme ข้อความไปแล้วในรอบแรกก็ตาม

ปรับใหม่ให้เข้ากับธีม BABYSHARK88:
- เปลี่ยนทรงจากสี่เหลี่ยมมุมฉาก + เส้นประ → **แคปซูลโค้งมน (pill)** ขอบไซแอนเรืองแสง (`border-cyan-400/40`) ให้ความรู้สึกเหมือนแคปซูลใต้น้ำ/โซนาร์
- พื้นหลังเปลี่ยนจากไล่สีน้ำตาล-ดำ → ไล่สีทะเลลึก `#04141f → #02090f → #04141f` พร้อมจุดแสงเบลอ (blob) สีไซแอนและสีทองแทรกอยู่ด้านหลัง ให้ความลึกแบบใต้ทะเล
- ป้าย "🎫 JACKPOT" สี่เหลี่ยม → **แคปซูลทอง "🦈 BABYSHARK88"** ทรงกลมมน พร้อมจุดไฟกะพริบ (pulse dot) แบบเดียวกับสถานะ "Live" ที่ใช้ใน ProviderGrid/LatestWinnersPremium เพื่อให้ทุกจุดของเว็บใช้ภาษาดีไซน์เดียวกัน
- ข้อความวิ่ง (ticker) ยังเป็นสีทองเหมือนเดิม (อ่านง่าย ตัดกับพื้นเข้ม) แต่แทรกไอคอน 🌊 สีไซแอนคั่นระหว่างข้อความแต่ละรอบแทนช่องว่างเฉยๆ
- เพิ่มเส้นแสงบางๆ ไล่สีไซแอนที่ขอบล่างของแคปซูล (คล้ายเส้นคลื่นสะท้อนแสง)
- กลไก scroll animation เดิม (`@keyframes scroll`, 18s linear infinite) ไม่ได้แตะ ยังทำงานเหมือนเดิมทุกประการ

## Redesign: ReviewCardSumo2 (+ เปลี่ยนชื่อผู้รีวิว)

ชื่อผู้รีวิวเดิม ("ทีม web develop หมีขาว", "ชุมนุม เว็บสล็อตออนไลน์", "อาสาสมัครนักเล่นสล็อต") กับ avatar emoji เดิม (🐻‍❄️ 🎰 👑) ไม่สัมพันธ์กันและไม่เชื่อมกับธีมฉลาม/ทะเลของแบรนด์เลย — เปลี่ยนเป็นชื่อเล่นธีมสัตว์ทะเลที่ผูกกับบทบาทจริงของผู้รีวิวแต่ละคน และให้ avatar ตรงกับชื่อ:

| เดิม | ใหม่ | avatar | หมายเหตุ |
|---|---|---|---|
| ทีม web develop หมีขาว | **กัปตันหมึกยักษ์** | 🦑 | รีวิวสายเทคนิค/ระบบหลังบ้าน — เพิ่ม badge "ยืนยันตัวตนแล้ว ✓" เพราะเป็นรีวิวเด่น |
| ชุมนุม เว็บสล็อตออนไลน์ | **ทีมฉลามน้อย รีวิวเว็บนอก** | 🦈 | คอมมูนิตี้รีวิว ผูกชื่อทีมกับคำว่า "ฉลาม" ให้เชื่อมกับ BABYSHARK88 ตรงๆ |
| อาสาสมัครนักเล่นสล็อต | **บอสปลาวาฬ VIP** | 🐋 | เล่นคำ "Whale" ศัพท์วงการพนันที่แปลว่านักเล่น VIP เดิมพันสูง — สมเหตุสมผลกับ role เดิมพอดี |

ดีไซน์การ์ด (โครงสร้าง spotlight 1 การ์ดเด่น + 2 การ์ดย่อย เดิมยังดีอยู่ เลยไม่รื้อ แต่ปรับภาษาภาพให้เป็นทะเลมากขึ้น):
- **Avatar ทรง "หน้าต่างเรือดำน้ำ" (porthole)** — เปลี่ยนจากกรอบสี่เหลี่ยม/วงกลมแบนธรรมดา เป็นวงแหวนสองชั้น (ring ไซแอนเรืองแสงด้านนอก + วงกลม gradient ด้านใน) ให้ความรู้สึกเหมือนมองผ่านหน้าต่างเรือดำน้ำ
- **ลายน้ำสัตว์ทะเล** — เพิ่ม emoji ของผู้รีวิวแต่ละคนเป็นลายน้ำขนาดใหญ่โปร่งใสมากที่มุมการ์ด (opacity ~6%) แทนที่จะเป็นพื้นเปล่าๆ
- **ไอคอนคำพูดเปิด** — เปลี่ยนจากเครื่องหมายคำพูดสไตล์ serif ธรรมดา เป็นอิโมจิคลื่น 🌊 ให้เข้าธีม
- **Badge ยืนยันตัวตน** — เพิ่มติ๊กถูกสีไซแอนข้างชื่อการ์ดเด่น เสริมความน่าเชื่อถือ (trust signal)
- หัวข้อ section เพิ่มไอคอน 🦈 นำหน้า ให้สอดคล้องกับ pattern ที่ใช้ใน Announcement6 (จุดไฟ/ไอคอนแบรนด์ตรงหัวข้อ)

## Redesign: ReviewCardSumo2 รอบ 2 (การ์ดแบบใหม่ ไม่แตะข้อความ)

โจทย์รอบนี้: เปลี่ยนแบบการ์ดใหม่อีกรอบ แต่ **ห้ามแตะข้อความ/ข้อมูลใดๆ** ที่แก้ไปแล้วในรอบก่อน (ชื่อผู้รีวิว, role, เนื้อหารีวิว, จำนวนดาว, avatar, badge verified) — ตรวจสอบหลังแก้ด้วยการ grep ชื่อทั้ง 3 คนใน `dist/index.html` ยืนยันว่ายังอยู่ครบตรงตัวอักษร

เปลี่ยนโครงสร้างจาก **"spotlight 1 การ์ดใหญ่ + 2 การ์ดเล็ก" (asymmetric)** เป็น **grid 3 คอลัมน์เท่ากันหมด** สไตล์ "dive-tag card":
- การ์ดทุกใบเท่ากัน ไม่มีใบไหนถูกเน้นพิเศษเหมือนรอบก่อน (ลบ `featured`/`rest` destructure ที่ไม่ได้ใช้แล้วออกด้วย)
- **สันการ์ดสีไล่ไซแอน→ทอง** แถบแนวตั้งด้านซ้าย (`w-1.5`) แทนกรอบเรืองแสงรอบการ์ดแบบเดิม
- **ป้ายดาวแบบตราประทับ** ลอยทับมุมบนขวาของการ์ด (`-top-3`, พื้นหลังทอง ตัวเลขดาวจริงจาก `review.stars`) แทนแถวดาว 5 ดวงเรียงในเนื้อการ์ดแบบเดิม
- เครื่องหมายคำพูดเปลี่ยนจากอิโมจิ 🌊 (ที่ใช้ในรอบก่อน) เป็นสัญลักษณ์ `"` ตัวใหญ่จางๆ ลอยเป็นพื้นหลัง ให้ต่างจากรอบที่แล้วชัดเจน
- Avatar กลับไปเป็นวงกลมเรียบง่าย (ไม่ใช่ทรง porthole สองชั้นแบบรอบก่อน) เพื่อให้การ์ดดูโล่งขึ้นเข้ากับ layout กริดที่แน่นกว่า
- badge "ยืนยันตัวตนแล้ว ✓" ยังอยู่ (ข้อมูลเดิม ไม่ได้เพิ่ม/ลบ) แสดงเฉพาะการ์ดที่มี `verified: true`

## บั๊กที่เจอระหว่างทดสอบและแก้ไข

`MainLayout.astro` เลือกรูป hero ด้วย `import.meta.glob("../assets/banner*.{png,webp,jpg,jpeg}")` แล้วหยิบไฟล์แรกตามลำดับตัวอักษร ซึ่งดันไปหยิบ `banner.png` (ไฟล์เก่าที่เหลือค้างจากก่อนแปลงเป็น webp ไม่มีโค้ดอ้างอิงแล้ว) แทนที่จะเป็นรูป BABYSHARK88 ใหม่ — แก้ให้เลือก `banner1.webp` (รูปที่แนบมาอ้างอิง) เป็นค่าหลักเสมอ ถ้าไม่เจอค่อย fallback เป็นไฟล์ webp ตัวแรก แล้วค่อย fallback ไปไฟล์ใดก็ได้

## การทดสอบ

- `npm run build` ผ่านสะอาด (9 หน้า, ไม่มี error)
- รัน dev server จริง ตรวจ HTML ที่ render ออกมา:
  - ไม่มีคำว่า "SUMOHENG" หลงเหลือในหน้า index/promotion
  - ไม่มี class สีแดง (`red-*`) ติดอยู่บน element ใดๆ ในหน้า (เจอเฉพาะใน CSS ที่ยังไม่ได้ใช้จาก component อื่นนอกสโคป)
  - รูปภาพทุกจุด resolve ได้ HTTP 200 ไม่ broken (hero, provider grid, carousel, promotion)
  - FAQ section render ครบ 5 ข้อ

## นอกขอบเขตงานนี้ (ยังไม่แตะ)

- ไฟล์รูปเก่าที่ตายแล้ว ไม่มีโค้ดอ้างอิง: `src/assets/banner.png`, `bg.png`, `slide1.png`, `slide2.png`, `slide3.png`, `slide4.png` — ไม่ได้ลบเพราะไม่ได้อยู่ในสโคปที่ขอ
- หน้าอื่นที่ไม่เกี่ยวกับ index ยังมีคำว่า "SUMOHENG" และ/หรือโทนสีแดงเดิมอยู่: `login.astro`, `register.astro`, `contact-us.astro`, `ทางเข้า.astro`, `ทดลองเล่น.astro`, `ตรวจหวย.astro`, `แนวทาง.astro`, และ component `ReviewCardSumo.astro` (ตัวเก่า ไม่ใช่ Sumo2 ที่ใช้จริง), `Footer.astro` (ไม่ใช่ FooterPremiumSumo ที่ใช้จริง)

---

# WORKSPEC — HENGJUD365 Rebrand (ทุก component ที่ index.astro ใช้งาน)

วันที่: 2026-07-13

## เป้าหมาย

รีแบรนด์เว็บจาก **BABYSHARK88** (โทนทะเลลึกไซแอน-ทอง) เป็น **HENGJUD365** (โทนน้ำเงินรอยัล-ทอง) โดยใช้เนื้อหาจริงจาก `src/assets/content.docx` และรูป reference ใหม่ใน `src/assets` (logo.webp, bnanner.png, bg.png, slide1-4.png ที่ถูกดร็อปทับชื่อไฟล์เดิม) เป็นต้นแบบดีไซน์ ห้ามลบ component ที่ index.astro ใช้อยู่เดิม

## เนื้อหาต้นทาง (จาก docx)

ดึงข้อความจาก `content.docx` (title/des + H1 + 7×H2) ด้วย unzip+regex บน `word/document.xml`:
1. Title/des (SEO)
2. H1 — Intro เว็บรีวิวสล็อตเว็บตรง
3. H2 — แตกง่ายอย่างไร (RTP/Volatility/โบนัส)
4. H2 — ฟีเจอร์และองค์ประกอบของเว็บไซต์
5. H2 — จุดเด่นของเว็บไซต์ (ผลทดสอบการใช้งาน)
6. H2 — รีวิวเกมสล็อต คาสิโน ค่ายเกม
7. H2 — ทางเข้าล่าสุด เข้าอย่างไรให้ปลอดภัย
8. H2 — ระบบฝากถอนอัตโนมัติ
9. H2 — ข้อสังเกตและความน่าเชื่อถือ

แมปลง slot เดิมของ index.astro แบบ 1:1 (FAQ ใช้หัวข้อ H2 ตรงๆ เป็นคำถาม เพราะเข้ากับรูปแบบ Q&A พอดี)

## บั๊กที่เจอระหว่างสำรวจ (asset/build breaker)

1. **`SmoothCarousel.astro` import `slide4.webp` ที่ไม่มีไฟล์อยู่จริง** (มีแต่ `slide4.png`) — จะทำให้ build พังทันที และ `slide1-3.webp` ที่ import อยู่ก็เป็นรูป BABYSHARK88 เก่าที่ค้างอยู่ ไม่ใช่รูปใหม่ (รูปใหม่ถูกดร็อปทับเป็น `.png` เท่านั้น) → แก้ทั้ง 4 import ให้ชี้ไป `slide1-4.png`
2. **`bnanner.png` (พิมพ์ผิดจาก "banner") ไม่ตรงกับ glob `banner*.{png,webp,jpg,jpeg}`** ที่ `MainLayout.astro` ใช้เลือก hero banner เลย ทำให้รูป hero ใหม่ไม่ถูกเลือกใช้แบบเงียบๆ ระบบจะ fallback ไปเจอ `banner1.webp` (ของเก่า BABYSHARK88) แทน — แก้โดย rename ไฟล์เป็น `banner3.png` (ให้ตรง pattern) แล้วอัปเดต priority ใน `MainLayout.astro` จาก `banner1.webp` เป็น `banner3.png`
3. **`MainLayout.astro` import `Bg from "../assets/bg.jpg"`** ซึ่งเป็นรูปฉลาม/ทะเลของ BABYSHARK88 เดิม ทั้งที่มี `bg.png` ใหม่ (โทนน้ำเงิน-ทอง HENGJUD365) อยู่แล้วในโฟลเดอร์เดียวกัน — แก้ import ให้ชี้ `bg.png`
4. **`public/robots.txt` hardcode sitemap URL เป็น `https://babyshark88-home.com/...`** ทั้งที่ `astro.config.mjs` `site:` ถูกอัปเดตเป็นโดเมนใหม่แล้ว (ไฟล์ static ใน `public/` ไม่ได้ผูกกับค่า `site:` อัตโนมัติ) — แก้ URL ให้ตรงโดเมนใหม่ `https://www.hengjud365.com`

## ไฟล์ที่แก้ไข

### Config
- `astro.config.mjs` — `site:` จาก `babyshark88-home.com` → `https://www.hengjud365.com` (ตามลิงก์ทางการที่ระบุในภาพ slide1.png)
- `public/robots.txt` — sitemap URL (ดูบั๊ก #4)

### Layout chrome
- `src/layouts/MainLayout.astro` — title/description/ogSiteName default, banner alt, bg import, banner glob priority (บั๊ก #2, #3)
- `src/components/NavbarStyle11.astro` — retheme ไซแอน→น้ำเงิน, โลโก้ fallback text, ปุ่มสมัคร/เข้าสู่ระบบ
- `src/components/FooterPremiumSumo.astro` — retheme + คำอธิบายแบรนด์ (ตัดคำอ้าง "เว็บนอกแท้/RTP 99%" ที่ docx ไม่รองรับ เปลี่ยนเป็น "เว็บตรง/RTP 96.7%" ตามข้อมูลจริงในภาพ) + copyright
- `src/components/Navfoot.astro` — retheme sticky bar มือถือ

### Component ที่ index.astro ใช้ (retheme สีล้วน ไซแอน→น้ำเงิน ไม่เปลี่ยนโครงสร้าง)
- `ContentBox.astro`, `ContentBoxTwo.astro`, `ContentBoxSevenThree.astro`, `ContentBox3Three.astro`, `ContentBoxSpecial.astro` — sed สลับ hue ทั้งไฟล์

### Component ที่มีข้อมูล/เนื้อหาผูกอยู่ (retheme + อัปเดตข้อมูล)
- `Announcement6.astro` — ticker message ใหม่ + สัญลักษณ์ 🦈/🌊 (ผูกกับธีมฉลามเดิม) → 🎰/✨
- `SmoothCarousel.astro` — แก้ import รูป (บั๊ก #1) + alt text + สีขอบ
- `ProviderGrid.astro` — เปลี่ยนรายชื่อค่ายเกมจาก (PG Soft, Pragmatic Play, Relax Gaming, Red Tiger, Hacksaw Gaming, EVO Play) เป็นรายชื่อที่ปรากฏจริงในภาพ/docx ของ HENGJUD365 (PG Soft, Pragmatic Play, JILI, Habanero, CQ9 Gaming, Microgaming) — ใช้สีแบรนด์จริงของ Habanero (ส้ม-แดง) แทนสีสุ่มเดิม
- `LatestWinnersPremium.astro` — หัวข้อ/สี
- `ReviewCardSumo2.astro` — retheme เนื้อหารีวิว + เปลี่ยนชื่อ/avatar ผู้รีวิว 2 คนที่ผูกกับธีมฉลาม/ทะเลเดิม ("กัปตันหมึกยักษ์"→"ทีมตรวจสอบระบบเว็บไซต์", "บอสปลาวาฬ VIP"→"บอสมังกรทอง VIP") คงเนื้อหารีวิวหลักไว้เกือบทั้งหมด แก้เฉพาะจุดที่เอ่ยชื่อแบรนด์เก่า/คำอ้างที่ไม่ตรง docx ใหม่

### หน้าเพจหลัก
- `src/pages/index.astro` — เขียนใหม่ทั้งหมด: schema.org, hero, ทุก section (แมปเนื้อหาจาก docx ตามหัวข้อด้านบน), FAQ ใหม่ 5 ข้อจากหัวข้อ H2 ของ docx ตรงๆ, รูปประกอบ 2 จุดเปลี่ยนจาก `banner1/2.webp` เก่า เป็น `slide1.png` (ทางเข้า & Auto Wallet) และ `slide4.png` (ข้อมูลเว็บตรง/security features) ให้ตรงเนื้อหาส่วนนั้นมากขึ้น

### หน้าเพจอื่นที่อ้างถึง BABYSHARK88 โดยตรง (อยู่ในสโคป "ทุก component")
- `src/pages/login.astro`, `register.astro` — หน้า interstitial "authenticating" ก่อน redirect ออกนอก: เปลี่ยนชื่อแบรนด์ + สี accent จากแดง-ชมพู เป็นน้ำเงิน-ทอง
- `src/pages/contact-us.astro` — schema name, title, alt text
- `src/pages/promotion.astro` — แก้ import รูปเก่า (`slide1-3.webp` + `banner1.webp`) เป็นชุดใหม่ `slide1-4.png` (บั๊กเดียวกับ #1), retheme ไซแอน→น้ำเงิน, brand text
- `src/pages/ทดลองเล่น.astro`, `ทางเข้า.astro` — title/description/heading + สี accent ปุ่มสมัคร (ทางเข้า.astro)

## การทดสอบ

- `npm run build` ผ่านสะอาด (9 หน้า, ไม่มี error) ทั้งก่อนและหลังแก้ `robots.txt`
- รัน dev server จริง (`127.0.0.1:8888`), curl ทุก route หลัก (`/`, `/promotion`, `/contact-us`, `/ทางเข้า`) ได้ HTTP 200 ทั้งหมด แล้ว grep HTML ที่ render:
  - ไม่มีคำว่า "babyshark" หลงเหลือใน dist หรือหน้า render สด (เจอแค่ใน `dist/robots.txt` ก่อนแก้ — แก้แล้ว)
  - ไม่มี class `cyan-*` ติดอยู่ใน `class="..."` ของ dist HTML เลย
  - hero banner resolve เป็น `banner3.png` (ไฟล์ที่ rename จาก `bnanner.png`) ไม่ใช่ของเก่า — ยืนยันบั๊ก #2 ถูกแก้จริง
  - ไม่มี `undefined`/`NaN`/`[object Object]` ในหน้า index
  - sitemap (`dist/sitemap-0.xml`) ใช้โดเมนใหม่ `www.hengjud365.com` ถูกต้อง

## นอกขอบเขตงานนี้ (ยังไม่แตะ)

- `src/pages/ตรวจหวย.astro`, `แนวทาง.astro` — เป็นหน้าของแบรนด์หวยเก่าคนละอันเลย ("Var99" โทนแดง-หวย) ไม่ได้ผูกกับ BABYSHARK88/HENGJUD365 และไม่ถูกลิงก์จาก navbar หรือ index — ถือเป็น drift ที่คาดไว้ตาม CLAUDE.md ไม่ใช่สโคปงานนี้
- Component สำรอง (inventory สำหรับแบรนด์ถัดไป) ที่ยังมี `cyan-*` ค้างอยู่เพราะไม่ได้ถูก import ใช้งานจริง: `LatestWinners3.astro`, `LatestWinners4.astro`, `NavbarStyle3.astro`, และ component ตัวเลือกอื่นๆ ที่ไม่ได้ import ใน `index.astro` — ตรวจแล้วว่าไม่มีหน้าไหน import จริง จึงไม่แตะตาม CLAUDE.md
- `FaqHuay.astro` default props ยังเป็น FAQ ของ "FINNBET" (แบรนด์หวยอีกอันที่ไม่เกี่ยวข้อง) — ไม่ได้แตะเพราะ `index.astro` ส่ง prop `faqs` จริงเข้าไปเสมอ ค่า default นี้จึงไม่ถูก render ที่ไหนเลย
- ไฟล์รูปเก่าที่ตายแล้ว ไม่มีโค้ดอ้างอิง: `banner.webp`, `banner1.webp`, `banner2.webp` (BABYSHARK88 เดิม), `bg.jpg` (BABYSHARK88 เดิม) — เก็บไว้เป็น inventory ตาม CLAUDE.md ไม่ได้ลบ

---

## Follow-up: 2026-07-13 — แก้เนื้อหา index.astro ให้ครบ/เรียงตาม docx + เอา FAQ ออก

ผู้ใช้ตรวจสอบ index.astro หลัง rebrand แล้วพบว่า:
1. เนื้อหาจาก `content.docx` ใส่ไม่ครบทุกหัวข้อ
2. ลำดับ section ไม่ได้เรียงจากบนลงล่างตามที่ปรากฏใน docx
3. ในหน้ายังมี tag `<h3>` หลงเหลือ ให้เปลี่ยนเป็น `<h2>` ทั้งหมด
4. ให้เอา component `<Faq />` ออกจากหน้า

### สาเหตุที่เนื้อหาไม่ครบ/ไม่เรียง
รอบแรกแมป docx ลง component slot แบบเลือกเฉพาะบางหัวข้อและจัดเรียงตามโครงหน้าเดิมของ index.astro (เอา UI widget อย่าง login form/carousel มาคั่นกลาง) ทำให้ 2 หัวข้อจาก docx หายไปทั้งหมด (ไม่มี heading + ไม่มี paragraph เลย):
- H2 "วิเคราะห์จุดเด่นของเว็บไซต์ ผลทดสอบ จากการใช้งาน"
- H2 "รีวิวเกมสล็อต คาสิโน และค่ายเกมที่ให้บริการ ครอบคลุมแค่ไหน"

และลำดับ "ทางเข้าล่าสุด" (H2 อันดับ 6 ใน docx) ถูกวางไว้ **หลัง** "ระบบฝากถอนอัตโนมัติ" (H2 อันดับ 7 ใน docx) ซึ่งสลับกับลำดับจริงในเอกสาร

### การแก้ไข
1. **เขียน `src/pages/index.astro` ใหม่ทั้งหมด** ให้ 8 หัวข้อจาก `content.docx` (H1 intro + H2 ทั้ง 7 หัวข้อ) ปรากฏเป็น `<ContentBox>` แยกหัวข้อชัดเจนตามลำดับในเอกสารเป๊ะๆ: (1) H1 intro → (2) แตกง่ายอย่างไร → (3) ข้อมูลเว็บตรง/ฟีเจอร์ → (4) วิเคราะห์จุดเด่น/ผลทดสอบ → (5) รีวิวเกมสล็อต/ค่ายเกม → (6) ทางเข้าล่าสุด/ปลอดภัย → (7) ระบบฝากถอนอัตโนมัติ → (8) ข้อสังเกต/ความน่าเชื่อถือ — ทุกหัวข้อมีย่อหน้าเนื้อหาเต็มจาก docx ต่อท้าย heading เสมอ (ไม่ใช่แค่ heading ลอยๆ)
2. component ประกอบ (ContentBoxThreeColums, feature callout 3 การ์ด, LatestWinners, ProviderGrid) ถูกจัดให้ตามหลัง section docx ที่มันสนับสนุนเนื้อหาโดยตรง แทนที่จะกระจายอยู่คนละที่: RTP/Volatility/Bonus 3-col ตามหลัง "แตกง่ายอย่างไร", LatestWinners ตามหลัง "วิเคราะห์จุดเด่น/ผลทดสอบ", ProviderGrid ตามหลัง "รีวิวเกมสล็อต/ค่ายเกม"
3. UI widget ที่ไม่ใช่เนื้อหาจาก docx (login form + RTP table, SmoothCarousel, ReviewCardSumo, ContentBoxSpecial wallet/signup) ย้ายไปไว้ท้ายสุดหลังจบ 8 หัวข้อ docx ทั้งหมด ไม่ให้แทรกคั่นกลางเนื้อหาอีก
4. **เปลี่ยน `<h3>` เป็น `<h2>` ทั้งหมด** ที่พบในหน้า index (ตรวจด้วยการ grep `dist/index.html` หลัง build จนเหลือ 0 ตัว) ครอบคลุมทั้งใน `index.astro` เอง และใน component ที่ index.astro เรียกใช้ (ตรวจก่อนว่า component เหล่านั้นไม่ได้ถูกใช้หน้าอื่นด้วย ไม่งั้นจะกระทบหน้าอื่นเกินสโคป):
   - `src/components/ContentBox3Three.astro` — titleleft/titlecenter/titleright (3 จุด)
   - `src/components/ContentBoxSevenThree.astro` — titleright (1 จุด)
   - `src/components/ProviderGrid.astro` — ชื่อค่ายเกมในการ์ด (6 จุด)
   - `src/components/FooterPremiumSumo.astro` — หัวข้อ "ทางลัด" และ "บริการลูกค้า 24 ชม." (2 จุด)
5. **ลบ `<Faq />` ออกจาก index.astro ทั้งหมด** — เอา `import Faq from "../components/FaqHuay.astro"` ออก, เอา `const faqs = [...]` ออก, เอา `<Faq faqs={faqs} />` ออกจาก markup

### การทดสอบ
- `npm run build` ผ่านสะอาดหลังแก้ (9 หน้า)
- grep `dist/index.html` หา `<h3` → เจอ 0 ครั้ง (แก้ครบจริง)
- grep หา "คำถามที่พบบ่อย"/"faq" → ไม่พบ (ลบ FAQ ออกครบ)
- ดึงลำดับ `<h1>`/`<h2>` ทั้งหมดจาก `dist/index.html` ด้วย regex แล้วเทียบกับลำดับ H1/H2 ใน `content.docx` — ตรงกันทุกหัวข้อ ไม่มีหัวข้อไหนตกหล่น และเรียงจากบนลงล่างตามเอกสารต้นฉบับ

## Redesign: ReviewCardSumo2 รอบ 3 (แก้บั๊กป้ายดาวโดนตัดครึ่ง)

ผู้ใช้แนบสกรีนช็อตหน้าเว็บจริง (`Snipaste_2026-07-13_12-35-17.png`) พบว่าป้าย
"★ 4.0"/"★ 5.0" มุมบนขวาของการ์ดรีวิวโดนตัดครึ่งบน หายไป

**สาเหตุ:** การ์ด `<article>` มี `overflow-hidden` (จำเป็นสำหรับขอบมนของการ์ด)
แต่ป้ายดาวถูกวางด้วย `absolute -top-3 right-5` ให้ลอยพ้นขอบบนของการ์ดขึ้นไป
0.75rem ตามดีไซน์รอบ 2 (แบบ "ตราประทับมุมบน") — พอมันอยู่ *ในองค์ประกอบเดียวกัน*
ที่มี `overflow-hidden` ส่วนที่ลอยพ้นขอบเลยโดน container ของตัวเองตัดทิ้ง เป็นบั๊ก
โครงสร้าง ไม่ใช่แค่เรื่องสี

**การแก้ไข (redesign รอบ 3, ต่างจากรอบ 1 และรอบ 2 ชัดเจน):**
เปลี่ยนจาก "ตราประทับลอยมุมบน" เป็น **แถวหัวการ์ด (header row)** — ย้ายป้ายดาว
เข้ามาอยู่ในแถวเดียวกับ avatar/ชื่อ/บทบาท ที่ด้านบนสุดของพื้นที่ padding ของการ์ด
(ไม่ absolute อีกต่อไป ไม่มีอะไรลอยพ้นขอบกล่องอีกเลย จึงตัดปัญหาการโดน
`overflow-hidden` clip ได้ถาวรโดยไม่ต้องเลี่ยง `overflow-hidden` ออก) และเปลี่ยน
แถบสันสีด้านซ้าย (`w-1.5` ตั้ง) เป็น **แถบไล่สีน้ำเงิน-ทองแนวนอนเต็มความกว้างด้านบน
การ์ด** แทน ให้ต่างจากรอบก่อนอย่างชัดเจน (ไม่ใช่แค่ขยับตำแหน่งป้ายดาว)
เครื่องหมายคำพูดใหญ่จางๆ ยังคงไว้แต่ย่อขนาดลงและวางในตำแหน่งที่อยู่ในกรอบ
เนื้อหาแทน

**คงเนื้อหาเดิมทั้งหมด** — array `reviews` (ชื่อ, บทบาท, เนื้อหารีวิว, จำนวนดาว,
avatar, verified) ไม่ถูกแตะเลย ตรวจสอบด้วยการ grep ชื่อผู้รีวิวทั้ง 3 คนและ
ค่าดาวทั้ง 3 ค่าใน `dist/index.html` หลัง build ยืนยันว่ายังอยู่ครบตรงตัวอักษร

ระหว่างแก้ยังเปลี่ยน `<h4>` (ชื่อผู้รีวิว) เป็น `<h2>` ให้สอดคล้องกับการ flatten
heading level ทั้งเว็บที่ทำไปในงานก่อนหน้า (ดูหัวข้อ "Follow-up: 2026-07-13")

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `dist/index.html` ยืนยันว่า pattern `absolute -top-3 right-5` (ต้นตอบั๊ก) หายไปจากไฟล์คอมโพเนนต์แล้ว
- grep ยืนยันดาว `★ 4.0`, `★ 4.0`, `★ 5.0` ยังปรากฏครบใน HTML ที่ build ออกมา
- grep ยืนยันชื่อผู้รีวิวทั้ง 3 คนยังอยู่ครบ ไม่ถูกแก้ไข

## Refactor: 2026-07-13 — แยก section "เข้าสู่ระบบ" + "RTP ค่ายเกม" ออกเป็น component ใหม่

ผู้ใช้ขอให้แยกบล็อก `<ContentBoxTwo titleleft="เข้าสู่ระบบ..." titleright="RTP ค่ายเกม...">`
ที่เขียนเป็น markup ยาวฝังอยู่ใน `index.astro` โดยตรง (ฟอร์ม login ฝั่งซ้าย +
ตาราง RTP ของแต่ละค่ายเกมฝั่งขวา) ออกมาเป็น component แยกต่างหาก แบ่งคอลัมน์
50/50 แล้ว import กลับเข้ามาใช้ใน `index.astro`

**ไฟล์ใหม่:** `src/components/LoginRtpSection.astro`
- ห่อด้วย `ContentBoxTwo` เดิม (ตัวนี้ทำ layout grid 50/50 + หัวข้อซ้าย/ขวาอยู่แล้ว
  `grid-cols-1 md:grid-cols-2`) แทนที่จะเขียน grid ใหม่ซ้ำ — ประหยัด/reuse โค้ด
  แทนการ duplicate
- ย้าย markup ฟอร์ม login (slot="left") และตาราง RTP (slot="right") มาไว้ในไฟล์นี้
  ทั้งหมด แบบคัดลอกตรงตัว ไม่มีการเปลี่ยนดีไซน์/ข้อความใดๆ
- ย้ายตัวแปร `jackpotProviders` (รายชื่อค่ายเกม + ค่า RTP) จาก `index.astro`
  เข้ามาอยู่ใน frontmatter ของ component นี้แทน เพราะข้อมูลนี้ใช้เฉพาะใน
  section นี้ที่เดียว

**`index.astro`:**
- ลบ import `ContentBoxTwo` (ไม่ได้ใช้ตรงๆ ในไฟล์นี้แล้ว เพราะย้ายไปอยู่ใน
  `LoginRtpSection.astro` แทน) และเพิ่ม import `LoginRtpSection`
- ลบ `const jackpotProviders = [...]` ออก (ย้ายไปแล้ว)
- แทนที่บล็อก `<ContentBoxTwo>...</ContentBoxTwo>` ทั้งก้อน (~110 บรรทัด) ด้วย
  `<LoginRtpSection />` บรรทัดเดียว ตำแหน่งเดิม (หลัง `SmoothCarousel`, ก่อน
  `ReviewCardSumo`) ไม่ได้ย้ายลำดับ section

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `dist/index.html` ยืนยันฟอร์ม login ("เข้าสู่ระบบ HENGJUD365"),
  รายชื่อค่ายเกมในตาราง RTP (PG Soft, Pragmatic Play, CQ9 Gaming ฯลฯ) และ
  class `grid-cols-1 gap-6 md:grid-cols-2` (คอลัมน์ 50/50) ยังปรากฏครบใน HTML
  ที่ build ออกมาเหมือนก่อน refactor ทุกจุด ไม่มี `undefined`/`NaN` จาก prop
  ที่เชื่อมพัง

## Fix: 2026-07-13 — แก้ real url เป็น hengjud365-guideline.com

ผู้ใช้แจ้งว่า domain `https://www.hengjud365.com` ที่เดาไว้ตอนรีแบรนด์ (จากรูป
reference ที่โชว์ตัวอย่างลิงก์ "OFFICIAL LINK") เป็น url ที่ผิด และชี้แจง
convention ว่า: คำสั่ง "rebrand and redesign to `<webname>`" เฉยๆ ไม่ได้แปลว่า
ให้เอาชื่อแบรนด์ไปเดาแล้วแก้ url — จะแก้ url ก็ต่อเมื่อผู้ใช้ระบุ real url
มาด้วยชัดเจนเท่านั้น (เช่น "rebrand to `<webname>` และ real url `<XXXX>`")
รอบนี้ผู้ใช้ให้ real url จริงมาคือ `hengjud365-guideline.com`

**แก้ไข domain เป็น `https://www.hengjud365-guideline.com` ใน 3 จุดที่มี URL
ฝังอยู่:**
- `astro.config.mjs` — `site:`
- `public/robots.txt` — `Sitemap:` line
- `src/pages/index.astro` — `webSiteSchema.url` (string literal ที่ไม่ได้
  derive จาก `Astro.url.origin` เหมือน `orgSchema.url`/`homePage` เลยต้องแก้
  มือแยกต่างหาก)

**อัปเดต skill `rebrand-site`** (`.claude/skills/rebrand-site/SKILL.md`)
Phase 1 เพิ่มกฎห้ามเดา domain จากชื่อแบรนด์/รูป reference/docx เด็ดขาด
ต้องรอ real url จากผู้ใช้เท่านั้นถึงจะแก้ทั้ง 3 จุดข้างต้น และเพิ่มหัวข้อใน
Phase 3 เรื่อง component ที่ซ้อนกัน (เช่น `LoginRtpSection.astro` ห่อ
`ContentBoxTwo.astro` อยู่ — grep เฉพาะ `index.astro` ตื้นๆ จะมองไม่เห็น
`ContentBoxTwo` เลย ต้องไล่ grep แบบ recursive) พร้อมเพิ่ม `LoginRtpSection`
เป็นตัวอย่างใน Phase 7 (follow-up single-component redesign) ด้วย

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `astro.config.mjs`, `public/robots.txt`, `src/pages/index.astro` และ
  `dist/` ทั้งหมด หา domain เก่า `hengjud365.com` (ไม่มี `-guideline`) →
  ไม่พบเหลือแม้แต่จุดเดียว
- `dist/sitemap-0.xml` และ `dist/robots.txt` ยืนยันใช้
  `https://www.hengjud365-guideline.com` ถูกต้องตรงกันทั้งคู่

## Redesign: 2026-07-13 — ใช้ ContentBox "family" หลายแบบ + ภาพ slide1-4 ประกอบเนื้อหา

ผู้ใช้สังเกตว่า 8 หัวข้อจาก docx เกือบทั้งหมดใช้ `ContentBox` แบบคอลัมน์เดียวซ้ำๆ
กัน ทั้งที่ในโปรเจกต์มี "family" ของ ContentBox หลายแบบอยู่แล้ว
(`ContentBox*Premium/CyberCut/FloatingBadge/Huay/Neumorphism`) และมีรูป
`slide1-4.png` ที่ยังไม่ได้ถูกใช้ประกอบเนื้อหาให้ครบ ขอให้เลือกใช้อย่าง
สร้างสรรค์มากขึ้น

**Retheme 6 component ในตระกูล "Premium/CyberCut/FloatingBadge" ก่อนใช้งาน**
(ของเดิมเป็นโทนม่วง/เขียวมรกต คนละธีมกับ HENGJUD365) — ตรวจสอบก่อนว่าไม่มี
หน้าอื่น import ใช้อยู่ (ปลอดภัยที่จะแก้):
- `ContentBoxPremium.astro`, `ContentBoxCyberCut.astro`,
  `ContentBoxFloatingBadge.astro` — สลับม่วง/เขียว → น้ำเงิน (คงทองไว้)
- `ContentBoxSevenThreePremium.astro`, `ContentBoxSevenThreeCyberCut.astro`,
  `ContentBoxSevenThreeFloatingBadge.astro` — สลับสีเดียวกัน พร้อมแก้
  `ContentBoxSevenThreeFloatingBadge` ที่ titleleft/titleright เดิมเป็น
  `<h3>` ให้เป็น `<h2>` ตาม convention heading ของเว็บ (ดูหัวข้อ
  "Follow-up: 2026-07-13")

**จับคู่รูป slide1-4.png กับหัวข้อ docx ตามความหมายจริงของรูป** (ไม่ใช่สุ่ม
หรือใช้ซ้ำรูปเดิม 2 รูปตามที่เคยทำ):
- `slide3.png` ("แตกง่ายอย่างไร? RTP PERFORMANCE / VOLATILITY") → หัวข้อ
  "HENGJUD365 แตกง่ายอย่างไร?" — ชื่อภาพตรงกับหัวข้อเป๊ะ
- `slide4.png` ("ข้อมูลเว็บตรง WEBSITE STRUCTURE") → หัวข้อ "ข้อมูลเว็บตรง
  HENGJUD365 ฟีเจอร์และองค์ประกอบของเว็บไซต์" — ย้ายมาจากหัวข้อ "ทางเข้า"
  เดิมเพราะชื่อภาพตรงกับหัวข้อนี้มากกว่า
- `slide2.png` ("ค่ายเกม TOP PROVIDERS") → หัวข้อ "รีวิวเกมสล็อต คาสิโน
  และค่ายเกมที่ให้บริการ" — ก่อนหน้านี้ใช้แค่ใน carousel ยังไม่เคยใช้เป็น
  ภาพประกอบเนื้อหา
- `slide1.png` ("ทางเข้า & Auto Wallet") → หัวข้อ "ระบบฝากถอนอัตโนมัติ
  รองรับระบบใดบ้าง" — คงตำแหน่งเดิมไว้ (`ContentBoxSevenThree` ฐาน)

**เลือก layout ให้แต่ละหัวข้อไม่ซ้ำกัน** (สลับกันระหว่างมีภาพ/ไม่มีภาพ เพื่อ
จังหวะการอ่านที่หลากหลาย):
1. H1 intro → `ContentBox` (คอลัมน์เดียว, เดิม)
2. แตกง่ายอย่างไร → `ContentBoxSevenThreeFloatingBadge` (ภาพ+ข้อความ, หัวข้อ
   ลอยแบบแคปซูล) + `ContentBoxThreeColums` ฐานสำหรับ RTP/Volatility/Bonus
3. ข้อมูลเว็บตรง/ฟีเจอร์ → `ContentBoxSevenThreeCyberCut` (ภาพ+ข้อความ, มุม
   ตัดเฉียงสไตล์ cyber) + การ์ดไอคอน 3 ใบเดิม (ไม่เปลี่ยน)
4. วิเคราะห์จุดเด่น/ผลทดสอบ → `ContentBoxPremium` (คอลัมน์เดียว, แถบหัวข้อ
   กลาง) + `LatestWinners`
5. รีวิวเกมสล็อต/ค่ายเกม → `ContentBoxSevenThreePremium` (ภาพ+ข้อความ) +
   `LoginRtpSection` + `ProviderGrid`
6. ทางเข้า/ปลอดภัย → `ContentBoxFloatingBadge` (คอลัมน์เดียว, หัวข้อลอย)
7. ระบบฝากถอนอัตโนมัติ → `ContentBoxSevenThree` ฐาน (คงเดิม เป็นจุด anchor
   ของตระกูลสีน้ำเงินมาตรฐาน)
8. ข้อสังเกต/ความน่าเชื่อถือ → `ContentBoxCyberCut` (คอลัมน์เดียว, มุมตัด)

ทุก component ที่มี prop `as` (`ContentBoxPremium`/`CyberCut`/`FloatingBadge`)
ถูกส่ง `as="h2"` ชัดเจน (ค่า default ของ component คือ `h1`) ส่วน
`ContentBoxSevenThree*` ทั้ง 3 ตัวใหม่ hardcode เป็น `<h2>` อยู่แล้วในตัว
component เอง — คงกฎ "ทุกหัวข้อเป็น h2 ยกเว้น H1 เดียวตอนต้น" ไว้ครบ

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- ดึงลำดับ `<h1>`/`<h2>` จาก `dist/index.html` เทียบ docx checklist — ครบ
  8 หัวข้อ เรียงลำดับถูกต้องเหมือนเดิมทุกจุด (แค่เปลี่ยน component ที่ห่อ)
- grep `<h3` → 0 (ไม่มี heading tag หลุด)
- grep หา class สีม่วง/เขียวมรกตเดิม (`purple`, `#10b981`, `#120322`,
  `#0a001a`) → ไม่พบเหลือใน HTML ที่ build ออกมา
- grep `alt="HENGJUD365...` ยืนยันภาพทั้ง 4 (slide1-4) ถูกใช้ครบและข้อความ
  alt ตรงกับเนื้อหาแต่ละหัวข้อจริง ไม่มี `undefined`/`NaN`

## Skill update: 2026-07-13 — สรุปกฎการใช้ "component family" ให้ครอบคลุมทุกตระกูล

ผู้ใช้ขอให้ generalize กฎที่เขียนไว้เฉพาะตระกูล `ContentBox*` ให้ครอบคลุม
ตระกูลอื่นในโปรเจกต์ด้วย: `Announcement*`, `LatestWinners*`,
`NavbarStyle*`/`Navbar*`, และ `Footer*`/`FooterStyle*` — สำรวจ inventory
จริงในโปรเจกต์ก่อนเขียน (ไม่เดา):
- `Announcement*` มี 9 ไฟล์ (`Announcement`, `Announcement2-6`, `Cyber`,
  `Premium`, `Huay`) — grep `Astro.props` เจอว่า **ทุกไฟล์มี default
  `message` เป็นสโลแกนแบรนด์เก่าคนละอันกันหมด** (PANAMA888, BRAZIL999,
  TEENOI69, VEGUS24R, MARANG7777, Var99, QQ882 ฯลฯ) มีแค่ `Announcement6`
  (ตัวที่ใช้จริง) เท่านั้นที่เป็น HENGJUD365
- `LatestWinners*` มี 7 ไฟล์ — ไม่ได้ใช้ prop สำหรับชื่อแบรนด์/สี เป็น
  hardcode ฝังใน JSX ตรงๆ เหมือนไฟล์อื่นทั่วไป
- `Navbar*`/`NavbarStyle1-11` มี 15 ไฟล์, `Footer*`/`FooterStyle2-3` มี 7
  ไฟล์ — ต่างจากตระกูลอื่นตรงที่ **มีแค่ 1 ไฟล์ที่ active จริงต่อเว็บ**
  (import เข้า `MainLayout.astro` แค่จุดเดียว) ไม่ใช่ใช้ได้หลายตัวพร้อมกัน
  แบบ ContentBox/Announcement/LatestWinners

**อัปเดต skill `rebrand-site`** (`.claude/skills/rebrand-site/SKILL.md`
Phase 2) — เปลี่ยนหัวข้อเดิมที่พูดถึงแค่ `ContentBox` family ให้ generalize
ครอบคลุมทั้ง 5 ตระกูลข้างต้น พร้อมข้อสังเกตเฉพาะของแต่ละตระกูล (Announcement
ต้องส่ง `message` prop เองเสมอห้ามพึ่ง default, LatestWinners ต้อง
retheme+เปลี่ยนชื่อแบรนด์แบบ full-file เหมือน Phase 3 เพราะไม่มี prop,
Navbar/Footer เลือกได้แค่ไฟล์เดียวต่อเว็บ) และคงกฎเดิมไว้ครบ (retheme ก่อนใช้,
เช็ก heading tag ก่อนใช้, จับคู่รูป slide กับเนื้อหาให้ตรงความหมาย)

## Refactor: 2026-07-13 — แยก feature-card list (H3) ออกเป็น component `FeatureHighlights`

ผู้ใช้แนบสกรีนช็อต (`Snipaste_2026-07-13_13-32-16.png`) ของ section การ์ด
ไอคอน 3 ใบใต้หัวข้อ "ข้อมูลเว็บตรง HENGJUD365 ฟีเจอร์และองค์ประกอบของเว็บไซต์"
ที่ก่อนหน้านี้เขียน markup ยาวซ้ำ 3 รอบฝังอยู่ใน `index.astro` ตรงๆ (แต่ละใบมี
ไอคอน + `<h2>` + คำอธิบาย) — ขอให้แยกเป็น component โดยเปลี่ยน heading เป็น
`<h3>` (เพราะเป็น sub-item ย่อยอยู่ใต้หัวข้อ H2 ของ section นั้นอยู่แล้ว ไม่ใช่
หัวข้อ section ใหม่) และให้ใช้ component นี้ทุกครั้งที่นำเนื้อหาจาก
`content.docx` มาใส่ในหน้าเว็บ ไม่ใช่เขียน markup ใหม่ทุกรอบ

**ไฟล์ใหม่:** `src/components/FeatureHighlights.astro` — รับ prop
`items: { icon, title, description, accent? }[]` แต่ละ item render เป็น
การ์ดไอคอน + `<h3>{title}</h3>` + `<p>{description}</p>` รองรับสอง accent
(`gold` สำหรับใบแรก/ใบเด่น, `blue` สำหรับใบที่เหลือ — ดีไซน์เดิมทุกจุด แค่
parameterize เป็น prop แทนการ hardcode สี/ไอคอน/ข้อความซ้ำ 3 รอบ)

**`index.astro`:** แทนที่ markup 3 การ์เดิม (~50 บรรทัด, ใช้ `<h2>`) ด้วย
`<FeatureHighlights items={[...]} />` ภายใน `<ContentBox>` เดิม (ยังคงเป็น
sub-content ต่อท้ายหัวข้อ H2 "ข้อมูลเว็บตรง..." เหมือนเดิม) — ข้อความ/ไอคอน/
ลำดับการ์ดเหมือนเดิมทุกตัวอักษร ไม่ได้แก้เนื้อหา

**อัปเดต skill `rebrand-site`** (`.claude/skills/rebrand-site/SKILL.md`
Phase 2) — เพิ่มเงื่อนไขการใช้ `FeatureHighlights`: ใช้เมื่อ docx section
มีเนื้อหาย่อยแบบ bullet-list สั้นๆ หลายจุดอยู่ใต้หัวข้อ H2 เดียว (ไม่ใช่ docx
section ใหม่) — เป็นข้อยกเว้นเดียวที่อนุญาตให้ใช้ `<h3>` ได้ (สร้าง hierarchy
จริง H1→H2→H3) ต่างจากกฎ "flatten ทุกอย่างเป็น h2" ปกติ

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `dist/index.html` หา `<h3` → เจอ 3 ครั้งพอดี (ตรงกับ 3 การ์ด ไม่มี h3
  หลุดที่อื่น)
- grep ข้อความหัวข้อการ์ดทั้ง 3 ("รวมค่ายเกมสล็อต...", "สล็อตใหม่...",
  "เลือกเล่นได้หลายค่าย...") ยืนยันยังอยู่ครบตรงตัวอักษร ไม่มี
  `undefined`/`NaN`

## Redesign: 2026-07-13 — สลับ LatestWinners variant + retheme

ผู้ใช้ขอให้เปลี่ยนรูปแบบ component `LatestWinners` เป็นแบบอื่นจากตระกูล
`LatestWinners*` (ก่อนหน้านี้ใช้ `LatestWinnersPremium.astro` — แถบหัวข้อ +
stat-strip + feed แนวตั้งคอลัมน์เดียว) แล้ว retheme ให้เข้าธีม HENGJUD365

**เลือก `LatestWinners2.astro`** เพราะเป็นรูปแบบที่ต่างชัดเจนที่สุดในตระกูล —
**grid การ์ด 2 คอลัมน์** (`grid-cols-1 md:grid-cols-2`) แทนที่จะเป็น list
เรียงแนวตั้งแบบเดิม (ตัวเลือกอื่นในตระกูลอย่าง `LatestWinners`/`Huay` ก็ยังเป็น
list แนวตั้งเหมือนเดิม, `Cyber` เป็น HUD คอลัมน์เดียวเช่นกัน มีแค่ `LatestWinners2`
ที่เป็น grid จริงๆ)

**Retheme** (ของเดิมเป็นโทนแดง-น้ำตาลเข้ม `#4a0404`/`#2b0404`/`#3d0606` +
ขอบทอง `border-yellow-600` — ตรวจแล้วว่าไม่มีหน้าอื่น import ใช้ ปลอดภัยที่จะแก้):
- พื้นหลังการ์ดหลัก `#4a0404` → `#050d16` (navy มาตรฐานของเว็บ), ขอบ
  `border-yellow-600/40` → `border-blue-500/30`, เงา/blur ตกแต่งจาก
  `rgba(234,179,8,0.15)`/`bg-yellow-500/20` → `rgba(37,99,235,0.15)`/
  `bg-blue-600/20`
- การ์ดย่อยแต่ละใบ `#2b0404`/hover `#3d0606` → `#0a1830`/hover `#0f2340`,
  ขอบ `border-yellow-600/20` → `border-blue-500/20`
- ป้ายผู้ใช้ `text-red-100/80` → `text-blue-100/80`
- คงสีทอง/เหลืองไว้ทุกจุดที่เป็น accent จริง (หัวข้อ gradient ทอง, ยอดเงิน
  `text-yellow-400`, badge สถานะสำเร็จสีทอง) ไม่แตะ เพราะเป็นสี accent ของ
  แบรนด์ ไม่ใช่สีแบรนด์เก่า
- เพิ่มข้อความ "HENGJUD365" ต่อท้ายหัวข้อ `<h2>รายการถอนเงินล่าสุด...` ให้
  ตรงกับ convention ที่ใช้ใน `LatestWinnersPremium`/`FooterPremiumSumo`
- ไม่แตะสีธนาคารจริง (`bg-[#1155cc]` KBank ฯลฯ) ตามกฎเดิม

**`index.astro`:** เปลี่ยน import จาก
`../components/LatestWinnersPremium.astro` เป็น
`../components/LatestWinners2.astro` (ชื่อตัวแปร `LatestWinners` เดิมไม่ได้
เปลี่ยน จุดที่เรียกใช้ `<LatestWinners />` จึงไม่ต้องแก้)

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `dist/index.html` หา class ที่ render จริงของการ์ด (ไม่ใช่ CSS bundle)
  ยืนยันใช้ `border-blue-500/20 bg-[#0a1830]/80` ถูกต้อง
- grep เจอ `#2b0404`/`#3d0606`/`border-yellow-600` หลงเหลือใน `dist/index.html`
  แต่ตรวจแล้วพบว่ามาจาก `<style>` bundle ที่ Tailwind สแกน
  `NavbarStyle10.astro` (component สำรองที่ไม่ได้ import ใช้จริง) เข้ามารวม
  ไม่ได้อยู่ใน `class="..."` ของ element ไหนเลย — เป็น noise ที่คาดไว้แล้ว
  ตามที่ skill ระบุไว้ ไม่ใช่บั๊กจริง
- `grid-cols-1 gap-4 md:grid-cols-2` ยืนยันว่า layout เป็น grid 2 คอลัมน์จริง
  ไม่มี `undefined`/`NaN`

## บั๊ก: 2026-07-13 — mobile responsive พังที่หัวข้อ "ป้ายลอย" (FloatingBadge)

ผู้ใช้แนบสกรีนช็อตมือถือ (`Snipaste_2026-07-13_14-02-36.png`) เห็นข้อความหัวข้อ
"...365 แตกง่ายอย่างไร? คู่มือสำหรับผู้เริ่มต้นเล่น..." ขึ้นแบบตัดครึ่งซ้าย-ขวา
ไม่มี wrap เหมือนป้ายกว้างเกินจอ

**สาเหตุ:** `ContentBoxFloatingBadge.astro` และ `ContentBoxSevenThreeFloatingBadge.astro`
(ใช้จริงในหน้า index.astro สำหรับหัวข้อ H2 แบบ "ป้ายลอย") วางหัวข้อในกล่อง
`position: absolute` ที่มี `whitespace-nowrap` และไม่มีการจำกัดความกว้างเลย —
พอหัวข้อยาว (เช่น heading เต็มประโยคจาก docx) กล่องป้ายเลยขยายกว้างกว่าจอมือถือ
ไปทั้งสองฝั่ง (เพราะ `left-1/2 -translate-x-1/2` จัดกึ่งกลางแต่ไม่จำกัดความกว้าง)
ทำให้ข้อความโดนตัด และหน้าเว็บทั้งหน้าเกิด horizontal scroll เพราะไม่มี
`overflow-x: hidden` ที่ระดับ body คอยกันไว้เลย

**ตรวจทั้งระบบเพิ่มเติม** — grep หา `whitespace-nowrap` และ `w-[XXXpx]`/`min-w-[XXXpx]`
ทั่ว component ที่ index.astro/MainLayout ใช้งานจริง พบว่ามีแค่ 2 ไฟล์ข้างต้นที่เป็น
บั๊ก (ตัว `Announcement6.astro` ก็มี `whitespace-nowrap` เหมือนกันแต่เป็นของ ticker
scroll ที่ตั้งใจให้ไม่ wrap อยู่ในกล่อง overflow-hidden อยู่แล้ว ไม่ใช่บั๊ก) ส่วน
`max-w-[1400px]` ที่เจอเกลื่อนทุกไฟล์เป็น max-width cap คู่กับ `w-full` ปกติ ไม่ใช่
fixed width จึงไม่มีปัญหา

### การแก้ไข
- `ContentBoxFloatingBadge.astro`, `ContentBoxSevenThreeFloatingBadge.astro`
  (ใช้จริง) และ `ContentBoxTwoFloatingBadge.astro`,
  `ContentBox3ThreeFloatingBadge.astro` (ยังไม่ได้ใช้ แต่เป็นบั๊กแบบเดียวกันใน
  ตระกูลเดียวกัน แก้ไว้ล่วงหน้าไม่ให้เจอซ้ำตอนหยิบมาใช้ครั้งหน้า — ไม่ได้แตะสีเพราะ
  ยังไม่ได้ใช้งานจริง ตามกฎ "retheme ตอนหยิบมาใช้เท่านั้น") — เอา
  `whitespace-nowrap` ออก, เพิ่ม `w-[92%] max-w-2xl` ให้กล่องป้าย, เพิ่ม
  `text-center` ให้ข้อความ wrap ได้สวย, ลด padding/font-size บนจอเล็ก
  (`px-4 sm:px-8`, `text-base sm:text-xl md:text-2xl`)
- `src/layouts/MainLayout.astro` — เพิ่ม `overflow-x: hidden; max-width: 100%;`
  บน `html, body` เป็นเกราะป้องกันชั้นที่สอง กันไม่ให้บั๊กลักษณะนี้ (element ไหน
  ก็ตามที่ล้นขอบจอ) ทำให้ทั้งหน้าเกิด horizontal scroll อีกในอนาคต

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- รัน dev server, grep HTML ที่ render จริง: `whitespace-nowrap` เหลือแค่ 2 จุด
  ยืนยันว่ามาจาก ticker ของ `Announcement6` เท่านั้น (ของที่ตั้งใจไว้)
- grep เจอ class `w-[92%] max-w-2xl` บนป้ายทั้ง 2 จุดที่ใช้จริงในหน้า index
- grep เจอ `overflow-x: hidden` ใน `<style>` ของหน้าที่ build ออกมาจริง

## บั๊ก: 2026-07-13 (16:06) — ป้ายลอย (FloatingBadge) ทับซ้อนแนวตั้งกับเนื้อหาในการ์ดตัวเอง

ผู้ใช้แนบสกรีนช็อตอีกภาพ (`Snipaste_2026-07-13_16-06-46.png`) ของหัวข้อเดียวกัน
("HENGJUD365 แตกง่ายอย่างไร? คู่มือสำหรับผู้เริ่มต้นเล่นเกมสล็อต") — รอบนี้ข้อความ
wrap ได้ถูกต้องแล้ว (ผลจากการแก้บั๊กรอบ 14:02 ด้านบน) แต่ดูเหมือนกล่องป้ายทับซ้อน
กับเนื้อหาด้านบน จึงตรวจสอบเพิ่มเติม — มุมภาพ (บนซ้าย/บนขวา) มีพิกเซลที่ตรงกับ
`banner3.png` (โลโก้เกม "TIGER"/"OLYMPUS" ในรูป hero banner) แต่พิสูจน์ทางโครงสร้าง
DOM แล้วว่าเป็นไปไม่ได้ที่ hero banner จะทับซ้อนกับ section นี้จริง (มี Announcement
+ ContentBox H1 เต็มๆ คั่นกลางใน `<main>`) — สรุปว่ามุมภาพทั้งสองเป็น window/desktop
bleed จากการ snip ไม่ใช่บั๊กของเว็บนี้

**บั๊กจริงที่พบ (คนละตัวกับรอบ 14:02 แต่ root cause ตระกูลเดียวกัน — "FloatingBadge
ถูกออกแบบมาสำหรับหัวข้อสั้นบรรทัดเดียว"):** หลังแก้ `whitespace-nowrap` แล้วให้
wrap ได้ ป้ายที่ wrap เป็น 2 บรรทัดจะมีความสูงรวม padding+border ประมาณ 48-72px
(ขึ้นกับ breakpoint) แต่การ์ดที่ครอบมันสำรอง `pt-12`/`pt-14` (48px/56px) ไว้ก่อน
เนื้อหาข้างในเริ่ม โดยป้ายวางด้วย `-top-6` (-24px) จากขอบบนการ์ด — คำนวณแล้วขอบล่าง
ของป้าย 2 บรรทัดที่ขนาดจอมือถือ (`text-base`) ตกอยู่ที่ ~48px พอดีกับจุดที่เนื้อหา
เริ่ม (`pt-12`) แทบไม่มี margin เผื่อเลย (ประมาณ 0-4px) พอเจอการ render จริง
(เส้นสระ/วรรณยุกต์ไทยที่ทำให้ line-height จริงสูงกว่าที่คำนวณเล็กน้อย) เลยทับกัน

### การแก้ไข
- `ContentBoxSevenThreeFloatingBadge.astro`, `ContentBoxFloatingBadge.astro`:
  `pt-12` → `pt-16` (64px)
- `ContentBox3ThreeFloatingBadge.astro`: `pt-14` → `pt-18` (72px, คงส่วนต่าง +8px
  เท่าของเดิม)
- ไม่ได้แตะ `ContentBoxTwoFloatingBadge.astro` (โครงสร้างต่างออกไป ไม่มี grid
  2/3-คอลัมน์แบบเดียวกัน ยังไม่ได้ใช้งานจริง — นอกสโคปจนกว่าจะถูกหยิบมาใช้)
- อัปเดต `.claude/skills/rebrand-site/SKILL.md` เพิ่มหมายเหตุ "แนวตั้ง" ต่อจาก
  หมายเหตุ `whitespace-nowrap` เดิมใน Phase 2 ข้อ 3 และเพิ่ม checklist item ใน
  Phase 5 ให้เช็ก vertical clearance ของ `*FloatingBadge` ด้วยหัวข้อจริงที่จอมือถือ
  ทุกครั้งที่ใช้ component ตระกูลนี้ ไม่ใช่แค่เช็กตอน build ผ่าน

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า) หลังแก้ padding ทั้ง 3 ไฟล์
- ไม่มี browser/screenshot tool ใช้ตรวจ visual ซ้ำได้ในเซสชันนี้ — ยืนยันด้วยการ
  คำนวณ box-model ตรงๆ (line-height × จำนวนบรรทัด + padding + border เทียบกับ
  `pt-*` ใหม่) แทน ควรตรวจซ้ำด้วยตาจริงที่ mobile viewport รอบหน้า

## ทำความสะอาด: 2026-07-13 — ลบไฟล์รูปภาพที่ไม่มีการ import/reference เหลืออยู่จริง

ผู้ใช้ขอให้ลบรูปภาพที่ไม่ได้ถูกใช้งานออก — grep หา `import ... from ".../assets/..."`
ทุกไฟล์ .astro บวก `import.meta.glob` ทั้งหมด แล้วเทียบกับไฟล์จริงใน `src/assets/`
และ `public/` ก่อนลบ (ไม่ใช่แค่ดูว่า index.astro ใช้อะไร — เพราะ component variant
ที่ยังไม่ถูกเรียกใช้จากหน้าไหนเลยก็ยังนับว่า "ใช้งาน" ไฟล์ภาพของมันอยู่ ตามกฎ
CLAUDE.md ที่ห้ามลบ component สำรอง)

**ลบแล้ว (ยืนยันว่าไม่มี import/glob อ้างถึงที่ไหนเลยในทั้ง repo):**
- `src/assets/banner.webp`, `banner1.webp`, `banner2.webp` — ของเก่าตระกูล
  BABYSHARK88 ที่ตรงกับ glob `banner*.{png,webp,jpg,jpeg}` ใน `MainLayout.astro`
  แต่ logic เลือกภาพ preferred `banner3.png` เสมอ ไฟล์เหล่านี้ไม่เคยถูกเลือกจริง
- `src/assets/bg.jpg` — bg เก่าของ BABYSHARK88 (ฉลาม/ทะเล), `MainLayout.astro`
  import `bg.png` เท่านั้นแล้ว
- `src/assets/slide1.webp`, `slide2.webp`, `slide3.webp` — ของเก่าตระกูล
  BABYSHARK88 เช่นกัน (ตอนนี้ทุกที่ import `slide*.png` แทน)
- `src/assets/banks/ttb.png` — ไม่มี `LatestWinners*` ตัวไหน (รวม 7 variant) import
  ธนาคารนี้เลยสักตัว
- `public/android-chrome-192x192.png`, `android-chrome-512x512.png`,
  `apple-touch-icon-114x114.png`, `-120x120.png`, `-180x180.png`, `-57x57.png`,
  `favicon-16x16.png`, `favicon-32x32.png`, `genfavicon-*.png` (11 ไฟล์),
  `pro3.webp` — เหลือจากการ generate favicon/OG มาหลายชุด แต่
  `MainLayout.astro`/`site.webmanifest` อ้างถึงแค่ `favicon-96x96.png`,
  `favicon.svg`, `favicon.ico`, `apple-touch-icon.png` (180x180 ตัวไม่มี suffix),
  `web-app-manifest-192x192.png`, `web-app-manifest-512x512.png` เท่านั้น

**ตั้งใจไม่ลบ (มี import จริง แต่จาก component ที่ยังไม่ได้ถูกเรียกใช้หน้าไหนเลย):**
- `src/assets/providers/game1-6.avif` — import อยู่ใน `ProviderGridPremium.astro`
  ตัวเดียว ซึ่งตัว component เองก็ไม่ถูก import จากหน้าไหนใน `src/pages` เลยเช่นกัน
  (เป็น "ของสำรอง" ตามนิยาม CLAUDE.md) ถ้าลบรูปนี้จะทำให้ component ตัวนี้ build พัง
  ทันทีที่มีคนหยิบมาใช้ครั้งหน้า จึงเก็บไว้คู่กันเพื่อให้ยังเป็น inventory ที่ใช้งาน
  ได้จริง ไม่ใช่ dead code ครึ่งๆ กลางๆ

ทุกไฟล์ที่ลบเป็นไฟล์ที่ git track อยู่แล้ว (ลบผ่าน `git rm`, กู้คืนได้จาก history
ถ้าจำเป็น) ไม่ได้ลบ `src/assets/content.docx` (ไม่ใช่รูปภาพ อยู่นอกสโคปคำขอนี้)

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า) หลังลบไฟล์ทั้งหมด 27 ไฟล์

## บั๊ก: 2026-07-13 — เอาเมาส์วางรูปเดียวใน `ทดลองเล่น.astro` แต่ปุ่ม "เล่นเลย" ขึ้นทุกรูป

ผู้ใช้แจ้งว่า hover การ์ดเกมใบเดียวในหน้า `ทดลองเล่น.astro` แล้วปุ่ม "เล่นเลย"
โผล่ขึ้นมาพร้อมกันทุกรูปในกริด แทนที่จะขึ้นเฉพาะรูปที่ชี้เมาส์อยู่

**สาเหตุ:** แต่ละการ์ดเกมใช้ Tailwind `group`/`group-hover:` แบบไม่ตั้งชื่อ
(`class="group relative ..."` + `group-hover:opacity-100`) แต่ทั้งกริดถูกครอบด้วย
`ContentBox.astro` ซึ่งตัว container หลักของมันเองก็ใช้ `class="group relative ..."`
(ไม่ตั้งชื่อเหมือนกัน) สำหรับ hover-glow ของตัวเอง — เมื่อมี `.group` แบบไม่ตั้งชื่อ
ซ้อนกันสองชั้น selector ที่ Tailwind gen ออกมา (`.group:hover .group-hover\:opacity-100`)
จะจับคู่กับ `.group` ชั้นไหนก็ได้ที่กำลัง hover อยู่ ไม่ได้ scope แค่ตัวที่ใกล้ที่สุด
ดังนั้นแค่เมาส์อยู่ในขอบเขตของ `.group` ชั้นนอก (ContentBox) ก็ทำให้ `group-hover:`
ของการ์ดทุกใบ (ซึ่งใช้ class เดียวกันหมด) ทำงานพร้อมกันหมด

### การแก้ไข
- `src/pages/ทดลองเล่น.astro` — เปลี่ยนการ์ดแต่ละใบจาก `group`/`group-hover:` แบบไม่
  ตั้งชื่อ เป็น named group `group/card`/`group-hover/card:` (ทั้ง scale รูปตอน hover
  และ opacity ของปุ่ม "เล่นเลย") เพื่อไม่ให้ชนกับ `.group` ของ `ContentBox.astro`
  ที่ครอบอยู่ชั้นนอก
- ตรวจแล้วว่า `แนวทาง.astro` (การ์ดลักษณะคล้ายกัน มี `group`/`group-hover:` เหมือนกัน)
  ไม่ได้ใช้ `ContentBox` ครอบ จึงไม่มี `.group` ซ้อนกันสองชั้น ไม่ติดบั๊กนี้ — ไม่ได้
  แก้ไข (นอกจากนี้หน้านี้เป็นแบรนด์เก่าคนละอันที่ไม่ผูกกับ HENGJUD365 อยู่แล้วตาม
  workspec ด้านบน)

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า)
- grep `dist/ทดลองเล่น/index.html`: เจอ `group/card` ครบ 12 การ์ด และไม่เหลือ
  `group-hover:opacity-100`/`group-hover:scale-105` แบบไม่ตั้งชื่อบนการ์ดแล้ว
- ควรตรวจซ้ำด้วยตาจริงในเบราว์เซอร์ (เซสชันนี้ไม่มี browser tool) ว่า hover
  แต่ละการ์ดแล้วปุ่มขึ้นเฉพาะใบนั้นจริง

## เพิ่มฟีเจอร์: 2026-07-13 — สร้าง 3 component ใหม่จากรูป `providers/game1-6.avif` + wire เข้า index

ต่อเนื่องจากงานทำความสะอาดไฟล์ (รอบ 16:xx) ที่ตั้งใจไม่ลบ `providers/game1-6.avif`
เพราะยัง import อยู่ใน `ProviderGridPremium.astro` (component สำรองที่ไม่ถูกใช้) — ผู้ใช้
ขอให้เอารูปชุดนี้มาออกแบบ UI ประกอบเป็น ~3 component ตามธีมปัจจุบัน (HENGJUD365
น้ำเงิน-ทอง) แบบมืออาชีพ แล้วนำเข้าไปใช้จริงในหน้า index

**หลักการออกแบบ:** ทำ 3 component ที่ "รูปทรงต่างกันจริง" (ไม่ใช่แค่ recolor กริดเดิม)
และต่างจาก component เกม/ค่ายที่มีอยู่แล้ว (`ProviderGrid` = กริด 6 ช่องมีแท็บกรอง +
initial ไม่มีรูป, `ProviderGridPremium` = กริดรูป 6 ช่องโทนม่วง unused, `SmoothCarousel`
= marquee เลื่อนอัตโนมัติของรูป slide กว้าง) — ทั้ง 3 ตัวใหม่ใช้รูป game1-6 ทั้งชุด
ในธีมน้ำเงิน-ทอง + ฟอนต์ Kanit + heading เป็น `<h2>` (ตามกฎ heading ของ skill)

**ไฟล์ที่สร้างใหม่:**
- `src/components/GameRankingBoard.astro` — บอร์ดจัดอันดับเกม RTP สูงสุด: แถวเรียง
  แนวตั้ง (list rows ไม่ใช่กริด) มีเหรียญอันดับ 🥇🥈🥉/`#4-6`, thumbnail สี่เหลี่ยม,
  แถบ RTP % (gradient bar), จำนวนผู้เล่นออนไลน์ (pulse dot), ปุ่มเล่นเลย — แถวอันดับ 1
  ไฮไลต์ทองพิเศษ
- `src/components/PopularGamesStrip.astro` — แถวเกมยอดนิยมเลื่อนแนวนอน: `snap-x
  snap-mandatory overflow-x-auto` การ์ดแนวตั้ง `aspect-[3/4]` มี gradient overlay +
  แท็บ "🔥 มาแรง/ยอดนิยม" + ปุ่ม "เล่นเลย" ตอน hover (ใช้ named group `group/card`
  กันบั๊ก nested-group ที่เพิ่งแก้ในหน้า `ทดลองเล่น`) — ต่างจาก SmoothCarousel ตรงที่
  เลื่อนเองด้วยมือ + scroll-snap + การ์ดสี่เหลี่ยม ไม่ใช่ marquee อัตโนมัติ
- `src/components/FeaturedGames.astro` — บอร์ดเกมแนะนำแบบ bento ไม่สมมาตร: game1 เป็น
  hero 2x2 (มีป้าย "⭐ แนะนำสูงสุด"), game4/5/6 เป็นช่องกว้าง col-span-2, game2/3 เป็น
  ช่องเล็ก — layout ไม่มีช่องว่างทั้ง mobile (2 คอลัมน์) และ desktop (4 คอลัมน์)

**Wire เข้า `src/pages/index.astro` (วางตามบริบทเนื้อหา ไม่ยัดรวมกันเป็นก้อนเดียว):**
- `<GameRankingBoard />` ต่อจาก section 3 คอลัมน์ RTP/Volatility (หัวข้อ "แตกง่าย
  อย่างไร") — เพราะเป็นเรื่อง RTP เหมือนกัน
- `<PopularGamesStrip />` ต่อจาก section "รีวิวเกมสล็อต คาสิโน และค่ายเกม" — เพราะพูด
  เรื่องความหลากหลายของเกม
- `<FeaturedGames />` ต่อจาก `<ProviderGrid />` — โซนรวมเกม/ค่ายต่อเนื่องกัน

ชื่อเกม/ค่ายใน 3 component ใช้ชุดเดียวกับ `ProviderGridPremium` เดิม (PG Soft, Joker
Gaming, JILI, Evolution, SA Gaming, Sexy Baccarat) เพื่อความสอดคล้อง

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า) — warning `noise.png` เป็นของเดิมในโค้ดเบส
  ไม่เกี่ยวกับ component ใหม่
- grep `dist/index.html`: เจอหัวข้อทั้ง 3 component, ป้าย TOP RTP/เหรียญ/bento hero,
  `snap-mandatory`, รูป `game[1-6].*.avif/webp` รวม 105 ref (3 component × 6 เกม ×
  หลาย width/format), ไม่มี `undefined`/`NaN`/`[object Object]`
- ควรตรวจซ้ำด้วยตาจริงในเบราว์เซอร์ (เซสชันนี้ไม่มี browser tool) เรื่อง responsive
  ของ bento/strip และ hover overlay

## อัปเดต: 2026-07-13 — ผู้ใช้เอา 2 ใน 3 component ออกจาก index + เพิ่มกฎ "สลับ variant ทุก rebrand" ลง skill

**ผู้ใช้ปรับ index เอง:** เอา `<PopularGamesStrip />` และ `<FeaturedGames />` ออกจาก
`index.astro` (บอกว่า "ไม่สวย") เหลือใช้แค่ `<GameRankingBoard />` ตัวเดียว — ตัว
`GameRankingBoard` ยังอยู่ในหน้า ต่อจาก section 3 คอลัมน์ RTP ตามเดิม

**ไฟล์ 2 ตัวที่ถูกเอาออก — เก็บไว้เป็น inventory ไม่ลบ:**
`PopularGamesStrip.astro` และ `FeaturedGames.astro` ตอนนี้ไม่ถูก import จากหน้าไหนแล้ว
(grep ทั้ง `src/` ไม่เจอ) — ตามกฎ CLAUDE.md "ห้ามลบ component ที่ไม่ได้ใช้ เว้นแต่สั่ง
โดยตรง" จึงเก็บไฟล์ไว้เป็นของสำรองสำหรับแบรนด์หน้า (เหมือน `ProviderGridPremium`) ผู้ใช้
ไม่ได้สั่งลบไฟล์ สั่งแค่เอาออกจากหน้า — ถ้าต้องการลบไฟล์จริงค่อยแจ้ง

**เพิ่มกฎใหม่ลง `.claude/skills/rebrand-site/SKILL.md`:** ทุกครั้งที่ rebrand ต้อง
"หมุนสลับ variant" ของแต่ละ family ให้ต่างจากแบรนด์ก่อนเสมอ ไม่ใช่แค่เปลี่ยนสีของตัวเดิม —
ครอบคลุม **ContentBox family, Announcement family, LatestWinners family, Navbar/
NavbarStyle family, Footer family** โดย:
- Phase 2: เพิ่มบล็อกกฎ "Rotate every family's variant on each rebrand" — สั่งให้ระบุ
  variant ที่แบรนด์เดิมใช้ก่อน (grep import จริงใน index.astro/MainLayout.astro) แล้ว
  จงใจเลือก sibling คนละตัวสำหรับแบรนด์ใหม่ (คนละ *รูปทรง* ไม่ใช่ recolor) ถ้าจำเป็นต้อง
  ใช้ตัวเดิมให้บันทึกเหตุผลใน workspec
- Phase 6: เพิ่มให้บันทึก variant แบบ before→after ต่อ family (เช่น `Navbar:
  NavbarStyle11 → NavbarStyle6`) เพื่อให้แบรนด์หน้าอ่านย้อนได้ว่าห้ามใช้ตัวไหนซ้ำ

### การทดสอบ
- `npm run build` ผ่านสะอาด (9 หน้า) หลังผู้ใช้เอา 2 component ออก

---

## 2026-07-15 — ContentBox family: ลด DOM depth (คงโครง HTML5 semantic)

**เป้าหมาย:** ปรับ ContentBox family ให้ DOM ไม่ลึกเกินไป โดยยังคง semantic tag (section/article/header/h1–h6) ครบเดิม — เลือกแนวทาง "safe merges only / zero visual change" และทำเฉพาะ variant ที่ใช้งานจริง (ไม่แตะ inventory ที่ยังไม่ถูก render)

**สิ่งที่ทำ:** ในกลุ่ม multi-column ทุกคอลัมน์เดิมเป็น `<article class="flex ... gap-N"> <h2> <div class="text-…"><slot/></div> </article>` — `<div>` ชั้นในทำหน้าที่แค่ถือ class ตัวอักษร (size/leading/color) ซึ่ง inherit ได้ จึงย้าย class เหล่านั้นขึ้นไปไว้บน `<article>` แล้วลบ `<div>` ทิ้ง = ตัดความลึกลงคอลัมน์ละ 1 ชั้น
- กัน `leading-relaxed` รั่วไปที่ `<h2>` (heading ไม่ได้ตั้ง line-height เอง จะ inherit เป็น 1.625) ด้วยการเติม `leading-normal` (=1.5, no-op ตรงกับค่าเดิม) ให้ทุก h2 ที่เป็นพี่น้องกับ slot

**ไฟล์ที่แก้ (5):** ContentBoxSevenThree, ContentBoxSevenThreeFloatingBadge, ContentBoxSevenThreeCyberCut, ContentBoxSevenThreePremium (คอลัมน์ text ทั้งคู่), ContentBox3Three (ทั้ง 3 คอลัมน์)

**จงใจไม่แตะ:** single-slot variants (ContentBox, Premium, CyberCut, FloatingBadge, Huay) และ Special — content wrapper ถือ `relative z-10` เพื่อลอยเหนือเลเยอร์ตกแต่ง absolute (หรือ bg-clip-text ที่ต้องอยู่บน element ของ text เอง) การ flatten จึงเสี่ยง stacking regression ไม่ผ่านเกณฑ์ zero-visual-change — เว้นไว้เป็น follow-up ถ้าต้องการ

**การทดสอบ:** `npm run build` ผ่านสะอาด (9 หน้า) + grep `dist/index.html` ยืนยัน `<article>` ถือ text class โดยตรงและ wrapper `<div>` หายไปแล้ว

---

## 2026-07-15 — เปิดตัวแบรนด์ใหม่ FUNBEYOND (rebrand + retheme + real URL)

**เป้าหมาย:** รีแบรนด์เต็มจาก HENGJUD365 (น้ำเงิน+ทอง) → **FUNBEYOND** (ม่วง/violet นีออน + ทอง) ตาม docx + ชุดรูปใหม่ พร้อมตั้ง real URL `https://www.funbeyond-brand.com`

**อินพุตแบรนด์:**
- โลโก้: "FUN" ไล่เฉด magenta→ม่วง + "Beyond" สคริปต์ทอง → พาเลตต์ = ม่วง (`purple-*`, glow `rgba(157,78,221)`) + ทอง (`yellow/amber` คงไว้), พื้นเข้ม `#0a001a`
- มู้ด: neon-cyber luxury ม่วง → เลือกตระกูล chrome เป็น **Cyber** (ซึ่งบังเอิญเป็นม่วง+ทองของแบรนด์เก่า MARANG7777 อยู่แล้ว เลยรีธีมน้อย)
- docx: `src/assets/content.docx` → H1 + 5×H2 + 3×H3 (nested ใต้ H2 "ผลทดสอบ")

**docx heading checklist (เรียงตามเอกสาร) — ครบทุกหัวข้อ:**
1. H1: FUNBEYOND เว็บสล็อตมีใบรับรอง เกมลิขสิทธิ์แท้ ระบบออโต้ เข้าเล่นเลย → `ContentBox` (as h1) + ปุ่ม CTA
2. H2: ทำความรู้จักกับ FUNBEYOND น้องใหม่ → `ContentBoxSevenThreePremium` + **slide1**
3. H2: เว็บสล็อตมีใบรับรอง เกมลิขสิทธิ์แท้ มาตรฐาน (MGA/PAGCOR/Anjouan, RNG/GLI/iTech, SSL/TLS) → `ContentBoxSevenThree` + **slide3** → ตามด้วย `ProviderGrid`
4. H2: ผลทดสอบการใช้งาน ระบบออโต้ → `ContentBoxSevenThreeNeumorphism` + **slide2**
   - H3×3 (ความเร็ว / ฝากถอนอัตโนมัติ / ความเสถียร) → `FeatureHighlights` (title=h3) — เคส H2→H3 ที่ skill อนุญาต + wire ตัว FeatureHighlights ที่เดิม import ค้างไม่ได้ใช้
   - ตามด้วย `GameRankingBoard` + `LatestWinnersCyber`
5. H2: คำวิจารณ์เกี่ยวกับ FUNBEYOND → `ContentBoxPremium` (as h2) → ตามด้วย `ReviewCardSumo2` + `SmoothCarousel`
6. H2: สมัครสมาชิก FUNBEYOND เข้าเล่นเลย รับโปรพิเศษ → `ContentBoxSevenThreeCyberCut` + **slide4** → ตามด้วยแถบโปรฯ **banner2** (คืนยอดเสีย 5%) + `LoginRtpSection` + `ContentBoxSpecial`

**การแมปรูป (ตามเนื้อในภาพจริง):** banner1=hero (MainLayout), slide1=รู้จักแบรนด์, slide3=ใบรับรอง/SSL/RNG/GLI/MGA/PAGCOR, slide2=performance test, slide4=member-center/สมัคร, banner2=แถบโปรฯคืนยอดเสีย 5%

**Variant rotation (before → after) — ห้ามแบรนด์ถัดไปใช้ตัว "after" ซ้ำ:**
- Navbar: `NavbarStyle11` → **`NavbarCyber`**
- Footer: `FooterPremiumSumo` → **`FooterCyber`**
- Announcement: `Announcement6` → **`AnnouncementCyber`**
- LatestWinners: `LatestWinners2` → **`LatestWinnersCyber`**
- ContentBox mix: FloatingBadge+CyberCut-heavy (น้ำเงิน) → **Premium + plain + Neumorphism + FeatureHighlights** (นำ), ตัด FloatingBadge ทั้งคู่ออก, เพิ่ม Neumorphism เป็นรูปทรงใหม่
  - **ข้อยกเว้นเดียว:** `ContentBoxSevenThreeCyberCut` ยัง carry over จาก HENGJUD (ใช้ 1 ครั้งที่ section สมัครสมาชิก) — เหตุผล: ตัวเลือก SevenThree ที่เหลือ (Huay=ธีมแดง+เรนเดอร์ h3, FloatingBadge=บั๊ก mobile overflow) ไม่เข้ากับมู้ด neon ม่วงและต้องผ่าตัดเยอะ; CyberCut เข้ามู้ดสุด ใช้แค่ครั้งเดียว ส่วนที่เหลือหมุนครบแล้ว

**stale-asset / glob (Phase 4):**
- `MainLayout.astro`: repoint `preferredBannerPath` จาก hardcode `banner3.png` → regex `banner1.(png|webp|jpg|jpeg)` ตามธรรมเนียม banner1=hero (กันแบรนด์หน้าอัปโหลด banner3 เป็นรูปประกอบแล้วโดนหยิบเป็น hero)
- slide1–4.png / banner1–2.png มีครบ ไม่มีปัญหานามสกุลค้าง (SmoothCarousel/promotion.astro อ้าง .png ที่มีจริง)

**URL (3 จุด ตั้งเป็น `https://www.funbeyond-brand.com`):** `astro.config.mjs` site, `public/robots.txt` Sitemap, `src/pages/index.astro` `webSiteSchema.url` (string literal)

**ไฟล์ที่แก้ — chrome/layout:** MainLayout (import Cyber nav/footer, hero=banner1, brand strings, apple-title), NavbarCyber/FooterCyber/AnnouncementCyber (MARANG7777→FUNBEYOND + copy), LatestWinnersCyber (ม่วง+ทองอยู่แล้ว ไม่มีชื่อแบรนด์)
**ไฟล์ที่แก้ — retheme น้ำเงิน→ม่วง + brand (15):** ContentBox, ContentBoxPremium, ContentBoxSevenThree, ContentBoxSevenThreePremium, ContentBoxSevenThreeCyberCut, ContentBox3Three, ContentBoxSpecial, ContentBoxTwo, FeatureHighlights, ProviderGrid, GameRankingBoard, LoginRtpSection, ReviewCardSumo2, SmoothCarousel, Navfoot (swap `blue-`→`purple-`, `sky-`→`fuchsia-`, `indigo-`→`violet-`, `#050d16`/`#0b1633`→`#0a001a`, `rgba(37,99,235)`→`rgba(157,78,221)`, คงทอง/เขียว/สีธนาคาร)
**heading normalize:** demote ProviderGrid card name, ReviewCardSumo2 author, LoginRtpSection "ยินดีต้อนรับกลับ" จาก h2→h3 (เป็น sub-item ใต้ section) → outline สะอาด H1 → H2(section) → H3(sub-item/3 tests)

**การทดสอบ (Phase 5):** `npm run build` ผ่านสะอาด (9 หน้า); grep `dist/index.html`: HENGJUD=0, MARANG=0, `<!--`=0, undefined/NaN/[object Object]=0, ไม่มี blue/sky/indigo ใน class attr, hero=banner1, ใช้ slide1–4+banner2 ครบ, ไม่มี .png อ้างตรงค้าง; heading H1=1 + docx H2 5 หัวข้อครบตามลำดับ + H3 3 tests ครบ; purple class เรนเดอร์เต็มหน้า, ทองคงอยู่; URL funbeyond ใน schema/canonical/sitemap

**นอกสโคป (ไม่แตะ — รายงานไว้):** หน้าอื่นยังเป็น HENGJUD365 — `login`, `register`, `promotion`, `contact-us`, `ทางเข้า.astro`, `ทดลองเล่น.astro` (grep เจอใน dist ของหน้าเหล่านั้น); component inventory เก่าที่ไม่ได้ render (NavbarStyle11, FooterPremiumSumo, Announcement6, LatestWinners2/Premium, PopularGamesStrip, Faq*, FloatingBadge variants ฯลฯ) ยังเป็นของเก่า = drift ที่คาดไว้ ไม่ลบ; ContentBox3Three รีธีมม่วงไว้แล้วแต่รอบนี้ไม่ได้ render (เป็น inventory พร้อมใช้)

### แก้เพิ่ม (ตาม feedback ผู้ใช้ 2026-07-15): จำกัดการใช้ ContentBoxSevenThree + วางแบนเนอร์ใน ContentBox คอลัมน์เดียว

**กฎใหม่ (บันทึกลง SKILL.md แล้ว — Phase 1 + Phase 2):**
- `ContentBoxSevenThree*` (ทั้ง family) ใช้ได้ **มากสุด 2 ครั้ง/รีแบรนด์** (ถ้าบทความน้อยใช้ 1 ครั้ง) — สุ่ม slide มา 2 รูปที่เข้ากับ section จริง ที่เหลือปล่อยว่างได้
- section อื่น ๆ **เน้น `ContentBox*` คอลัมน์เดียว + `ContentBoxTwo*`** ไม่ใช่ยัด SevenThree ทุกอัน
- `banner2/3/4` = รูปประกอบ ให้ใส่ **ในกล่อง `ContentBox` คอลัมน์เดียว** แบบ inline + resize คุมความกว้าง (`max-w-2xl` ฯลฯ) ไม่ใช่แถบเต็มจอ ไม่ใช่ hero ไม่ใช่คอลัมน์ SevenThree — และใช้เฉพาะไฟล์ของ asset ชุดปัจจุบัน (banner3.png เก่ากว่า banner1/2 = leftover ข้าม)

**สิ่งที่แก้ใน FUNBEYOND ให้ตรงกฎ:** เดิมใช้ SevenThree 4 ครั้ง (slide1–4) + banner2 เป็นแถบเต็มกว้าง → ปรับเป็น
- SevenThree **2 ครั้ง**: `ContentBoxSevenThree` + **slide3** (ใบรับรอง), `ContentBoxSevenThreePremium` + **slide2** (ผลทดสอบ)
- section เดี่ยว: H1 intro=`ContentBox`, ทำความรู้จัก=`ContentBoxPremium`, คำวิจารณ์=`ContentBoxCyberCut`, สมัคร=`ContentBoxNeumorphism` (มี **banner2** inline `max-w-2xl` + ปุ่ม LINE) + `ContentBoxTwo` ผ่าน `LoginRtpSection`
- retheme เพิ่ม `ContentBoxCyberCut` (เดี่ยว) น้ำเงิน→ม่วง; `ContentBoxNeumorphism` เป็นโทนกลางอยู่แล้วไม่ต้องแก้
- slide1/slide4 ไม่ใช้เป็นรูปประกอบ SevenThree แล้ว (ยังโผล่ใน SmoothCarousel ซึ่งเป็น widget วนรูปโปรฯ ต่างหาก — ปล่อยตามเดิม)

**ทดสอบ:** `npm run build` ผ่าน (9 หน้า); grep `dist/index.html`: SevenThree opening tag = 2, รูปประกอบ = slide2+slide3, banner2 inline `max-w-2xl`, hero=banner1, HENGJUD/MARANG/comment/blue-in-class = 0, H1 + 5 docx H2 ครบตามลำดับ

### แก้เพิ่ม (feedback ผู้ใช้): ความกว้างกล่องไม่เท่ากัน
`ContentBox`/`ContentBoxSevenThree`/`ContentBoxSpecial` ใช้ `max-w-[1400px]` แต่ `ContentBoxPremium`/`ContentBoxNeumorphism`/`ContentBoxCyberCut` ใช้ `max-w-7xl` (1280px) → กล่องแคบกว่า ไม่ align กัน แก้ทั้ง 3 ไฟล์เป็น `max-w-[1400px]` ให้เท่ากันทั้งหน้า (มีแค่ index ที่ใช้ ปลอดภัย)
- ผู้ใช้แก้ section "ผลทดสอบ" เองจาก SevenThreePremium+slide2 → `ContentBoxNeumorphism` + FeatureHighlights (SevenThree เหลือ 1 ครั้ง = ใบรับรอง+slide3) → ลบ import ที่ค้าง (`ContentBoxSevenThreePremium`, slide2/imgPerformance) ออก
- `npm run build` ผ่าน (9 หน้า), ทุกกล่อง max-w-[1400px] = 6/6

### แก้เพิ่ม (feedback ผู้ใช้): รีแบรนด์หน้าอื่นให้ครบ + Announcement ตรงกับ index
เดิม index เสร็จแล้วแต่หน้าอื่นยังเป็น HENGJUD365 (ตอนแรกระบุว่า out of scope) — ผู้ใช้สั่งให้ตามไปแก้ให้ครบ และเพิ่มกฎนี้ลง SKILL.md (Phase 4.5 ใหม่: "รีแบรนด์ทุกหน้า ไม่ใช่แค่ index" + เช็ก Announcement/chrome ให้ตรง index)

**หน้าที่แก้ (6):**
- `contact-us`, `promotion`, `ทางเข้า`, `ทดลองเล่น` (ใช้ MainLayout → nav/footer/hero เป็น Cyber/ม่วง อยู่แล้ว): เปลี่ยน `Announcement6` → **`AnnouncementCyber`** (ตรงกับ index), แก้ชื่อแบรนด์ HENGJUD365→FUNBEYOND (title/desc/h1/schema/alt), retheme `blue-*`→`purple-*` + `#0b1633`→`#0a001a` + `#93c5fd/#2563eb` gradient → ม่วง + `rgba(37,99,235)`→`rgba(157,78,221)` (promotion/ทางเข้า มีสีน้ำเงิน)
- `login`, `register` (standalone HTML ไม่ใช้ MainLayout, ธีมด้วย raw hex/rgba ใน `<style>` — grep `blue-[0-9]` จับไม่เจอ): แก้ `.brand-identity`/title HENGJUD365→FUNBEYOND, `--brand-red:#2563eb`→`#9d4edd`, `rgba(37,99,235)`/`rgba(0,243,255)`→`rgba(157,78,221)`

**Announcement ทั้งไซต์ตรงกัน:** index ส่ง `message` prop = ข้อความเดียวกับ default ของ `AnnouncementCyber` พอดี → หน้าอื่นเรียก `<Announcement />` เปล่า ๆ ก็ได้ข้อความ FUNBEYOND ชุดเดียวกัน สไตล์ ticker ม่วงเหมือนกันหมด

**ยกเว้นตามตั้งใจ:** `แนวทาง.astro`, `ตรวจหวย.astro` = หน้าหวย ธีม Huay (แดง/ทอง) + `AnnouncementHuay` — คงธีมไว้ (grep แล้วไม่มีชื่อแบรนด์เก่า HENGJUD=0) ไม่บังคับเป็นม่วง

**ทดสอบ:** `npm run build` ผ่าน (9 หน้า); `grep -rl HENGJUD dist/` = **ไม่เหลือเลยทุกหน้า**, ไม่มี blue ใน class attr ทั้ง dist, ทุกหน้า casino ใช้ AnnouncementCyber ม่วงตรงกัน

### แก้เพิ่ม (feedback ผู้ใช้ 2026-07-15): เก็บตก slogan HENGJUD ที่ contact-us + ยืนยัน exception หน้าหวย (Var99) เป็น inventory

**เก็บตก contact-us:** รอบ "รีแบรนด์หน้าอื่น" ก่อนหน้าเปลี่ยน literal `HENGJUD365`→FUNBEYOND แล้ว แต่ **สโลแกน "ฝากถอนออโต้ จ่ายจริง เฮงทุกสปิน"** (เฮง = รากคำ HENGJUD ในภาษาไทย) หลุด grep เพราะ Phase 5 grep หา "HENGJUD" (อังกฤษ) ไม่ครอบคำไทย → ค้างใน h1, ContactPage JSON-LD `name`/`description`, meta `description` แก้ 4 จุดเป็นคอปปี้ FUNBEYOND (`ติดต่อ FUNBEYOND ทีมงานดูแลตลอด 24 ชม.` / `ติดต่อทีมงาน FUNBEYOND ดูแลตลอด 24 ชม. ผ่าน LINE Official`) + แก้บั๊ก attribute `title="..." ,description=...` (คอมมาเกินหน้า `description`) → `description=...`
- ไฟล์: `src/pages/contact-us.astro` (4 จุด + comma)
- ทดสอบ: `npm run build` ผ่าน (9 หน้า); `grep -c "เฮงทุกสปิน\|HENGJUD" dist/contact-us/index.html` = 0; h1 เดียว = FUNBEYOND; JSON-LD/meta = FUNBEYOND

**บทเรียน (ควรใส่ Phase 5):** grep หา old brand ใน Phase 5 ต้องรวม **รากคำ/สโลแกนภาษาไทย** ด้วย (เช่น "เฮง" ของ HENGJUD) ไม่ใช่แค่ literal อังกฤษ — leftover แบบสโลแกนจะหลุด grep ตัวอังกฤษ

**Exception หน้าหวย = inventory (ยืนยันตาม feedback ผู้ใช้, choice ข):** `ตรวจหวย.astro`, `แนวทาง.astro` **ตั้งใจคงแบรนด์ Var99 + เนื้อหาหวย + ธีม Huay ไว้ทั้งหมด** ไม่ sweep เป็น FUNBEYOND — เพราะเป็น vertical หวยคนละเจ้า เก็บเป็น inventory ไว้ดึงมาใช้ (พร้อม wire เข้า navbar) เฉพาะตอน rebrand แบรนด์หวย ไม่เกี่ยวกับ FUNBEYOND (สล็อต/คาสิโน) ยกเว้นทั้ง **hue และชื่อ Var99** ของตัวเอง (กว้างกว่าที่ Phase 4.5 ข้อ 5 เขียนว่า "ยกเว้นแค่ธีม") — ยังยืนยันไม่มีชื่อ casino เก่า HENGJUD บนหน้าเหล่านี้ (=0); ที่คงไว้คือ Var99 = identity หวยของมันเอง

**ไม่ได้ทำ (optional):** rename CSS var `--brand-red`/`--brand-pink` ใน `login`/`register` — ค่าเป็นม่วง `#9d4edd` ถูกแล้ว ชื่อ var สื่อผิด (zero-visual) เว้นไว้ตามที่ผู้ใช้ยังไม่ขอ

---

## 2026-07-15 — รีแบรนด์ FUNBEYOND → 999LORD (blue/red neon-cyber)

**เป้าหมาย:** รีแบรนด์+รีธีมทั้งไซต์เป็น "999LORD" (โลโก้อินทรี+มงกุฎ+โพดำ "ACE FAIRGAMES UNION") พร้อม real url `https://www.999lord-review.com`

**พาเลตต์:** น้ำเงินไฟฟ้า (primary, `blue-*`) + ไฮไลต์นีออน `cyan-*`/`sky-*` + แดง/คอรัล (accent, `red-*`) บนพื้นเนวี่เข้ม (`#050d16`/`#03071c`/`#020617`/`#0b1633`) — แทนที่ม่วง+ทองของ FUNBEYOND
**mapping:** `purple/violet/fuchsia-*`→`blue-*`; `#0a001a`ฯลฯ→navy hex; `rgba(157,78,221)`→`rgba(37,99,235)`; ทอง/เหลือง (accent เดิม) → **หัวข้อ=cyan→blue gradient, CTA/badge/divider/เงิน=red** `rgba(239,68,68)`; คงสี semantic (LINE เขียว, เขียว success/live, สีธนาคาร, ส้ม TrueMoney/Habanero)

**docx (`src/assets/content.docx`) = H1 + 8×H2 (flat ไม่มี H3):** ครบทุกหัวข้อ เรียงตามเอกสาร:
1. H1 → `ContentBox` + ปุ่ม CTA (login/register)
2. H2 ภาพรวมเว็บไซต์ → `ContentBoxPremium`
3. H2 รีวิวโครงสร้าง/ฟีเจอร์ → `ContentBoxSevenThree` + **slide1** (โครงสร้าง/ฟีเจอร์) [SevenThree #1]
4. H2 ฟีเจอร์จุดเด่นเทียบคู่แข่ง → `ContentBoxCyberCut`
5. H2 รวมค่ายสล็อต (PG/Pragmatic/JILI/Habanero/CQ9) → `ContentBoxNeumorphism` → `ProviderGrid` → `GameRankingBoard`
6. H2 ระบบอัตโนมัติ Auto System → `ContentBoxSevenThree` + **slide4** (Auto System) [SevenThree #2] → `LatestWinners`
7. H2 ช่องทางเข้า/ตรวจสอบเว็บไซต์ → `ContentBoxFloatingBadge` (รูปทรงใหม่)
8. H2 มาตรฐานความปลอดภัย SSL/HTTPS → `ContentBox` → `ReviewCardSumo` + `SmoothCarousel`
9. H2 ขั้นตอนการสมัคร + เตรียมข้อมูล → `ContentBox` (2-col: สิ่งที่ควรเตรียม 3 ข้อ / ขั้นตอน 6 ข้อ เป็น `<ul>/<ol>` ไม่ใช่ heading) → `LoginRtpSection`

**การแมปรูป:** banner1=hero(MainLayout); slide1=โครงสร้าง(SevenThree#1); slide4=auto(SevenThree#2); slide2+slide3=SmoothCarousel widget. **banner2 = ของเก่า FUNBEYOND (โปรฯคืนยอดเสีย 5% โลโก้ funbeyond ม่วง/ทอง) → ข้าม ไม่ใช้เป็นรูปประกอบ**; banner3 เก่ากว่า (2026-07-12) = leftover ข้าม → รอบนี้ไม่มี banner ประกอบที่ valid จึงไม่ใส่รูป inline (ตามกฎ skill)

**Variant rotation (before → after) — ห้ามแบรนด์ถัดไปใช้ตัว "after" ซ้ำ:**
- Navbar: `NavbarCyber` → **`NavbarPremium`** (pill โค้งมน ต่างจาก clip-path เหลี่ยมของ Cyber)
- Footer: `FooterCyber` → **`FooterPremium`** (rounded-t-3rem)
- Announcement: `AnnouncementCyber` → **`Announcement4`** (LIVE ticker, badge แดง+บาร์น้ำเงิน, ตั้ง default message = 999LORD)
- LatestWinners: `LatestWinnersCyber` → **`LatestWinnersPremium`** (เป็นน้ำเงินอยู่แล้ว → เปลี่ยนชื่อ HENGJUD→999LORD + ทอง→แดง)
- ContentBox mix: (FUNBEYOND=plain+Premium+SevenThree×1+Neumorphism+CyberCut+**Special**+**FeatureHighlights**) → **999LORD=plain+Premium+SevenThree×2+CyberCut+Neumorphism+FloatingBadge**; ตัด Special + FeatureHighlights ออก, เพิ่ม **FloatingBadge** เป็นรูปทรงใหม่ (FUNBEYOND ไม่ได้ใช้) + SevenThree ตัวที่ 2 → shape-mix ต่างชัด
  - **หมายเหตุ:** ไม่ใช้ `ContentBox3Three` เพราะไม่มี section ไหนใน docx เป็น 3-parallel-points จริง (security เป็น prose ย่อหน้าเดียว ไม่ใช่ bullet 3 ข้อ) — ไม่ยัด 3Three แบบสร้าง sub-heading เกินจริง; ไม่ใช้ FeatureHighlights ด้วยเหตุผลเดียวกัน (registration lists เป็น label ล้วน ไม่มี description)
  - **FloatingBadge:** ไฟล์เป็นน้ำเงิน+bug-fixed อยู่แล้ว (`w-[92%] max-w-2xl` + `pt-16`, ไม่มี `whitespace-nowrap`) → ปรับหัวข้อทอง→cyan, badge border ทอง→แดง, `max-w-7xl`→`max-w-[1400px]` ให้เท่ากล่องอื่น; ยืนยัน dist ไม่มี whitespace-nowrap ที่ badge (2 hit ที่เหลือ = ticker Announcement4 ตั้งใจ)

**URL (3 จุด → `https://www.999lord-review.com`):** `astro.config.mjs` site, `public/robots.txt` Sitemap, `src/pages/index.astro` webSiteSchema.url (string literal)

**ไฟล์ที่แก้ — chrome/layout:** `MainLayout.astro` (import NavbarPremium/FooterPremium, hero=banner1(เดิมถูกแล้ว), brand strings/apple-title/og_site_name=999LORD, default title/desc), `NavbarPremium`/`FooterPremium` (QQ882→999LORD + retheme น้ำเงิน/แดง), `Announcement4` (retheme + message), `LatestWinnersPremium` (HENGJUD→999LORD, ทอง→แดง, ลบ HTML comment 3 จุด)
**ไฟล์ที่แก้ — retheme ม่วง/ทอง→น้ำเงิน/แดง + brand:** `ContentBox`, `ContentBoxPremium`, `ContentBoxSevenThree`, `ContentBoxCyberCut`, `ContentBoxNeumorphism`, `ContentBoxFloatingBadge`, `ContentBoxTwo`, `LoginRtpSection`, `ProviderGrid`, `GameRankingBoard`, `ReviewCardSumo2`, `SmoothCarousel`, `Navfoot` (ทั้งหมด FUNBEYOND→999LORD)
**heading:** docx flat → H1(1) + H2(8 section) เรียงตามเอกสารครบ; widget h3 (ProviderGrid card, GameRanking, Review author, LoginRtp "ยินดีต้อนรับกลับ") = sub-item ภายใน widget คงไว้เหมือน FUNBEYOND

**หน้าอื่น (Phase 4.5) — รีแบรนด์ครบ:**
- `contact-us` (Announcement4, ContactPage schema+meta+h1+alt 999LORD, ปุ่มทอง→แดง), `promotion` (Announcement4, slide1-4 .png มีจริง, h1+4 alt+border รูป+ปุ่ม, .text-purple-gradient hex→blue), `ทางเข้า` (Announcement4, 2 ปุ่ม→น้ำเงิน/แดง), `ทดลองเล่น` (Announcement4, ปุ่มเล่นเลย→แดง) — ทั้งหมดใช้ MainLayout จึงได้ nav/footer/hero 999LORD อัตโนมัติ
- `login`/`register` (standalone HTML ไม่ใช้ MainLayout, ธีม CSS var ใน `<style>`): title+`.brand-identity` FUNBEYOND→999LORD, `--brand-red:#9d4edd`→`#ef4444`, `--brand-pink:#fbbf24`→`--brand-blue:#3b82f6`, `rgba(157,78,221)`→น้ำเงิน/แดง
- **Announcement ทั้งไซต์ตรงกัน:** ทุกหน้า casino ใช้ `Announcement4`; index ส่ง message ตรงกับ default ของ Announcement4 → หน้าอื่นเรียกเปล่าก็ได้ข้อความ 999LORD ชุดเดียวกัน

**ยกเว้น (inventory คงไว้):** `แนวทาง.astro`, `ตรวจหวย.astro` = หวย Var99 ธีม Huay (แดง/ทอง) + `AnnouncementHuay` — คงเนื้อหา/ชื่อ Var99/ธีมไว้; แชร์ `MainLayout` จึง inherit nav/footer/hero + meta default (og_site_name/description) ของแบรนด์ casino ปัจจุบัน (= 999LORD ตอนนี้ เหมือนที่เคย inherit FUNBEYOND) — เป็น drift ที่มีมาก่อน ไม่ใช่บั๊ก ไม่แตะ; ยืนยันไม่มีชื่อ casino เก่า (FUNBEYOND/HENGJUD) หลงเหลือ = 0

**การทดสอบ (Phase 5):** `npm run build` ผ่านสะอาด (9 หน้า); `grep -rlE "FUNBEYOND|funbeyond|HENGJUD|QQ882|TEENOI|MARANG|เฮงทุกสปิน" dist/` = **0 ทุกหน้า**; purple/yellow/violet/fuchsia ใน class attr = **0** ทุกหน้า casino (ที่เหลือใน `<style>` bundle = inventory/ไม่ render = noise ที่คาดไว้); `<!--` ใน dist = 0; undefined/NaN/[object Object] = 0; hero=banner1; slide1+slide4 = SevenThree, slide2+slide3 = carousel (ใช้ครบ 4); URL 999lord-review.com ใน schema/canonical/og/sitemap, ไม่มี funbeyond; H1=1 + 8 docx H2 เรียงถูกลำดับครบ; FloatingBadge badge = `w-[92%] max-w-2xl` ไม่มี overflow

## รีแบรนด์: 999LORD → MAFIA168 (2026-07-16)

**เป้าหมาย:** เปิดตัวแบรนด์ MAFIA168 (คู่มือการใช้งานเว็บ) จาก asset drop 2026-07-16 21:17 (logo.webp, banner1.png, bg.png, slide1-4.png, content.docx) + user ให้ **real URL = mafia168-guide.com** ชัดเจน — ทำแบบ 2-agent ขนานตาม SKILL (P0 spec → P1 shared chrome → P2 fan-out A/B → P3 merge+verify) มีเหตุแทรก: Agent A โดน API error กลางทาง + user เน็ตหลุด — resume agent เดิมสำเร็จ ไฟล์ไม่ชนกัน (Write ของ orchestrator ถูก reject เพราะ agent เขียน index.astro ไปก่อนพอดี)

**Palette:** น้ำเงิน/แดง (999LORD) → **เขียวนีออน/ไลม์ + เงินเมทัลลิก + ทอง accent** (ตามโลโก้/แบนเนอร์ MAFIA168): `blue-*`→`green-*`, `cyan-300`→`lime-300`, `red-*` identity→`green/lime`, `#050d16`→`#03120a`, `#0b1633`→`#06170d`, `rgba(37,99,235)`→`rgba(34,197,94)`, `rgba(239,68,68)`→`rgba(132,204,22)`; คงไว้: LINE `#00B900`, สีธนาคาร (รวม `text-purple-500` ของ SCB ใน FooterStyle3), ทอง `#fef08a/#eab308` ใน LatestWinners3/ปุ่ม CTA footer

**docx = H1(1) + H2(5) + H3(4 จริง: โปรฯ 0.8%/0.3%, วิธีฝาก/ถอน)** — แบรนด์แรกที่ docx มี H3 hierarchy จริง จึงคง h3 เฉพาะ 4 ตัวนี้ และ normalize card-name h3 ของ widget (ProviderGrid/GameRanking/Review/LoginRtp) เป็น `<p>` ทั้งหมด (ต่างจากแนวทาง 999LORD ที่คง widget h3 ไว้)

**Mapping (docx order เป๊ะ):**
1. H1 คู่มือการใช้งาน → `ContentBoxSpecial` (as h1) + ปุ่ม login/register
2. H2 โปรโมชั่น → `ContentBoxSevenThreeNeumorphism` + **slide2** (คืนยอดเสีย) [SevenThree #1] → H3×2 → `ContentBoxTwoNeumorphism` (คอลัมน์ h2→h3)
3. H2 ฝากถอน → `ContentBoxTwoCyberCut` (เพิ่ม main-title h2 + intro slot ในไฟล์; คอลัมน์ h2→h3; ขั้นตอนเป็น ol) → `LatestWinners3`
4. H2 สมัครสมาชิก → `ContentBox` (plain, step cards เป็น p ไม่ใช่ heading) + CTA /register
5. H2 คู่มือการเล่นเกม → `ContentBoxSevenThreeNeumorphism` + **slide1** (รูปคู่มือ) [SevenThree #2] + bullet 6 ข้อ → `ProviderGrid` + `GameRankingBoard`
6. H2 ติดต่อไลน์ → `ContentBox` (plain) + bullet 6 ข้อ + ปุ่ม LINE → `ReviewCardSumo2` + `SmoothCarousel` + `LoginRtpSection` + `Navfoot`

**การแมปรูป:** banner1=hero (MainLayout ล็อก banner1 อยู่แล้ว); slide2=SevenThree#1; slide1=SevenThree#2; slide3/slide4 ไม่ใช้ใน SevenThree (ตั้งใจ — โผล่เฉพาะใน SmoothCarousel widget ที่ import slide1-4 ครบ); **banner2.png (2026-07-15) / banner3.png (2026-07-12) เก่ากว่า drop = ของแบรนด์ก่อน ข้ามทั้งคู่ ไม่มีรูปประกอบ inline**

**Variant rotation (before → after) — ห้ามแบรนด์ถัดไปใช้ตัว "after" ซ้ำ:**
- Navbar: `NavbarPremium` → **`NavbarStyle6`** (notch logo + left rail sidebar; เดิมเป็น KIKI49 แดงเข้ม → เขียว)
- Footer: `FooterPremium` → **`FooterStyle3`** (CTA card ลอย + quick links + payment grid; เดิม HYDRA888 แดง → เขียว; h2/h3 ในไฟล์ normalize เป็น p ทั้งหมด)
- Announcement: `Announcement4` → **`Announcement3`** (megaphone ticker; ทอง→เขียว/ไลม์; default message = MAFIA168 + URL)
- LatestWinners: `LatestWinnersPremium` → **`LatestWinners3`** (cyan→เขียว/ไลม์ ทั้ง JSX และ JS template string; ไม่มีชื่อแบรนด์ hardcode)
- ContentBox mix: (999LORD=plain+Premium+SevenThree×2+CyberCut+Neumorphism+FloatingBadge) → **MAFIA168=Special(H1)+SevenThreeNeumorphism×2+TwoNeumorphism+TwoCyberCut+plain×2** — เลิกใช้ Premium/CyberCut/FloatingBadge เดี่ยว, นำด้วย Two-column family + Neumorphism shape ที่ 999LORD ไม่ได้ใช้

**URL (3 จุด → `https://www.mafia168-guide.com`):** `astro.config.mjs` site, `public/robots.txt` Sitemap, `src/pages/index.astro` webSiteSchema.url (string literal) — user ให้ URL จริงมากับคำสั่ง จึงแก้ครบตามกฎ (ใส่ www ตาม convention เดิมของ repo)

**ไฟล์ที่แก้ — P1 shared chrome (orchestrator, commit แยกเป็น baseline):** `MainLayout.astro` (import Style6/Style3, meta/OG/apple-title/default title-desc = MAFIA168), `NavbarStyle6`, `FooterStyle3`, `Navfoot`, `ContentBox`, `Announcement3`, `astro.config.mjs`, `public/robots.txt`
**ไฟล์ที่แก้ — Agent A (index + 11 components):** `index.astro` (เขียนใหม่ทั้งหน้า + schema 3 ก้อน), `ContentBoxSpecial` (เพิ่ม title/as prop), `ContentBoxTwoNeumorphism`, `ContentBoxTwoCyberCut` (เพิ่ม main title + intro slot), `ContentBoxSevenThreeNeumorphism`, `ContentBoxTwo` (คอลัมน์ h2→p widget), `LoginRtpSection` (999LORD×2→MAFIA168, h3→p), `ProviderGrid` (h2 brand + h3 card→p + class ใน filter script), `GameRankingBoard` (h3→p), `LatestWinners3`, `ReviewCardSumo2` (รีวิว 999LORD→MAFIA168, h3→p), `SmoothCarousel` (alt + slide1-4.png ตรง extension)
**ไฟล์ที่แก้ — Agent B (หน้าอื่น 6 หน้า):** `promotion` (Announcement3, h1/alt×4/gradient hex ใน style, ปุ่ม→เขียว), `contact-us` (Announcement3, ContactPage schema, ปุ่ม→lime), `ทดลองเล่น`/`ทางเข้า` (Announcement3, title/ปุ่ม→เขียว/ไลม์), `login`/`register` (standalone: `.brand-identity`, CSS var `--brand-red:#ef4444`→`--brand-lime:#a3e635`, `--brand-blue:#3b82f6`→`--brand-green:#22c55e`, rgba ทุกจุด; ไม่แตะ targetUrl affiliate)

**Announcement ทั้งไซต์ตรงกัน:** ทุกหน้า casino ใช้ `Announcement3`; index ส่ง message = default ของ Announcement3 → หน้าอื่นเรียกเปล่าได้ข้อความ MAFIA168 ชุดเดียวกัน

**ยกเว้น (ตั้งใจไม่แตะ):** `แนวทาง.astro`, `ตรวจหวย.astro` + `AnnouncementHuay`/`ContentBoxHuay` = หวย Var99 ธีม Huay (แดง/ทอง) — grep ไม่มีชื่อ casino เก่า = ไม่แก้แม้แต่บรรทัดเดียว; inventory variants เก่า (Announcement4, NavbarPremium, FooterPremium, LatestWinnersPremium, ContentBoxPremium/CyberCut/FloatingBadge ฯลฯ) ยังเป็นสี/ชื่อ 999LORD = expected drift ไม่ลบ; **contact-us contactPoint ชี้ `tinyurl.com/linepigpg` ขณะ `/line` redirect ใน config เป็น `tinyurl.com/suhng`** — drift เก่าที่มีมาก่อน user ไม่ได้ให้ลิงก์ LINE ใหม่ จึงไม่เดาแก้ (ฝากไว้ให้เจ้าของตัดสิน)

**การทดสอบ (Phase 5 — build เดียว):** `npm run build` ผ่านสะอาด 9 หน้า; grep dist ทุกหน้า: ชื่อแบรนด์เก่า (999LORD/HENGJUD/FUNBEYOND/QQ882/MARANG/KIKI49/HYDRA888) = **0**; old hue ใน class attr = **0 ทุกหน้า casino** (ตรวจหวย/แนวทาง มี red/gold = ธีม Huay ตั้งใจ; `text-purple-500` = SCB); `<!--` = 0 ทุกหน้า; undefined/NaN/[object Object] = 0; hero = banner1.avif; banner2/3 ไม่โผล่ใน dist เลย; h1=1, h2 = 5 docx เรียงถูกลำดับ + 4 widget (Winners/Provider/Ranking/Review), h3 = 4 ตัวจาก docx เท่านั้น; whitespace-nowrap เหลือ 2 จุดที่ตั้งใจ (ticker Announcement3 + ปุ่มสั้น footer) ไม่ใช้ FloatingBadge รอบนี้จึงไม่มี badge-overflow ให้เช็ก; URL mafia168-guide.com ครบใน schema/canonical/og/sitemap

### แก้เพิ่ม (2026-07-16): เอา LoginRtpSection ออกจาก index
ผู้ใช้สั่งถอด section ล็อคอิน (login widget + RTP table) ออกจากหน้าแรก — ลบ import + `<LoginRtpSection />` ใน `index.astro` (จุดเดียวที่ render); ตัวไฟล์ `LoginRtpSection.astro` + `ContentBoxTwo.astro` คงไว้เป็น inventory (รีธีมเขียว MAFIA168 แล้ว พร้อมใช้); build ผ่าน 9 หน้า, grep dist ไม่มี "ยินดีต้อนรับกลับ"/LoginRtp เหลือ
