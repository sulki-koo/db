-- INDEX (인덱스)
-- 1) 대량의 데이터(일반적으로 한테이블에 수십만건 이상)
--    조회할때 인덱싱(조회 속도를 증가시키는 작업)하기 위해 만드는 객체
--    BINARY TREE, B+ TREE 알고리즘을 사용해서 인덱싱을 함
-- 2) B+ TREE 인덱싱 알고리즘을 사용 (중간값을 설정하고 작은값은 왼쪽 큰값은 오른쪽)
-- 3) 데이터가 적을때는 인덱스를 사용하는게 비효율적 (인덱스 생성에 시간 소요)
-- 4) 데이터의 조회가 많은 경우는 인덱스가 효율적
-- 5) 데이터의 삽입, 삭제가 많은 경우는 인덱스가 비효율적
-- 6) 인덱스로 사용하는 컬럼의 값들이 유일할수록 인덱스 성능이 향상됨
-- 7) PK컬럼을 테이블에 생생하는 경우는 자동으로 PK인덱스가 만들어짐 

-- T1테이블의 SAGE컬럼에 IDX_T1_SAGE라는 이름의 인덱스를 생성
SELECT * FROM T1;
CREATE INDEX IDX_T1_SAGE ON T1(SAGE);

-- 사용자의 인덱스가 적용된 테이블과 컬럼 정보 조회 - 데이터 사전
SELECT * FROM USER_IND_COLUMNS;

-- VIEW (뷰)
-- 1) 한 테이블의 일부 컬럼이나 조인된 결과 중 일부 또는 전체 컬럼을 조회할
--    목적으로 사용하는 객체
-- 2) 뷰는 물리적으로 데이터를 저장하는 MATERIALZED VIEW와
--    물리적으로 데이터를 저장하지 않는 VIEW(SELECT구문)로 구분
-- 3) 뷰를 사용하는 목적은 편리성, 보안성

-- 뷰 생성
-- 뷰 생성 권한이 없다면 관리자 계정으로 FRANT CREATE VIEW TO ksk;
-- OR REPLACE : 이미 존재하면 덮어씀
CREATE OR REPLACE VIEW VW_T1
AS SELECT * FROM T1;

-- 뷰를 통해 조회
SELECT * FROM VW_T1;

-- 사용자 뷰 정보 조회
SELECT * FROM USER_VIEWS;

-- 실습) HONG의 잔액과 KANG의 잔액을 조회하는 VW_MONEY라는 뷰를 생성
CREATE OR REPLACE VIEW VW_MONEY
AS SELECT (SELECT MONEY FROM HONG) "HONG잔액",
		  (SELECT MONEY FROM KANG) "KANG잔액"
FROM DUAL;

SELECT * FROM VW_MONEY;

-- 시퀀스 (SEQUENCE)
-- 1) 연속번호 생성시 사용하는 객체
-- 2) 테이블에 PK가 없는 경우에 한해서 시퀀스를 만들어 사용

-- 시퀀스 생성
CREATE SEQUENCE SEQ_T1; -- 1부터 시작해서 1씩 증가하는 시퀀스

-- 시퀀스 사용
SELECT SEQ_T1.NEXTVAL FROM DUAL; -- 다음 시퀀스 값
SELECT SEQ_T1.CURRVAL FROM DUAL; -- 현재 시퀀스 값

-- 시퀀스 속성
CREATE SEQUENCE SEQ_T2
INCREMENT BY 2 -- 증가값
START WITH 10 -- 최초값
MINVALUE 10 -- 최소값
MAXVALUE 50 -- 최대값
NOCYCLE; -- 최대값에 도달했을때 최초값으로 돌아갈 것인지

SELECT SEQ_T2.NEXTVAL FROM DUAL;
SELECT SEQ_T2.CURRVAL FROM DUAL;

-- SYNONYM(시노님)
-- 객체명이 긴 경우에 짧은 별칭(별명)을 부여
CREATE TABLE TB_MY_TABLE (
 NAME VARCHAR2(200));

CREATE SYNONYM TMT FOR TB_MY_TABLE;

SELECT * FROM TMT;

DROP SYNONYM TMT; -- 시노님 지우기






