# GitHub Par Code Push Karne Ka Tarika

## ✅ Step 1: GitHub Par Repository Create Karein

1. **Browser mein jao**: https://github.com
2. **Login karo** (ds95745@gmail.com se)
3. **Top right corner** mein **"+"** button click karo
4. **"New repository"** select karo
5. **Repository details fill karo**:
   - **Repository name**: `booking-tracking-app` (ya apna naam)
   - **Description**: "Flutter Booking & Tracking App with Clean Architecture"
   - **Public** ya **Private** select karo
   - ⚠️ **IMPORTANT**: "Add a README file" ko **UNCHECK** karo (kyunki hum already README hai)
   - "Add .gitignore" ko bhi **UNCHECK** karo
   - "Choose a license" ko bhi **UNCHECK** karo
6. **"Create repository"** button click karo

## ✅ Step 2: Terminal Mein Ye Commands Run Karein

GitHub repository create karne ke baad, GitHub aapko commands dikhayega. Ye commands run karein:

```bash
# Remote add karo (apne repository URL se replace karo)
git remote add origin https://github.com/ds95745/booking-tracking-app.git

# Verify karo
git remote -v

# Code push karo
git push -u origin main
```

## 🔐 Step 3: Authentication (Agar Required)

Agar push karte waqt username/password maange:

### Option A: Personal Access Token (Recommended)

1. **GitHub Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **"Generate new token (classic)"** click karo
3. **Note**: "Booking App Token" (ya koi naam)
4. **Expiration**: Apne hisaab se (90 days recommended)
5. **Permissions**: `repo` checkbox select karo
6. **"Generate token"** click karo
7. **Token copy karo** (ye sirf ek baar dikhega!)

**Push karte waqt:**
- **Username**: `ds95745`
- **Password**: `<your-copied-token>` (token paste karo)

### Option B: GitHub CLI (Agar Installed Hai)

```bash
gh auth login
gh repo create booking-tracking-app --public --source=. --remote=origin --push
```

## 📋 Complete Commands (Copy-Paste Ready)

```bash
# 1. Remote add karo
git remote add origin https://github.com/ds95745/booking-tracking-app.git

# 2. Verify remote
git remote -v

# 3. Push karo
git push -u origin main
```

## ✅ Success Message

Agar sab kuch sahi hai, to aapko ye dikhega:
```
Enumerating objects: 120, done.
Counting objects: 100% (120/120), done.
Writing objects: 100% (120/120), done.
To https://github.com/ds95745/booking-tracking-app.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

## 🔍 Troubleshooting

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/ds95745/booking-tracking-app.git
```

### Error: "repository not found"
- GitHub par repository create kiya hai ya nahi check karo
- Repository name sahi hai ya nahi verify karo
- Access rights check karo

### Error: "authentication failed"
- Personal access token use karo (password ki jagah)
- Token expire to nahi hua check karo

---

**Agar koi problem aaye, to error message share karo!**

