-- 그룹핑 (GROUP BY, HAVING)
-- GROUP BY 뒤에는 그룹핑할 컬럼(들)이 위치
-- 그룹핑한 각각에 대해서 조건을 부여할때는 HAVING을 사용
-- SELECT 뒤에 나오는 모든 조회 컬럼들의 조회된 개수는 동일해야 함
-- => 그래야 행을 만들 수 있다
-- SELECT 뒤에 그룹함수를 사용하면 나머지 컬럼들의 결과는 하나여야 함

SELECT * FROM EMPLOYEES; -- 107 ROWS

SELECT COUNT(*) FROM EMPLOYEES; -- 1ROWS

SELECT SUM(SALARY) FROM EMPLOYEES; -- 1ROWS

-- SUM(SALARY) 결과는 하나, EMPLOYEE_ID 결과는 107개 - 같이 조회 안됨
-- SELECT SUM(SALARY), EMPLOYEE_ID FROM EMPLOYEES; -- 1ROWS

SELECT SUM(SALARY), COUNT(EMPLOYEE_ID) FROM EMPLOYEES;

SELECT 'HELLO' FROM EMPLOYEES; -- 107 ROWS

-- 단일값의 경우는 그룹함수와 같이 사용 가능
SELECT 'HELLO', SUM(SALARY) FROM EMPLOYEES; 

-- GROUP BY 뒤에 나온 컬럼은 SELECT에서 그룹함수와 같이 사용할 수 있음
-- 그룹핑 된 EMPLOYEE_ID 각각에 대한 SUM(SALRAY)가 실행됨
SELECT SUM(SALARY), EMPLOYEE_ID 
FROM EMPLOYEES
GROUP BY EMPLOYEE_ID;

-- SELECT에서 그룹함수와 같이 조회되는 모든 컬럼은 GROUP BT 뒤에 있어야 함
SELECT SUM(SALARY), DEPARTMENT_ID, EMPLOYEE_ID 
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, EMPLOYEE_ID;

-- SELECT 뒤에 그룹함수로만 이루어져도 결과가 한 행에 나오므로 OK
SELECT COUNT(*), SUM(SALARY), AVG(SALARY) FROM EMPLOYEES;

-- 1) 같은 부서에 근무하는 직원 수와 그 직원들의 월급 합계
-- 2) 월급합계가 50000만 이상인 부서
-- 3) DEPARTMENT_ID가 없는 경우는 제외
-- 4) 월급합계가 높은 순으로 정렬
SELECT DEPARTMENT_ID, TO_CHAR(COUNT(EMPLOYEE_ID)||'명') AS "부서별 직원수", SUM(SALARY) AS "월급 합계"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL 
GROUP BY DEPARTMENT_ID
HAVING SUM(SALARY) >= 50000
ORDER BY SUM(SALARY) DESC;

