# CP08 – Quản lý địa điểm theo Tỉnh / Điểm đến

## Đã sửa
- Admin > Locations có trường **Tỉnh / Điểm đến** khi thêm/sửa địa điểm.
- Có datalist lấy các destination đã có; admin vẫn có thể gõ một destination mới.
- Danh sách admin hiển thị destination của từng địa điểm.
- Trang chủ hiển thị **từng tỉnh/điểm đến**, không còn hiển thị tên từng địa điểm như trước. Bấm vào tỉnh sẽ lọc Explore theo destination.
- Explore có bộ lọc **Tất cả điểm đến**.
- Tạo chuyến đi đã có sẵn logic lấy `DISTINCT destination` từ bảng `locations`, nên sau khi admin thêm địa điểm cho destination mới, destination đó tự xuất hiện trong dropdown tạo trip.
- Trip detail đã lọc địa điểm bằng `WHERE destination=?`, nên địa điểm mới sẽ tự xuất hiện trong lịch trình đúng destination.

## Không cần SQL mới
Cột `locations.destination` đã tồn tại trong schema hiện tại.
