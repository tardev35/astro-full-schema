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
