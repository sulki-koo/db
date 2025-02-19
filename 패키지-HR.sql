-- 패키지 (PACKAGE)
-- 관련있는 함수와 프로시져들의 모임
-- PACKAGE, PACKAGE BODY 2개로 구성
-- PACKAGE : 선언부, 함수와 프로시져의 선
-- PACKAGE BODY : 구현부, 함수와 프로시져의 구현
 
-- PACKAGE 생성
CREATE OR REPLACE PACKAGE PKG_EMP
IS 
	PROCEDURE PROC_TEST(P_IN IN NUMBER);

	PROCEDURE PROC_TEST2(
		P_IN IN NUMBER,	P_OUT OUT NUMBER, P_INOUT IN OUT NUMBER);
	
	PROCEDURE PROC_TEST3(
		P_IN1 IN NUMBER, P_IN2 IN NUMBER, P_OUT OUT NUMBER);
	
	FUNCTION FUNC_GETDEPTID(
		P_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN NUMBER;
	
	FUNCTION FUNC_EMP_CNT(
		P_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE)	RETURN NUMBER;
	
	 FUNCTION FUNC_EMP_FULLNAME (
		P_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN VARCHAR2;
END;

-- PACKAGE BODY 생성
CREATE OR REPLACE PACKAGE BODY PKG_EMP
IS 
	PROCEDURE PROC_TEST(P_IN IN NUMBER) IS 
		BEGIN P('IN 파라미터 P_IN변수의 값:'||P_IN); 
	END;

	PROCEDURE PROC_TEST2(
	P_IN IN NUMBER,	P_OUT OUT NUMBER, P_INOUT IN OUT NUMBER) IS 
		BEGIN 
			P('P_IN 변수가 전달받은 값:'||P_IN);
			P('P_INOUT 변수가 전달받은 값:'||P_INOUT);
			P_OUT := 40; P_INOUT := 50; 
	END;
		
	PROCEDURE PROC_TEST3(P_IN1 IN NUMBER, P_IN2 IN NUMBER, P_OUT OUT NUMBER) IS
		BEGIN
			P_OUT := P_IN1 + P_IN2;
			P(P_IN1||'+'||P_IN2||'='||P_OUT); 
	END;

	FUNCTION FUNC_GETDEPTID(P_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN NUMBER
		IS 	V_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE;
		BEGIN
			SELECT DEPARTMENT_ID INTO V_DEPT_ID
			FROM EMPLOYEES
			WHERE EMPLOYEE_ID = P_EMP_ID;
			RETURN V_DEPT_ID; 
	END;
			
	FUNCTION FUNC_EMP_CNT(P_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE)
		RETURN NUMBER IS V_CNT NUMBER;
		BEGIN
			SELECT COUNT(*) INTO V_CNT
			FROM EMPLOYEES
			WHERE DEPARTMENT_ID = P_DEPT_ID;
			RETURN V_CNT; 
	END;
		
	FUNCTION FUNC_EMP_FULLNAME (P_EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
		RETURN VARCHAR2 
		IS V_FN EMPLOYEES.FIRST_NAME%TYPE; V_LN EMPLOYEES.LAST_NAME%TYPE;
		BEGIN
			SELECT FIRST_NAME, LAST_NAME INTO V_FN, V_LN
			FROM EMPLOYEES 
			WHERE EMPLOYEE_ID = P_EMP_ID;
			RETURN V_FN||' '||V_LN; 
	END;
END;

-- 패키지내의 프로시져, 함수 사용
DECLARE V_SUM NUMBER;
BEGIN PKG_EMP.PROC_TEST3(10,20,V_SUM);
END;

SELECT PKG_EMP.FUNC_EMP_FULLNAME(100) FROM DUAL;

-- 
-- 
