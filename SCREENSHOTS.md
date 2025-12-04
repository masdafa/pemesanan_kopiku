# 📸 Kopi Kang Dafa - UI Screenshots & Preview

Dokumentasi lengkap tentang UI/UX aplikasi Kopi Kang Dafa dengan penjelasan detail setiap screen.

---

## 🎯 Screen Flow Overview

```
SplashScreen (Branding)
    ↓
AuthScreen (Login/Register Tabs)
    ↓
MainTabsScreen (Bottom Navigation)
    ├─ Menu Tab
    │  ├─ CoffeeListScreen (4 category tabs)
    │  │  ├─ Coffee Detail Screen
    │  │  └─ Cart Screen
    │  └─ Checkout Screen
    ├─ Orders Tab
    │  ├─ OrderScreen (Order History)
    │  └─ OrderTrackingScreen
    ├─ Vouchers Tab
    │  ├─ VoucherScreen
    │  └─ VoucherSelectionScreen
    └─ Profile Tab
       ├─ ProfileScreen
       ├─ EditProfileScreen
       └─ RewardsScreen
```

---

## 🖼️ DETAILED SCREEN DESCRIPTIONS

### 1️⃣ **SPLASH SCREEN**

**Purpose**: App initialization dengan branding

**Visual Elements:**
- Full screen with brown gradient background
- Large "Kopi Kang Dafa" logo/text centered
- Loading indicator atau welcome message
- Splash duration: 2-3 seconds
- Auto-routing based on auth status

**User Flow:**
- App launches → SplashScreen
- If authenticated → MainTabsScreen
- If not authenticated → AuthScreen

**Color Scheme:** Brown gradient (professional, warm)

---

### 2️⃣ **AUTH SCREEN - LOGIN TAB**

**Purpose**: User authentication

**Visual Layout:**
- Tab bar dengan 2 tabs: "LOGIN" dan "DAFTAR"
- Form fields:
  - Username input (hint: "admin@kopi.com")
  - Password input (hint: "admin123", obscured)
  - Login button (brown background, white text)

**Form Validation:**
- ✅ Username required
- ✅ Password min 5 characters
- ✅ Error messages shown below fields
- ✅ Submit button disabled until valid

**Color Scheme:** Brown theme dengan green accent untuk buttons

---

### 3️⃣ **COFFEE LIST SCREEN (Main Menu)**

**Purpose**: Browse menu items dengan category filtering

**Visual Layout:**
```
┌─────────────────────────────────┐
│  ☕ KOPI KANG DAFA              │  ← Branded SliverAppBar
│  Selamat Datang, Dafa!          │  ← Personalized greeting
│  [🔔 Notification] [🛒 Cart]    │  ← Action icons with badges
└─────────────────────────────────┘
│  [Search input field]            │  ← Search with clear button
├─────────────────────────────────┤
│ [Kopi] [Non Kopi] [Spesial]... │  ← Category tabs (pinned)
├─────────────────────────────────┤
│ ┌─────────┐  ┌─────────┐       │
│ │         │  │         │       │  ← Grid view (2 columns)
│ │ Coffee1 │  │ Coffee2 │       │
│ │Rp30k ❤️ │  │Rp42k ❤️ │       │
│ └─────────┘  └─────────┘       │
│ ┌─────────┐  ┌─────────┐       │
│ │ Coffee3 │  │ Coffee4 │       │
│ └─────────┘  └─────────┘       │
└─────────────────────────────────┘
```

**Key Features:**
- Header: Coffee icon badge + app name "Kopi Kang Dafa"
- Personalized greeting dengan nama user
- Search box dengan real-time filter
- 4 category tabs: Kopi, Non Kopi, Spesial, Pastry
- Grid layout (2 columns) dengan cards
- Each card: image, name, price, favorite icon
- Pinned tab bar (stays visible saat scroll)

**Interactions:**
- Click card → CoffeeDetailScreen
- Click heart → Toggle favorite
- Type in search → Filter menu items
- Tap category → Filter by category

**Color Scheme:** Brown dominant, green accents, white background

---

### 4️⃣ **COFFEE DETAIL SCREEN**

**Purpose**: View product details dan customize order

**Visual Layout:**
```
┌─────────────────────────────────┐
│ ← [Coffee Name] [❤️ Favorite]   │  ← AppBar
├─────────────────────────────────┤
│         [Product Image]         │  ← Hero animation
│         (300px height)          │
├─────────────────────────────────┤
│ Classic Latte                   │
│ Espresso dengan susu steamed... │
│                                 │
│ Size & Temperature:             │
│ [Small] [●Medium] [Large]       │  ← Choice chips
│                    [Hot] [●Iced]│
│                                 │
│ Optional Topping:               │
│ [●None] [Boba] [Cheese] [Choco]│
│                                 │
│ Quantity: [−] 1 [+]             │  ← Quantity selector
│                                 │
│ Total: Rp 30.000                │  ← Dynamic price
└─────────────────────────────────┘
│ [ADD TO CART Button - Brown]    │
└─────────────────────────────────┘
```

**Key Features:**
- Hero animation dari list ke detail
- Product image dengan loading indicator
- Product name & description
- Size selection chips (small, medium, large)
- Temperature selection chips (hot, iced)
- Topping selection chips (none, boba, cheese, choco)
- Quantity adjuster
- Real-time price calculation
- Add to cart button

**Interactions:**
- Select size → Price updates
- Select topping → Price updates
- Change quantity → Price updates
- Click add to cart → Redirect to cart, show snackbar

**Color Scheme:** Brown buttons, green accents, light background

---

### 5️⃣ **SHOPPING CART SCREEN**

**Purpose**: Manage shopping cart items

**Visual Layout:**
```
┌─────────────────────────────────┐
│ Keranjang (Cart)         [←]    │
├─────────────────────────────────┤
│ ITEMS:                          │
│ ┌─────────────────────────────┐ │
│ │ [Image] Classic Latte       │ │ ← Cart items
│ │         Medium | Hot | None │ │
│ │         Qty: [−] 1 [+]      │ │
│ │         Rp 30.000  [Delete] │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ [Image] Caramel Macchiato   │ │
│ │         Large | Iced | Boba │ │
│ │         Qty: [−] 2 [+]      │ │
│ │         Rp 94.000  [Delete] │ │
│ └─────────────────────────────┘ │
├─────────────────────────────────┤
│ Subtotal:      Rp 124.000       │
│ Discount:      Rp 0             │
│ ─────────────────────────────── │
│ Total:         Rp 124.000       │
├─────────────────────────────────┤
│ [Apply Voucher]                 │
│ [CHECKOUT Button - Brown]       │
└─────────────────────────────────┘
```

**Key Features:**
- List of cart items with details
- Quantity adjuster for each item
- Delete button untuk remove items
- Subtotal calculation
- Discount display (if voucher applied)
- Total price
- Apply voucher button
- Checkout button

**Interactions:**
- Adjust quantity → Total updates
- Delete item → Item removed
- Apply voucher → Discount applied
- Click checkout → CheckoutScreen

**Color Scheme:** White cards, brown buttons, green accents

---

### 6️⃣ **CHECKOUT SCREEN**

**Purpose**: Order confirmation dan payment simulation

**Visual Layout:**
```
┌─────────────────────────────────┐
│ Checkout                  [←]   │
├─────────────────────────────────┤
│ ORDER SUMMARY:                  │
│ Items: 2                        │
│ Subtotal: Rp 124.000           │
│ Voucher Discount: Rp 0         │
│ ─────────────────────────────── │
│ TOTAL: Rp 124.000              │
│                                 │
│ DELIVERY ADDRESS:               │
│ [Text field - optional]        │
│                                 │
│ NOTES:                          │
│ [Text field - optional]        │
│                                 │
│ PAYMENT METHOD:                 │
│ ○ Debit Card                   │
│ ○ E-Wallet                     │
│ ● Cash on Delivery             │
│                                 │
│ [CONFIRM ORDER - Brown Button]  │
└─────────────────────────────────┘
```

**Key Features:**
- Order summary dengan total
- Delivery address field
- Order notes field
- Payment method selection
- Confirm order button

**Interactions:**
- Select payment method → Info updated
- Click confirm → Order created, navigate to order tracking

**Color Scheme:** Brown buttons, blue/purple accents

---

### 7️⃣ **REWARDS SCREEN**

**Purpose**: View rewards points dan redeem vouchers

**Visual Layout:**
```
┌─────────────────────────────────┐
│ Rewards & Points          [←]   │
├─────────────────────────────────┤
│ YOUR POINTS:                    │
│          [⭐ 500]               │
│                                 │
│ PROGRESS TO NEXT TIER:          │
│ ████████░░  80%                │
│ 400 / 500 points               │
│                                 │
│ REDEEM OPTIONS:                 │
│ ┌─────────────────────────────┐ │
│ │ 100 Points → Rp 10.000      │ │
│ │ Voucher Code: KOPI100       │ │
│ │         [REDEEM Button]      │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 200 Points → Rp 25.000      │ │
│ │ Voucher Code: KOPI200       │ │
│ │         [REDEEM Button]      │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 500 Points → Rp 70.000      │ │
│ │ Voucher Code: KOPI500       │ │
│ │         [REDEEM Button]      │ │
│ └─────────────────────────────┘ │
│                                 │
│ REDEEMED VOUCHERS:              │
│ • KOPI100: Rp 10.000 (Valid)   │
│ • KOPI200: Rp 25.000 (Expired) │
└─────────────────────────────────┘
```

**Key Features:**
- Points display dengan star icon
- Progress bar ke next tier
- Redeem options dengan different tiers
- Each option: points required, discount value, voucher code
- Redeem button untuk setiap option
- List of redeemed vouchers

**Interactions:**
- Click redeem → Point deducted, voucher created
- Error if insufficient points → Show alert
- Success → Voucher added to user account

**Color Scheme:** Gold/yellow for points, brown buttons, green accents

---

### 8️⃣ **ORDER HISTORY SCREEN**

**Purpose**: View past orders

**Visual Layout:**
```
┌─────────────────────────────────┐
│ Pesanan Saya (Orders)     [←]   │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ Order #001                  │ │
│ │ Date: 2025-12-04 14:30     │ │
│ │ Status: ✅ Completed       │ │
│ │ Items: 2                    │ │
│ │ Total: Rp 124.000          │ │
│ │ [View Details]             │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ Order #002                  │ │
│ │ Date: 2025-12-03 10:15     │ │
│ │ Status: 🔄 Processing      │ │
│ │ Items: 3                    │ │
│ │ Total: Rp 156.000          │ │
│ │ [View Details]             │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ Order #003                  │ │
│ │ Date: 2025-12-02 18:45     │ │
│ │ Status: 📦 Delivered       │ │
│ │ Items: 1                    │ │
│ │ Total: Rp 35.000           │ │
│ │ [View Details]             │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**Key Features:**
- List of orders dengan order info
- Order date & time
- Order status dengan emoji
- Item count & total price
- View details button untuk setiap order

**Interactions:**
- Click view details → OrderTrackingScreen
- Tap order card → Show details

**Color Scheme:** White cards, status indicators (green/orange/blue)

---

### 9️⃣ **PROFILE SCREEN**

**Purpose**: User profile & account management

**Visual Layout:**
```
┌─────────────────────────────────┐
│ Akun Saya (Profile)       [←]   │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │    [D] Dafa Yunidar        │ │ ← Avatar dengan initial
│ │    Member Gold             │ │
│ └─────────────────────────────┘ │
│ ┌──────────────┐ ┌────────────┐ │
│ │ 💰 Rp100.000│ │ ⭐ 500 Poin│ │ ← Wallet & points
│ │  Saldo      │ │ Rewards    │ │
│ └──────────────┘ └────────────┘ │
├─────────────────────────────────┤
│ [📋] Riwayat Pesanan           │ ← Menu items
│ [❤️] Minuman Favorit            │
│ [🔔] Notifikasi                 │
│ [💎] Rewards                    │
│ [⚙️] Pengaturan Akun            │
├─────────────────────────────────┤
│ [LOGOUT Button - Red Outline]   │
└─────────────────────────────────┘
```

**Key Features:**
- Avatar dengan initial
- Username & member status
- Wallet balance card
- Points/rewards card
- Menu items: order history, favorites, notifications, settings, rewards
- Logout button

**Interactions:**
- Click menu items → Navigate to respective screen
- Click rewards → RewardsScreen
- Click logout → Reset session, back to auth screen

**Color Scheme:** Brown theme, red logout button, white cards

---

## 🎨 **UI/UX Design Principles**

### Color Palette
```
Primary: Brown (#6D4C41, #795548, #8D6E63)
Secondary: Green (#388E3C, #43A047)
Accent: Amber (#FFA726, #FFB74D)
Background: Light Grey/White (#F5F5F5, #FFFFFF)
Text: Dark Grey/Black (#212121, #424242)
```

### Typography
- **Headers**: 24-28px, Bold, Dark Grey
- **Title**: 16-20px, Bold, Dark Grey
- **Body**: 14-16px, Regular, Dark Grey
- **Small**: 12-14px, Regular, Medium Grey

### Spacing
- **Padding**: 8px, 12px, 16px, 20px
- **Margin**: 8px, 12px, 16px
- **Border Radius**: 10px, 15px, 25px (fully round)

### Interactions
- **Buttons**: Rounded corners (10px), 15px vertical padding
- **Cards**: Elevation 2-6, rounded corners (15px)
- **Icons**: 24px standard, 40px large, 16px small

---

## 📱 **Responsive Design**

Aplikasi didesain responsif untuk:
- ✅ Mobile phones (320px - 480px)
- ✅ Tablets (600px - 900px)
- ✅ Landscape orientation

---

## 🚀 **How to View the UI**

```bash
cd "c:\Users\Dafa Yunidar\pemesanan_kopiku"
flutter run
```

**Login dengan:**
- Email: `admin@kopi.com`
- Password: `admin123`

**Explore semua screen melalui:**
- Bottom Navigation Bar (4 main sections)
- Back buttons untuk navigate back
- Search & filter di menu screen

---

**Dokumentasi UI Created**: December 4, 2025  
**Author**: Dafa Yunidar  
**Status**: ✅ Complete
