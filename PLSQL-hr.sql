-- PL/SQL (Procedual Language / Structured Query Language)
-- 오라클에서 사용하는 절차적SQL 구문/언어

-- PL/SQL 콘솔 출력
-- SQLPLUS에서 SET SERVEROUTPUT ON; 명령을 수행해야 함
-- 익명프로시져(ANONYMOUS PROCEDURE)
BEGIN 
	-- DBMS_OUTPUT 패키지의 PUT_LINE 프로시져
	DBMS_OUTPUT.PUT_LINE('HELLO PL/SQL');
END;

-- 변수 사용
-- 대입연산자 (:=)
DECLARE
	-- 선언부 : 변수,상수,커서,레코드,컬렉션... 선언
	-- 만든 변수들은 'V_변수명'으로 선언하는 것이 관례
	V_EMPLOYEE_NO NUMBER(4) := 110; -- 선언 + 초기화
	V_EMPFULLNAME VARCHAR2(100); -- 선언
BEGIN
	-- 실행부 : 수행할 SQL구문들, PL/SQL
	V_EMPFULLNAME := 'Chen John'; -- 문자열 할당
	DBMS_OUTPUT.PUT_LINE(V_EMPLOYEE_NO);
	DBMS_OUTPUT.PUT_LINE(V_EMPFULLNAME);
END;

-- 상수 사용
DECLARE
	C_PI CONSTANT NUMBER(3,2) := 3.14; -- C_변수명 => 상수
BEGIN
	-- C_PI := 5.5; -- 상수는 초기화한 후에 값 변경 불가
	DBMS_OUTPUT.PUT_LINE(C_PI);
END;

-- 출력용 프로시져
CREATE OR REPLACE PROCEDURE P(P_STR VARCHAR2)
IS 
BEGIN 
	DBMS_OUTPUT.PUT_LINE(P_STR);
END;

-- 변수 기본값 지정
DECLARE
	V_NO NUMBER(4) DEFAULT 1000;
BEGIN
	P(V_NO);
END;

-- 변수에 NULL값 불허
DECLARE
	V_NO NUMBER(4) NOT NULL;
BEGIN
	-- V_NO := NULL;
	V_NO := 1000;
	P(V_NO);
END;

-- 참조타입
-- %ROWTYPE : 특정 테이블의 한 행의 모든 컬럼의 타입
DECLARE
	V_EMPLOYEES_ROW EMPLOYEES%ROWTYPE;
BEGIN
	-- INTO 뒤에 %ROWTYPE 변수를 지정해서 조회된 한 행의 모든 컬럼의 값을 저장
	SELECT * INTO V_EMPLOYEES_ROW
	FROM EMPLOYEES
	WHERE EMPLOYEE_ID = 100;
	P(V_EMPLOYEES_ROW.FIRST_NAME||' '||V_EMPLOYEES_ROW.LAST_NAME);
END;

-- %TYPE : 특정 테이블의 한 컬럼의 타입
DECLARE
	V_EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN
	SELECT EMPLOYEE_ID INTO V_EMPLOYEE_ID
	FROM EMPLOYEES
	WHERE FIRST_NAME||' '||LAST_NAME = 'Steven King';
	P(V_EMPLOYEE_ID);
END;

-- 제어문 IF
DECLARE
	V_NUM NUMBER := 5;
BEGIN
	IF MOD(V_NUM, 2)= 1
	THEN P('홀수');
	ELSE P('짝수');
	END IF;
END;

DECLARE
	V_NUM NUMBER := 78;
BEGIN
	IF V_NUM >= 90 THEN P('A학점');
	ELSIF V_NUM >= 80 THEN P('B학점');
	ELSIF V_NUM >= 70 THEN P('C학점');
	ELSIF V_NUM >= 60 THEN P('D학점');
	ELSE P('F학점');
	END IF;
END;

-- 제어문 CASE
DECLARE
	V_NUM NUMBER := 78;
BEGIN
	CASE
		WHEN V_NUM >= 90 THEN P('A학점');
		WHEN V_NUM >= 80 THEN P('B학점');
		WHEN V_NUM >= 70 THEN P('C학점');
		WHEN V_NUM >= 60 THEN P('D학점');
		ELSE P('F학점');
	END CASE;
END;

-- 반복문 LOOP
DECLARE
	V_CNT NUMBER := 1;
BEGIN
	LOOP
		P(V_CNT);
		V_CNT := V_CNT +1;
		EXIT WHEN V_ENT >10;
	END LOOP;
END;

-- 반복문 FOR
BEGIN
	FOR I IN 1..10
	LOOP
		P(I);
	END LOOP;
END;

BEGIN
	FOR I IN REVERSE 1..10
	LOOP
		P(I;)
	END LOOP;
END;

-- 반복문 WHILE
DECLARE
	I NUMBER := 1;
BEGIN
	WHILE I<11
	LOOP
		P(I);
		I := I+1;
	END LOOP;
END;

-- CONTINUE WHEN
-- 조건이 참이면 다음번 반복을 수행
BEGIN
	FOR I IN 1..10
	LOOP
		CONTINUE WHEN MOD(I,2)=0;
		P(I);
	END LOOP;
END;

-- EXIT WHEN
-- 조건이 참이면 반복문 탈출
BEGIN
	FOR I IN 1..10
	LOOP
		EXIT WHEN I=5;
		P(I);
	END LOOP;
END;
