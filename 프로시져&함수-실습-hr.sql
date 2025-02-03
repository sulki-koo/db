-- 프로시져 & 함수 실습

CREATE TABLE EMP
AS 
SELECT * FROM EMPLOYEES;

CREATE TABLE DEPT
AS 
SELECT * FROM DEPARTMENTS;
-- 프로시져 실습

-- 1) 직무명을 입력받아서 해당 직무를 수행하는 직원의 수를 출력하는 PrintEmployeeCountByJob
CREATE OR REPLACE PROCEDURE PrintEmployeeCountByJob(
	P_JOB_TITLE IN VARCHAR2
)
IS
	V_EMP_COUNT NUMBER;
BEGIN
	SELECT COUNT(*) INTO V_EMP_COUNT
	FROM JOBS J, EMP E
	WHERE J.JOB_ID = E.JOB_ID 
	 	AND J.JOB_TITLE = P_JOB_TITLE;
	P(V_EMP_COUNT||'명');
END;

BEGIN
	PrintEmployeeCountByJob('Accountant');
END;

-- 2) 부서ID와 새로운 부서명을 입력받아서 부서명을 업데이트 하는 UpdateDepartmentName
CREATE OR REPLACE PROCEDURE UpdateDepartmentName(
	P_ID IN NUMBER,
	P_NAME IN VARCHAR2
)
IS
BEGIN
	UPDATE DEPT SET DEPARTMENT_NAME = P_NAME WHERE DEPARTMENT_ID = P_ID;
	COMMIT;
END;

SELECT * FROM DEPT;

BEGIN
	UpdateDepartmentName(10, '라라라');-- 원래 10번부서명 Administration
END;

-- 3) 직원ID와 월급 인상률을 입력받아 월급을 인상하는 IncreaseEmployeeSalary
CREATE OR REPLACE PROCEDURE IncreaseEmployeeSalary(
	P_EMP_ID IN NUMBER,
	P_INCREASE IN NUMBER
)
IS
BEGIN
	UPDATE EMP SET SALARY = SALARY+SALARY*P_INCREASE WHERE EMPLOYEE_ID = P_EMP_ID;
	COMMIT;
END;

SELECT * FROM EMP;

BEGIN
	IncreaseEmployeeSalary(100,0.5);
END;

-- 4) 부서ID를 입력받아 해당 부서의 평균 연봉과 관리자의 연봉을 비교해서 
--    관리자의 연봉이 부서 평균 연봉보다 큰지 작은지 출력하는 CompareManagerAndDeptAvgSalary
CREATE OR REPLACE PROCEDURE CompareManagerAndDeptAvgSalary(
	P_DEPT_ID IN NUMBER)
IS
	P_AVG NUMBER;
	P_MANAGER NUMBER;
BEGIN
	SELECT AVG(NVL(SALARY,0)) INTO P_AVG
	FROM EMP
	WHERE DEPARTMENT_ID = P_DEPT_ID;
	
	SELECT SALARY INTO P_MANAGER
	FROM EMP
	WHERE EMPLOYEE_ID = (SELECT MANAGER_ID
		FROM DEPT
		WHERE DEPARTMENT_ID = P_DEPT_ID);

	IF P_AVG > P_MANAGER THEN P(P_AVG||'>'||P_MANAGER||'부서 평균 연봉이 높음');
	ELSIF P_AVG < P_MANAGER THEN P(P_AVG||'<'||P_MANAGER||'관리자 연봉이 높음');
	ELSE P(P_AVG||'='||P_MANAGER||'부서 평균 연봉과 관리자 연봉이 같음');
	END IF;
END;

BEGIN
	CompareManagerAndDeptAvgSalary(20);
END;

-- 5) 부서ID를 입력받아 해당 부서의 직원 풀네임 모두를 출력하는 PrintEmployeeNamesByDept
CREATE OR REPLACE PROCEDURE PrintEmployeeNamesByDept(
	P_DEPT_ID NUMBER
)
IS
	CURSOR CUR_FULLNAME IS 
		SELECT FIRST_NAME||' '||LAST_NAME FULLNAME
		FROM EMP 
		WHERE DEPARTMENT_ID = P_DEPT_ID;
BEGIN
	FOR V_FULLNAME IN CUR_FULLNAME
	LOOP 
		P(V_FULLNAME.FULLNAME);
	END LOOP;
END;

SELECT * FROM EMP;

BEGIN
	PrintEmployeeNamesByDept(90);
END;

-- 함수 실습
-- 1) 직원ID를 입력받아 연봉((SALARY+SALARY*COMMISSION_PCT)*12을 반환하는
--     GetYearlySalary
CREATE OR REPLACE FUNCTION GetYearlySalary(
	P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN NUMBER
IS 
	V_TOTAL NUMBER;
BEGIN
	SELECT NVL((SALARY+SALARY*COMMISSION_PCT),0)*12 INTO V_TOTAL
	FROM EMP
	WHERE EMPLOYEE_ID = P_EMP_ID;
	RETURN V_TOTAL;
END;

SELECT GetYearlySalary(160) FROM DUAL;


-- 2) 직원ID를 입력받아 입사일 기준 현재까지의 근속일수를 반환하는 GetHireDate
CREATE OR REPLACE FUNCTION GetHireDate(
	P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN VARCHAR2
IS
	V_DAY VARCHAR2(200);
BEGIN
	SELECT SYSDATE-HIRE_DATE INTO V_DAY
	FROM EMP
	WHERE EMPLOYEE_ID = 100;
	RETURN V_DAY;
END;

SELECT SYSDATE-HIRE_DATE||'일'
	FROM EMP
	WHERE EMPLOYEE_ID = 100;

SELECT GetHireDate(100) FROM DUAL;

-- 3) 직원ID를 입력받아 입력받은 직원의 관리자의 풀네임을 반환하는 GetManagerFullname
CREATE OR REPLACE FUNCTION GetManagerFullname(
	P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN VARCHAR2
IS
	V_FULLNAME VARCHAR2(200);
	V_MANAGER NUMBER;
BEGIN
	SELECT D.MANAGER_ID INTO V_MANAGER
	FROM EMP E, DEPT D
	WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID 
		AND E.EMPLOYEE_ID = P_EMP_ID;
						
	SELECT FIRST_NAME||' '||LAST_NAME INTO V_FULLNAME
	FROM EMP
	WHERE EMPLOYEE_ID = V_MANAGER;
	
	RETURN V_FULLNAME;
END;

SELECT GetManagerFullname(100) FROM DUAL;

-- 4) 부서ID를 입력받아 부서의 직원수, 월급합계를 반환하는 GetEmployeeCountSalarySum


-- 5) 부서ID 2개를 입력받아 두 관리자의 풀네임과 월급의 차를 반환하는 GetManagerSalaryGap




--------------------------------------------------------------------------------------
-- 프로시져 & 함수 실습

-- EMP테이블과 DEPT테이블 이용해서 실습
CREATE TABLE EMP AS SELECT * FROM EMPLOYEES;
CREATE TABLE DEPT AS SELECT * FROM DEPARTMENTS;

-- 프로시져 실습
-- 1) 직무명을 입력받아서 해당 직무를 수행하는 직원의 수를 출력하는 PrintEmployeeCountByJob
CREATE OR REPLACE PROCEDURE PrintEmployeeCountByJob(
   P_JOB_TITLE JOBS.JOB_TITLE%TYPE
)
IS
   V_EMP_CNT NUMBER;
BEGIN
   SELECT COUNT(*) INTO V_EMP_CNT
   FROM EMP
   WHERE JOB_ID 
      = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE=P_JOB_TITLE);
   P(V_EMP_CNT);
END;

BEGIN PrintEmployeeCountByJob('Sales Manager'); END;

-- 2) 부서ID와 새로운 부서명을 입력받아서 부서명을 업데이트 하는 UpdateDepartmentName
CREATE OR REPLACE PROCEDURE UpdateDepartmentName(
   P_DEPT_ID DEPT.DEPARTMENT_ID%TYPE,
   P_DEPT_NAME DEPT.DEPARTMENT_NAME%TYPE
)
IS
BEGIN
   UPDATE DEPT SET DEPARTMENT_NAME = P_DEPT_NAME
   WHERE DEPARTMENT_ID = P_DEPT_ID;
END;

BEGIN UpdateDepartmentName(10, 'ADMIN'); END;

-- 3) 직원ID와 월급 인상률을 입력받아 월급을 인상하는 IncreaseEmployeeSalary
CREATE OR REPLACE PROCEDURE IncreaseEmployeeSalary(
   P_EMP_ID EMP.EMPLOYEE_ID%TYPE,
   P_INCREASE NUMBER
)
IS
BEGIN
   UPDATE EMP SET SALARY = SALARY + SALARY*P_INCREASE
   WHERE EMPLOYEE_ID = P_EMP_ID;
END;

BEGIN IncreaseEmployeeSalary(100, 0.1); END;

-- 4) 부서ID를 입력받아 해당 부서의 평균 연봉과 관리자의 연봉을 비교해서
--     관리자의 연봉이 부서 평균 연봉보다 큰지 작은지 출력하는 CompareManagerAndDeptAvgSalary
CREATE OR REPLACE PROCEDURE CompareManagerAndDeptAvgSalary(
   P_DEPT_ID DEPT.DEPARTMENT_ID%TYPE
)
IS
   V_AVG_SAL NUMBER;
   V_MGR_SAL NUMBER;
BEGIN
   
   SELECT AVG(NVL(SALARY,0)) INTO V_AVG_SAL
   FROM EMPLOYEES
   WHERE DEPARTMENT_ID = P_DEPT_ID;

   SELECT SALARY INTO V_MGR_SAL
   FROM EMPLOYEES
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID 
      FROM DEPARTMENTS
      WHERE DEPARTMENT_ID = P_DEPT_ID
   );

   P('부서 관리자의 월급 : '||V_MGR_SAL);
   P('부서 평균 월급 : '||V_AVG_SAL);

   IF V_MGR_SAL < V_AVG_SAL THEN
      P('부서 관리자의 월급이 부서 평균 월급보다 적습니다!');
   ELSIF V_MGR_SAL = V_AVG_SAL THEN
      P('부서 관리자의 월급이 부서 평균 월급과 같습니다!');
   ELSE
      P('부서 관리자의 월급이 부서 평균 월급보다 많습니다!');
   END IF;

END;

BEGIN CompareManagerAndDeptAvgSalary(30); END;

-- 5) 부서ID를 입력받아 해당 부서의 직원 풀네임 모두를 출력하는 PrintEmployeeNamesByDept
CREATE OR REPLACE PROCEDURE PrintEmployeeNamesByDept(
   P_DEPT_ID DEPT.DEPARTMENT_ID%TYPE
)
IS
   V_DEPT_ROW DEPT%ROWTYPE;
BEGIN
   FOR V_DEPT_ROW IN (
      SELECT FIRST_NAME||' '||LAST_NAME FULLNAME
      FROM EMP
      WHERE DEPARTMENT_ID = P_DEPT_ID
   )
   LOOP
      P(V_DEPT_ROW.FULLNAME);
   END LOOP;   
END;

BEGIN PrintEmployeeNamesByDept(30); END;

-- 함수 실습
-- 1) 직원ID를 입력받아 연봉((SALARY+SALARY*COMMISSION_PCT)*12을 반환하는
--     GetYearlySalary
CREATE OR REPLACE FUNCTION GetYearlySalary(
   P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN NUMBER
IS
   V_YEARSAL NUMBER;
BEGIN
   SELECT (SALARY+SALARY*NVL(COMMISSION_PCT,0))*12 INTO V_YEARSAL
   FROM EMP
   WHERE EMPLOYEE_ID = P_EMP_ID;
   RETURN V_YEARSAL;
END;

SELECT GetYearlySalary(100) FROM DUAL;

-- 2) 직원ID를 입력받아 입사일 기준 현재까지의 근속일수를 반환하는 GetHireDate
CREATE OR REPLACE FUNCTION GetHireDate(
   P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN NUMBER
IS
   V_HIREDATE NUMBER;
BEGIN
   SELECT SYSDATE - HIRE_DATE INTO V_HIREDATE
   FROM EMP
   WHERE EMPLOYEE_ID = P_EMP_ID;
   RETURN V_HIREDATE;
END;

SELECT GetHireDate(100) FROM DUAL;

-- 3) 직원ID를 입력받아 입력받은 직원의 관리자의 풀네임을 반환하는 GetManagerFullname
CREATE OR REPLACE FUNCTION GetManagerFullname(
   P_EMP_ID EMP.EMPLOYEE_ID%TYPE
)
RETURN VARCHAR2
IS
   V_MGR_FULLNAME VARCHAR2(100);
BEGIN
   SELECT FIRST_NAME||' '||LAST_NAME INTO V_MGR_FULLNAME
   FROM EMP
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID 
      FROM EMP 
      WHERE EMPLOYEE_ID = P_EMP_ID
   );
   RETURN V_MGR_FULLNAME;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN '관리자가 없음!';
END;

SELECT GetManagerFullname(110) FROM DUAL;

-- 4) 부서ID를 입력받아 부서의 직원수, 월급합계를 반환하는 GetEmployeeCountSalarySum
CREATE OR REPLACE TYPE OBJ_EMP AS OBJECT (
   V_EMPCNT NUMBER,
   V_SUMSAL NUMBER
);
CREATE OR REPLACE FUNCTION GetEmployeeCountSalarySum(
   P_DEPT_ID DEPT.DEPARTMENT_ID%TYPE
)
RETURN OBJ_EMP
IS
   V_OBJ_EMP OBJ_EMP;
BEGIN
   
   V_OBJ_EMP := OBJ_EMP(0, 0);
   
   SELECT COUNT(*) INTO V_OBJ_EMP.V_EMPCNT 
   FROM EMP 
   WHERE DEPARTMENT_ID = P_DEPT_ID;

   SELECT SUM(NVL(SALARY,0)) INTO V_OBJ_EMP.V_SUMSAL 
   FROM EMP 
   WHERE DEPARTMENT_ID = P_DEPT_ID;

   RETURN V_OBJ_EMP;

END;

DECLARE
   V_OBJ_EMP OBJ_EMP;
BEGIN
   V_OBJ_EMP := GetEmployeeCountSalarySum(50);
   P(V_OBJ_EMP.V_EMPCNT||' '||V_OBJ_EMP.V_SUMSAL);
END;

-- 5) 부서ID 2개를 입력받아 두 관리자의 풀네임과 월급의 차를 반환하는 GetManagerSalaryGap
CREATE OR REPLACE TYPE OBJ_MANAGER AS OBJECT (
   V_FULLNAME1 VARCHAR2(100),
   V_FULLNAME2 VARCHAR2(100),
   V_SALARYGAP NUMBER
);
CREATE OR REPLACE FUNCTION GetManagerSalaryGap(
   P_DEPT_ID1 DEPT.DEPARTMENT_ID%TYPE,
   P_DEPT_ID2 DEPT.DEPARTMENT_ID%TYPE
)
RETURN OBJ_MANAGER
IS
   V_OBJ_MANAGER OBJ_MANAGER;
   V_SALARY1 EMP.SALARY%TYPE;
   V_SALARY2 EMP.SALARY%TYPE;
BEGIN
   
   V_OBJ_MANAGER := OBJ_MANAGER('', '', 0);

   SELECT FIRST_NAME||' '||LAST_NAME INTO V_OBJ_MANAGER.V_FULLNAME1
   FROM EMP
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID
      FROM DEPT
      WHERE DEPARTMENT_ID = P_DEPT_ID1
   );

   SELECT FIRST_NAME||' '||LAST_NAME INTO V_OBJ_MANAGER.V_FULLNAME2
   FROM EMP
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID
      FROM DEPT
      WHERE DEPARTMENT_ID = P_DEPT_ID2
   );

   SELECT SALARY INTO V_SALARY1
   FROM EMP
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID
      FROM DEPT
      WHERE DEPARTMENT_ID = P_DEPT_ID1
   );

   SELECT SALARY INTO V_SALARY2
   FROM EMP
   WHERE EMPLOYEE_ID = (
      SELECT MANAGER_ID
      FROM DEPT
      WHERE DEPARTMENT_ID = P_DEPT_ID2
   );

   V_OBJ_MANAGER.V_SALARYGAP := V_SALARY1 - V_SALARY2;

   RETURN V_OBJ_MANAGER;
   
END;

SELECT GetManagerSalaryGap(50, 60) FROM DUAL;

