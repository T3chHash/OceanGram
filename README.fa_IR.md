[English](/README.md) | [فارسی](/README.fa_IR.md)

<div align="center" dir="rtl">

# 🌊 اوشن‌گرام (OceanGram)

[![Version](https://img.shields.io/badge/نسخه-1.0.0-blue.svg)](https://github.com/T3chHash/OceanGram)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Ubuntu-20.04%20%7C%2022.04%20%7C%2024.04-orange.svg)](#نصب-یک-خطی-روی-اوبونتو)

**پیام‌رسان ابری، امن، سبک و سلف‌هاستد مدرن با انیمیشن‌های روان و طراحی اقیانوسی**

</div>

---

## ⚡ نصب یک‌خطی روی سرور اوبونتو (Ubuntu / Debian)

برای نصب سریع و بدون دردسر OceanGram روی سرور اوبونتو کافیست دستور زیر را با دسترسی روت اجرا کنید:

```bash
curl -fsSL https://raw.githubusercontent.com/T3chHash/OceanGram/main/install.sh | sudo bash
```

### این اسکریپت چه کارهایی انجام می‌دهد؟
- 🐳 نصب خودکار و بهینه‌سازی داکر (Docker) و Docker Compose
- 🔐 تنظیم و راه‌اندازی گواهی امنیتی SSL / HTTPS
- 🌐 پیکربندی کامل Nginx Reverse Proxy برای ترافیک وب، وب‌سوکت و رویدادهای زنده
- ⚙️ ایجاد دستور خط فرمان `oceangram` برای مدیریت فوق‌العاده راحت
- 🛡️ ایجاد کلیدها و توکن‌های فوق امن رمزشده برای دیتابیس و نشست‌ها

### دستورات مدیریت سرور:
```bash
oceangram status    # بررسی وضعیت سرویس‌ها و کانتینرها
oceangram logs      # مشاهده زنده لاگ‌های سرور
oceangram restart   # راه‌اندازی مجدد سرور
oceangram update    # دریافت آخرین آپدیت‌ها و بازسازی خودکار
```

---

## ✨ ویژگی‌های برجسته و بازطراحی:

- 🌊 **طراحی اقیانوسی مدرن**: پالت رنگی فیروزه‌ای و نیلی اقیانوس، جلوه‌های شیشه‌ای (Glassmorphic)، حاشیه‌های درخشان و امواج زنده
- 🎬 **انیمیشن‌های نرم و بی‌نقص**: باز شدن روان پیام‌ها، افکت‌های تپش وضعیت آنلاین، ریپل کلیک و انتقال‌های بی‌صدا
- 💬 **ارتباطات کامل**: گفتگوهای دونفره، گروه‌ها، کانال‌های اطلاع‌رسانی و ارسال مدیا
- 📞 **تماس صوتی و تصویری WebRTC**: تماس فوق سریع نظیربه‌نظیر با امواج صوتی زنده
- 📁 **پردازش مدیا و فایل**: تبدیل فرمت ویدیوها، فشرده‌سازی عکس و ویس
- 📱 **پشتیبانی از PWA**: قابلیت نصب به عنوان اپلیکیشن روی موبایل و دسکتاپ
- 🇮🇷 **پشتیبانی بومی از زبان فارسی**: با فونت وزیرمتن و راست‌چین‌سازی استاندارد

---

## 🚀 راه‌اندازی دستی با داکر:

```bash
git clone https://github.com/T3chHash/OceanGram.git /opt/oceangram
cd /opt/oceangram
docker compose up -d --build
```

---

## 📜 لایسنس
توسعه یافته تحت مجوز [MIT](LICENSE).
