<?php
$conn = new mysqli("localhost", "root", "", "tripmate");
if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}
$conn->set_charset("utf8");

// 1. Cập nhật ảnh cho bảng cấp Tỉnh/Thành phố (destinations)
$sql_dest = "SELECT id, name FROM destinations";
$result_dest = $conn->query($sql_dest);
$count_dest = 0;

if ($result_dest && $result_dest->num_rows > 0) {
    while($row = $result_dest->fetch_assoc()) {
        $id = $row['id'];
        // Gán ảnh phong cảnh mặc định đẹp lung linh cho từng tỉnh thành
        $img = "https://images.unsplash.com/photo-1509042239860-f550ce710b93"; 
        
        $update = "UPDATE destinations SET image_url = '$img' WHERE id = $id";
        if ($conn->query($update) === TRUE) {
            $count_dest++;
        }
    }
}

// 2. Cập nhật giá và ảnh cho bảng Địa danh chi tiết (locations)
$sql_loc = "SELECT id, name FROM locations";
$result_loc = $conn->query($sql_loc);
$count_loc = 0;

if ($result_loc && $result_loc->num_rows > 0) {
    while($row = $result_loc->fetch_assoc()) {
        $id = $row['id'];
        $name = $row['name'];
        $price = 50000;
        $img = "https://images.unsplash.com/photo-1509042239860-f550ce710b93"; 
        
        if (stripos($name, 'Fansipan') !== false || stripos($name, 'Cáp treo') !== false) {
            $price = 850000;
        } elseif (stripos($name, 'Hạ Long') !== false || stripos($name, 'Vịnh') !== false) {
            $price = 290000;
            $img = "https://images.unsplash.com/photo-1528127269322-539801943592";
        } elseif (stripos($name, 'Tràng An') !== false || stripos($name, 'Bái Đính') !== false) {
            $price = 250000;
            $img = "https://images.unsplash.com/photo-1609137144813-7e94c92014d7";
        } elseif (stripos($name, 'Hội An') !== false) {
            $price = 80000;
            $img = "https://images.unsplash.com/photo-1559592413-7cec4d0cae2b";
        } elseif (stripos($name, 'Đèo') !== false || stripos($name, 'Cột mốc') !== false) {
            $price = 0;
            $img = "https://images.unsplash.com/photo-1565557623262-b51c2513a641";
        } elseif (stripos($name, 'Thác') !== false) {
            $price = 45000;
            $img = "https://images.unsplash.com/photo-1588392382834-a891154bca4d";
        }

        $update_loc = "UPDATE locations SET price = $price, image_url = '$img' WHERE id = $id";
        if ($conn->query($update_loc) === TRUE) {
            $count_loc++;
        }
    }
}

echo "<h2 style='color: green;'>Cập nhật thành công!</h2>";
echo "<p>Đã cập nhật ảnh cho <b>$count_dest</b> tỉnh/thành phố (bảng destinations).</p>";
echo "<p>Đã cập nhật giá và ảnh cho <b>$count_loc</b> địa danh (bảng locations).</p>";
echo "<p>Bây giờ bạn hãy quay lại trang quản lý admin và nhấn F5 để kiểm tra.</p>";

$conn->close();
?>