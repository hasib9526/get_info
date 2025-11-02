# Backend Requirements for Web Deployment
# ওয়েব ডিপ্লয়মেন্টের জন্য ব্যাকএন্ড প্রয়োজনীয়তা

## Problem / সমস্যা

Your Flutter web app is hosted on GitHub Pages at:
- **https://hasib9526.github.io/get_info/** (HTTPS - Secure)

But your API is hosted at:
- **http://apps.bitopibd.com:8090/bimobapiv2/api** (HTTP - Not Secure)

**Browsers BLOCK HTTP requests from HTTPS websites for security.**

আপনার Flutter web app GitHub Pages এ host করা:
- **https://hasib9526.github.io/get_info/** (HTTPS - নিরাপদ)

কিন্তু আপনার API host করা:
- **http://apps.bitopibd.com:8090/bimobapiv2/api** (HTTP - অনিরাপদ)

**Browser নিরাপত্তার জন্য HTTPS website থেকে HTTP request block করে।**

---

## Solution / সমাধান

Your backend team MUST make these changes:
আপনার ব্যাকএন্ড টিমকে এই পরিবর্তন করতে হবে:

### Option 1: Enable HTTPS (Best Solution) ✅

**What backend team needs to do:**
1. Get an SSL/TLS certificate for `apps.bitopibd.com`
   - Free option: Let's Encrypt (https://letsencrypt.org/)
   - Paid option: Purchase from SSL provider
2. Configure the server to use HTTPS (port 443)
3. Change API URL from:
   - ❌ `http://apps.bitopibd.com:8090/...`
   - ✅ `https://apps.bitopibd.com/...` (remove port if using 443)

**ব্যাকএন্ড টিমকে যা করতে হবে:**
1. `apps.bitopibd.com` এর জন্য SSL/TLS সার্টিফিকেট নিতে হবে
   - বিনামূল্যে: Let's Encrypt (https://letsencrypt.org/)
   - টাকা দিয়ে: SSL provider থেকে কিনতে হবে
2. Server কে HTTPS ব্যবহার করার জন্য configure করতে হবে (port 443)
3. API URL পরিবর্তন করতে হবে

---

### Option 2: Add CORS Headers (Required for Web) ✅

Even with HTTPS, you need CORS headers. Backend must add these headers to API responses:

```
Access-Control-Allow-Origin: https://hasib9526.github.io
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Accept, Authorization
Access-Control-Allow-Credentials: true
```

**For ASP.NET Core (.NET):**

```csharp
// In Startup.cs or Program.cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddCors(options =>
    {
        options.AddPolicy("AllowFlutterWeb",
            builder => builder
                .WithOrigins("https://hasib9526.github.io")
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials());
    });
}

public void Configure(IApplicationBuilder app)
{
    app.UseCors("AllowFlutterWeb");
    // ... other middleware
}
```

**CORS header যোগ করতে হবে। Backend এ এই header গুলো add করতে হবে।**

---

## Testing After Backend Changes / ব্যাকএন্ড পরিবর্তনের পরে টেস্ট

After backend team makes changes:
ব্যাকএন্ড টিম পরিবর্তন করার পর:

1. Update `lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'https://apps.bitopibd.com/bimobapiv2/api';
   // Changed from http:// to https://
   ```

2. Rebuild and redeploy:
   ```bash
   flutter build web --release
   git add .
   git commit -m "Update API URL to HTTPS"
   git push
   ```

3. Wait 5 minutes for GitHub Actions to deploy

4. Test at: https://hasib9526.github.io/get_info/

---

## Alternative: Deploy Frontend on HTTP Server

If backend cannot add HTTPS, deploy frontend on HTTP server instead:
- ❌ Don't use GitHub Pages (HTTPS only)
- ✅ Use a custom server that supports HTTP
- ⚠️ Not recommended - HTTP is insecure

যদি ব্যাকএন্ড HTTPS add করতে না পারে, তাহলে frontend HTTP server এ deploy করুন:
- ❌ GitHub Pages ব্যবহার করবেন না (শুধু HTTPS)
- ✅ Custom server ব্যবহার করুন যা HTTP support করে
- ⚠️ সুপারিশ করা হয় না - HTTP অনিরাপদ

---

## Contact Information

**Backend Team Checklist:**
- [ ] Enable HTTPS/SSL certificate
- [ ] Add CORS headers to all API endpoints
- [ ] Test with: `curl -I https://apps.bitopibd.com/bimobapiv2/api/...`
- [ ] Inform frontend team when ready

**ব্যাকএন্ড টিম চেকলিস্ট:**
- [ ] HTTPS/SSL সার্টিফিকেট চালু করতে হবে
- [ ] সব API endpoint এ CORS header যোগ করতে হবে
- [ ] Test করতে হবে
- [ ] Frontend টিমকে জানাতে হবে যখন ready

---

## Summary / সারাংশ

**Current Status:** ❌ Web app doesn't work (API requests blocked)

**Required:** ✅ Backend team must enable HTTPS + CORS

**Timeline:** Usually takes 1-2 days for backend team to implement

**বর্তমান অবস্থা:** ❌ Web app কাজ করছে না (API request block হচ্ছে)

**প্রয়োজন:** ✅ ব্যাকএন্ড টিমকে HTTPS + CORS চালু করতে হবে

**সময়:** সাধারণত ব্যাকএন্ড টিমের জন্য ১-২ দিন লাগে
