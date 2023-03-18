CREATE DATABASE IF NOT EXISTS Boss;
USE Boss;

create table user (
	uid int primary key auto_increment,
	email varchar(30),
	name varchar(20)
);

-- schedule
create table schedule (
	sid int primary key auto_increment,
	title varchar(30),
  region varchar(30),
	start varchar(30),
	stop varchar(30),
	uid int,
	foreign key(uid) references user(uid) on delete cascade
);

-- place
create table place (	
	pid int primary key auto_increment,
	name varchar(30),
	address varchar(50),
	latitude double, -- decimal(13,10),
	longitude double, -- decimal(13,10),
	category varchar(30),
	status bool default 0,
	diary varchar(1000) default "",
	total_spending int default 0,
  visit_date varchar(30),
	sid int,
	uid int,
	foreign key(sid) references schedule(sid) on delete cascade,
	foreign key(uid) references user(uid) on delete cascade
);

-- spending 테이블 생성
create table spending (
	spid int primary key auto_increment,
	name varchar(50),
	quantity int,
	price int,
	pid int,
	foreign key(pid) references place(pid) on delete cascade
);

-- photo 테이블 생성
create table photo (
	phid int primary key auto_increment,
	url varchar(100),
	uid int,
	pid int,
	foreign key(uid) references user(uid) on delete cascade,
	foreign key(pid) references place(pid) on delete cascade
);

-- category 테이블 생성
create table category (
	phid int,
	category_name varchar(30),
	primary key(phid, category_name),
	foreign key(phid) references photo(phid) on delete cascade
);


insert into user(email, name) values("lee@naver.com", "lee");
insert into schedule(title, region, start, stop, uid) values ("부산 여행", "부산", "2023.04.01", "2023.04.07", 1);
insert into place(name, address, latitude, longitude, category, status, diary, total_spending, visit_date, sid, uid) values ("더베이", "부산", 35.1565954, 129.1520357, "", 0, "", 0, "2023.04.01", 1, 1);