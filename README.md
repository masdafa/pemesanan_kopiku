# ☕ Kopi Kang Dafa - Coffee Ordering App

Aplikasi mobile untuk pemesanan kopi dengan sistem rewards dan voucher yang terintegrasi. Dibangun menggunakan **Flutter** dan **Provider** untuk state management.

## 📱 Fitur Utama

### 1. **Autentikasi & User Management**
- ✅ Login dengan kredensial (admin@kopi.com / admin123)
- ✅ User profile management
- ✅ Session management dengan logout
- ✅ Splash screen dengan auto-routing berdasarkan auth status

### 2. **Menu Kopi & Pastry**
- ✅ 4 kategori: Kopi, Non Kopi, Spesial, Pastry
- ✅ 11 item menu dengan detail lengkap
- ✅ Search & filter functionality
- ✅ Favorit management
- ✅ Image caching untuk optimasi performa

### 3. **Shopping Cart & Checkout**
- ✅ Tambah/hapus item dari cart
- ✅ Pilih ukuran (Small, Medium, Large)
- ✅ Pilih suhu (Hot, Iced)
- ✅ Pilih topping (Boba, Cheese, Choco Chips)
- ✅ Real-time price calculation
- ✅ Cart badge di bottom navigation

### 4. **Sistem Rewards & Voucher**
- ✅ Earning poin dari setiap pembelian
- ✅ Redeem poin menjadi voucher
- ✅ Apply voucher ke cart untuk diskon
- ✅ Rewards tracking screen
- ✅ Unit & widget tests untuk rewards feature

### 5. **Order Management**
- ✅ Order history
- ✅ Order tracking
- ✅ Order status updates
- ✅ Notifikasi in-app

### 6. **Additional Features**
- ✅ Dompet/wallet balance
- ✅ Notifikasi system
- ✅ Responsive UI design
- ✅ Indonesian localization

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI Framework** | Flutter 3.9.2 |
| **State Management** | Provider 6.1.1 |
| **ID Generation** | UUID 4.5.2 |
| **Testing** | Flutter Test |
| **Architecture** | MVVM with Providers |

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── coffee.dart               # Coffee model & enums
│   ├── cart_item.dart            # Cart item model
│   ├── order.dart                # Order model
│   ├── voucher.dart              # Voucher model
│   └── enums.dart                # Shared enumerations
├── providers/                     # State management
│   ├── user_provider.dart        # User & auth logic
│   ├── cart_provider.dart        # Cart management
│   ├── order_provider.dart       # Order management
│   ├── favorites_provider.dart   # Favorites logic
│   └── notification_provider.dart # Notifications
├── screens/                       # UI screens
│   ├── splash_screen.dart        # App initialization
│   ├── auth_screen.dart          # Login & Register
│   ├── main_tabs_screen.dart     # Main navigation
│   ├── coffee_list_screen.dart   # Menu listing
│   ├── coffee_detail_screen.dart # Item details
│   ├── cart_screen.dart          # Shopping cart
│   ├── checkout_screen.dart      # Payment flow
│   ├── order_screen.dart         # Order history
│   ├── rewards_screen.dart       # Rewards & points
│   ├── profile_screen.dart       # User profile
│   └── ...                       # Other screens
└── widgets/                       # Reusable widgets
    ├── coffee_item_card.dart     # Coffee card component
    └── cart_item_widget.dart     # Cart item component

test/
├── providers/                     # Provider unit tests
│   └── redeem_unit_test.dart     # Rewards redemption tests
└── widgets/                       # Widget tests
    └── rewards_widget_test.dart   # RewardsScreen tests
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2+
- Dart 3.0+
- Android SDK / Xcode (untuk build native)

### Installation

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd pemesanan_kopiku
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run app**
   ```bash
   flutter run
   ```

4. **Run tests**
   ```bash
   flutter test
   flutter test --coverage
   ```

### Login Credentials
- **Username**: admin@kopi.com
- **Password**: admin123

## 📊 Menu Items

### ☕ Kopi (3 items)
- Classic Latte - Rp 30.000
- Caramel Macchiato - Rp 42.000
- Iced Americano - Rp 25.000

### 🥛 Non Kopi (2 items)
- Mocha Praline - Rp 42.000
- Matcha Frappe - Rp 38.000

### ❄️ Spesial (2 items)
- Holiday Spice Latte - Rp 45.000
- Summer Berry Cooler - Rp 40.000

### 🥐 Pastry (4 items)
- Croissant Mentega - Rp 35.000
- Cheese Cake - Rp 48.000
- Chocolate Donut - Rp 20.000
- Blueberry Muffin - Rp 32.000

## 🔄 App Flow

```
SplashScreen
    ↓
AuthScreen (login/register)
    ↓
MainTabsScreen (4 bottom tabs)
    ├── Menu (CoffeeListScreen)
    │   ├── Coffee Detail Screen
    │   └── Cart Screen
    ├── Orders (OrderScreen)
    │   └── Order Tracking
    ├── Vouchers (VoucherScreen)
    └── Profile (ProfileScreen)
        ├── Edit Profile
        ├── Rewards
        └── Logout
```

## 🧪 Testing

Aplikasi dilengkapi dengan comprehensive test coverage:

- **Unit Tests**: 
  - Rewards redemption logic
  - Point calculation
  - Voucher application
  
- **Widget Tests**:
  - RewardsScreen UI
  - Cart button interactions
  - Voucher redemption flow

Run tests dengan:
```bash
flutter test
flutter test --coverage
```

## 🎨 UI/UX Features

- ✨ Branded header dengan "Kopi Kang Dafa" logo
- 🎯 Bottom navigation untuk easy access
- 🖼️ Image caching & fallback icons
- 📱 Responsive design
- 🌍 Indonesian localization
- 🔔 In-app notifications badge

## 🔒 Security & Best Practices

- ✅ Input validation pada login form
- ✅ Safe async/await handling
- ✅ Error handling dengan user-friendly messages
- ✅ No hardcoded sensitive data
- ✅ Proper state management isolation
- ✅ Code formatting & analysis

## 📋 Recent Updates (Final Version)

### Fitur Baru
- ✅ Pastry menu dengan 4 items
- ✅ Branding "Kopi Kang Dafa" di seluruh app
- ✅ Improved image loading dengan caching
- ✅ Enhanced UI dengan gradient headers
- ✅ Rewards system dengan point redemption
- ✅ Comprehensive test coverage

### Bug Fixes & Improvements
- ✅ Fixed login/logout flow (splash screen routing)
- ✅ Improved image caching untuk better performance
- ✅ Better error handling untuk image loading
- ✅ Indonesian localization untuk category names
- ✅ Removed deprecated Flutter APIs
- ✅ Code formatting & lint compliance

## ✅ Code Quality

```
flutter analyze    → No issues found! ✅
flutter test       → All tests passing ✅
pub get           → All dependencies resolved ✅
```

## 📝 License

Proyek ini adalah bagian dari tugas kuliah Mobile Development.

## 👨‍💻 Author

**Dafa Yunidar**

---

**Last Updated**: December 4, 2025
**Project Status**: ✅ Production Ready
