# Advanced Calculator – Flutter Lab 3

**Sinh viên:** Trần Cao Tiến Huy  
**MSSV:** 2224802010173  
**Package:** `advancedcalculator_2224802010173_trancaotienhuy`  
**Deadline:** 11:59 PM – 24/04/2026

---

## Mô tả dự án

Ứng dụng máy tính nâng cao xây dựng bằng Flutter, hỗ trợ ba chế độ hoạt động (Cơ bản, Khoa học, Lập trình viên), phân tích biểu thức đầy đủ với độ ưu tiên toán tử, lịch sử tính toán có lưu trữ, chuyển đổi giao diện sáng/tối, chức năng bộ nhớ và bộ kiểm thử toàn diện.

---

## Tính năng

### Ba chế độ máy tính

| Chế độ | Mô tả |
|--------|-------|
| **Cơ bản** | Lưới 4×5 – các phép tính số học, phần trăm, đổi dấu |
| **Khoa học** | Lưới 6×6 – lượng giác, logarithm, lũy thừa, căn, giai thừa, hằng số (π, e), phím bộ nhớ |
| **Lập trình viên** | Số học thập lục phân, các phép tính bit (AND, OR, XOR, NOT), dịch bit (<< >>) |

### Hàm khoa học

- **Lượng giác (DEG & RAD):** `sin`, `cos`, `tan`, `asin`, `acos`, `atan`
- **Logarithm:** `log` (log₁₀), `log2` (log₂), `ln` (logarithm tự nhiên)
- **Lũy thừa & Căn:** `x²`, `x³`, `xʸ`, `√`, `∛`, `^`
- **Hằng số:** `π`, `e` với nhân ngầm định (ví dụ: `2π`)
- **Giai thừa:** `n!` (hỗ trợ 0–170)

### Bộ phân tích biểu thức

- Độ ưu tiên toán tử đầy đủ (PEMDAS/BODMAS)
- Xử lý ngoặc đơn với tự động đóng ngoặc
- Nhân ngầm định (`2π`, `2(3+4)`, `(2)(3)`)
- Tự động loại bỏ toán tử thừa cuối biểu thức
- Chuyển đổi góc độ → radian trong chế độ DEG

### Lịch sử & Lưu trữ (SharedPreferences)

- Lưu 50 phép tính gần nhất gồm biểu thức, kết quả và thời gian
- Lịch sử không mất khi tắt ứng dụng
- Màn hình lịch sử cho phép xoá và sử dụng lại phép tính cũ
- Chế độ máy tính, giá trị bộ nhớ và cài đặt đều được lưu lại

### Chức năng bộ nhớ

| Nút | Chức năng |
|-----|-----------|
| M+ | Cộng kết quả vào bộ nhớ |
| M- | Trừ kết quả khỏi bộ nhớ |
| MR | Lấy lại giá trị bộ nhớ |
| MC | Xoá bộ nhớ |

### Màn hình cài đặt

- **Giao diện:** Sáng / Tối / Theo hệ thống
- **Độ chính xác thập phân:** 2–10 chữ số thập phân (thanh trượt)
- **Chế độ góc:** Độ / Radian
- **Phản hồi haptic:** Bật / Tắt

### Giao diện & Trải nghiệm người dùng

- Màn hình hiển thị nhiều dòng, có thể cuộn (biểu thức hiện tại + kết quả trước)
- **Hiệu ứng rung** khi kết quả là Error
- **Hiệu ứng mờ dần** khi hiển thị kết quả mới
- **Hiệu ứng thu phóng** (0.88×) khi nhấn nút (200 ms)
- **Hiệu ứng chuyển đổi chế độ** (300 ms)
- Vuốt phải trên màn hình → xoá ký tự cuối
- Vuốt lên trên → mở lịch sử tính toán
- Chỉ báo chế độ (DEG/RAD), chỉ báo bộ nhớ

### Thông số thiết kế

| Thuộc tính | Giá trị |
|-----------|---------|
| Font chữ | Roboto – Regular 16px (nút), Medium 32px (màn hình), Light 18px (lịch sử) |
| Bo góc nút | 16px |
| Bo góc màn hình | 24px |
| Padding màn hình | 24px |
| Khoảng cách nút | 12px |
| Hiệu ứng nhấn nút | 200ms |
| Hiệu ứng chuyển chế độ | 300ms |
| Màu nhấn – Giao diện Sáng | #FF6B6B |
| Màu nhấn – Giao diện Tối | #4ECDC4 |

---

## Kiến trúc dự án

```
lib/
├── main.dart
├── models/
│   ├── calculation_history.dart     # Model dữ liệu + tuần tự hoá toMap/fromMap
│   ├── calculator_mode.dart         # Enum: basic | scientific | programmer
│   └── calculator_settings.dart    # Model cài đặt với copyWith & helper lưu trữ
├── providers/
│   ├── calculator_provider.dart     # Trạng thái chính (biểu thức, kết quả, chế độ, bộ nhớ)
│   ├── history_provider.dart        # Trạng thái danh sách lịch sử
│   └── theme_provider.dart          # Trạng thái giao diện + cài đặt
├── screens/
│   ├── calculator_screen.dart       # Màn hình chính (định tuyến chế độ, nhận cử chỉ)
│   ├── history_screen.dart          # Danh sách lịch sử với xoá / dùng lại
│   └── settings_screen.dart        # Giao diện, độ chính xác, chế độ góc, haptic
├── widgets/
│   ├── display_area.dart            # Màn hình có hiệu ứng (rung, mờ, vuốt)
│   ├── calculator_button.dart       # Nút có hiệu ứng thu phóng
│   ├── basic_keypad.dart            # Bàn phím cơ bản 4×5
│   ├── scientific_keypad.dart       # Bàn phím khoa học 6×6
│   ├── programmer_keypad.dart       # Bàn phím chế độ lập trình viên
│   ├── mode_selector.dart           # Widget chuyển đổi chế độ
│   ├── button_grid.dart             # Trợ giúp bố cục lưới chung
│   └── right_navigation.dart        # Ngăn điều hướng bên phải
├── utils/
│   ├── calculator_logic.dart        # API tĩnh: evaluateExpression, evaluateProgrammer, sin/cos/…
│   ├── expression_parser.dart       # Bộ phân tích: tiền xử lý → phân tích → tính toán
│   └── constants.dart              # Hằng số toàn ứng dụng
└── services/
    └── storage_service.dart         # Wrapper SharedPreferences (lịch sử, cài đặt, chế độ, bộ nhớ)
```

**Quản lý trạng thái:** Provider pattern (`ChangeNotifier`)  
**Lưu trữ:** SharedPreferences  
**Bộ tính toán biểu thức:** `math_expressions ^2.4.0`

---

## Hướng dẫn cài đặt

### Yêu cầu
- Flutter SDK ≥ 3.10.4 / Dart SDK ^3.10.4
- Android Studio hoặc VS Code với plugin Flutter
- Thiết bị Android / iOS hoặc máy giả lập

### Cài đặt & Chạy

```bash
# 1. Giải nén hoặc clone dự án
cd advancedcalculator_2224802010173_trancaotienhuy

# 2. Cài đặt các gói phụ thuộc
flutter pub get

# 3. Chạy ứng dụng
flutter run
```

### Các gói phụ thuộc (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  math_expressions: ^2.4.0
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  flutter_lints: ^6.0.0
```

---

## Hướng dẫn kiểm thử

Bộ kiểm thử nằm tại `test/calculator_test.dart` gồm khoảng **218 test case** trong 19 nhóm (A–S).

```bash
# Chạy toàn bộ kiểm thử
flutter test

# Chạy một nhóm cụ thể (ví dụ)
flutter test --name "A –"
```

### Tổng quan các nhóm kiểm thử

| Nhóm | Chủ đề | Số test |
|------|--------|---------|
| A | Số học cơ bản | 16 |
| B | Độ ưu tiên toán tử (PEMDAS) | 8 |
| C | Ngoặc đơn & tự động đóng ngoặc | 8 |
| D | Lượng giác – chế độ độ | 14 |
| E | Lượng giác – chế độ radian | 10 |
| F | Lượng giác ngược (asin / acos / atan) | 14 |
| G | Logarithm (log / log2 / ln) | 20 |
| H | Lũy thừa & căn (^, sqrt, cbrt) | 18 |
| I | Giai thừa | 14 |
| J | Hằng số (π, e) & nhân ngầm định | 10 |
| K | Định dạng độ chính xác thập phân | 10 |
| L | Lập trình viên – AND / OR / XOR | 12 |
| M | Lập trình viên – số học | 10 |
| N | Lập trình viên – dịch bit (<< / >>) | 10 |
| O | Lập trình viên – NOT (32-bit) | 6 |
| P | Lỗi & trường hợp biên | 16 |
| Q | Tuần tự hoá CalculationHistory | 10 |
| R | Vector đặc tả lab (rubric chấm điểm) | 12 |
| S | Các hàm tĩnh ExpressionParser | 10 |
| **Tổng** | | **~218** |

### Các vector kiểm thử chính (theo rubric lab)

```
(5 + 3) × 2 - 4 ÷ 2  = 14         ✔ Độ ưu tiên toán tử
sin(45°) + cos(45°)   ≈ 1.414      ✔ Khoa học / chế độ độ
sin(30°)              = 0.5        ✔ Giá trị lượng giác chính xác
log(1000)             = 3          ✔ Logarithm
5!                    = 120        ✔ Giai thừa
FF AND 0F             = F          ✔ Lập trình viên bitwise
1 << 4                = 10 (hex)   ✔ Lập trình viên dịch bit
((2+3) × (4-1)) ÷ 5  = 3          ✔ Ngoặc đơn lồng nhau
```

---

## Kiểm tra đáp ứng yêu cầu lab

| Yêu cầu | Trạng thái | Ghi chú |
|---------|-----------|---------|
| Ba chế độ máy tính (Cơ bản, Khoa học, Lập trình viên) | ✅ | Enum `CalculatorMode` + 3 widget bàn phím |
| Bộ phân tích biểu thức với độ ưu tiên PEMDAS | ✅ | `ExpressionParser` + `math_expressions` |
| Ngoặc đơn với tự động đóng ngoặc | ✅ | `_autoCloseParentheses()` |
| Nhân ngầm định (2π, 2(…)) | ✅ | `_implicitMultiply()` |
| Lượng giác: sin, cos, tan, asin, acos, atan | ✅ | Cả hai chế độ DEG & RAD |
| Logarithm: log, log2, ln (Error khi ≤0) | ✅ | Xử lý miền giá trị |
| Lũy thừa & căn: x², x³, x^y, √, ∛ | ✅ | cbrt mở rộng thành `(x)^(1/3)` |
| Hằng số π, e | ✅ | Tiêm vào trong tiền xử lý |
| Giai thừa n! (0–170) | ✅ | Tính trước trước khi đưa vào parser |
| Lập trình viên: AND, OR, XOR, NOT (32-bit) | ✅ | `evaluateProgrammer()` |
| Lập trình viên: dịch bit <<, >> | ✅ | Có trong bảng toán tử |
| Bộ nhớ M+, M−, MR, MC + lưu trữ | ✅ | Lưu qua SharedPreferences |
| Lịch sử tính toán (50 phép tính) + lưu trữ | ✅ | `HistoryProvider` + `StorageService` |
| Giao diện Sáng / Tối / Theo hệ thống | ✅ | `ThemeProvider` |
| Cài đặt độ chính xác thập phân (2–10) | ✅ | Thanh trượt trong màn hình cài đặt |
| Chuyển đổi chế độ góc DEG / RAD | ✅ | Cài đặt + provider |
| Phản hồi haptic | ✅ | Cài đặt được lưu lại |
| Hiệu ứng nút nhấn thu phóng (200ms) | ✅ | `calculator_button.dart` |
| Hiệu ứng mờ dần kết quả | ✅ | `display_area.dart` |
| Hiệu ứng rung khi lỗi | ✅ | `display_area.dart` |
| Hiệu ứng chuyển chế độ (300ms) | ✅ | `mode_selector.dart` |
| Vuốt phải → xoá ký tự cuối | ✅ | `onHorizontalDragEnd` |
| Vuốt lên → mở lịch sử | ✅ | `onVerticalDragEnd` |
| Quản lý trạng thái Provider | ✅ | `CalculatorProvider`, `HistoryProvider`, `ThemeProvider` |
| Kiểm thử đơn vị > 80% coverage | ✅ | ~218 test bao phủ toàn bộ logic |
| Cài đặt được lưu và tải lại | ✅ | `StorageService.saveSettings` / `loadSettings` |

---

## Hướng dẫn chụp màn hình

Đặt ảnh chụp màn hình vào thư mục `screenshots/` theo tên file dưới đây:

| File                                  | Nội dung cần chụp                                                |
|---------------------------------------|------------------------------------------------------------------|
| `screenshots/01_basic_mode.png`       | Chế độ Cơ bản — biểu thức `(5+3)×2-4÷2` với kết quả `14`         |
| `screenshots/02_scientific_sin45.png` | Chế độ Khoa học — `sin(45)+cos(45)` → `≈1.41421`                 |
| `screenshots/03_radian_mode.png`      | Chế độ Khoa học RAD — `sin(π÷2)` → `1`                           |
| `screenshots/04_programmer_and.png`   | Chế độ Lập trình viên — `FF AND 0F` → `F`                        |
| `screenshots/05_programmer_shift.png` | Chế độ Lập trình viên — `1 << 4` → `10`                          |
| `screenshots/06_history_screen.png`   | Màn hình lịch sử với nhiều phép tính                             |
| `screenshots/07_settings_screen.png`  | Màn hình cài đặt (giao diện, thanh độ chính xác, chuyển đổi góc) |
| `screenshots/08_dark_theme.png`       | Giao diện tối đang hoạt động                                     |
| `screenshots/09_light_theme.png`      | Giao diện sáng đang hoạt động                                    |
| `screenshots/10_error_handling.png`   | `1÷0` → `Error` hoặc `sqrt(-1)` → `Error`                        |
| `screenshots/11_testing.png`          | ảnh chạy test case trong file test 'calculator_logic_test.dart'                              |

---

## Cải tiến trong tương lai

- Hỗ trợ chế độ ngang (landscape)
- Vẽ đồ thị hàm số (bonus)
- Xuất lịch sử ra CSV / PDF (bonus)
- Nhập liệu bằng giọng nói (bonus)
- Tạo giao diện tuỳ chỉnh (bonus)
- Tối ưu hoá cho máy tính bảng / iPad

---

## Liêm chính học thuật

Đây là sản phẩm của cá nhân Trần Cao Tiến Huy (MSSV: 2224802010173). Các tài nguyên trực tuyến chỉ được tham khảo cho mục đích tra cứu API.