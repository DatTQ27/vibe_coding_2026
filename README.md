# MintClub — Green Premium Loyalty UI (v3.0)

Ứng dụng web thẻ thành viên hai chế độ **Thành viên / Quầy**, chạy trên **HTML + CSS + JavaScript**, **không cần backend, MySQL, Redis hoặc Internet** sau khi cài cache offline. Giao diện và hướng dẫn bằng tiếng Việt.

> **Lưu ý về dữ liệu chính thức:** Không có file dữ liệu do Ban tổ chức phát đề trong gói này. Ứng dụng hỗ trợ nạp file được phát **.xlsx / .csv / .json**; mã `KT-004` chỉ có sau khi bạn nạp dữ liệu chứa thành viên đó. Không bịa dữ liệu chính thức.

## Nhận diện và giao diện v3

- Màu xanh lá và trắng, nền xanh rất nhạt, card trắng, kính mờ chọn lọc.
- Logo: `assets/images/mintclub-logo.webp` (ảnh người dùng cung cấp).
- Mascot Minty: `assets/images/minty-mascot.webp` (ảnh người dùng cung cấp).
- CSS giao diện bổ sung: `assets/css/mint-green.css`; giữ nguyên các module nghiệp vụ.
- Ảnh chụp bố cục: `preview-1440.png`, `preview-768.png`, `preview-390.png`, `preview-360.png`.
- Lưu ý: chỉ các mục điều hướng và nghiệp vụ có trong dự án mới hoạt động; ảnh concept có thể chứa tính năng minh họa chưa nằm trong phạm vi đề.

## 1. Chạy trên Ubuntu / Windows / macOS

Yêu cầu Python 3 (hoặc máy chủ HTTP tĩnh bất kỳ). Tại thư mục có `index.html`:

```bash
python3 -m http.server 8600 --bind 127.0.0.1
```

Mở **http://localhost:8600** bằng Chrome/Edge. Trên Windows, nếu lệnh `python3` không có, dùng `py -m http.server 8600 --bind 127.0.0.1`.

Không chạy trực tiếp `file://` vì một số tính năng camera, module JavaScript, Service Worker và localStorage có hành vi không nhất quán ở địa chỉ file.

**Thử offline:** Mở ứng dụng qua localhost/HTTPS một lần, mở DevTools → Application → Service Workers để xác nhận đã cài, tải lại trang khi đang có mạng, sau đó tắt Internet hoặc bật chế độ Offline trong DevTools rồi tải lại. Python HTTP server vẫn cần chạy khi dùng localhost để truy cập mới nếu Service Worker không chiếm quyền điều khiển.

Để dùng từ điện thoại qua mạng LAN, cần HTTPS hợp lệ cho tính năng camera và Service Worker; `http://192.168.x.x` thường không được coi là secure context. Có thể dùng host HTTPS phù hợp hoặc kiểm thử tại localhost trên từng thiết bị.

## 2. Công nghệ

- HTML5, CSS3, ES Modules JavaScript; giao diện không tải CDN.
- `localStorage`: một khóa `loyalty_member_pro_v1`, chứa members, transactions, pointHistory, wallet, audit.
- `sw.js` và Cache API cho offline; `manifest.webmanifest` để hỗ trợ cài PWA ở trình duyệt có khả năng.
- QR tạo bằng mã nguồn QRCode của Kazuhiko Arase (MIT) được đóng gói nội bộ, không tải mạng.
- QR đọc bằng **BarcodeDetector API** và `getUserMedia`, có nhập mã thủ công khi không hỗ trợ. **Không bảo đảm quét camera trên mọi trình duyệt**; dùng Chrome/Edge phiên bản hỗ trợ BarcodeDetector QR.
- XLSX đọc bằng `JSZip` (MIT) bản local + XML parser có sẵn trong trình duyệt. CSV/JSON đọc local. Không hỗ trợ Excel `.xls` cổ, macro `.xlsm` hay workbook được mã hóa.
- Trợ lý Minty **rule-based offline**, không gọi LLM, không dùng RAG.

## 3. Các chức năng

### Phần bắt buộc

1. Đăng ký: tên, điện thoại; tạo mã thành viên `MB-000001`... với kiểm tra trùng.
2. Thẻ thành viên đổi màu Đồng, Bạc, Vàng theo **điểm tích lũy trọn đời**.
3. Chế độ Quầy cộng điểm theo **10.000đ = 1 điểm**, làm tròn xuống.
4. Chống cộng trùng mã giao dịch trên toàn bộ dữ liệu của trình duyệt này (không phân biệt chữ hoa/thường và bỏ khoảng trắng đầu/cuối).
5. Hai mức quà: voucher giảm 20.000đ (50 điểm), bình giữ nhiệt (150 điểm).
6. Ví ưu đãi, lịch sử điểm, timestamp.
7. Nút **Nạp dữ liệu mẫu từ file** trong Thể lệ & dữ liệu.
8. Dữ liệu lưu localStorage, ứng dụng tĩnh chạy offline sau cache.

### Nâng cao nhóm 1 + nhóm 2 + trợ lý 3.1

- Hiển thị QR mã thành viên; quét QR bằng camera nếu trình duyệt hỗ trợ.
- Hiệu ứng thẻ lên hạng, thanh tiến độ, dashboard tổng thành viên/điểm phát/điểm đổi/giao dịch và phân bố hạng.
- Tra cứu nhanh tên, mã thành viên, số điện thoại.
- Ví voucher có mã và trạng thái **Chưa dùng / Đã dùng**; không dùng lại voucher.
- Lọc lịch sử biến động điểm.
- Biên nhận TXT sau giao dịch; xuất danh sách thành viên, giao dịch và nhật ký CSV.
- Sao lưu và khôi phục JSON (khôi phục thay thế dữ liệu sau xác nhận).
- Nhật ký Quầy, cảnh báo giao dịch giá trị lớn >= 5.000.000đ.
- PWA/Service Worker, có thể cài trên trình duyệt hỗ trợ.
- Trợ lý Minty: trả lời số điểm, tiến độ lên hạng, quà có thể đổi, ví, thể lệ, lịch sử **dựa trên dữ liệu thật**, không dùng mạng.

## 4. Quy tắc nghiệp vụ

| Nội dung | Quy tắc |
|---|---|
| Tỷ lệ tích điểm | `floor(số tiền VND / 10000)` |
| Hạng Đồng | 0–99 điểm tích lũy |
| Hạng Bạc | 100–299 điểm tích lũy |
| Hạng Vàng | Từ 300 điểm tích lũy |
| Đổi quà | Trừ `pointsBalance`, không trừ `lifetimePoints` |
| Giao dịch trùng | Từ chối mọi mã đã có, kể cả dùng cho thành viên khác |
| QR | Nội dung đúng mã thành viên, không có URL hoặc JSON bọc ngoài |
| Quyền Quầy | Chuyển chế độ trong cùng ứng dụng, không yêu cầu đăng nhập |

Nếu BTC yêu cầu xét hạng theo số dư điểm thay vì điểm tích lũy, cần sửa rõ `tier(...)` trong `assets/js/core.js` và cập nhật Thể lệ. Hiện tại quy tắc được công bố minh bạch trong ứng dụng.

## 5. Nhập dữ liệu mẫu từ Ban tổ chức

Trong **Thể lệ & dữ liệu → Nạp dữ liệu mẫu từ file**, chọn file được phát. Hệ thống tự dò cột tiêu đề. Các tên được nhận diện gồm:

| Trường | Tên cột ví dụ |
|---|---|
| Mã thành viên | `MaThanhVien`, `MaTV`, `MemberID`, `MaKH`, `ID` |
| Họ tên | `HoTen`, `Ten`, `TenThanhVien`, `Name` |
| Điện thoại | `SoDienThoai`, `SDT`, `Phone` |
| Điểm | `Diem`, `DiemTichLuy`, `Points`, `PointsBalance` |
| Tổng điểm | `TongDiemTichLuy`, `LifetimePoints` |
| QR payload | `MaQR_Payload`, `QRPayload`, `MaQR` |

Nếu tồn tại sheet `KT_MaQR`, hệ thống tìm dữ liệu mã QR theo mã thành viên và kiểm tra payload khớp mã. Nếu không thấy cột mã thành viên, ứng dụng báo lỗi thay vì tự đoán. Hệ thống mặc định **bỏ qua** mã thành viên đã tồn tại để tránh phá hủy giao dịch mới; không ghi đè dữ liệu khi nạp lại. Dữ liệu điểm nhập vào được tính là số điểm ban đầu, không tạo lịch sử cộng điểm giả.

**Nếu bộ dữ liệu thực tế dùng tên cột khác**, cập nhật `aliases` trong `assets/js/importer.js` để ánh xạ đúng. Nếu sheet QR chỉ có một cột payload và mã thành viên trùng payload, hiện bản đọc chuẩn kỳ vọng thêm cột mã; có thể bổ sung ánh xạ theo file thực tế.

## 6. Kiểm thử nhanh với mã KT-004

1. Nạp file chính thức có `KT-004`.
2. Tìm mã `KT-004` trong Thành viên và xác nhận tên/điểm với Excel.
3. Xem QR trong thẻ: payload phải chính xác `KT-004`.
4. Trong Quầy nhập `KT-004`, mã `GD-TEST-001`, số tiền `100000`; cộng đúng 10 điểm.
5. Thử lặp `GD-TEST-001` với bất kỳ thành viên: phải báo lỗi, không cộng lại.
6. Đổi quà nếu đủ điểm, xác nhận lịch sử và ví ưu đãi.
7. Tải lại trang, kiểm tra dữ liệu được giữ; tắt mạng, kiểm tra sau khi Service Worker cache xong.
8. Kiểm tra màn hình rộng 360–390 px.

## 7. Kiểm thử tự động

Máy có Node.js 18+:

```bash
node --test tests/core.test.mjs
```

Ngoài ra có thể dùng trình duyệt và DevTools để test QR/camera, responsive, offline và import XLSX.

## 8. Cấu trúc thư mục

```text
index.html                  Giao diện SPA
assets/css/style.css        CSS gốc (giữ nguyên để tương thích)
assets/css/fintech-ui.css   Design tokens + giao diện Fintech Glass v2
assets/js/core.js           Logic nghiệp vụ, store, kiểm tra dữ liệu
assets/js/importer.js       Đọc XLSX/CSV/JSON
assets/js/app.js            Tương tác giao diện, QR camera, trợ lý
assets/vendor/              JSZip + QR engine được đóng gói local
assets/icons/               Icon ứng dụng
sw.js                       Cache offline
manifest.webmanifest        Thông tin cài đặt PWA
tests/core.test.mjs         Unit tests
```

## 9. Giới hạn và lưu ý an toàn

- localStorage không phải database server và **không đồng bộ giữa thiết bị hoặc origin**. Giao dịch chống trùng chỉ bảo đảm trong dữ liệu đang dùng trên một trình duyệt, không an toàn với nhiều tab thực hiện ghi đồng thời. Không dùng ứng dụng này làm hệ thống tích điểm tài chính thực tế.
- Xóa dữ liệu website hoặc dùng chế độ ẩn danh có thể làm mất dữ liệu; thường xuyên dùng **Sao lưu JSON**.
- `BarcodeDetector` chưa hỗ trợ thống nhất trên mọi trình duyệt; nếu không tương thích, người dùng nhập mã tay. Cần HTTPS/localhost và quyền camera.
- Trình đọc XLSX dành cho bảng dữ liệu đơn giản, không tính lại công thức; nên sử dụng các ô có giá trị, không workbook phức tạp.
- Điểm đã phát trong thống kê = tổng điểm tích lũy trọn đời của các thành viên, gồm điểm từ dữ liệu mẫu và điểm cộng từ giao dịch; không trừ điểm đã đổi.
- Không dùng CDN, Google Fonts, API AI hay khóa bí mật; trợ lý chỉ có khả năng trả lời theo các mẫu câu đã lập trình.

## 10. Bản quyền thư viện

- QRCode (Kazuhiko Arase): MIT License, phiên bản được phân phối trong `qrcode-terminal` vendor.
- JSZip: MIT License. Xem file `LICENSE-THIRD-PARTY.md`.

## 11. Dữ liệu thử nghiệm kèm theo

File `tests/DU_LIEU_GIA_LAP_CHI_DE_TEST.xlsx` chỉ là **bộ dữ liệu mô phỏng để thử tính năng import**, KHÔNG phải dữ liệu chính thức của Ban tổ chức. Có hai thành viên `KT-004`, `KT-005` để kiểm tra import và QR.

## 10. Thiết kế giao diện phiên bản 2.0

- Chủ đề **Modern Soft Glassmorphism + Premium Fintech SaaS**. Xanh `#2563EB` / `#1E40AF`, nền `#F8FAFC`, card trắng, kính mờ rất nhẹ ở header/sidebar/chatbot.
- Lucide-style SVG sprite nội bộ, không dùng CDN; không thêm dependency runtime.
- Sidebar desktop, bottom nav tablet/mobile, card thành viên ba hạng, giao diện Quầy theo luồng nghiệp vụ.
- Dashboard mở rộng biểu đồ giao dịch 7 ngày, bảng thành viên có tìm kiếm và lọc hạng, tìm nhật ký quản trị. Tất cả suy ra từ dữ liệu hiện có.
- Minty là cửa sổ chat nổi dùng lại `assistant(...)` trong core; có câu hỏi gợi ý và trạng thái phản hồi ngắn.
- Cấu trúc localStorage **giữ nguyên `loyalty_member_pro_v1`**, schemaVersion 1; module `core.js`, `importer.js` không đổi.
- Mã nguồn CSS mới tách riêng để có thể hoàn tác giao diện; Service Worker đổi tên cache sang `mintclub-fintech-v2.0.0` và precache file CSS mới.

### Kiểm tra sau nâng cấp

```bash
node --test tests/*.test.mjs
```

Đặc biệt thử 360/390/768/1440 px và đăng ký → cộng điểm → đổi quà → reload → lọc báo cáo → Minty → QR.

Các chức năng quét camera và cài PWA chỉ có thể xác nhận đầy đủ trên trình duyệt/thiết bị hỗ trợ. Trạng thái “Minty đang trả lời” là micro-interaction trên câu trả lời rule-based, không phải truy vấn LLM hay streaming.
