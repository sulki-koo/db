CREATE TABLE PRTABLE(
	NAME VARCHAR2(200)
);

-- EMPLOYEES테이블 조회 권한을 부여
-- 권한부여 : grant select on hr.employees to pr;

-- EMPLOYEES테이블 조회
SELECT * FROM HR.EMPLOYEES;

-- 실습1) KSK의 T1테이블에 한 행을 입력
-- 권한부여 : grant insert on hr.employees to pr;
INSERT INTO KSK.T1 VALUES('지니',15);

-- 실습2) ksk의 T1테이블의 데이터 조회
-- 권한부여 : GRANT SELECT ON KSK.T1 TO PR;
SELECT * FROM KSK.T1;

-- 사용자의 제약조건 조회
SELECT * FROM USER_ROLE_PRIVS; 

-- 사용자 데이터사전(USER_, ALL_) 목록 조회
SELECT * FROM DICT;

-- 사용자 관리
-- WITH ADMIN OPTION : PR이 DBA롤을 부여받으면서 다른계정에도 DBA롤을 부여할 수 있음
-- SYSTEM : GRANT DBA TO PR WITH ADMIN OPTION;
--          GRANT CREATE USER TO PR;

-- 사용자 생성
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
CREATE USER TEMPUSER IDENTIFIED BY TEMPUSER;

-- 사용자에게 권한 부여
GRANT CREATE SESSION TO TEMPUSER; -- 세션 생성 권한
GRANT CREATE TABLE TO TEMPUSER; -- 테이블 생성 권한

-- 롤 (ROLE)
-- 권한의 묶음
-- SYSTME 계정에서

-- 롤 생성
-- GRANT CREATE ROLE TO PR;
CREATE ROLE PRROLE;

-- 롤에 권한을 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON KSK.T1 TO PRROLE;

-- 롤을 사용자에 부여
GRANT PRROLE TO PR;

SELECT * FROM KSK.T1;
INSERT INTO KSK.T1 VALUES('홍길동',30);
UPDATE KSK.T1 SET SNAME='강감찬';
DELETE KSK.T1 WHERE SNAME='강감찬';
COMMIT;

-- 롤을 사용자에게서 제거
REVOKE UPDATE, DELETE ON KSK.T1 FROM PRROLE;

-- 롤 삭제
DROP ROLE PRROLE;
-- 사용자에게 롤 제거
REVOKE PRROLE FROM PR;

-- 사용자가 가진 권한 조회
SELECT * FROM USER_ROLE_PRIVS;





