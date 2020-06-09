
--学生表
--Student
--学号
--姓名
--性别
--出生年月日
--所在班级

create table student(
    sno varchar(20) primary key,
    sname varchar(20) not null,
    ssex varchar(10) not null,
    sbirthday datetime,
    class varchar(20)
);

--教师表
--Teacher
--教师编号
--教师名字
--教师性别
--出生年月日
--职称
--所在部门

create table teacher(
    tno varchar(20) primary key,
    tname varchar(20) not null,
    tsex varchar(10) not null,
    tbirthday datetime,
    prof varchar(20) not null,
    depart varchar(20) not null
);

--课程表
--Course
--课程号
--课程名称
--教师编号

create table course(
    cno varchar(20) primary key,
    cname varchar(20) not null,
    tno varchar(20) not null,
    foreign key(tno) references teacher(tno)
);

--
--成绩表
--Score
--学号
--课程号
--成绩
--
create table score(
    sno varchar(20) not null,
    cno varchar(20) not null,
    degree decimal,
    foreign key(sno) references student(sno),
    foreign key(cno) references course(cno),
    primary key(sno,cno)
);

--往表里添加数据
--学生表
insert into student values('101','张三','男','1991-12-01','11303');
insert into student values('102','李四','男','1991-12-02','11302');
insert into student values('103','王菲','男','1991-12-03','11302');
insert into student values('104','张福记','男','1991-12-08','11303');
insert into student values('105','黎明','男','1991-12-04','11304');
insert into student values('106','韩红','男','1991-12-06','11301');
--教师表
insert into teacher values('101','家业','男','1991-12-01','副教授','计算机系');
insert into teacher values('102','韩武','男','1991-04-01','讲师','电子工程系');
insert into teacher values('103','刘华','男','1991-08-04','副教授','生物学');
insert into teacher values('104','张飞','男','1991-09-11','助教','电子工程系');
--课程表
insert into course values('32130001','计算机网络技术','101');
insert into course values('32130002','操作系统','102');
insert into course values('32130003','数字电路','103');
insert into course values('32130004','高等数学','104');
--成绩表
insert into score values('101','32130001','80');
insert into score values('102','32130002','85');
insert into score values('103','32130003','88');
insert into score values('104','32130004','96');

--查询练习
--1.查询 student 表的所有记录
select * from student;
--2.查询 student 表中的所有记录色 sname、ssex 和 class 列
select sname,ssex,class from student;
--3.查询教师所有的单位即是不重复的 depart 列
select distinct depart from teacher;
--4.查询 score表中成绩在60到80之间是我所有记录
select * from score where degree between 60 and 80;
--5.查询 score 表中成绩未85，86或88的记录
select * from score where degree in(85,86,88);
--6.查询 student 表中 11303 班或性别为 女同学记录
select * from student where class='11303' or ssex='女';
--7.以 class 降序查询 student 表的所有记录
--升序（默认的）
select * from student order by class asc;
--降序
select * from student order by class desc;
--8.以cno 升序、degree降序查询 score 表的所有记录
select * from score order by cno asc, degree desc;
--9.查询11303 班的学生人数
select count(*) from student where class='11303';
--10.查询 score 表中是我最高分的学生学号和课程号。（子查询或者排序）
select sno ,cno from score where degree=(select max(degree) from score);
--limit 第一个数字表示从多少开始，第二个数字表示查多少条
select sno,cno,degree from score order by degree desc limit 0,1；
--11.查询每门课的平均成绩
select avg(degree) from score where cno='101';
select cno,avg(degree) from score group by cno;
--12.查询 score 表中至少有2名学生选修的并以3开头的课程的平均成绩
select cno,avg(degree),count(*) from score group by cno
having count(cno)>=2
and cno link '3%';
--13.查询分数大于70，小于90的 sno 列
select sno, degree from score where degree>70 and degree<90;
select sno, degree from score where degree between 70 and 90;
--14.查询所有学生的 sname、cno 和 degree 列
select sno,sname from student;
select sno,cno, degree from score;

select sname,cno,degree from student,score where student.sno = score.sno;

--15.查询所有学生的 sno、cname 和 degree 列
select sno,cname,degree from course,score where course.cno = score.cno;
--16.查询所有学生的 sname 、cname 和 degree 列
select sname,cname,degree from student,course,score where student.sno=score.sno and course.cno = score.cno;
select sname,cname,degree,student.sno as stu_sno,course.cno as cou_cno from student,course,score where student.sno=score.sno and course.cno = score.cno;

--17.查询11303班学生每门课的平均分
select * from student where class='11303';
select sno from student where class='11303';
select * from score where sno in(select sno from student where class='11303');
select cno, avg(degree)
from score
where sno in(select sno from student where class='11303')
group by cno;
--18.查询选修32130001 课程的成绩高于102号同学 32130001 成绩的所有同学记录
select degree from score where sno='102' and cno='32130001';
select * from score where cno='32130001' and degree > (select degree from score where sno='102' and cno='32130001');
--19.查询学号和101、103的同学同年出生的所有学生的 sno、sname 和 sbirthday 列
select year(sbirthday) from student where sno in (108,101);
select * from student where year(sbirthday) in (select year(sbirthday) from student where sno in (108,101));
--20.查询‘刘华’教师任课的学生成绩
select tno from teacher where tname='刘华';
select cno from course where tno=(select tno from teacher where tname='刘华');
select * from score where cno=(select cno from course where tno=(select tno from teacher where tname='刘华'));
--21.查询计算机系与电子工程系不同职称的教师的 tname 和 prof
--union 合并
select prof from teacher where depart='电子工程系';
select * from teacher where depart='计算机系' and prof not in(select prof from teacher where depart='电子工程系')
union
select * from teacher where depart='电子工程系' and prof not in(select prof from teacher where depart='计算机系');
--22.查询选修编号为32130001 课程且成绩至少高于选修编号为32130002的同学的 cno、sno和 degree，并按 degree 从高到低次序排序
select * from score where cno ='32130001';
select * from score where cno ='32130002';
--至少？ 大于其中至少一个，any
select * from score
where cno='32130001'
and degree>any(select degree from score where cno ='32130002')
order by degree desc;
--22.查询选修编号为32130001 课程且成绩且高于选修编号为32130002的同学的 cno、sno和 degree
-- 且？ all表示所有的关系
select * from score
where cno='32130001'
and degree>all(select degree from score where cno ='32130002');
--23.查询所有教师和同学的 name、sex和 birthday
select tname as name,tsex as sex,tbirthday as birthday from teacher
union
select sname, ssex,sbirthday from student;

--24.查询成绩比该课程平均成绩低的同学的成绩表
select cno, avg(degree) from score group by cno;

select * from score a where degree <(select avg(degree) from score b where a.cno = b.cno);

--25.查询 student 表中最大和最小的 sbirthday 日期值
select sbirthday from student order by sbirthday;
--max min
select max(sbirthday) as '最大',min(sbirthday) as '最小' from student;

--26.查询最高分同学的 sno、cno和 degree 列
select max(degree) from score;
select * from score where degree=(select max(degree) from score);

--27.假设使用如下命令建立了一个 grade表
create table grade(
    low int(3),
    upp int(3),
    grade char(1)
);
insert into grade values(90,100,'A');
insert into grade values(80,89,'B');
insert into grade values(70,79,'C');
insert into grade values(60,69,'D');
insert into grade values(0,59,'E');

--现查询所有同学的 sno、cno 和 rank列
 select sno,cno,grade from score,grade where degree between low and upp;
