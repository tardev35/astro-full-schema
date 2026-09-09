export interface SiteAuthor {
  /** ชื่อที่แสดงเป็นผู้เขียน เว้นว่าง = ปิดฟีเจอร์ทั้งหมด */
  name: string;
  /** ตำแหน่ง/บทบาท เช่น "บรรณาธิการเนื้อหา" */
  jobTitle: string;
  /** ประวัติย่อ 1-2 ประโยค บอกว่าทำไมคนนี้ถึงเขียนเรื่องนี้ได้ */
  bio: string;
  /** URL โปรไฟล์ Gravatar เว้นว่าง = ไม่ผูกโปรไฟล์ภายนอก */
  profileUrl: string;
  /** true = ใส่ profileUrl ลง sameAs และทำชื่อเป็นลิงก์ */
  linkProfile: boolean;
}

export const SITE_AUTHOR: SiteAuthor = {
  name: "",
  jobTitle: "",
  bio: "",
  profileUrl: "",
  linkProfile: true,
};

export const hasAuthor = SITE_AUTHOR.name.trim().length > 0;

export const authorSameAs: readonly string[] =
  hasAuthor && SITE_AUTHOR.linkProfile && SITE_AUTHOR.profileUrl.trim() ? [SITE_AUTHOR.profileUrl.trim()] : [];

export const authorInitials = SITE_AUTHOR.name
  .trim()
  .split(/\s+/)
  .slice(0, 2)
  .map((w) => [...w][0] ?? "")
  .join("");

const avatarFiles = import.meta.glob<{ default: ImageMetadata }>("../assets/author.{webp,png,jpg,jpeg}", { eager: true });
const avatarKey = Object.keys(avatarFiles).sort()[0];

export const authorAvatar = avatarKey ? avatarFiles[avatarKey].default : null;
