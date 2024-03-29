-- ======================================================
-- ==================== INTRODUCCION ====================
-- ======================================================

-- CREACIÓN DE TABLAS


CREATE DATABASE SQLCookbook

USE SQLCookbook
GO

CREATE TABLE dept(
	DEPTNO INTEGER NOT NULL,
	DNAME VARCHAR(10) NOT NULL,
	LOC VARCHAR(15) NOT NULL
	CONSTRAINT pk_dept PRIMARY KEY (DEPTNO)
)

CREATE TABLE emp(
	EMPNO INTEGER NOT NULL,
	ENAME VARCHAR(20) NOT NULL,
	JOB VARCHAR(15) NOT NULL,
	MGR INTEGER NULL,
	HIREDATE DATE NOT NULL,
	SAL INTEGER NOT NULL,
	COMM INTEGER NULL,
	DEPTNO INTEGER NOT NULL
	CONSTRAINT pk_emp PRIMARY KEY (EMPNO),
	CONSTRAINT fk_emp FOREIGN KEY (DEPTNO) REFERENCES dept (DEPTNO)
)

 CREATE TABLE t1(
	ID INTEGER NULL
 )

 CREATE TABLE t10(
	ID INTEGER NULL
 )

CREATE TABLE emp_bonus(
	EMPNO INTEGER NOT NULL,
	RECEIVED DATE NOT NULL,
	TYPE INTEGER NOT NULL
	CONSTRAINT fk_emp_bonus FOREIGN KEY (EMPNO) REFERENCES emp (EMPNO)
)

CREATE TABLE emp_bonus2(
	EMPNO INTEGER NOT NULL,
	RECEIVED DATE NOT NULL,
	TYPE INTEGER NOT NULL
	CONSTRAINT fk_emp_bonus2 FOREIGN KEY (EMPNO) REFERENCES emp (EMPNO)
)

CREATE TABLE new_sal(
	DEPTNO INTEGER NOT NULL,
	SAL INTEGER NOT NULL,
	CONSTRAINT fk_newsal FOREIGN KEY (DEPTNO) REFERENCES dept (DEPTNO)
)

CREATE TABLE emp_comission(
	DEPTNO INTEGER NOT NULL,
	EMPNO INTEGER NOT NULL,
	ENAME VARCHAR(20) NOT NULL,
	COMM INTEGER NULL
	CONSTRAINT fk_emp_comm FOREIGN KEY (DEPTNO) REFERENCES dept (DEPTNO),
	CONSTRAINT fk_emp_comm2 FOREIGN KEY (EMPNO) REFERENCES emp (EMPNO)
)

CREATE TABLE dupes( 
	ID INT, 
	NAME VARCHAR(10)
)

CREATE TABLE dept_accidents(
	DEPTNO         INTEGER,
	ACCIDENT_NAME  VARCHAR(20) 
)


-- INSERTAR REGISTROS

INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK')
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS')
INSERT INTO dept VALUES (30,'SALES','CHICAGO')
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON')

INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'17-DEC-2005',800,' ',20)
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-2006',1600, 300, 30)
INSERT INTO emp VALUES (7521, 'WARD', 'SALESMAN', 7698,'22-FEB-2006', 1250, 500, 30)
INSERT INTO emp VALUES (7566, 'JONES', 'MANAGER', 7839,'02-FEB-2006', 2975,' ',20)
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-2006',1250,1400,30)
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'01-MAY-2006',2850,' ',30)
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'09-JUN-2006',2450,' ',10)
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'09-DEC-2007',3000,' ',20)
INSERT INTO emp VALUES (7839,'KING','PRESIDENT','','17-NOV-2006',5000,' ',10)
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'08-SEP-2006',1500,0,30)
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-2008',1100,' ',20)
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'03-DEC-2006',950,' ',30)
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'03-DEC-2006',3000,' ',20)
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'23-JAN-2007',1300,' ',10)

INSERT INTO t1 VALUES (1)

INSERT INTO t10 VALUES (1)
INSERT INTO t10 VALUES (2)
INSERT INTO t10 VALUES (3)
INSERT INTO t10 VALUES (4)
INSERT INTO t10 VALUES (5)
INSERT INTO t10 VALUES (6)
INSERT INTO t10 VALUES (7)
INSERT INTO t10 VALUES (8)
INSERT INTO t10 VALUES (9)
INSERT INTO t10 VALUES (10)

INSERT INTO emp_bonus VALUES (7369,'14-MAR-2005',1)
INSERT INTO emp_bonus VALUES (7900,'14-MAR-2005',2)
INSERT INTO emp_bonus VALUES (7788,'14-MAR-2005',3)

INSERT INTO emp_bonus2 VALUES (7934,'17-MAR-2005',1)
INSERT INTO emp_bonus2 VALUES (7934,'15-FEB-2005',2)
INSERT INTO emp_bonus2 VALUES (7839,'15-FEB-2005',3)
INSERT INTO emp_bonus2 VALUES (7782,'15-FEB-2005',1)

INSERT INTO new_sal VALUES (10,4000)

INSERT INTO emp_comission VALUES (10,7782,'CLARK',NULL)
INSERT INTO emp_comission VALUES (10,7839,'KING',NULL)
INSERT INTO emp_comission VALUES (10,7934,'MILLER',NULL)

INSERT INTO dupes VALUES (1, 'NAPOLEON')
INSERT INTO dupes VALUES (2, 'DYNAMITE')
INSERT INTO dupes VALUES (3, 'DYNAMITE')
INSERT INTO dupes VALUES (4, 'SHE SELLS')
INSERT INTO dupes VALUES (5, 'SEA SHELLS')
INSERT INTO dupes VALUES (6, 'SEA SHELLS')
INSERT INTO dupes VALUES (7, 'SEA SHELLS')

INSERT INTO dept_accidents VALUES (10,'BROKEN FOOT')
INSERT INTO dept_accidents VALUES (10,'FLESH WOUND')
INSERT INTO dept_accidents VALUES (20,'FIRE')
INSERT INTO dept_accidents VALUES (20,'FIRE')
INSERT INTO dept_accidents VALUES (20,'FLOOD')
INSERT INTO dept_accidents VALUES (30,'BRUISED GLUTE')