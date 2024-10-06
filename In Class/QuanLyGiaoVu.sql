-- Tạo database quản lí giáo vụ
CREATE DATABASE QUANLIGIAOVU

USE QUANLIGIAOVU

-- Tạo các quan hệ trong database
CREATE TABLE HOCVIEN(
	 MAHV char(5) PRIMARY KEY,
	 HO varchar(40),
	 TEN varchar(10),
	 NGSINH smalldatetime,
	 GIOITINH varchar(3),
	 NOISINH varchar(40),
	 MALOP char(4),
);

ALTER TABLE HOCVIEN
ALTER COLUMN MALOP CHAR (3)

ALTER TABLE HOCVIEN ADD
CONSTRAINT FK_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)

CREATE TABLE KHOA(
	MAKHOA varchar(4) PRIMARY KEY,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4),
);

CREATE TABLE MONHOC(
	MAMH VARCHAR(10) PRIMARY KEY,
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4) REFERENCES KHOA(MAKHOA),
);

CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
	MAMH_TRUOC VARCHAR(10) REFERENCES MONHOC(MAMH),
	PRIMARY KEY (MAMH, MAMH_TRUOC),
);

CREATE TABLE GIAOVIEN(
	MAGV CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4) REFERENCES KHOA(MAKHOA),
);

CREATE TABLE LOP(
	MALOP CHAR(3) PRIMARY KEY,
	TENLOP VARCHAR(40),
	TRGLOP CHAR(5) REFERENCES HOCVIEN(MAHV),
	SISO TINYINT,
	MAGVCN CHAR(4) REFERENCES GIAOVIEN(MAGV),
);

CREATE TABLE GIANGDAY(
	MALOP CHAR(3) REFERENCES LOP(MALOP),
	MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
	MAGV CHAR(4) REFERENCES GIAOVIEN(MAGV),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME,
	PRIMARY KEY (MALOP, MAMH),
);

CREATE TABLE KETQUATHI(
	MAMH VARCHAR(10) REFERENCES MONHOC(MAMH),
	MAHV CHAR(5) REFERENCES HOCVIEN(MAHV),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA VARCHAR(10),
	PRIMARY KEY(MAHV, MAMH, LANTHI),
);

ALTER TABLE KHOA ADD
CONSTRAINT FK_TGK_GV FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)



-- I.
-- 3. Thuộc tính của GIOITINH chỉ có giá trị là "Nam" hoặc "Nữ".
ALTER TABLE HOCVIEN ADD
CONSTRAINT CK_GT_HV CHECK (GIOITINH IN ('Nam', 'Nu'))

ALTER TABLE GIAOVIEN ADD
CONSTRAINT CK_GT_GV CHECK (GIOITINH IN ('Nam', 'Nu'))

-- 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD 
CONSTRAINT CK_DIEM CHECK (
	DIEM BETWEEN 0 AND 10 AND
	LEN(SUBSTRING(CAST(DIEM AS VARCHAR), CHARINDEX('.', DIEM) + 1, 1000)) >= 2
)

-- 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD 
CONSTRAINT CK_KQUA CHECK (KQUA = IIF(DIEM BETWEEN 5 AND 10, 'Dat', 'Khong dat'))

-- 6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD
CONSTRAINT CK_SOLANTHI CHECK (LANTHI <= 3)

-- 7. Học kì chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD
CONSTRAINT CK_HOCKY CHECK (HOCKY BETWEEN 1 AND 3)

-- 8. Học vị của giáo viên chỉ có thể là "CN", "KS", "ThS", "TS", "PTS".
ALTER TABLE GIAOVIEN ADD
CONSTRAINT CK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'ThS', 'TS', 'PTS'))



-- Nhập dữ liệu cho cơ sở dữ liệu
INSERT KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA) VALUES 
(N'KHMT', N'Khoa hoc may tinh', CAST(N'2005-06-07T00:00:00.000' AS DateTime), NULL),
(N'HTTT', N'He thong thong tin', CAST(N'2005-06-07T00:00:00.000' AS DateTime), NULL),
(N'CNPM', N'Cong nghe phan mem', CAST(N'2005-06-07T00:00:00.000' AS DateTime), NULL),
(N'MTT', N'Mang va truyen thong', CAST(N'2005-10-20T00:00:00.000' AS DateTime), NULL),
(N'KTMT', N'Ky thuat may tinh', CAST(N'2005-12-20T00:00:00.000' AS DateTime), NULL);

INSERT MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA) VALUES
(N'THDC', N'Tin hoc dai cuong', 4, 1, N'KHMT'),
(N'CTRR', N'Cau truc roi rac', 5, 0, N'KHMT'),
(N'CSDL', N'Co so du lieu', 3, 1, N'HTTT'),
(N'CTDLGT', N'Cau truc du lieu va giai thuat', 3, 1, N'KHMT'),
(N'PTTKTT', N'Phan tich thiet ke thuat toan', 3, 0, N'KHMT'),
(N'DHMT', N'Do hoa may tinh', 3, 1, N'KHMT'),
(N'KTMT', N'Kien truc may tinh', 3, 0, N'KTMT'),
(N'TKCSDL', N'Thiet ke co so du lieu', 3, 1, N'HTTT'),
(N'PTTKHTTT', N'Phan tich thiet ke he thong thong tin', 4, 1, N'HTTT'),
(N'HDH', N'He dieu hanh', 4, 0, N'KTMT'),
(N'NMCNPM', N'Nhap mon cong nghe phan mem', 3, 0, N'CNPM'),
(N'LTCFW', N'Lap trinh C for win', 3, 1, N'CNPM'),
(N'LTHDT', N'Lap trinh huong doi tuong', 3, 1, N'CNPM');

INSERT DIEUKIEN (MAMH, MAMH_TRUOC) VALUES
(N'CSDL', N'CTRR'),
(N'CSDL', N'CTDLGT'),
(N'CTDLGT', N'THDC'),
(N'PTTKTT', N'THDC'),
(N'PTTKTT', N'CTDLGT'),
(N'DHMT', N'THDC'),
(N'LTHDT', N'THDC'),
(N'PTTKHTTT', N'CSDL');

INSERT GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA) VALUES
(N'GV01', N'Ho Thanh Son', N'PTS', N'GS', N'Nam', '1950-05-02', '2004-01-11', 5, 2250000, N'KHMT'),
(N'GV02', N'Tran Tam Thanh', N'TS', N'PGS', N'Nam', '1965-12-17', '2004-04-20', 4.5, 2025000, N'HTTT'),
(N'GV03', N'Do Nghiem Phung', N'TS', N'GS', N'Nu', '1950-08-01', '2004-09-23', 4, 1800000, N'CNPM'),
(N'GV04', N'Tran Nam Son', N'TS', N'PGS', N'Nam', '1961-02-22', '2005-01-12', 4.5, 2025000, N'KTMT'),
(N'GV05', N'Mai Thanh Danh', N'ThS', N'GV', N'Nam', '1958-03-12', '2005-01-12', 3, 1350000, N'HTTT'),
(N'GV06', N'Tran Doan Hung', N'TS', N'GV', N'Nam', '1953-03-11', '2005-01-12', 4.5, 2025000, N'KHMT'),
(N'GV07', N'Nguyen Minh Tien', N'ThS', N'GV', N'Nam', '1971-11-23', '2005-03-01', 4, 1800000, N'KHMT'),
(N'GV08', N'Le Thi Tran', N'KS', N'Null', N'Nu', '1974-03-26', '2005-03-01', 1.69, 760500, N'KHMT'),
(N'GV09', N'Nguyen To Lan', N'ThS', N'GV', N'Nu', '1966-12-31', '2005-03-01', 4, 1800000, N'HTTT'),
(N'GV10', N'Le Tran Anh Loan', N'KS', N'Null', N'Nu', '1972-07-17', '2005-03-01', 1.86, 837000, N'CNPM'),
(N'GV11', N'Ho Thanh Tung', N'CN', N'GV', N'Nam', '1980-01-12', '2005-05-15', 2.67, 1201500, N'MTT'),
(N'GV12', N'Tran Van Anh', N'CN', N'Null', N'Nu', '1981-03-29', '2005-05-15', 1.69, 760500, N'CNPM'),
(N'GV13', N'Nguyen Linh Dan', N'CN', N'Null', N'Nu', '1980-05-23', '2005-05-15', 1.69, 760500, N'KTMT'),
(N'GV14', N'Truong Minh Chau', N'ThS', N'GV', N'Nu', '1976-11-30', '2005-05-15', 3, 1350000, N'MTT'),
(N'GV15', N'Le Ha Thanh', N'ThS', N'GV', N'Nam', '1978-05-04', '2005-05-15', 3, 1350000, N'KHMT');

INSERT LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN) VALUES
(N'K11', N'Lop 1 khoa 1', N'K1108', 11, N'GV07'),
(N'K12', N'Lop 2 khoa 1', N'K1205', 12, N'GV09'),
(N'K13', N'Lop 3 khoa 1', N'K1305', 12, N'GV14');

INSERT HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP) VALUES
(N'K1101', N'Nguyen Van', N'A', '1986-01-27', N'Nam', N'TpHCM', N'K11'),
(N'K1102', N'Tran Ngoc', N'Han', '1986-03-14', N'Nu', N'Kien Giang', N'K11'),
(N'K1103', N'Ha Duy', N'Lap', '1986-04-18', N'Nam', N'Nghe An', N'K11'),
(N'K1104', N'Tran Ngoc', N'Linh', '1986-03-30', N'Nu', N'Tay Ninh', N'K11'),
(N'K1105', N'Tran Minh', N'Long', '1986-02-27', N'Nam', N'TpHCM', N'K11'),
(N'K1106', N'Le Nhat', N'Minh', '1986-01-24', N'Nam', N'TpHCM', N'K11'),
(N'K1107', N'Nguyen Nhu', N'Nhut', '1986-01-27', N'Nam', N'Ha Noi', N'K11'),
(N'K1108', N'Nguyen Manh', N'Tam', '1986-02-27', N'Nam', N'Kien Giang', N'K11'),
(N'K1109', N'Phan Thi Thanh', N'Tam', '1986-01-27', N'Nu', N'Vinh Long', N'K11'),
(N'K1110', N'Le Hoai', N'Thuong', '1986-02-05', N'Nu', N'Can Tho', N'K11'),
(N'K1111', N'Le Ha', N'Vinh', '1986-12-25', N'Nam', N'Vinh Long', N'K11'),
(N'K1201', N'Nguyen Van', N'B', '1986-02-11', N'Nam', N'TpHCM', N'K12'),
(N'K1202', N'Nguyen Thi Kim', N'Duyen', '1986-01-18', N'Nu', N'TpHCM', N'K12'),
(N'K1203', N'Tran Thi Kim', N'Duyen', '1986-09-17', N'Nu', N'TpHCM', N'K12'),
(N'K1204', N'Truong My', N'Hanh', '1986-05-19', N'Nu', N'Dong Nai', N'K12'),
(N'K1205', N'Nguyen Thanh', N'Nam', '1986-04-17', N'Nam', N'TpHCM', N'K12'),
(N'K1206', N'Nguyen Thi Truc', N'Thanh', '1986-03-04', N'Nu', N'Kien Giang', N'K12'),
(N'K1207', N'Tran Thi Bich', N'Thuy', '1986-02-08', N'Nu', N'Nghe An', N'K12'),
(N'K1208', N'Huynh Thi Kim', N'Trieu', '1986-04-08', N'Nu', N'Tay Ninh', N'K12'),
(N'K1209', N'Pham Thanh', N'Trieu', '1986-02-23', N'Nam', N'TpHCM', N'K12'),
(N'K1210', N'Ngo Thanh', N'Tuan', '1986-02-14', N'Nam', N'TpHCM', N'K12'),
(N'K1211', N'Do Thi', N'Xuan', '1986-03-09', N'Nu', N'Ha Noi', N'K12'),
(N'K1212', N'Le Thi Phi', N'Yen', '1986-03-12', N'Nu', N'TpHCM', N'K12'),
(N'K1301', N'Nguyen Thi Kim', N'Cuc', '1986-06-09', N'Nu', N'Kien Giang', N'K13'),
(N'K1302', N'Truong Thi My', N'Hien', '1986-03-18', N'Nu', N'Nghe An', N'K13'),
(N'K1303', N'Le Duc', N'Hien', '1986-03-21', N'Nam', N'Tay Ninh', N'K13'),
(N'K1304', N'Le Quang', N'Hien', '1986-04-18', N'Nam', N'TpHCM', N'K13'),
(N'K1305', N'Le Thi', N'Huong', '1986-03-27', N'Nu', N'TpHCM', N'K13'),
(N'K1306', N'Nguyen Thai', N'Huu', '1986-03-30', N'Nam', N'Ha Noi', N'K13'),
(N'K1307', N'Tran Minh', N'Man', '1986-05-28', N'Nam', N'TpHCM', N'K13'),
(N'K1308', N'Nguyen Hieu', N'Nghia', '1986-04-08', N'Nam', N'Kien Giang', N'K13'),
(N'K1309', N'Nguyen Trung', N'Nghia', '1987-01-18', N'Nam', N'Nghe An', N'K13'),
(N'K1310', N'Tran Thi Hong', N'Tham', '1986-04-22', N'Nu', N'Tay Ninh', N'K13'),
(N'K1311', N'Tran Minh', N'Thuc', '1986-04-04', N'Nam', N'TpHCM', N'K13'),
(N'K1312', N'Nguyen Thi Kim', N'Yen', '1986-09-07', N'Nu', N'TpHCM', N'K13');

INSERT GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY) VALUES
(N'K11', N'THDC', N'GV07', 1, 2006, '2006-01-02', '2006-05-12'),
(N'K12', N'THDC', N'GV06', 1, 2006, '2006-01-02', '2006-05-12'),
(N'K13', N'THDC', N'GV15', 1, 2006, '2006-01-02', '2006-05-12'),
(N'K11', 'CTRR', N'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
(N'K12', N'CTRR', N'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
(N'K13', N'CTRR', N'GV08', 1, 2006, '2006-01-09', '2006-05-17'),
(N'K11', N'CSDL', N'GV05', 2, 2006, '2006-06-01', '2006-07-15'),
(N'K12', N'CSDL', N'GV09', 2, 2006, '2006-06-01', '2006-07-15'),
(N'K13', N'CTDLGT', N'GV15', 2, 2006, '2006-06-01', '2006-07-15'),
(N'K13', N'CSDL', N'GV05', 3, 2006, '2006-08-01', '2006-12-15'),
(N'K13', N'DHMT', N'GV07', 3, 2006, '2006-08-01', '2006-12-15'),
(N'K11', N'CTDLGT', N'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
(N'K12', N'CTDLGT', N'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
(N'K11', N'HDH', N'GV04', 1, 2007, '2007-01-02', '2007-02-18'),
(N'K12', N'HDH', N'GV04', 1, 2007, '2007-01-02', '2007-03-20'),
(N'K11', N'DHMT', N'GV07', 1, 2007, '2007-02-18', '2007-03-20');

INSERT KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES
(N'K1101', N'CSDL', 1, '2006-07-20', 10, N'Dat'),
(N'K1101', N'CTDLGT', 1, '2006-12-28', 9, N'Dat'),
(N'K1101', N'THDC', 1, '2006-05-20', 9, N'Dat'),
(N'K1101', N'CTRR', 1, '2006-05-13', 9.5, N'Dat'),
(N'K1102', N'CSDL', 1, '2006-07-20', 4, N'Khong Dat'),
(N'K1102', N'CSDL', 2, '2006-07-27', 4.25, N'Khong Dat'),
(N'K1102', N'CSDL', 3, '2006-08-10', 4.5, N'Khong Dat'),
(N'K1102', N'CTDLGT', 1, '2006-12-28', 4.5, N'Khong Dat'),
(N'K1102', N'CTDLGT', 2, '2007-01-05', 4, N'Khong Dat'),
(N'K1102', N'CTDLGT', 3, '2007-01-15', 6, N'Dat'),
(N'K1102', N'THDC', 1, '2006-05-20', 5, N'Dat'),
(N'K1102', N'CTRR', 1, '2006-05-13', 7, N'Dat'),
(N'K1103', N'CSDL', 1, '2006-07-20', 3.5, N'Khong Dat'),
(N'K1103', N'CSDL', 2, '2006-07-27', 8.25, N'Dat'),
(N'K1103', N'CTDLGT', 1, '2006-12-28', 7, N'Dat'),
(N'K1103', N'THDC', 1, '2006-05-20', 8, N'Dat'),
(N'K1103', N'CTRR', 1, '2006-05-13', 6.5, N'Dat'),
(N'K1104', N'CSDL', 1, '2006-07-20', 3.75, N'Khong Dat'),
(N'K1104', N'CTDLGT', 1, '2006-12-28', 4, N'Khong Dat'),
(N'K1104', N'THDC', 1, '2006-05-20', 4, N'Khong Dat'),
(N'K1104', N'CTRR', 1, '2006-05-13', 4, N'Khong Dat'),
(N'K1104', N'CTRR', 2, '2006-05-20', 3.5, N'Khong Dat'),
(N'K1104', N'CTRR', 3, '2006-06-30', 4, N'Khong Dat'),
(N'K1201', N'CSDL', 1, '2006-07-20', 6, N'Dat'),
(N'K1201', N'CTDLGT', 1, '2006-12-28', 5, N'Dat'),
(N'K1201', N'THDC', 1, '2006-05-20', 8.5, N'Dat'),
(N'K1201', N'CTRR', 1, '2006-05-13', 9, N'Dat'),
(N'K1202', N'CSDL', 1, '2006-07-20', 8, N'Dat'),
(N'K1202', N'CTDLGT', 1, '2006-12-28', 4, N'Khong Dat'),
(N'K1202', N'CTDLGT', 2, '2007-01-05', 5, N'Dat'),
(N'K1202', N'THDC', 1, '2006-05-20', 4, N'Khong Dat'),
(N'K1202', N'THDC', 2, '2006-05-27', 4, N'Khong Dat'),
(N'K1202', N'CTRR', 1, '2006-05-13', 3, N'Khong Dat'),
(N'K1202', N'CTRR', 2, '2006-05-20', 4, N'Khong Dat'),
(N'K1202', N'CTRR', 3, '2006-06-30', 6.25, N'Dat'),
(N'K1203', N'CSDL', 1, '2006-07-20', 9.25, N'Dat'),
(N'K1203', N'CTDLGT', 1, '2006-12-28', 9.5, N'Dat'),
(N'K1203', N'THDC', 1, '2006-05-20', 10, N'Dat'),
(N'K1203', N'CTRR', 1, '2006-05-13', 10, N'Dat'),
(N'K1204', N'CSDL', 1, '2006-07-20', 8.5, N'Dat'),
(N'K1204', N'CTDLGT', 1, '2006-12-28', 6.75, N'Dat'),
(N'K1204', N'THDC', 1, '2006-05-20', 4, N'Khong Dat'),
(N'K1204', N'CTRR', 1, '2006-05-13', 6, N'Dat'),
(N'K1301', N'CSDL', 1, '2006-12-20', 4.25, N'Khong Dat'),
(N'K1301', N'CTDLGT', 1, '2006-07-25', 8, N'Dat'),
(N'K1301', N'THDC', 1, '2006-05-20', 7.75, N'Dat'),
(N'K1301', N'CTRR', 1, '2006-05-13', 8, N'Dat'),
(N'K1302', N'CSDL', 1, '2006-12-20', 6.75, N'Dat'),
(N'K1302', N'CTDLGT', 1, '2006-07-25', 5, N'Dat'),
(N'K1302', N'THDC', 1, '2006-05-20', 8, N'Dat'),
(N'K1302', N'CTRR', 1, '2006-05-13', 8.5, N'Dat'),
(N'K1303', N'CSDL', 1, '2006-12-20', 4, N'Khong Dat'),
(N'K1303', N'CTDLGT', 1, '2006-07-25', 4.5, N'Khong Dat'),
(N'K1303', N'CTDLGT', 2, '2006-08-07', 4, N'Khong Dat'),
(N'K1303', N'CTDLGT', 3, '2006-08-15', 4.25, N'Khong Dat'),
(N'K1303', N'THDC', 1, '2006-05-20', 4.5, N'Khong Dat'),
(N'K1303', N'CTRR', 1, '2006-05-13', 3.25, N'Khong Dat'),
(N'K1303', N'CTRR', 2, '2006-05-20', 5, N'Dat'),
(N'K1304', N'CSDL', 1, '2006-12-20', 7.75, N'Dat'),
(N'K1304', N'CTDLGT', 1, '2006-07-25', 9.75, N'Dat'),
(N'K1304', N'THDC', 1, '2006-05-20', 5.5, N'Dat'),
(N'K1304', N'CTRR', 1, '2006-05-13', 5, N'Dat'),
(N'K1305', N'CSDL', 1, '2006-12-20', 9.25, N'Dat'),
(N'K1305', N'CTDLGT', 1, '2006-07-25', 10, N'Dat'),
(N'K1305', N'THDC', 1, '2006-05-20', 8, N'Dat'),
(N'K1305', N'CTRR', 1, '2006-05-13', 10, N'Dat');

UPDATE KHOA SET TRGKHOA = N'GV01' 
WHERE MAKHOA = N'KHMT'

UPDATE KHOA SET TRGKHOA = N'GV02' 
WHERE MAKHOA = N'HTTT'

UPDATE KHOA SET TRGKHOA = N'GV03' 
WHERE MAKHOA = N'CNPM'

UPDATE KHOA SET TRGKHOA = N'GV04' 
WHERE MAKHOA = N'MTT'

UPDATE KHOA SET TRGKHOA = N'Null'
WHERE MAKHOA = N'KTMT'

-- 11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD
CONSTRAINT CK_TUOI CHECK (GETDATE() - NGSINH >= 18)

-- 12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD
CONSTRAINT CK_NGAY CHECK (TUNGAY < DENNGAY)

-- 13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD
CONSTRAINT CK_TUOIGV CHECK (NGVL - NGSINH >= 22)

-- 14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC 
ADD CONSTRAINT CK_LT_TH CHECK (ABS(TCLT - TCTH) <= 3)



-- III. 
-- 1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, LOP.MALOP FROM HOCVIEN, LOP
WHERE LOP.TRGLOP = HOCVIEN.MAHV

-- 2. In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HOCVIEN.MAHV, HO, TEN, LANTHI, DIEM FROM HOCVIEN, KETQUATHI, MONHOC
WHERE MONHOC.MAMH = KETQUATHI.MAMH AND KETQUATHI.MAHV = HOCVIEN.MAHV AND TENMH = N'Cau truc roi rac' AND MALOP = N'K12'
ORDER BY TEN ASC, HO ASC

-- 3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV, HO, TEN, MONHOC.TENMH FROM HOCVIEN, KETQUATHI, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV AND KETQUATHI.MAMH = MONHOC.MAMH AND LANTHI = 1 AND KQUA = N'Dat'

-- 4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, HO, TEN FROM HOCVIEN, KETQUATHI, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV AND KETQUATHI.MAMH = MONHOC.MAMH AND LANTHI = 1 AND KQUA = N'Khong Dat' AND MALOP = N'K11' AND TENMH = N'Cau truc roi rac'

-- 5. Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT HOCVIEN.MAHV, HO, TEN FROM HOCVIEN, KETQUATHI, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV AND KETQUATHI.MAMH = MONHOC.MAMH AND KQUA = N'Khong Dat' AND MALOP LIKE N'K%' AND TENMH = N'Cau truc roi rac'

