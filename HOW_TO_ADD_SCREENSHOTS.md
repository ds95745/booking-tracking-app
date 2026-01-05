# 📸 Screenshots Kaise Add Karein

## Step 1: App Run Karein

```bash
# Android ke liye
flutter run

# iOS Simulator ke liye
flutter run -d ios

# Web ke liye
flutter run -d chrome
```

## Step 2: Screenshots Lein

### Android Device/Emulator:
1. App run karo
2. Screenshot lene ke liye:
   - **Emulator**: Toolbar mein camera icon click karo
   - **Physical Device**: Power + Volume Down buttons

### iOS Simulator:
1. App run karo simulator mein
2. **Cmd + S** press karo
3. Screenshot Desktop par save hoga
4. Screenshot ko `screenshots/` folder mein copy karo

### Web:
1. Browser mein app open karo
2. Browser ke developer tools se screenshot lein
   - Chrome: Cmd/Ctrl + Shift + P → "Capture screenshot"

## Step 3: Screenshots Ko Organize Karein

Screenshots ko `screenshots/` folder mein add karein with these names:

1. `login_screen.png` - Login page
2. `home_screen.png` - Home/Dashboard
3. `create_booking.png` - Create booking form
4. `location_picker.png` - Google Maps location picker
5. `booking_history.png` - List of all bookings
6. `booking_details.png` - Single booking details
7. `live_tracking.png` - Live tracking screen
8. `status_change.png` - Status change dialog

## Step 4: Screenshots Add Karein Git Mein

```bash
cd /Users/apple/tarcker

# Screenshots add karo
git add screenshots/*.png

# Commit karo
git commit -m "Add app screenshots"

# Push karo GitHub par
git push origin main
```

## Screenshot Guidelines

✅ **Do:**
- High resolution screenshots (minimum 1080x1920)
- Clear, visible content
- Important features highlight karo
- Consistent naming

❌ **Don't:**
- Blurry ya low quality images
- Personal information dikhao
- Very large file sizes (compress if needed)

## Recommended Screenshots

### 1. Login Screen
- Email/password fields visible
- Login button
- Demo mode indicator

### 2. Home Screen
- Welcome message
- Quick action buttons
- Navigation drawer (optional)

### 3. Create Booking
- Location picker buttons
- Date/time picker
- Notes field
- Create button

### 4. Location Picker
- Google Maps visible
- Selected location marker
- Address displayed at bottom

### 5. Booking History
- List of bookings
- Status chips visible
- Filter button
- FAB button

### 6. Booking Details
- Map with route
- All booking information
- Status chip
- Action buttons

### 7. Live Tracking
- Map with markers
- Route polyline
- Current location marker
- Control buttons

### 8. Status Change
- Dialog with status options
- Current status highlighted

## Image Optimization (Optional)

Agar screenshots ka size zyada hai, compress kar sakte ho:

```bash
# Using ImageMagick (if installed)
convert screenshot.png -quality 85 -resize 1080x1920 screenshot_optimized.png
```

Ya online tools use karo:
- TinyPNG
- Squoosh
- ImageOptim

---

**Note**: Screenshots add karne ke baad README automatically update ho jayega kyunki usme screenshots section already hai!

