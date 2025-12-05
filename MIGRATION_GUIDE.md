# 🚀 Hướng Dẫn Chuyển Đổi SQLite sang FastAPI + MySQL

## ✅ ĐÃ HOÀN THÀNH

### 1. Cấu Hình Dependencies
- ✅ Đã thêm `dio ^5.4.0` - HTTP client hiện đại
- ✅ Đã thêm `provider ^6.1.1` - State management
- ✅ Đã thêm `flutter_dotenv ^5.1.0` - Environment variables
- ✅ Đã thêm `cached_network_image ^3.3.1` - Image caching
- ✅ Đã xóa `sqflite` khỏi dependencies

### 2. Cấu Hình API
**File `.env` đã tạo:**
```env
API_BASE_URL=http://10.0.2.2:8000
API_TIMEOUT=30
DEBUG_MODE=true
```

📌 **Quan trọng:**
- `10.0.2.2` = địa chỉ localhost của máy host khi chạy Android emulator
- Nếu test trên thiết bị thật: thay bằng IP LAN của máy (VD: `http://192.168.1.100:8000`)
- Nếu iOS Simulator: thay bằng `http://localhost:8000`

### 3. Đã Cập Nhật Providers
**CartProvider (lib/provider/cart_provider.dart)**
- ❌ Xóa: Tất cả code SQLite/DatabaseHandler
- ✅ Giữ lại: 100% API logic từ `ApiService`
- ✅ Giữ lại: Cấu trúc public API (UI không bị ảnh hưởng)

**FavoriteProvider (lib/provider/favorite_provider.dart)**
- ❌ Xóa: Sync SQLite logic
- ✅ Giữ lại: Pure API calls
- ✅ Giữ lại: Interface methods (UI không thay đổi)

### 4. Main App
**lib/main.dart**
- ✅ Thêm: `await dotenv.load(fileName: ".env");`
- ❌ Xóa: DatabaseHandler initialization
- ✅ Giữ lại: MultiProvider setup

### 5. DatabaseHandler Stub
**lib/services/DatabaseHandler.dart**
- ✅ Tạo stub file với exception messages
- Mục đích: Ngăn compile errors cho các screen còn import DatabaseHandler
- ⚠️ **KHÔNG dùng trong code mới** - sẽ throw exception

---

## ⚠️ VẤN ĐỀ CẦN GIẢI QUYẾT

### Lỗi Compilation (338 errors)

#### 1. **Missing Files/Widgets**
Các file này không tồn tại hoặc bị thiếu:
- `lib/screens/welcome.dart` (imported in main.dart)
- `lib/widgets/bottom_navy_bar.dart` (imported ở nhiều screens)
- `lib/models/filter_model.dart`
- `lib/models/history_search_model.dart`

**Giải pháp:**
- Comment imports nếu file không cần
- Hoặc tạo lại files này từ backup

#### 2. **DatabaseHandler Calls**
4 screens vẫn gọi methods từ DatabaseHandler:
- `lib/screens/search.dart`
- `lib/screens/favorite.dart` 
- `lib/screens/checkout.dart`
- `lib/screens/cart.dart`

**Giải pháp:** Cập nhật để dùng Provider pattern:
```dart
// CŨ (sẽ crash):
final carts = await handler.getListCart();

// MỚI:
final cartProvider = Provider.of<CartProvider>(context, listen: false);
await cartProvider.loadCart();
final carts = cartProvider.carts;
```

#### 3. **ApiService Singleton Pattern**
Một số file dùng `ApiService.instance` (pattern cũ):
- `lib/screens/login.dart`
- `lib/screens/register.dart`

**Giải pháp:** 
```dart
// Thay ApiService.instance bằng:
final api = ApiService();
```

#### 4. **Missing Methods**
Một số methods không tồn tại:
- `CategoryProvider.getCategory()` → chỉ có `loadCategories()`
- `ProductProvider.getProduct()` → chỉ có `loadProducts()`
- `CountryCityProvider.getListCountry()` → API chưa implement

---

## 🔧 HƯỚNG DẪN FIX

### Bước 1: Tạo Missing Files

**Option A - Tạo stub files:**
```dart
// lib/screens/welcome.dart
import 'package:flutter/material.dart';

class Welcom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome - Coming soon')),
    );
  }
}
```

**Option B - Comment imports:**
```dart
// lib/main.dart
// import 'screens/welcome.dart';  // TODO: Restore later
```

### Bước 2: Fix DatabaseHandler Calls

**Ví dụ với cart.dart:**
```dart
// Xóa import:
// import '../services/DatabaseHandler.dart';

// Thêm:
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

// Trong initState hoặc method:
final cartProvider = Provider.of<CartProvider>(context, listen: false);
await cartProvider.loadCart();
```

### Bước 3: Fix Providers Methods

**Cập nhật các calls trong home.dart:**
```dart
// CŨ:
await categoryProvider.getCategory();

// MỚI:
await categoryProvider.loadCategories();
```

### Bước 4: Android Network Config

**android/app/src/main/AndroidManifest.xml:**
```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        android:usesCleartextTraffic="true"
        ...>
```

---

## 🎯 TESTING PLAN

### 1. Chạy Backend
```bash
# Trong thư mục backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Kiểm tra: http://localhost:8000/docs

### 2. Config .env
```bash
# Android Emulator
API_BASE_URL=http://10.0.2.2:8000

# iOS Simulator  
API_BASE_URL=http://localhost:8000

# Physical Device (thay IP máy)
API_BASE_URL=http://192.168.1.100:8000
```

### 3. Chạy App
```bash
flutter clean
flutter pub get
flutter run
```

### 4. Test Flows
- [ ] Login/Register
- [ ] Load products từ API
- [ ] Add to Cart (POST /cart)
- [ ] Add to Favorites (POST /favorites)
- [ ] Checkout flow
- [ ] Order history

---

## 📝 CÁC BƯỚC TIẾP THEO

### Ưu tiên cao:
1. **Tạo/restore missing files** (welcome.dart, bottom_navy_bar.dart)
2. **Fix 4 screens còn dùng DatabaseHandler** (search, favorite, checkout, cart)
3. **Update method calls** trong home.dart (getCategory → loadCategories, v.v.)
4. **Test kết nối API** với backend

### Ưu tiên thấp:
- Fix deprecated warnings (.withOpacity, MaterialStateProperty)
- Implement missing API endpoints (Country/City)
- Add error handling cho offline scenarios
- Setup JWT token refresh logic

---

## 💡 TIPS

### Debug API Calls
```dart
// lib/services/api_service.dart đã có logging
dio.interceptors.add(LogInterceptor(
  request: true,
  responseBody: true,
  error: true,
));
```

### Check Token Storage
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
String? token = await storage.read(key: 'auth_token');
print('Token: $token');
```

### Test API Connectivity
```dart
try {
  final api = ApiService();
  final response = await api.dio.get('/health'); // Cần endpoint này
  print('API OK: ${response.data}');
} catch (e) {
  print('API Error: $e');
}
```

---

## 🆘 TROUBLESHOOTING

### Lỗi "Connection refused"
- Kiểm tra backend đang chạy: `curl http://localhost:8000/docs`
- Kiểm tra .env có đúng IP không
- Android emulator: PHẢI dùng `10.0.2.2` thay cho `localhost`

### Lỗi "CORS"
Backend cần config:
```python
# main.py
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Lỗi "401 Unauthorized"
- Check token có được lưu sau login không
- Check header: `Authorization: Bearer <token>`
- Xem ApiService đã thêm token vào headers chưa

---

## 📊 KẾT LUẬN

**Đã hoàn thành:**
- ✅ Remove SQLite dependencies
- ✅ Setup environment config (.env)
- ✅ Migrate CartProvider & FavoriteProvider sang pure API
- ✅ Update main.dart initialization

**Đang làm dở:**
- ⚠️ 338 compile errors cần fix
- ⚠️ Missing files cần tạo/restore
- ⚠️ DatabaseHandler calls cần refactor

**Chưa làm:**
- ❌ Android network permissions
- ❌ End-to-end testing với backend
- ❌ Error handling cho offline
- ❌ Token refresh mechanism

**Ước tính thời gian:**
- Fix compile errors: 2-3 giờ
- Testing + debugging: 1-2 giờ
- Polish: 1 giờ

**TỔNG: ~4-6 giờ** để app chạy ổn định với backend.
