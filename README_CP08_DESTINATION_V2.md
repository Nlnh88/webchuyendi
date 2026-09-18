# CP08 v2 — Mô hình Điểm đến -> Địa danh

## Ý tưởng
- `destinations`: chỉ chứa tỉnh / thành phố mà người dùng có thể chọn khi tạo chuyến đi.
- `locations`: chứa các địa danh du lịch cụ thể và bắt buộc thuộc một `destination_id`.
- Không cho nhập tay tên tỉnh khi thêm địa danh hoặc tạo Trip; dùng dropdown lấy trực tiếp từ DB.
- Trang chủ Inspiration dùng `destination_id`, nên bấm “Đà Nẵng” sẽ mở Explore đúng Đà Nẵng.
- Trip Detail lọc Quick Add và danh sách địa điểm theo `destination_id`.

## Cách cài
1. Backup database `tripmate`.
2. Mở phpMyAdmin -> DB `tripmate` -> SQL.
3. Chạy `database/patch_destinations_v2.sql` một lần.
4. Copy các file PHP trong patch vào đúng thư mục `webchuyendi` và ghi đè file cùng tên.
5. Đăng nhập admin -> `Điểm đến`.
6. Thêm “Hà Nội” (hoặc tỉnh/thành cần dùng), điền ghi chú/chi phí/rating/ảnh.
7. Bấm vào Hà Nội -> `+ Thêm địa danh` -> thêm Hồ Hoàn Kiếm, Văn Miếu... Các địa danh tự động thuộc Hà Nội.
8. Vào `Địa danh` nếu muốn xem/sửa toàn bộ địa danh.
9. Vào Tạo chuyến đi -> dropdown Điểm đến chỉ hiển thị các điểm đến đang hoạt động.
10. Tạo Trip Hà Nội -> Trip Detail -> Quick Add/Thêm hoạt động chỉ hiện địa danh Hà Nội.

## Xóa điểm đến
Nút “Ẩn” là xóa mềm: điểm đến không còn xuất hiện trong Tạo chuyến đi/Explore nhưng dữ liệu lịch sử và Trip cũ không bị phá. Có thể “Hiện lại”.

## Lưu ý
Migration giữ lại cột text `locations.destination` và `trips.destination` để tương thích dữ liệu/code cũ, nhưng code mới dùng khóa `destination_id` làm quan hệ chuẩn. Không nhập tay vào hai cột text này.
