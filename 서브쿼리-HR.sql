-- SUBQUERY
-- 쿼리(메인쿼리) 안에 사용되는 쿼리(서브쿼리)

-- 단일행 서브쿼리 : 서브쿼리의 결과가 한 행
-- 입사일이 149번 직원의 입사일보다 빠른 직원들의 정보를 조회
SELECT *
FROM EMPLOYEES
WHERE HIRE_DATE < (
	SELECT HIRE_DATE FROM EMPLOYEES
	WHERE EMPLOYEE_ID = 149
);

-- 다중행 서브쿼리 : 서브쿼리의 결과가 여러 행
-- 부서별 최고 급여에 해당하는 급여를 받는 직원들의 정보를 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY IN(
	SELECT MAX(SALARY) FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
);
SELECT *
FROM EMPLOYEES
WHERE SALARY = ANY(
	SELECT MAX(SALARY) FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
);
SELECT *
FROM EMPLOYEES
WHERE SALARY = SOME(
	SELECT MAX(SALARY) FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
);

-- 실습 1) 30번 부서 직원들의 최대 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY < (
	SELECT MAX(SALARY) FROM EMPLOYEES 
	WHERE DEPARTMENT_ID = 30
);

-- 실습 2) 30번 부서 직원들의 최소 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY < (
	SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 30
);
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL(
	SELECT SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 30
);

-- 서브쿼리의 결과가 존재하면 메인쿼리를 수행
SELECT *
FROM EMPLOYEES
WHERE EXISTS(
	SELECT * FROM DUAL WHERE 1 = 0
);
SELECT *
FROM EMPLOYEES
WHERE NOT EXISTS(
	SELECT * FROM DUAL WHERE 1 = 0
);
SELECT *
FROM EMPLOYEES
WHERE EXISTS(
	SELECT * FROM DUAL WHERE 1 = 1
);

-- 다중열 서브쿼리 : 서브쿼리의 결과가 여러 열
-- 부서별로 최대급여를 받는 직원들의 정보를 조회
SELECT *
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, SALARY) IN (
	SELECT DEPARTMENT_ID, MAX(SALARY)
	FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
);

-- INLINE VIEW : FROM절 뒤에 서브쿼리
SELECT *
FROM (
	SELECT *
	FROM EMPLOYEES
	WHERE DEPARTMENT_ID = 30
);

-- ROWNUM : 오라클이 제공하는 조회된 행에 자동으로 부여되는 번호
-- ROWID : 오라클이 제공하는 조회된 행에 자동으로 부여되는 아이디
SELECT ROWNUM, ROWID
FROM EMPLOYEES;

-- TOP-N QUERY : SELECT 조회 행 중에 상위 몇개만 조회
SELECT ROWNUM, E.*
FROM (
	SELECT * 
	FROM EMPLOYEES E
	WHERE DEPARTMENT_ID = 50
) E 
WHERE ROWNUM < 11;











