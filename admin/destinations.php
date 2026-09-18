<?php
session_start(); require __DIR__.'/../config/database.php'; require __DIR__.'/../includes/helpers.php'; require_admin();
if($_SERVER['REQUEST_METHOD']==='POST'){
  verify_csrf(); $action=$_POST['action']??'';
  if($action==='save'){
    $id=(int)($_POST['id']??0); $name=trim($_POST['name']??'');
    $notes=trim($_POST['notes']??''); $cost=max(0,(float)($_POST['average_cost']??0));
    $rating=max(0,min(5,(float)($_POST['rating']??0))); $image=trim($_POST['image_url']??'');
    if($name===''){flash('danger','Vui lòng nhập tên tỉnh / thành phố.'); redirect('admin/destinations.php');}
    try{
      if($id){$pdo->prepare('UPDATE destinations SET name=?,notes=?,average_cost=?,rating=?,image_url=? WHERE id=?')->execute([$name,$notes,$cost,$rating,$image,$id]);flash('success','Đã cập nhật điểm đến.');}
      else{$pdo->prepare('INSERT INTO destinations(name,notes,average_cost,rating,image_url) VALUES(?,?,?,?,?)')->execute([$name,$notes,$cost,$rating,$image]);flash('success','Đã thêm điểm đến.');}
    }catch(PDOException $e){flash('danger',str_contains($e->getMessage(),'Duplicate')?'Tên tỉnh / thành phố đã tồn tại.':'Không thể lưu điểm đến.');}
  } elseif($action==='toggle'){
    $id=(int)$_POST['id']; $pdo->prepare('UPDATE destinations SET is_active=1-is_active WHERE id=?')->execute([$id]); flash('info','Đã cập nhật trạng thái điểm đến.');
  } elseif($action==='delete'){
    $id=(int)$_POST['id'];
    // Xóa mềm: giữ lịch sử Trip và địa danh, nhưng không cho xuất hiện khi tạo Trip/Explore.
    $pdo->prepare('UPDATE destinations SET is_active=0 WHERE id=?')->execute([$id]); flash('info','Đã ẩn điểm đến. Nó sẽ không còn xuất hiện khi tạo chuyến đi.');
  }
  redirect('admin/destinations.php');
}
$rows=$pdo->query('SELECT d.*,COUNT(l.id) location_count FROM destinations d LEFT JOIN locations l ON l.destination_id=d.id GROUP BY d.id ORDER BY d.is_active DESC,d.name')->fetchAll();
$pageTitle='Admin · Điểm đến'; include __DIR__.'/../includes/header.php'; show_flash();
?>
<div class="page-shell">
  <div class="d-flex justify-content-between align-items-center"><div><div class="eyebrow">ADMIN</div><h1 class="fw-800 mb-0">Điểm đến</h1><div class="subtext mt-1">Quản lý tỉnh / thành phố. Địa danh được thêm bên trong từng điểm đến.</div></div><button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#destModal" onclick="resetDestForm()">+ Thêm tỉnh / thành phố</button></div>
  <div class="row g-3 mt-3">
  <?php foreach($rows as $r): ?>
    <div class="col-md-6 col-xl-4"><div class="panel h-100 p-0 overflow-hidden"><a href="<?= base_url('admin/destination-detail.php?id='.$r['id']) ?>" class="text-decoration-none text-dark"><img src="<?= e($r['image_url'] ?: 'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=900&q=80') ?>" style="width:100%;height:170px;object-fit:cover" alt=""><div class="p-3"><div class="d-flex justify-content-between"><span class="pill"><?= $r['is_active']?'Đang dùng':'Đã ẩn' ?></span><small class="text-secondary"><?= (int)$r['location_count'] ?> địa danh</small></div><h3 class="fs-5 fw-800 mt-2 mb-1"><?= e($r['name']) ?></h3><div class="small text-secondary">⭐ <?= e($r['rating']) ?> · <?= number_format($r['average_cost'],0,',','.') ?>đ</div><?php if($r['notes']): ?><p class="small text-secondary mt-2 mb-0"><?= e($r['notes']) ?></p><?php endif; ?></div></a><div class="px-3 pb-3 d-flex gap-2"><button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#destModal" onclick='editDest(<?= json_encode($r,JSON_HEX_TAG|JSON_HEX_APOS|JSON_HEX_AMP|JSON_HEX_QUOT) ?>)'>Sửa</button><form method="post"><input type="hidden" name="csrf" value="<?= e(csrf_token()) ?>"><input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="<?= $r['id'] ?>"><button class="btn btn-sm btn-light border"><?= $r['is_active']?'Ẩn':'Hiện lại' ?></button></form></div></div></div>
  <?php endforeach; ?>
  </div>
</div>
<div class="modal fade" id="destModal"><div class="modal-dialog modal-lg"><div class="modal-content"><form method="post"><div class="modal-header"><h5 class="modal-title fw-800" id="destTitle">Thêm tỉnh / thành phố</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body"><input type="hidden" name="csrf" value="<?= e(csrf_token()) ?>"><input type="hidden" name="action" value="save"><input type="hidden" name="id" id="destId"><div class="row g-3"><div class="col-md-6"><label class="form-label fw-semibold">Tỉnh / thành phố</label><input class="form-control" name="name" id="destName" placeholder="Ví dụ: Hà Nội" required></div><div class="col-md-3"><label class="form-label">Chi phí dự kiến</label><input class="form-control" type="number" min="0" name="average_cost" id="destCost" value="0"></div><div class="col-md-3"><label class="form-label">Rating</label><input class="form-control" type="number" step="0.1" min="0" max="5" name="rating" id="destRating" value="4.5"></div><div class="col-12"><label class="form-label">Ghi chú</label><textarea class="form-control" name="notes" id="destNotes" rows="3" placeholder="Đặc trưng, thời điểm nên đi, lưu ý..."></textarea></div><div class="col-12"><label class="form-label">Ảnh đại diện</label><input class="form-control" name="image_url" id="destImage" placeholder="URL ảnh"></div></div></div><div class="modal-footer"><button class="btn btn-primary">Lưu</button></div></form></div></div></div>
<script>function resetDestForm(){destTitle.textContent='Thêm tỉnh / thành phố';destId.value='';destName.value='';destCost.value='0';destRating.value='4.5';destNotes.value='';destImage.value='';}function editDest(r){destTitle.textContent='Sửa tỉnh / thành phố';destId.value=r.id;destName.value=r.name;destCost.value=r.average_cost;destRating.value=r.rating;destNotes.value=r.notes||'';destImage.value=r.image_url||'';}</script>
<?php include __DIR__.'/../includes/footer.php'; ?>
