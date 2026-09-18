# TripMate — Website Lập Kế Hoạch Chuyến Đi

TripMate là website hỗ trợ người dùng tìm kiếm địa điểm du lịch, lập kế hoạch chuyến đi và quản lý các thông tin liên quan như lịch trình, ngân sách, danh sách công việc và thành viên tham gia.

Dự án được xây dựng trong khuôn khổ môn **Thiết kế Web** thực hiện bởi nhóm NOTHING, sử dụng PHP và MySQL với giao diện Bootstrap 5.

---

## 👥 Thành viên nhóm

| STT | Thành viên | Vai trò |
|-----|------------|---------|
| 1 | **Nguyễn Lê Ngọc Hân** | Frontend / UI / Responsive / Testing |
| 2 | **Lê Hoàng Gia Bảo** | Database / Authentication / Trip / Itinerary |
| 3 | **Lê Bá Hải** | Backend PHP / Admin / Budget / Favorite / Checklist |

---

## 🎯 Mục tiêu dự án

TripMate hướng đến việc xây dựng một website lập kế hoạch chuyến đi với các chức năng chính:

- Quản lý tài khoản người dùng.
- Tìm kiếm và khám phá địa điểm du lịch.
- Xem thông tin chi tiết địa điểm.
- Lưu địa điểm yêu thích.
- Tạo và quản lý chuyến đi.
- Xây dựng lịch trình theo ngày.
- Quản lý ngân sách chuyến đi.
- Quản lý checklist.
- Quản lý thành viên tham gia chuyến đi.
- Đăng ký tham gia các chuyến đi công khai.
- Quản trị hệ thống thông qua trang Admin.

---

## ✨ Các chức năng chính

### 1. Authentication

- Đăng ký tài khoản.
- Đăng nhập.
- Đăng xuất.
- Quản lý session.
- Mã hóa mật khẩu bằng password hash.

### 2. Explore Locations

- Hiển thị danh sách địa điểm.
- Tìm kiếm địa điểm.
- Lọc theo danh mục.
- Sắp xếp dữ liệu.
- Phân trang.

### 3. Location Detail

- Xem thông tin chi tiết địa điểm.
- Hiển thị hình ảnh và thông tin địa điểm.
- Hiển thị đánh giá và nhận xét.
- Cho phép người dùng đánh giá địa điểm.

### 4. Favorites

- Lưu địa điểm yêu thích.
- Bỏ địa điểm khỏi danh sách yêu thích.
- Xem danh sách địa điểm đã lưu.

### 5. Trip Management

- Tạo chuyến đi.
- Xem thông tin chuyến đi.
- Chỉnh sửa chuyến đi.
- Xóa chuyến đi.
- Quản lý chuyến đi của người dùng.

### 6. Itinerary

- Thêm hoạt động vào lịch trình.
- Chọn ngày và thời gian.
- Gắn địa điểm vào hoạt động.
- Xóa hoạt động khỏi lịch trình.
- Chỉ cho phép chọn địa điểm phù hợp với điểm đến của chuyến đi.

### 7. Budget

- Thêm khoản chi.
- Xóa khoản chi.
- Phân loại khoản chi.
- Tính tổng ngân sách chuyến đi.

### 8. Checklist

- Thêm công việc cần chuẩn bị.
- Đánh dấu công việc đã hoàn thành.
- Xóa công việc.
- Theo dõi các công việc cần thực hiện trước chuyến đi.

### 9. Members & Registration

- Thêm thành viên vào chuyến đi.
- Quản lý thành viên.
- Hiển thị các chuyến đi công khai.
- Cho phép người dùng đăng ký tham gia chuyến đi công khai.

### 10. Admin

Admin có thể:

- Xem Dashboard.
- Quản lý người dùng.
- Quản lý địa điểm.
- Quản lý danh mục.
- Quản lý chuyến đi.
- Quản lý đăng ký tham gia.
- Theo dõi dữ liệu hệ thống.

---

## 🛠 Công nghệ sử dụng

- **PHP 8+**
- **MySQL 8+**
- **HTML5**
- **CSS3**
- **Bootstrap 5**
- **JavaScript**
- **XAMPP**
- **phpMyAdmin**
- **Git / GitHub**

---

## 🗄 Cơ sở dữ liệu

Các bảng chính trong hệ thống:

```text
users
categories
locations
trips
trip_members
itineraries
expenses
favorites
registrations
reviews
checklists
