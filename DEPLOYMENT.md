# GitHub Pages Deployment Guide
# গিটহাব পেজে ডিপ্লয় করার গাইড

## Your App Will Be Live At / আপনার অ্যাপ লাইভ হবে:
**https://hasib9526.github.io/get_info/**

---

## Step-by-Step Deployment / ধাপে ধাপে ডিপ্লয়মেন্ট

### Step 1: Push Code to GitHub / কোড গিটহাবে পুশ করুন

```bash
git add .
git commit -m "Add GitHub Pages deployment workflow"
git push origin app_without_login
```

### Step 2: Enable GitHub Pages / গিটহাব পেজ চালু করুন

1. আপনার GitHub repository তে যান: **https://github.com/hasib9526/get_info**
2. উপরে **Settings** ট্যাবে ক্লিক করুন
3. বাম সাইডবারে **Pages** এ ক্লিক করুন
4. **Source** এর নিচে **Deploy from a branch** সিলেক্ট করুন
5. **Branch** ড্রপডাউন থেকে **gh-pages** সিলেক্ট করুন
6. **/(root)** সিলেক্ট করুন
7. **Save** বাটনে ক্লিক করুন

### Step 3: Enable GitHub Actions / গিটহাব অ্যাকশন চালু করুন

1. আপনার repository তে **Actions** ট্যাবে যান
2. যদি "Workflows found in this repository" দেখান, তাহলে **Enable Actions** এ ক্লিক করুন
3. Workflow স্বয়ংক্রিয়ভাবে শুরু হবে

### Step 4: Wait for Deployment / ডিপ্লয়মেন্টের জন্য অপেক্ষা করুন

1. **Actions** ট্যাবে যান
2. "Deploy Flutter Web to GitHub Pages" workflow চেক করুন
3. সবুজ চেকমার্ক দেখার জন্য অপেক্ষা করুন (2-5 মিনিট)

### Step 5: Visit Your Live Website / আপনার লাইভ ওয়েবসাইট দেখুন

আপনার অ্যাপ এখন লাইভ:
**https://hasib9526.github.io/get_info/**

---

## Automatic Deployment / স্বয়ংক্রিয় ডিপ্লয়মেন্ট

এখন থেকে, যখনই আপনি কোড পুশ করবেন `app_without_login` বা `main` ব্রাঞ্চে, GitHub Actions স্বয়ংক্রিয়ভাবে:
1. Flutter web build করবে
2. GitHub Pages এ ডিপ্লয় করবে
3. ৫ মিনিটের মধ্যে লাইভ হবে

---

## Custom Domain (Optional) / কাস্টম ডোমেইন (ঐচ্ছিক)

যদি আপনার নিজের ডোমেইন থাকে (যেমন: www.yourcompany.com), তাহলে:

1. Settings > Pages এ যান
2. **Custom domain** এ আপনার ডোমেইন লিখুন
3. DNS সেটিংসে CNAME যুক্ত করুন

---

## Troubleshooting / সমস্যা সমাধান

### যদি অ্যাপ লোড না হয়:
1. GitHub Actions চেক করুন - সবুজ চেকমার্ক আছে কিনা
2. Settings > Pages এ গিয়ে দেখুন **gh-pages** branch সিলেক্ট করা আছে কিনা
3. ৫-১০ মিনিট অপেক্ষা করুন - GitHub Pages কখনো কখনো সময় নেয়

### যদি API কাজ না করে:
- নিশ্চিত করুন আপনার API endpoint HTTP/HTTPS সমর্থন করে
- Mixed content error এড়াতে HTTPS API ব্যবহার করুন

---

## Manual Deployment (Alternative) / ম্যানুয়াল ডিপ্লয়মেন্ট (বিকল্প)

যদি GitHub Actions ব্যবহার না করতে চান, ম্যানুয়ালি ডিপ্লয় করতে:

```bash
# Build the web app
flutter build web --release --base-href /get_info/

# Create .nojekyll file
touch build/web/.nojekyll

# Install gh-pages package (first time only)
npm install -g gh-pages

# Deploy to GitHub Pages
npx gh-pages -d build/web
```

---

## Support / সহায়তা

প্রশ্ন থাকলে GitHub Issues এ যোগাযোগ করুন:
**https://github.com/hasib9526/get_info/issues**
