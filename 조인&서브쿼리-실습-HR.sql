-- 조인/서브쿼리 실습

-- 1) 연봉이 전체평균연봉보다 높은 직원의 정보를 연봉이 많은순으로 조회
--    (연봉=SALARY*12)
-- NVL(SALARY*12, 0) : 연봉이 NULL인 경우(정해지지 않은 경우) 0으로 처리
SELECT E.*, NVL(SALARY*12, 0) AS 연봉
FROM EMPLOYEES E
WHERE NVL(SALARY*12, 0) > (
	SELECT AVG(NVL(SALARY*12, 0)) 
	FROM EMPLOYEES E
)
ORDER BY NVL(SALARY*12, 0) DESC;

SELECT E.*, NVL(SALARY*12, 0) "연봉"
FROM EMPLOYEES E
WHERE NVL(SALARY*12, 0) > (
   SELECT AVG(NVL(SALARY*12, 0))
   FROM EMPLOYEES
)
ORDER BY NVL(SALARY*12, 0) DESC;


-- 2) 부서별로 연봉을 가장 많이 받는 직원의 정보를 조회
SELECT E.*, NVL(SALARY*12, 0) AS 연봉
FROM EMPLOYEES E
WHERE (DEPARTMENT_ID, NVL(SALARY*12, 0)) IN (
	SELECT DEPARTMENT_ID, MAX(NVL(SALARY*12, 0))
	FROM EMPLOYEES 
	GROUP BY DEPARTMENT_ID
) ORDER BY DEPARTMENT_ID;

SELECT E.*, NVL(SALARY*12,0) "연봉"
FROM EMPLOYEES E
WHERE (DEPARTMENT_ID, NVL(SALARY*12,0)) IN (
   SELECT DEPARTMENT_ID, MAX(NVL(SALARY*12,0))
   FROM EMPLOYEES
   GROUP BY DEPARTMENT_ID
);


-- 3) JOB_ID가 SA_REP인 직원들 중에서 입사일이 가장 빠른 직원의 정보를 조회
-- MIN(HIRE_DATE) : 입사일이 가장 빠른
SELECT *
FROM EMPLOYEES
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEES
	WHERE JOB_ID = 'SA_REP'
);

SELECT *
FROM EMPLOYEES
WHERE HIRE_DATE = (
   SELECT MIN(HIRE_DATE)
   FROM EMPLOYEES
   WHERE JOB_ID = 'SA_REP'
);


-- 4) JOB_ID가 S로 시작하는 직원 중 최저월급을 받는 직원의 정보를 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY = (
	SELECT MIN(SALARY)
	FROM EMPLOYEES
	WHERE JOB_ID LIKE 'S%'
);

SELECT *
FROM EMPLOYEES
WHERE SALARY = (
   SELECT MIN(SALARY)
   FROM EMPLOYEES
   WHERE JOB_ID LIKE 'S%'
);


-- 5) 직원아이디가 100인 직원과 같은 부서에 근무하는 직원들의
--    직원아이디, 직원명, 부서아이디, 부서명을 조회
SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명, D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
WHERE E.DEPARTMENT_ID = (
	SELECT DEPARTMENT_ID 
	FROM EMPLOYEES
	WHERE EMPLOYEE_ID = 100
);

SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND E.DEPARTMENT_ID = (
      SELECT E2.DEPARTMENT_ID
      FROM EMPLOYEES E2
      WHERE E2.EMPLOYEE_ID = 100
   );

-- 6) 부서명이 S로 시작하는 부서에 근무하는 직원들의
--    직원아이디, 직원명, 부서아이디, 부서명을 조회
SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명, D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE REGEXP_LIKE(D.DEPARTMENT_NAME,'^[S]+');

SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID 
   AND D.DEPARTMENT_NAME LIKE 'S%';

-- 7) 직무아이디가 IT_PROG인 직원들 중 최소월급을 받는 사람과
--    최대월급을 받는 사람의 직원아이디, 직원명, 부서명, 월급을 조회
SELECT E.JOB_ID, E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명, D.DEPARTMENT_NAME, E.SALARY 
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.JOB_ID = 'IT_PROG' AND (E.SALARY = (
	SELECT MAX(SALARY) 	FROM EMPLOYEES 	WHERE JOB_ID = 'IT_PROG') 
	OR E.SALARY = (SELECT MIN(SALARY)	FROM EMPLOYEES	WHERE JOB_ID = 'IT_PROG')
);

SELECT E.EMPLOYEE_ID, E.FIRST_NAME ||''||E.LAST_NAME, D.DEPARTMENT_NAME, E.SALARY 
FROM EMPLOYEES E, DEPARTMENTS D 
WHERE 
   E.DEPARTMENT_ID = D.DEPARTMENT_ID 
   AND (SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG')
      OR
      SALARY = (SELECT MIN(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'))
   AND JOB_ID = 'IT_PROG';


-- 8) 모든 직원의 직원아이디, 직원명, 부서명, 커미션이 포함된 월급을 조회
--    (단, 커미션퍼센트가 NULL인 경우는 제외)
SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명, D.DEPARTMENT_NAME, (E.SALARY+E.COMMISSION_PCT*E.SALARY) AS "커미션 포함 월급"
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.COMMISSION_PCT IS NOT NULL;

SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME, D.DEPARTMENT_NAME, E.SALARY + (E.SALARY*E.COMMISSION_PCT)
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND E.COMMISSION_PCT IS NOT NULL;

-- 9) 커미션퍼센트가 NULL인 직원들이 근무하는 부서별로
--    부서아이디, 부서명, 부서직원들의 커미션이 포함된 월급의 합계를 조회
--    (단, 커미션퍼센트가 NULL인 경우는 제외)
SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME, SUM(E.SALARY+NVL(E.COMMISSION_PCT,0)*E.SALARY) AS "월급"
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.COMMISSION_PCT IS NULL
GROUP BY E.DEPARTMENT_ID, D.DEPARTMENT_NAME;
		
SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME, SUM(E.SALARY + NVL(E.COMMISSION_PCT,0)*E.SALARY)
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND E.COMMISSION_PCT IS NULL
GROUP BY E.DEPARTMENT_ID, D.DEPARTMENT_NAME;


-- 10) 직무수행시간(END_DATE-START_DATE)이 가장 길었던 직무를 수행했던 직원이
--     근무하는 직원들의 직무아이디, 직무명, 부서명, 직원아이디, 직원명을 조회
SELECT JH.JOB_ID, D.DEPARTMENT_NAME, E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명
FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
	JOIN JOB_HISTORY JH ON E.JOB_ID = JH.JOB_ID
	JOIN JOBS J ON JH.JOB_ID = J.JOB_ID 
WHERE (D.DEPARTMENT_ID, END_DATE-START_DATE) IN (
	SELECT D.DEPARTMENT_ID, MAX(JH.END_DATE-JH.START_DATE)
	FROM JOB_HISTORY JH, EMPLOYEES E
	WHERE JH.JOB_ID = E.JOB_ID  -- 값을 하나로 추려줌
);

SELECT JH.JOB_ID, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, J.JOB_TITLE, 
		E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME
FROM EMPLOYEES E
   JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
   JOIN JOB_HISTORY JH ON E.JOB_ID = JH.JOB_ID
   JOIN JOBS J ON JH.JOB_ID = J.JOB_ID
WHERE (D.DEPARTMENT_ID , END_DATE-START_DATE) IN (
   SELECT D.DEPARTMENT_ID, MAX(JH.END_DATE-JH.START_DATE)
   FROM JOB_HISTORY JH, EMPLOYEES E
   WHERE JH.JOB_ID = E.JOB_ID
);


-- 11) 시애틀(Seattle)에 있는 부서에 근무하는 모든 직원들의
--     부서아이디, 부서명, 직원아이디, 직원명을 조회
SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명
FROM LOCATIONS L, DEPARTMENTS D, EMPLOYEES E
WHERE L.LOCATION_ID = D.LOCATION_ID 
	AND D.DEPARTMENT_ID = E.DEPARTMENT_ID 
	AND D.LOCATION_ID = (
		SELECT LOCATION_ID 
		FROM LOCATIONS
		WHERE CITY = 'Seattle'
); 

SELECT D.DEPARTMENT_ID, D.DEPARTMENT_NAME, 
   E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D
   ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.LOCATION_ID = (
   SELECT LOCATION_ID 
   FROM LOCATIONS 
   WHERE CITY='Seattle'
);


-- 12) 유럽(Europe)에 있는 도시들에 있는 모든 부서에 근무하는 직원들의
--     도시명, 부서아이디, 부서명, 직원아이디, 직원명을 조회
SELECT L.CITY, D.DEPARTMENT_ID, D.DEPARTMENT_NAME, E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 직원명
FROM COUNTRIES C, LOCATIONS L, DEPARTMENTS D, EMPLOYEES E
WHERE C.COUNTRY_ID = L.COUNTRY_ID 
	AND L.LOCATION_ID = D.LOCATION_ID 
	AND D.DEPARTMENT_ID = E.DEPARTMENT_ID 
	AND C.REGION_ID = (
		SELECT REGION_ID 
		FROM REGIONS
		WHERE REGION_NAME = 'Europe'
);

SELECT L.CITY, D.DEPARTMENT_ID, D.DEPARTMENT_NAME,
   E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME
FROM EMPLOYEES E
   JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
   JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID 
   JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
   JOIN REGIONS R ON C.REGION_ID = R.REGION_ID
WHERE R.REGION_NAME = 'Europe';


-- 13) 입사년도별로 최대급여와 최소급여 받는 직원의 입사년도 네자리, 직원아이디
--     풀네임, 월급을 입사년도 내림차순으로 조회
SELECT TO_CHAR(HIRE_DATE, 'YYYY') AS "입사년도", EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS 풀네임, SALARY
FROM EMPLOYEES
WHERE (TO_CHAR(HIRE_DATE, 'YYYY'), SALARY) IN (
	SELECT TO_CHAR(HIRE_DATE, 'YYYY'), MAX(SALARY)
	FROM EMPLOYEES
	GROUP BY TO_CHAR(HIRE_DATE, 'YYYY'))
OR (TO_CHAR(HIRE_DATE, 'YYYY'), SALARY) IN (
	SELECT	TO_CHAR(HIRE_DATE, 'YYYY'),	MIN(SALARY)
	FROM	EMPLOYEES
	GROUP BY	TO_CHAR(HIRE_DATE, 'YYYY'))
ORDER BY HIRE_DATE DESC;

SELECT TO_CHAR(HIRE_DATE, 'YYYY'), EMPLOYEE_ID, 
   FIRST_NAME||' '||LAST_NAME, SALARY
FROM EMPLOYEES
WHERE
   (TO_CHAR(HIRE_DATE, 'YYYY'), SALARY) IN (
      SELECT TO_CHAR(HIRE_DATE, 'YYYY'), MAX(SALARY)
      FROM EMPLOYEES
      GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
   ) OR
   (TO_CHAR(HIRE_DATE, 'YYYY'), SALARY) IN (
      SELECT TO_CHAR(HIRE_DATE, 'YYYY'), MIN(SALARY)
      FROM EMPLOYEES
      GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
)
ORDER BY TO_CHAR(HIRE_DATE, 'YYYY') DESC;


-- OUTER JOIN 사용!
-- 14. 부서가 없는 직원의 풀네임 조회
SELECT E.EMPLOYEE_ID, E.FIRST_NAME||' '||E.LAST_NAME AS 풀네임
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID IS NULL;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
AND D.DEPARTMENT_ID IS NULL;


-- 15. 소속된 직원이 없는 부서명 조회
SELECT D.DEPARTMENT_NAME 
FROM DEPARTMENTS D LEFT OUTER JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID IS NULL;

SELECT D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID
AND E.EMPLOYEE_ID IS NULL;


-- 16. 월급이 부서의 평균월급보다 적은 직원의 풀네임과 월급을 조회
SELECT E.FIRST_NAME||' '||E.LAST_NAME AS 풀네임, E.SALARY 
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
WHERE E.SALARY < (
	SELECT AVG(E2.SALARY)
	FROM EMPLOYEES E2
	WHERE E.DEPARTMENT_ID = E2.DEPARTMENT_ID
	GROUP BY DEPARTMENT_ID
);

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME, E.SALARY
FROM EMPLOYEES E, (
   SELECT DEPARTMENT_ID, AVG(SALARY) AS AVG_SALARY
   FROM EMPLOYEES
   GROUP BY DEPARTMENT_ID) AVGSAL
WHERE E.DEPARTMENT_ID = AVGSAL.DEPARTMENT_ID(+)
AND E.SALARY < AVGSAL.AVG_SALARY;

-- 17. 월급이 5000 이상인 직원 중 부서가 없는 직원의 풀네임과 월급을 조회
SELECT E.FIRST_NAME||' '||E.LAST_NAME AS 풀네임, E.SALARY 
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
WHERE E.SALARY >= 5000 AND E.DEPARTMENT_ID IS NULL;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME, E.SALARY
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
   AND D.DEPARTMENT_ID IS NULL
   AND E.SALARY >= 5000;


-- 18. 부서가 없는 직원 중 급여가 전체 평균급여보다 높은 직원 풀네임과 월급을 조회
SELECT E.FIRST_NAME||' '||E.LAST_NAME AS 풀네임, E.SALARY
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
WHERE E.DEPARTMENT_ID IS NULL 
	AND E.SALARY > (
		SELECT AVG(SALARY) 
		FROM EMPLOYEES 
);

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME, E.SALARY
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
   AND D.DEPARTMENT_ID IS NULL
   AND E.SALARY > (
      SELECT AVG(SALARY)
      FROM EMPLOYEES
   );


-- 19. 직원이 없는 부서를 포함하여 부서별 직원 수를 조회
SELECT D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID) 
FROM EMPLOYEES E RIGHT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;


SELECT D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID)
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;


-- 20. 부서가 없는 직원 중 월급이 7000 이상이고 직책이 'SA_REP'인
--      직원의 풀네임과 월급을 조회
SELECT E.FIRST_NAME||' '||E.LAST_NAME AS 풀네임, E.SALARY
FROM EMPLOYEES E LEFT OUTER JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
WHERE E.DEPARTMENT_ID IS NULL 
	AND E.SALARY >= 7000
	AND J.JOB_ID = 'SA_REP';

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME, E.SALARY
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
   AND D.DEPARTMENT_ID IS NULL
   AND E.SALARY >= 7000
   AND E.JOB_ID = 'SA_REP';

