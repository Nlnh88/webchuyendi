-- TripMate CP08 v2: Destination (tỉnh/thành phố) -> Locations (địa danh)
-- Chạy 1 lần trên DB tripmate.

CREATE TABLE IF NOT EXISTS destinations (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE,
  notes TEXT NULL,
  average_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
  rating DECIMAL(2,1) NOT NULL DEFAULT 0,
  image_url VARCHAR(500) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_destinations_active_name(is_active,name)
) ENGINE=InnoDB;

-- Đưa các destination cũ trong locations vào bảng cha.
INSERT IGNORE INTO destinations(name)
SELECT DISTINCT TRIM(destination)
FROM locations
WHERE destination IS NOT NULL AND TRIM(destination) <> '';

-- Nếu chạy lại sau khi đã có cột, bỏ 2 ALTER bên dưới.
ALTER TABLE locations ADD COLUMN destination_id INT UNSIGNED NULL AFTER category_id;
ALTER TABLE trips ADD COLUMN destination_id INT UNSIGNED NULL AFTER owner_id;

UPDATE locations l
JOIN destinations d ON d.name = TRIM(l.destination)
SET l.destination_id = d.id
WHERE l.destination_id IS NULL;

UPDATE trips t
JOIN destinations d ON d.name = TRIM(t.destination)
SET t.destination_id = d.id
WHERE t.destination_id IS NULL;

-- Các dòng cũ phải map được trước khi chuyển thành bắt buộc.
ALTER TABLE locations MODIFY destination_id INT UNSIGNED NOT NULL;
ALTER TABLE trips MODIFY destination_id INT UNSIGNED NOT NULL;

ALTER TABLE locations
  ADD CONSTRAINT fk_locations_destination
  FOREIGN KEY (destination_id) REFERENCES destinations(id)
  ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE trips
  ADD CONSTRAINT fk_trips_destination
  FOREIGN KEY (destination_id) REFERENCES destinations(id)
  ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE INDEX idx_locations_destination ON locations(destination_id);
CREATE INDEX idx_trips_destination ON trips(destination_id);

-- Đồng bộ tên cha vào dữ liệu cũ để các trang chưa refactor hết vẫn không bị lệch.
UPDATE locations l JOIN destinations d ON d.id=l.destination_id SET l.destination=d.name;
UPDATE trips t JOIN destinations d ON d.id=t.destination_id SET t.destination=d.name;

-- Gợi ý dữ liệu mẫu cho destination cũ: lấy ảnh đại diện đầu tiên của mỗi tỉnh/thành.
UPDATE destinations d
JOIN (
  SELECT destination_id, MIN(id) first_location_id
  FROM locations GROUP BY destination_id
) x ON x.destination_id=d.id
JOIN locations l ON l.id=x.first_location_id
SET d.image_url=COALESCE(NULLIF(d.image_url,''),l.image_url);
