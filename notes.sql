

一、数据记录常见操作

mysql -u root -p


增加
INSERT
删除
DELETE
修改
UPDATE
查询
SELECT


查看数据库表： show databases;
创建表：create database test;
适用表： use test;
查看表： show tables;
查看表数据： select * from test;
查询不重复：select distinct cellName from test;
查询区间：select * from test where cellName between ... and ...;
查询或者关系数据：select * from test where cellName in(...,...,...);
查询或者关系数据（不同字段）: select * from test where cellName1='...' or cellName2='...';
升序查询某列：select * from test order by cellName asc;
降序查询某列：select * from test order by cellName desc;
以...升序...降序查询：select * from test order by cellName1 asc, cellName2 desc;
查询统计某列某值：select count(*) from test where cellName='...';
查询最高xxx的...列和...列(子查询或者排序)：
select ... ,... from test where xxx=(select max(xxx) from test);
--limit 第一个数字表示从多少开始，第二个数字表示查多少条
select ...,...,xxx from test order by xxx desc limit 0,1；
查询平均成绩：
--avg()
select avg(xxx) from test where cellName='...';
--group by 分组
select cellName,avg(xxx) from test group by cellName;
删除表： drop table test;

二、建表约束
主键约束
它能够唯一确定一张表中的一条记录，也就是我们通过给某个字段添加约束，就可以使得该字段不重复且不为空。
create table user(
    id int primary key,
    name varchar(20)
);
insert into user value(1,'张三');
联合主键
主要联合的主键加起来不重复就可以
create table user2(
    id int,
    name varchar(20),
    password varchar(20),
    primary key(id,name)
);
insert into user2 values(1,'张三'，'1234');
insert into user2 values(2,'张三'，'1234');
自增约束
create table user3(
    id int primary key auto_increment,
    name varchar(20)
);
insert into user3 (name) values('张三');

创建表的时候，忘记创建主键约束了
create table user4(
    id int,
    name varchar(20)
);

修改表结构，添加主键
alter table user4 add primary key(id);
使用 modify 修改字段，添加约束
alter table user4 modify id int primary key;
删除
alter table user4 drop primary key;



唯一约束
约束修饰的字段值不可以重复
 --  方法一
create table user5(
    id int,
    name varchar(20)
);
alter table user5 add unique(name);
-- 方法二
create table user6(
    id int,
    name varchar(20),
    unique(name)
);

create table user7(
    id int,
    name varchar(20) unique
);
--  unique(id,name) 表示两个键在一起不重复就行
create table user8(
    id int,
    name varchar(20),
    unique(id,name)
);

--如何删除唯一约束
alter table user7 drop index name;

--modify 添加
alter table user7 modify name varchar(20) unique;

--总结
  --1.建表的时候就添加约束
  --2.可以使用 alter ... add ...
  --3.可以使用 alter ... modify ...
  --4.删除 alter ... drop ...

非空约束
修饰的字段不能为空 NULL
create table user9(
    id int,
    name varchar(20) not null
);
insert into user9 (name) values('张三');
默认约束
就是当我们插入字段值的时候，如果没有传值，就会使用默认值
create table user10(
    id int,
    name varchar(20),
    age int default 10
);

insert into user10 (id,name) values(1,'张三');
-- 传了值，就不会使用默认值
insert into user10 values(1,'张三'，23);

外键约束
涉及到两个表：父表(主表)、子表（副表）

--班级
create table classes(
    id int primary key,
    name varchar(20)
);
--学生表
create table students(
    id int primary key,
    name varchar(20),
    class_id int,
    foregin key(class_id) references classes(id)
);

insert into classes values(1,'一班');
insert into classes values(2,'二班');
insert into classes values(3,'三班');
insert into classes values(4,'四班');

insert into students values(10001,'张三',1);
insert into students values(10002,'李四',2);
insert into students values(10003,'王五',3);
insert into students values(10004,'阿甲',4);

-- 主表 classes 中没有的数据值，在副表中，是不可以使用的。
-- 主表中的记录被副表引用，是不可以被删除的。
insert into students values(10005,'阿乙',5);
delete from classes where id=4;


数据库的三大设计范式
1第一范式 1NF
-- 数据表中的所有字段都是不可分割的原子值
create table students2(
    id int primary key,
    name varchar(20),
    address varchar(30)
);
insert into students2 values (1,'张三','中国广东省广州市天河区科韵路14号');
-- 字段值还可以拆分，不满足第一范式。
create table students3(
    id int primary key,
    name varchar(20),
    country varchar(30),
    province varchar(30),
    city varchar(30),
    details varchar(30)
);
-- 范式，设计的越详细，对于某些实际操作可能更好，但不一定都是好处。

2 第二范式 2NF
--必须是满足第一范式的前提下，第二范式要求，除主键外的每一列都必须完全依赖于主键。
--如果要小户型不完全依赖，只可能发生在联合主键的情况下。
create table myOrder(
product_id int,
customer_id int,
product_name varchar(20),
customer_name varchar(20),
primary key (product_id,customer_id)
);
--问题
--除主键以外的其他列，只依赖于主键的部分字段
--拆表
create table myOrder(
    order_id int primary key,
    product_id int,
    customer_id int
);
create table product(
    id int primary key,
    name varchar(20)
);
create table customer(
    id int primary key,
    name varchar(20)
);

3 第三范式 3NF
--必须先满足第二范式，除开主键列的其他列之间不能有传递依赖关系。
create table myOrder(
    order_id int primary key,
    product_id int,
    customer_id int,
    customer_phone varchar(20)
);

--问题，存在传递依赖
--解决
create table myOrder(
    order_id int primary key,
    product_id int,
    customer_id int
);
create table customer(
    id int primary key,
    name varchar(20),
    phone varchar(20)
);

SQL 的四种连接查询

内连接
inner join 或者 join

外连接
1.左连接 left join 或者 left outer join
2.有连接 right join 或者 right outer join
3.完全外连接 full join 或者 full outer join

--创建两个表
create database testJoin;
--person表
id,
name,
cardId
create table person(
    id int,
    name varchar(20),
    cardId int
);
--card 表
id,
name

create table card(
    id int,
    name varchar(20)
);
insert into card values(1,'房卡');
insert into card values(2,'饭卡');
insert into card values(3,'工商卡');
insert into card values(4,'建设卡');
insert into card values(5,'农行卡');

insert into person values(1,'张三',2);
insert into person values(2,'李四',5);
insert into person values(3,'王五',3);

--并没有创建外键
--1.inner join 查询
--内联查询，其实就是两张表中是我数据，通过某个字段相对，查询出相关记录数据。
select * from person inner join card on person.cardId = card.id;

--2.left join(左外连接)
--左外连接，会把左边表里面的所有数据取出来，而右边表中的数据，如果有相等的，就显示出来,如果没有，就会补 NULL
select * from person left join card on person.cardId = card.id;

--3.right join(右外连接)
--右外连接，会把右边表里面的所有数据取出来，而左边表中的数据，如果有相等的，就显示出来,如果没有，就会补 NULL
select * from person right join card on person.cardId = card.id;

--4.full join (完全连接)
-- mysql 不支持
--两个表完全显示
select * from person left join card on person.cardId = card.id
union
select * from person right join card on person.cardId = card.id;


--mysql 事务
mysql中，事务其实是一个最小的不可分割的工作单元，事务能够保证一个业务的完整性。
比如我们的银行转账：
a——> -100
update user set money= money-100 where name ='a';
b--> +100
update user set money= money+100 where name ='b';
--实际的程序中，如果只有一条语句执行成功了，而另外一条没有执行成功？
--出现前后数据不一致
--多条 sql 语句，可能会有同时成功的要求，要么就同时失败。

--1.mysql 中如何控制事务?
--mysql默认是开启事务的（自动提交）。  @@autocommit = 1
select @@autocommit;
--默认事务开启的作用是什么？
--当我们去执行一个 sql 语句的时候，效果会立即体现出来，且不能回滚。

create database bank;
use bank;
create table user(
    id int primary key,
    name varchar(20),
    money int
);
insert into user values(1,'a',1000);

--事务回滚：撤销sql语句执行效果
rollback;

--设置 mysql 自动提交为 false
set autocommit = 0;

--使用 commit 提交(提交后是不可撤销的，持久性)
commit;

--2.手动开始事务
begin;
--或者
start transaction;

begin;
update user set money= money-100 where name ='a';
update user set money= money+100 where name ='b';

start transaction;
update user set money= money-100 where name ='a';
update user set money= money+100 where name ='b';

--事务开启之后，一旦 commit 提交，就不可以回滚（也就是当前的这个事务在提交的时候就结束了）

--3.事务的ACID特征
    --A 原子性：事务是最小的单位，不可以在分割。
    --C一致性：事务要求，同一个事务中的 sql 语句，必须保证同时成功或者同时失败。
    --I隔离性： 事务1和事务2之间是具有隔离性的。
    --D持久性：事务一旦结束（commit, rollback），就不可以返回。

--事务开始：
--    1.修改默认提交 set autocommit =0;
--    2.begin
--    3.start transaction;
--事务手动提交：
--    commit;
--事务手动回滚：
--    rollback;

--事务的隔离性:
    --1.read uncommitted; 读未提交的
    --2.read committed; 读已经提交的
    --3.repeatable read; 可以重复读
    --4.serializable; 串行化

--    性能越来越高

read uncommitted

--如果有事务 a 和事务 b，
--a 事务对数据进行操作，在操作过程中，事务没有被提交，但是 b 可以看见 a 操作的结果。

--如何查询数据库的隔离级别 默认隔离级别  REPEATABLE-READ
mysql 8.0
--系统级别的
select @@global.transaction_isolation;
--会话级别的
select @@transaction_isolation;

mysql 5.x
--系统级别的
select @@global.tx_isolation;
--会话级别的
select @@tx_isolation;

--如何修改隔离级别？
set global transaction isolation level read uncommitted;

--如果两个不同的地方，都在进行操作，如果事务 a 开始之后，他的数据可以被其他事务读取到。
--这样就会出现（脏读）
--脏读：一个事务读到了另外一个事务没有提交的数据，就叫做脏读。
--实际开发是不允许脏读出现的。


