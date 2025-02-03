-- DBMS_JOB
-- 오라클에서 주기적으로(정해진 시간 간격마다) 어떤 작업을 수행해야 할때 사용
-- 백업 및 데이터 분리/가공 작업에 많이 사용됨
-- SQL, PL/SQL만 주기적으로 실행가능

-- 로그 저장을 위한 테이블 생성
CREATE TABLE TBL_LOG(
	LOGSEQ NUMBER PRIMARY KEY,
	LOGCONTENT VARCHAR2(400),
	LOGDATE DATE
);

-- 로그테이블에 사용할 시퀀스
CREATE SEQUENCE SEQ_LOG;

-- 작업용 프로시져
CREATE OR REPLACE PROCEDURE PROC_JOB
IS 
BEGIN 
	INSERT INTO TBL_LOG
	VALUES(SEQ_LOG.NEXTVAL, 'LOG'||SYSDATE, SYSDATE);
	COMMIT;
END;

-- 잡을 등록하고 실행
DECLARE 
	-- 오라클이 만들어서 부여하는 잡번호를 저장할 변수
	V_JOB_NO NUMBER;
BEGIN
	DBMS_JOB.SUBMIT(
		JOB => V_JOB_NO, -- 잡번호
		WHAT => 'PROC_JOB;', -- 수행할 프로시져 (;필수)
		NEXT_DATE => SYSDATE, -- 다음 잡이 수행될 시점 (SYSDATE -> 바로 실행)
		INTERVAL => 'SYSDATE+5/60/60/24' --잡 수행 간격 (5초마다)
	);
	COMMIT;	
END;

SELECT * FROM TBL_LOG;
DROP TABLE TBL_LOG;
DROP SEQUENCE SEQ_LOG;

-- 잡 정보 조회
SELECT * FROM USER_JOBS;

-- 잡 일시중지
BEGIN 
	DBMS_JOB.BROKEN(2, TRUE); -- 1번 잡 일시중지
END;

-- 잡 재실행
BEGIN
	DBMS_JOB.BROKEN(2, FALSE); -- 2번 잡 재실행
END;

-- 잡 삭제
BEGIN
	DBMS_JOB.REMOVE(2);
	COMMIT;
END;

-- 잡 속성 변경
BEGIN
	DBMS_JOB.CHANGE(
		JOB => 2, -- 잡번호
		WHAT => 'PROC_JOB;', -- 수행할 프로시져 (;필수)
		NEXT_DATE => SYSDATE, -- 다음 잡이 수행될 시점 (SYSDATE -> 바로 실행)
		INTERVAL => 'SYSDATE+3/60/60/24' --잡 수행 간격 (5초마다)
	);
	COMMIT;	
END;

-- DBMS_SCHEDULER
-- 오라클에 주기적인 작업을 위해 존재하는 패키지
-- DBMS_JOB의 상위버전
-- SQL과 PL/SQL, 외부 프로그램 수행도 가능
-- 시간기반, 이벤트기반 주기적인 작업 가능
-- 체인(프로그램 체인) : 잡 내에서 순차적으로 수행되는 프로그램
-- GRANT CREATE JOB TO KSK;
-- GRANT MANAGE SCHEDULER TO KSK;
-- GRANT EXECUTE ON DBMS_SCHEDULER TO KSK;

-- 프로그램 생성
BEGIN
	DBMS_SCHEDULER.CREATE_PROGRAM(
		PROGRAM_NAME => 'ORA_SCH_PROG', -- 프로그램 명
		PROGRAM_TYPE => 'STORED_PROCEDURE', -- 프로그램 타입
		PROGRAM_ACTION => 'PROG_JOB', -- 프로그램 작업
		COMMENTS => '오라클 스케줄러 - 스케줄러(프로시져 사용)' -- 설명
	);
END;

-- 프로그램 조회
SELECT * FROM USER_SCHEDULER_PROGRAMS;

-- 잡 생성
BEGIN
	DBMS_SCHEDULER.CREATE_JOB(
		JOB_NAME => 'ORA_SCH_JOB', -- 잡 이름
		JOB_TYPE => 'STORED_PROCEDURE', -- 잡 타입
		JOB_ACTION => 'PROC_JOB', -- 수행할 프로시져
		REPEAT_INTERVAL => 'FREQ=SECONDLY; INTERVAL=5', -- 시간 간격
		COMMENTS => '오라클 스케줄러 - 잡' -- 잡 설명
	);
END;

-- 잡 조회
SELECT * FROM USER_SCHEDULER_JOBS;

-- 잡 활성화
-- 권한 부여
-- GRANT CREATE EXTERNAL JOB TO KSK;
BEGIN
	DBMS_SCHEDULER.ENABLE('ORA_SCH_JOB2');
END;

SELECT * FROM TBL_LOG;

-- 잡 비활성화
BEGIN
	DBMS_SCHEDULER.DISABLE('ORA_SCH_JOB2');
END;

-- 잡 생성 (외부파일 실행)
BEGIN
	DBMS_SCHEDULER.CREATE_JOB(
		JOB_NAME => 'ORA_SCH_JOB2', -- 잡 이름
		JOB_TYPE => 'EXECUTABLE', -- 잡 타입
		JOB_ACTION => 'D:/embededk/JOB.BAT', -- 수행할 프로시져
		REPEAT_INTERVAL => 'FREQ=SECONDLY; INTERVAL=5', -- 시간 간격
		COMMENTS => '오라클 스케줄러 - 잡' -- 잡 설명
	);
END;

-- 잡 확인 딕셔너리
SELECT * FROM USER_SCHEDULER_JOBS;

-- 잡 삭제
BEGIN
	--DBMS_SCHEDULER.DROP_JOB('ORA_SCH_JOB');
	DBMS_SCHEDULER.DROP_JOB('ORA_SCH_JOB2');
END;








