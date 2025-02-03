-- TRANSACTION (트랜잭션) 
-- 모두 처리되거나 모두 처리되지 말아야 할 개별작업들의 묶음
-- COMMIT: 트랜잭션 완료 (=데이터베이스에 반영=ROLLBACK 불가)
-- ROLLBACK : 최종 커밋 이후 상태로 돌림
-- SAVEPOINT : 롤백 시점을 저장
-- 예) 이체 트랜잭션 = 출금 + 입금
-- 	  => 출금만 일어나고 입금이 일어나지 않은 상태가 되면 안됨
--    => 출금과 입금은 개별 작업이지만 이체 트랜잭션으로 묶여야 함
--    => 출금과 입금이 다 일어나던지 다 일어나지 않던지 해야 함

-- 1. HONG계좌에 10000원을 입금
-- 2. 이체 트랜잭션
-- 	  2-1. HONG계좌에서 5000원을 출금
-- 	  2-2. KANG계좌에 5000을 입금
-- 	  2-1작업과 2-2작업은 모두 일어나거나 모두 일어나지 말아야 함
-- 	  2-1작업만 일어나는 경우가 있으면 안됨

-- HONG 계좌 생성
CREATE TABLE HONG(MONEY NUMBER);
-- KANG 계좌 생성
CREATE TABLE KANG(MONEY NUMBER);

-- HONG계좌에 10000원을 입금
INSERT INTO HONG VALUES(10000);
COMMIT;
SELECT * FROM HONG;
SELECT * FROM KANG;

-- 이체 트랜잭션
-- HONG계좌에서 5000원을 출금
UPDATE HONG SET MONEY = MONEY - 5000;
SELECT * FROM HONG;

-- 네트워크 오류가 발생했다고 가정 => ROLLBACK을 수행해야 함

-- KANG계좌에서 5000원을 입금
INSERT INTO KANG VALUES(5000);
SELECT * FROM KANG;
SELECT * FROM HONG;

-- 트랜잭션 완료 처리
COMMIT;
SELECT * FROM KANG;
SELECT * FROM HONG;

-- 트랜잭션 롤백 : 최종 COMMIT한 이후까지만 롤백 가능
ROLLBACK;
SELECT * FROM KANG;
SELECT * FROM HONG;

-- 실습 1-1) HONG계좌에서 KANG계좌로 1000원씩 5번 이체
UPDATE HONG SET MONEY = MONEY - 1000; -- 5번
UPDATE KANG SET MONEY = MONEY + 1000; -- 5번
COMMIT;
SELECT * FROM KANG;
SELECT * FROM HONG; 

-- 실습 1-2) KANG계좌에서 HONG계좌로 2000원씩 3번 이체 
UPDATE KANG SET MONEY = MONEY - 2000; -- 3번
UPDATE HONG SET MONEY = MONEY + 2000; -- 3번
COMMIT;
SELECT * FROM KANG; -- 4000
SELECT * FROM HONG; -- 6000

-- 실습 1-2) HONG계좌에서 KANG계좌로 2000씩 3번 이체
--			이체마다 SAVEPOINT 설정
UPDATE HONG SET MONEY = 6000;
UPDATE KANG SET MONEY = 4000;
COMMIT;
SELECT * FROM HONG; -- 6000
SELECT * FROM KANG; -- 4000

UPDATE HONG SET MONEY = MONEY - 2000;
UPDATE KANG SET MONEY = MONEY + 2000;
SELECT * FROM HONG; -- 4000
SELECT * FROM KANG; -- 6000

SAVEPOINT "SP1";
UPDATE HONG SET MONEY = MONEY - 2000;
UPDATE KANG SET MONEY = MONEY + 2000;
SELECT * FROM HONG; -- 2000
SELECT * FROM KANG; -- 8000

SAVEPOINT "SP2";
-- COMMIT 했다면 : HONG 0, KANG 10000
-- ROLLBAKC 했다면 : HONG 2000, KANG 8000 
UPDATE HONG SET MONEY = MONEY - 2000;
UPDATE KANG SET MONEY = MONEY + 2000;
SELECT * FROM HONG; -- 0
SELECT * FROM KANG; -- 10000

SAVEPOINT "SP3";

ROLLBACK TO "SP2";

COMMIT; -- SP3 이전까지 COMMIT이됨, SP2로 롤백시 UPDATE 2개 날아감
SELECT * FROM HONG; -- 2000
SELECT * FROM KANG; -- 8000

-- 세션(SEESION) : 데이터베이스 접속을 추상화한 개념, 한 사용자가 여러 세션을 가질 수 있음
-- ex) 동일한 사용자 계정으로 SQLPLUS로 2개 접속, DBEAVER로 2개 접속 => 세션 4개
-- SQLPLUS ksk/ksk로 2개 세션 열기
-- 현재 세션(DBEAVER)까지 총 3개 세션
UPDATE  HONG SET MONEY = MONEY -2000;
SELECT * FROM HONG; -- 0 / 다른 세션에선 2000

-- 쿼리를 수행한 세션에서 COMMIT하면 모든 세션에서 결과가 반영됨
-- 결론 : COMMIT, ROLLBACK, SAVEPOINT는 세션별로 적용됨
COMMIT;





