# GitHub Setup Instructions

## Step 1: Create GitHub Repository

1. GitHub par jao: https://github.com
2. Login karo (ds95745@gmail.com se)
3. Top right corner mein **"+"** button click karo
4. **"New repository"** select karo
5. Repository details fill karo:
   - **Repository name**: `booking-tracking-app` (ya koi bhi naam)
   - **Description**: "A production-ready Flutter application for booking and tracking deliveries using Clean Architecture"
   - **Visibility**: Public ya Private (apne hisaab se)
   - **⚠️ IMPORTANT**: "Initialize this repository with a README" ko **UNCHECK** karo (kyunki hum already README hai)
6. **"Create repository"** button click karo

## Step 2: Push Code to GitHub

Terminal mein ye commands run karo:

```bash
cd /Users/apple/tarcker

# GitHub repository URL add karo (apne repository URL se replace karo)
git remote add origin https://github.com/ds95745/booking-tracking-app.git

# Main branch ko set karo
git branch -M main

# Code push karo
git push -u origin main
```

**Note**: Agar pehli baar GitHub use kar rahe ho, to authentication ke liye GitHub token ya SSH key setup karna padega.

## Alternative: GitHub CLI se

Agar GitHub CLI installed hai:

```bash
gh repo create booking-tracking-app --public --source=. --remote=origin --push
```

## Authentication

Agar push karte waqt authentication error aaye:

1. **Personal Access Token** banayein:
   - GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - "Generate new token" click karo
   - Permissions: `repo` select karo
   - Token copy karo

2. Push karte waqt token use karo:
   ```bash
   git push -u origin main
   # Username: ds95745
   # Password: <your-token>
   ```

## Verify

Push ke baad GitHub repository page par jao aur verify karo ki sab files upload ho gayi hain.

---

**Repository ready hai! 🎉**

