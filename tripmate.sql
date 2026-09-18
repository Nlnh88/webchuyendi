CREATE DATABASE IF NOT EXISTS tripmate CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tripmate;

DROP TABLE IF EXISTS checklist_progress, review_images, checklists, reviews, registrations, favorites, expenses, itineraries, trip_members, trips, locations, categories, users;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user','admin') NOT NULL DEFAULT 'user',
  status ENUM('active','blocked') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE locations (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255) NOT NULL,
  description TEXT,
  average_cost DECIMAL(12,2) NOT NULL DEFAULT 0,
  rating DECIMAL(2,1) NOT NULL DEFAULT 0,
  image_url VARCHAR(500),
  destination VARCHAR(150) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_locations_name(name), INDEX idx_locations_rating(rating)
) ENGINE=InnoDB;

CREATE TABLE trips (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_id INT UNSIGNED NOT NULL,
  name VARCHAR(150) NOT NULL,
  destination VARCHAR(150) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  budget DECIMAL(12,2) NOT NULL DEFAULT 0,
  description TEXT,
  status ENUM('draft','published','completed','cancelled') NOT NULL DEFAULT 'draft',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_trips_dates(start_date,end_date)
) ENGINE=InnoDB;

CREATE TABLE trip_members (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  trip_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  member_role ENUM('owner','member') NOT NULL DEFAULT 'member',
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_trip_user(trip_id,user_id),
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE itineraries (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  trip_id INT UNSIGNED NOT NULL,
  location_id INT UNSIGNED NULL,
  day_number INT UNSIGNED NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NULL,
  note VARCHAR(255),
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (location_id) REFERENCES locations(id) ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_itinerary_trip_day(trip_id,day_number,start_time)
) ENGINE=InnoDB;

CREATE TABLE expenses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  trip_id INT UNSIGNED NOT NULL,
  paid_by INT UNSIGNED NOT NULL,
  category VARCHAR(80) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  description VARCHAR(255),
  expense_date DATE NOT NULL,
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (paid_by) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE favorites (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  location_id INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_favorite(user_id,location_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (location_id) REFERENCES locations(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE registrations (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  trip_id INT UNSIGNED NOT NULL,
  status ENUM('pending','confirmed','cancelled') NOT NULL DEFAULT 'pending',
  registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_registration(user_id,trip_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;


CREATE TABLE checklists (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  trip_id INT UNSIGNED NOT NULL,
  item_name VARCHAR(180) NOT NULL,
  is_completed TINYINT(1) NOT NULL DEFAULT 0,
  item_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_checklist_trip(trip_id,item_order,is_completed)
) ENGINE=InnoDB;

CREATE TABLE checklist_progress (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  checklist_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  is_completed TINYINT(1) NOT NULL DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_checklist_user(checklist_id,user_id),
  FOREIGN KEY (checklist_id) REFERENCES checklists(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_progress_user(user_id,checklist_id)
) ENGINE=InnoDB;

CREATE TABLE reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  location_id INT UNSIGNED NOT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_review_user_location(user_id,location_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (location_id) REFERENCES locations(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE review_images (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  review_id INT UNSIGNED NOT NULL,
  image_path VARCHAR(500) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (review_id) REFERENCES reviews(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_review_images_review(review_id)
) ENGINE=InnoDB;

INSERT INTO users(full_name,email,password_hash,role,status) VALUES
('Admin TripMate','admin@tripmate.local', '$2y$10$92VJbW4v7jW5j8y7Y2E.6eV6V2Lx6cJg6kQ5r7KJ7QG0cY8dR6a', 'admin','active'),
('Demo User','demo@tripmate.local', '$2y$10$92VJbW4v7jW5j8y7Y2E.6eV6V2Lx6cJg6kQ5r7KJ7QG0cY8dR6a', 'user','active');

INSERT INTO categories(name) VALUES ('Biển'),('Núi'),('Thành phố'),('Thiên nhiên'),('Văn hóa');

INSERT INTO locations(category_id,name,address,description,average_cost,rating,image_url,destination) VALUES
(2,'Đà Lạt','Lâm Đồng','Thành phố cao nguyên với khí hậu mát mẻ, quán cà phê và cảnh quan thơ mộng.',350000,4.8,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80','Đà Lạt'),
(1,'Kỳ Co','Quy Nhơn, Bình Định','Bãi biển xanh trong, hợp với lịch trình nghỉ dưỡng và khám phá.',250000,4.9,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80','Quy Nhơn'),
(4,'Tà Xùa','Sơn La','Đi săn mây, trekking nhẹ và ngắm bình minh trên vùng núi phía Bắc.',450000,4.7,'https://images.unsplash.com/photo-1464278533981-50106e6176b1?auto=format&fit=crop&w=1200&q=80','Tà Xùa'),
(3,'Đà Nẵng','Đà Nẵng','Thành phố biển hiện đại, thuận tiện kết hợp nghỉ dưỡng và khám phá.',500000,4.7,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=80','Đà Nẵng'),
(4,'Phong Nha','Quảng Bình','Thiên nhiên hùng vĩ với hệ thống hang động và sông ngầm.',550000,4.8,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80','Phong Nha'),
(5,'Huế','Thừa Thiên Huế','Không gian di sản, ẩm thực và kiến trúc cung đình.',300000,4.6,'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80','Huế'),
(1,'Phú Yên','Phú Yên','Nhịp sống chậm, biển đẹp và nhiều cung đường ven biển ấn tượng.',320000,4.8,'https://images.unsplash.com/photo-1493552152660-f915ab47ae9d?auto=format&fit=crop&w=1200&q=80','Phú Yên'),
(2,'Sa Pa','Lào Cai','Ruộng bậc thang, bản làng và các cung đường núi.',400000,4.7,'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80','Sa Pa'),
(4,'Hồ Xuân Hương','Trung tâm Đà Lạt, Lâm Đồng','Hồ nước biểu tượng của Đà Lạt, phù hợp đi dạo và ngắm cảnh.',100000,4.7,'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1200&q=80','Đà Lạt'),
(3,'Quảng trường Lâm Viên','Phường 10, Đà Lạt, Lâm Đồng','Không gian trung tâm với biểu tượng nụ hoa và view hồ.',120000,4.6,'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=80','Đà Lạt'),
(4,'Thung lũng Tình Yêu','Phường 8, Đà Lạt, Lâm Đồng','Khu tham quan xanh mát với nhiều góc chụp ảnh và hoạt động ngoài trời.',250000,4.6,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80','Đà Lạt'),
(5,'Dinh Bảo Đại','Đường Triệu Việt Vương, Đà Lạt, Lâm Đồng','Không gian kiến trúc và lịch sử nổi bật của Đà Lạt.',180000,4.5,'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80','Đà Lạt'),
(4,'Đồi chè Cầu Đất','Xuân Trường, Đà Lạt, Lâm Đồng','Đồi chè xanh mát, thích hợp săn mây và đón bình minh.',200000,4.8,'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1200&q=80','Đà Lạt');

INSERT INTO trips(owner_id,name,destination,start_date,end_date,budget,description,status) VALUES
(2,'Đà Lạt 3N2Đ','Đà Lạt','2026-09-10','2026-09-12',5000000,'Demo trip cho bài cuối kỳ.','published');
INSERT INTO trip_members(trip_id,user_id,member_role) VALUES (1,2,'owner');
INSERT INTO itineraries(trip_id,location_id,day_number,start_time,end_time,note) VALUES (1,1,1,'08:00','09:00','Ăn sáng + cà phê'),(1,1,1,'10:00','12:00','Khám phá trung tâm'),(1,5,2,'09:00','12:00','Gợi ý điểm thiên nhiên');
INSERT INTO expenses(trip_id,paid_by,category,amount,description,expense_date) VALUES (1,2,'Khách sạn',1500000,'2 đêm','2026-09-10'),(1,2,'Ăn uống',500000,'Ngày 1','2026-09-10'),(1,2,'Di chuyển',700000,'Xe + xăng','2026-09-10');
INSERT INTO checklists(trip_id,item_name,is_completed,item_order) VALUES (1,'CCCD / giấy tờ tùy thân',1,1),(1,'Sạc dự phòng',0,2),(1,'Kem chống nắng',0,3),(1,'Áo khoác mỏng',0,4);
