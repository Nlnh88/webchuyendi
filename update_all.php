<?php
$conn = new mysqli("localhost", "root", "", "tripmate");
if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}
$conn->set_charset("utf8");

// Khai báo các đường dẫn ảnh Unsplash chuẩn xác cho từng loại danh thắng Việt Nam
$anh_thac_ban_gioc = "https://images.unsplash.com/photo-1588392382834-a891154bca4d?w=800&auto=format&fit=crop&q=60";
$anh_dong_van      = "https://images.unsplash.com/photo-1590523277543-a94d2e4eb00b?w=800&auto=format&fit=crop&q=60";
$anh_oquyho        = "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=60";
$anh_fansipan      = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&auto=format&fit=crop&q=60";
$anh_trangan       = "https://images.unsplash.com/photo-1609137144813-7e94c92014d7?w=800&auto=format&fit=crop&q=60";
$anh_hoian         = "https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&auto=format&fit=crop&q=60";
$anh_halong        = "https://images.unsplash.com/photo-1528127269322-539801943592?w=800&auto=format&fit=crop&q=60";
$anh_mucangchai    = "https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=800&auto=format&fit=crop&q=60";

// Cập nhật riêng lẻ từng địa điểm chính xác có trên màn hình của bạn để test trước
$conn->query("UPDATE locations SET image_url = '$anh_thac_ban_gioc', price = 45000 WHERE name LIKE '%Thác Bản Giốc%'");
$conn->query("UPDATE locations SET image_url = '$anh_dong_van', price = 30000 WHERE name LIKE '%Đồng Văn%'");
$conn->query("UPDATE locations SET image_url = '$anh_oquyho', price = 0 WHERE name LIKE '%Ô Quy Hồ%'");
$conn->query("UPDATE locations SET image_url = '$anh_fansipan', price = 850000 WHERE name LIKE '%Fansipan%'");
$conn->query("UPDATE locations SET image_url = '$anh_trangan', price = 250000 WHERE name LIKE '%Tràng An%'");
$conn->query("UPDATE locations SET image_url = '$anh_hoian', price = 80000 WHERE name LIKE '%Hội An%'");
$conn->query("UPDATE locations SET image_url = '$anh_halong', price = 290000 WHERE name LIKE '%Hạ Long%'");
$conn->query("UPDATE locations SET image_url = '$anh_mucangchai', price = 20000 WHERE name LIKE '%Mù Căng Chải%'");

// Cập nhật quét tự động chung cho các địa điểm còn lại để không bị trống ảnh
$conn->query("UPDATE locations SET image_url = '$anh_trangan' WHERE image_url = '' OR image_url IS NULL");

echo "<h2 style='color: green;'>Đã khớp lại toàn bộ ảnh chính xác cho các địa điểm!</h2>";
echo "<p>Hãy ra lại trang web và bấm <b>Ctrl + F5</b> để xem kết quả.</p>";

$conn->close();
?>