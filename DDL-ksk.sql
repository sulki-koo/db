-- DDL (Data Definition Language : 데이터 정의어)
-- 데이터베이스 객체를 생성, 수정, 삭제하는 SQL
-- CREATE(생성), ALTER(수정), DROP(삭제)
-- TRUNCATE(데이터삭제+COMMIT), RENAME(이름변경)

-- 테이블 생성
CREATE TABLE MEMBER(
	MID NUMBER PRIMARY KEY, --주키(PK) : NOT NULL이면서 UNIQUE
	MNAME VARCHAR2(200) NOT NULL
);

-- 시퀀스 생성
CREATE SEQUENCE SEQ_MEMBER; -- 1부터 1씩 증가하는 시퀀스

-- 테이블에 컬럼 추가
ALTER TABLE MEMBER ADD(MAGE NUMBER);

--테이블에 컬럼 삭제 (컬럼에 데이터가 없을때만 삭제됨)
ALTER TABLE MEMBER DROP COLUMN MAGE;

-- 테이블의 컬럼 수정
ALTER TABLE MEMBER MODIFY(MNAME VARCHAR2(500));

-- 테이블명 변경
RENAME MEMBER TO MEM;

-- 테이블에 데이터 입력
INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '홍길동');

-- 테이블 데이터 조회
SELECT * FROM MEM;

-- 테이블의 데이터 수정
UPDATE MEM SET MNAME='홍길순' WHERE MID=1;

-- 테이블의 데이터 삭제 (DML)
DELETE FROM MEM; -- MEM 테이블의 모든 데이터 삭제 (ROLLBACK 가능)

-- 테이블의 데이터 삭제 (DDL)
TRUNCATE TABLE MEM; -- MEM 테이블의 모든 데이터 삭제 (ROLLBACK 불가능)

-- DBEAVER는 기본적으로 모든 SQL구문에 대해서 AUTO COMMIT이 TRUE로 설정되어 있음
-- 윈도우 > 설정 > 연결 > 연결 유형 > Auto-commit by default 체크 해제 

INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '강감찬');
SELECT * FROM MEM;

ROLLBACK;
SELECT * FROM MEM;

INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '강감찬');
SELECT * FROM MEM;

COMMIT;  -- INSERT 트랜잭션 완료
SELECT * FROM MEM;

ROLLBACK; -- COMMIT해서 ROLLBACK 안됨
SELECT * FROM MEM;

DELETE FROM MEM;
SELECT * FROM MEM;

ROLLBACK;
SELECT * FROM MEM;

TRUNCATE TABLE MEM;
SELECT * FROM MEM;

INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '1번 홍길동');
INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '2번 홍길동');
SELECT * FROM MEM;
COMMIT;

SAVEPOINT ROW2; -- 커밋의 중간지점

INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '3번 홍길동');
INSERT INTO MEM VALUES(SEQ_MEMBER.NEXTVAL, '4번 홍길동');
SELECT * FROM MEM;

ROLLBACK TO ROW2;
SELECT * FROM MEM;

COMMIT;
SELECT * FROM MEM;