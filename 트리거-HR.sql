-- TRIGGER (트리거)
-- DBMS에 발생한 이벤트에 대해서 자동 실행되는 SQL의 모음
-- 보안, 로깅, 백업작업 이벤트 발생시 자동으로 처리되게 하기 위해 사용

-- 원본 테이블 생성
CREATE TABLE ORG_TABLE(
	OTNO NUMBER PRIMARY KEY,
	OTCONTENT VARCHAR2(200) NOT NULL
);

-- 백업 테이블 생성
-- 원본테이블의 구조만 복사해서 생성
-- 데이터까지 복사하려면 1=1 식으로 항상 TRUE인 조건을 부여하면 됨
CREATE TABLE BK_TABLE
AS
SELECT * FROM ORG_TABLE WHERE 1 = -1; -- 값이 항상 FALSE 

-- 백업 트리거 생성
CREATE OR REPLACE TRIGGER BK_TRIGGER
-- ORG_TABLE에 INSERT쿼리가 실행된 후에 작동하는 트리거
AFTER INSERT ON ORG_TABLE
-- INSERT된 각 행들에 대해서 
FOR EACH ROW 
-- 트리거의 작업을 BEGIN ~ END에 정의
BEGIN 
	-- 새로 INSERT된 행을 백업테이블에도 INSERT
	-- :OLD => 기존행, :NEW => TOFHDNS GOD
	INSERT INTO BK_TABLE 
	VALUES(:NEW.OTNO, :NEW.OTCONTENT);
END;

SELECT * FROM ORG_TABLE;
SELECT * FROM BK_TABLE;

-- ORG_TABLE
INSERT INTO ORG_TABLE VALUES(1, '컨텐츠1');
INSERT INTO ORG_TABLE VALUES(2, '컨텐츠2');
INSERT INTO ORG_TABLE VALUES(3, '컨텐츠3');
COMMIT;
SELECT * FROM ORG_TABLE;
SELECT * FROM BK_TABLE;


-- 로그테이블 생성
CREATE TABLE LOG_TABLE(
	LOG_NO NUMBER PRIMARY KEY, -- 번호
	TBL_NAME VARCHAR2(100) NOT NULL, --테이블명
	DML VARCHAR2(10), -- DML
	CONTENT VARCHAR2(200), -- 내용
	LOG_DATE DATE -- 날짜시간
);

-- 시퀀스
CREATE SEQUENCE SEQ_LOG;

-- 로그 트리거 생성 
CREATE OR REPLACE TRIGGER LOG_TRIGGER
AFTER INSERT OR UPDATE OR DELETE ON ORG_TABLE
FOR EACH ROW 
BEGIN
	-- INSERT일때
	IF INSERTING THEN 
	 INSERT INTO LOG_TABLE
	 VALUES(SEQ_LOG.NEXTVAL, 'ORG_TABLE', 'INSERT', :NEW.OTCONTENT, SYSDATE);
	-- UPDATE일때
	ELSIF UPDATING THEN 
	 INSERT INTO LOG_TABLE
	 VALUES(SEQ_LOG.NEXTVAL, 'ORG_TABLE', 'UPDATE', :OLD.OTCONTENT, SYSDATE);
	-- DELETE일때
	ELSIF DELETING THEN 
	 INSERT INTO LOG_TABLE
	 VALUES(SEQ_LOG.NEXTVAL, 'ORG_TABLE', 'DELETE', :OLD.OTNO, SYSDATE);
	END IF;
END;

-- INSERT
INSERT INTO ORG_TABLE VALUES(4, '컨텐츠4');
COMMIT;
SELECT * FROM ORG_TABLE;
SELECT * FROM BK_TABLE;
SELECT * FROM LOG_TABLE;

-- UPDATE 
UPDATE ORG_TABLE SET OTCONTENT = '신규컨텐츠4' WHERE OTNO=4;
COMMIT;
SELECT * FROM ORG_TABLE;
SELECT * FROM BK_TABLE;
SELECT * FROM LOG_TABLE;

-- DELETE
DELETE ORG_TABLE WHERE OTNO=4;
COMMIT;
SELECT * FROM ORG_TABLE;
SELECT * FROM BK_TABLE;
SELECT * FROM LOG_TABLE;

-- 트리거 활성화/비활성화
ALTER TRIGGER LOG_TRIGGER ENABLE; -- 활성화
ALTER TRIGGER LOG_TRIGGER DISABLE; -- 비활성화

-- 테이블에 걸려있는 모든 트리거 활성화/비활성화
ALTER TABLE ORG_TABLE ENABLE ALL TRIGGERS; -- 활성화
ALTER TABLE ORG_TABLE DISABLE ALL TRIGGERS; -- 비활성화

-- TRIGGER 실습) 
CREATE TABLE DEPT
AS 
SELECT * FROM DEPARTMENTS;

CREATE TABLE DEPT_LOG(
 LOGNO NUMBER PRIMARY KEY,
 LOGTBL VARCHAR2(20) NOT NULL,
 LOGDML VARCHAR2(20) CHECK (LOGDML IN('INSERT', 'UPDATE', 'DELETE')),
 LOGTBLID NUMBER NOT NULL,
 LOGOLD VARCHAR2(200),
 LOGNEW VARCHAR2(200),
 LOGDATE DATE
);

CREATE SEQUENCE SEQ_DEPT;

-- 1) DEPT 테이블에 INSERT가 일어나면 INSERT된 행을 삭제하는 TRIGGER
--    TRG_DEPT_SECURE 생성하고 테스트
--CREATE OR REPLACE TRIGGER TRG_DEPT_SECURE
--AFTER INSERT ON DEPT
--FOR EACH ROW 
--BEGIN 
--	DELETE FROM DEPT 
--	WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID
--	AND DEPARTMENT_NAME = :NEW.DEPARTMENT_NAME
--	AND MANAGER_ID = :NEW.MANAGER_ID
--	AND LOCATION_ID = :NEW.LOCATION_ID;
--END;

-- INSERT 실행
INSERT INTO DEPT VALUES (100, 'IT', 101, 1700);

-- 결과 확인
SELECT * FROM DEPT;
ROLLBACK;

-- 1) DEPT 테이블에 INSERT가 일어나면 INSERT된 행의 데이터를 출력하는 
--    TRIGGER TRG_DEPT_SECURE를 생성하고 테스트
CREATE OR REPLACE TRIGGER TRG_DEPT_SECURE
AFTER INSERT ON DEPT
FOR EACH ROW 
BEGIN 
	P(:NEW.DEPARTMENT_ID||' '
	||:NEW.DEPARTMENT_NAME||' '
	||:NEW.MANAGER_ID||' '
	||:NEW.LOCATION_ID);
END;


-- 1) DEPT 테이블에 INSERT가 일어나면 INSERT된 행의 데이터를 출력하는
--     TRIGGER TRG_DEPT_SECURE를 생성하고 테스트
CREATE OR REPLACE TRIGGER TRG_DEPT_SECURE
AFTER INSERT ON DEPT
FOR EACH ROW
BEGIN
   P(
      :NEW.DEPARTMENT_ID||' '||
      :NEW.DEPARTMENT_NAME||' '||
      :NEW.MANAGER_ID||' '||
      :NEW.LOCATION_ID
   );
END;

INSERT INTO DEPT VALUES(280, 'NEWDEPT', NULL, 1700);
COMMIT;
SELECT * FROM DEPT;


-- 2) DEPT 테이블에 INSERT, UPDATE, DELETE가 일어나면 작업 로그를 DEPT_LOG
--    테이블에 남기는 TRG_DEPT_LOG 생성하고 테스트
CREATE OR REPLACE TRIGGER TRG_DEPT_LOG
AFTER INSERT OR UPDATE OR DELETE ON DEPT
FOR EACH ROW 
BEGIN
	IF INSERTING THEN 
	 INSERT INTO DEPT_LOG
	 VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'INSERT', 
	:NEW.DEPARTMENT_ID, NULL, NULL, SYSDATE);
	ELSIF UPDATING THEN 
	 INSERT INTO DEPT_LOG
	 VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'UPDATE', 
	:OLD.DEPARTMENT_ID, :OLD.DEPARTMENT_NAME, :NEW.DEPARTMENT_NAME, SYSDATE);
	ELSIF DELETING THEN 
	 INSERT INTO DEPT_LOG
	 VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'DELETE', 
	:OLD.DEPARTMENT_ID, NULL, NULL, SYSDATE);
	END IF;
END;



-- 2) DEPT 테이블에 INSERT, UPDATE, DELETE가 일어나면 작업 로그를 DEPT_LOG
--     테이블에 남기는 TRG_DEPT_LOG 생성하고 테스트
CREATE OR REPLACE TRIGGER TRG_DEPT_LOG
AFTER INSERT OR UPDATE OR DELETE ON DEPT
FOR EACH ROW
BEGIN
   IF INSERTING THEN
      INSERT INTO DEPT_LOG
      VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'INSERT', :NEW.DEPARTMENT_ID, 
         NULL, NULL, SYSDATE);
   ELSIF UPDATING THEN
      INSERT INTO DEPT_LOG
      VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'UPDATE', :OLD.DEPARTMENT_ID, 
         :OLD.DEPARTMENT_NAME, :NEW.DEPARTMENT_NAME, SYSDATE);
   ELSIF DELETING THEN
      INSERT INTO DEPT_LOG
      VALUES(SEQ_DEPT.NEXTVAL, 'DEPT', 'DELETE', :OLD.DEPARTMENT_ID, 
         NULL, NULL, SYSDATE);
   END IF;
END;

INSERT INTO DEPT VALUES(290, 'NEWDEPT', NULL, 1700);
COMMIT;
SELECT * FROM DEPT ORDER BY DEPARTMENT_ID DESC;
SELECT * FROM DEPT_LOG;
ROLLBACK;

UPDATE DEPT SET DEPARTMENT_NAME='NEWNEWDEPT'
WHERE DEPARTMENT_ID=290;
COMMIT;
SELECT * FROM DEPT ORDER BY DEPARTMENT_ID DESC;
SELECT * FROM DEPT_LOG;

DELETE DEPT WHERE DEPARTMENT_ID=290;
COMMIT;
SELECT * FROM DEPT ORDER BY DEPARTMENT_ID DESC;
SELECT * FROM DEPT_LOG;

