create database Hackathon;
use hackathon;
create table Guests(
	guest_id varchar(5) primary key,
    full_name varchar(1000) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null unique
    
 );
 create table RoomTypes(
	type_id varchar(5) primary key,
    type_name varchar(100) not null unique
    
 );
 create table Rooms(
	room_id varchar(5) primary key,
    room_name varchar(100) not null unique,
    type_id varchar(5),
    foreign key (type_id) references Roomtypes(type_id),
    price_per_night decimal(10,2) not null,
    capacity int
    
);	
create table Reservations (
	reservation_id int primary key auto_increment,
    guest_id varchar(5),
    room_id varchar(5),
    status varchar(20) not null,
    check_in_date date
    
);
insert into Guests (guest_id,full_name,email,phone) value
('G01','Lê Văn Tám','tam.lv@gmail.com','0901111111'),
('G02','Bùi Thị Lan','lan.bt@gmail.com','0902222222'),
('G03','Đỗ Hữu Trọng','trong.dh@gmail.com','0903333333'),
('G04','Lý Thanh Hà','ha.lt@gmail.com','0904444444'),
('G05','Trương Vĩnh Ký','ky.tv@gmail.com','0905555555');
insert into Roomtypes(type_id,type_name) value
('T01','Standard'),
('T02','Superior'),
('T03','Deluxe'),
('T04','Suite');
insert into rooms(room_id,room_name,type_id,price_per_night,capacity) value
('R01','Phòng 101','T01','500000.00','2'),
('R02','Phòng 102','T01','500000.00','2'),
('R03','Phòng 201','T02','800000.00','2'),
('R04','Phòng 301','T03','1200000.00','3'),
('R05','Phòng 401','T04','2500000.00','4');
insert into Reservations(reservation_id,guest_id,room_id,status,check_in_date) value
('1','G01','R01','Booked','2025-10-01'),
('2','G02','R03','Checked-in','2025-10-02'),
('3','G01','R02','Checked-in','2025-10-03'),
('4','G04','R05','Cancelled','2025-10-04'),
('5','G05','R01','Booked','2025-10-05');
select * from rooms;
-- 3 'Phòng 401' vừa được nâng cấp, hãy tăng capacity thêm 2 người và tăng price_per_night lên 5%.

Update rooms
set price_per_night = price_per_night * 0.5 and capacity = capacity + 2
where room_name = 'Phòng 401';
-- 4 Cập nhật số điện thoại của khách hàng có guest_id = 'G03' thành '0999999999'.
Update guests 
set phone = '0999999999'
where guest_id = 'G03';
-- 5 Xóa tất cả các bản ghi đặt phòng trong bảng Reservations có trạng thái là 'Cancelled' và có ngày check-in trước ngày '2025-10-03'
delete from Reservations 
where status = 'Cancelled' and check_in_date <  '2025-10-03';
-- 6 Liệt kê các phòng gồm room_id, room_name, price_per_night có giá mỗi đêm từ 800,000 đến 2,000,000 và có sức chứa (capacity) > 2
select room_id,
room_name,
price_per_night 
from rooms
where price_per_night between 800000 and 2000000 and capacity > 2;
-- 7 Lấy thông tin full_name, email của những khách hàng có họ là 'Lê'.
select * from guests 
where full_name like 'Lê%';
-- 8 Hiển thị danh sách các lượt đặt phòng gồm reservation_id, guest_id, check_in_date. Sắp xếp theo check_in_date giảm dần
select 
 reservation_id,
 guest_id,
 check_in_date
 from reservations
 order by check_in_date DESC;
 -- 9 Lấy ra 3 phòng có giá (price_per_night) đắt nhất trong khách sạn
select * from rooms
order by price_per_night DESC
limit 3;
-- 10 Hiển thị danh sách room_name, capacity từ bảng Rooms, bỏ qua 2 phòng đầu tiên và lấy 2 phòng tiếp theo (Phân trang).
select room_name,
capacity 
from rooms
limit 2 offset 2;
-- 11 Hiển thị danh sách gồm: reservation_id, full_name (của khách), room_name (của phòng) và check_in_date. Chỉ lấy những đơn đặt có trạng thái 'Booked'.
select r.reservation_id,
g.full_name,
r2.room_name,
r.check_in_date
from reservations as r
join guests as g
on g.guest_id = r.guest_id
join rooms as r2
on r2.room_id = r.room_id
where r.status = 'Booked';
-- 12 Liệt kê tất cả các Loại phòng (RoomType) và tên phòng (room_name) thuộc loại đó. Hiển thị cả những loại phòng chưa có phòng nào.

select room_name,
type_name 
from rooms as r1
right join roomtypes as r2
on r1.type_id = r2.type_id;
-- 13 Tính tổng số lượt đặt phòng theo từng trạng thái (status). Kết quả gồm hai cột: status và Total_Reservations.

select Status,count(status) as Total_reservation
from reservations
group by status;
-- 14 Thống kê số lượng phòng mà mỗi khách hàng đã đặt. Chỉ hiển thị tên khách hàng (full_name) có từ 2 lượt đặt trở lên.

select full_name,
count(room_id) as Total_book_room
from reservations as r
left join guests as g
on g.guest_id = r.guest_id
group by full_name
having total_book_room >= 2;
-- 15 Lấy thông tin chi tiết các phòng (room_id, room_name, price_per_night) có giá mỗi đêm nhỏ hơn giá trung bình của tất cả các phòng trong khách sạn.

select room_id,
room_name,
price_per_night
from rooms
where Price_per_night > (Select avg(Price_per_night) from rooms);
-- 16 Hiển thị full_name và phone của những khách hàng đã từng đặt 'Phòng 101'.

select full_name,
phone from guests as g
join reservations as r
on r.guest_id = g.guest_id
where r.room_id = 'R01'
