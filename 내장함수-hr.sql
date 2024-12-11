-- 내장함수 (EMBEDED FUNTION)
-- 오라클에 이미 만들어져 있는 함수

-- 문자함수: 문자열 처리에 사용되는 함수

-- UPPER:대문자로 변환
SELECT FIRST_NAME, UPPER(FIRST_NAME) FROM EMPLOYEES;

-- LOWER: 소문자로 변환
SELECT FIRST_NAME, LOWER(FIRST_NAME) FROM EMPLOYEES;

-- INITCAP: 첫글자만 대문자로 변환
SELECT INITCAP('abcde') FROM DUAL; 

-- LENGTH: 문자열의 길이 (=문자의 수)
SELECT LENGTH('abcde') FROM DUAL; 

-- SUBSTR: 문자열에서 부분문자열 추출
-- SUBSTR: (전체문자열, 시작인덱스): 인덱스는 1부터 시작
-- SUBSTR: (전체문자열, 시작인덱스, 추출할문자수)
SELECT SUBSTR('ABCDEFG',3) FROM DUAL;
SELECT SUBSTR('ABCDEFG',3,3) FROM DUAL;

-- INSTR:부분문자열의 시작인덱스 반환
-- INSTR(전체문자열, 부분문자열
SELECT INSTR('ABCDEFG','CD') FROM DUAL;
SELECT INSTR('ABCDEFG','XY') FROM DUAL; -- 0

-- REPLACE: 문자열의 일부 또는 전체를 다른 문자열로 대체
-- REPLACE(전체문자열, 기존문자열, 대체문자열)
SELECT REPLACE('ABCDEFG','AB','XY') FROM DUAL;

-- LPAD : 왼쪽의 공백을 특정문자로 채우기
-- LPAD(문자열, 전체자리수) : 전체자리수에서 왼쪽의 남는 공간을 공백문자로 채움
-- LPAD(문자열, 전체자리수, 채울문자) : 전체자리수에서 왼쪽의 남는 공간을 채울문자로 채움
SELECT LPAD('ABCDE',10) FROM DUAL;
SELECT LPAD('ABCDE',10, '*') FROM DUAL;

-- RPAD : 오른쪽의 공백을 특정문자로 채우기
-- RPAD(문자열, 전체자리수) : 전체자리수에서 오른쪽의 남는 공간을 공백문자로 채움
-- RPAD(문자열, 전체자리수, 채울문자) : 전체자리수에서 오른쪽의 남는 공간을 채울문자로 채움
SELECT RPAD('ABCDE',10) FROM DUAL;
SELECT RPAD('ABCDE',10, '*') FROM DUAL;

-- CONCAT : 두 문자열을 한 문자열로 붙이기
SELECT CONCAT('ABC','DEF') FROM DUAL;
SELECT 'ABC'||'DEF' FROM DUAL;

-- TRIM : 양쪽 공백문자들을 제거
SELECT TRIM('   ABC   ') FROM DUAL;
-- LTRIM : 왼쪽 공백문자들을 제거
SELECT LTRIM('   ABC   ') FROM DUAL;
-- RTRIM : 오른쪽 공백문자들을 제거
SELECT RTRIM('   ABC   ') FROM DUAL;

-- 숫자 함수
-- ROUND : 반올림
SELECT ROUND(3.141592) FROM DUAL; -- 소수점 첫째자리 반올림 
SELECT ROUND(3.141592, 2) FROM DUAL; -- 소수점 셋째자리 반올림 

-- TRUNC : 버림
SELECT TRUNC(3.141592) FROM DUAL; -- 소수점 첫째자리 버림
SELECT TRUNC(3.141592, 2) FROM DUAL; -- 소수점 셋째자리 버림

-- CEIL : 첫장값 (주어진 수보다는 크지만 가장 작은 정수)
SELECT CEIL(3.14) FROM DUAL; 

-- FLOOR : 바닥값 (주어진 수보다는 작지만 가장 큰 정수)
SELECT FLOOR(3.14) FROM DUAL; 

-- MOD : 앞의 수를 뒤의 수로 나눈 나머지 반환
SELECT MOD(7,3) FROM DUAL;

-- EXP : E의 몇 승
SELECT EXP(3) FROM DUAL;

-- LN : 자연로그
SELECT LN(3) FROM DUAL;

-- POWER : 제곱값
SELECT POWER(2,3) FROM DUAL; 

-- SQRT : 루트
SELECT SQRT(3) FROM DUAL; 

-- 날짜 함수
-- SYSDATE : 오라클이 제공하는 현재 시스템의 날짜와 시간 정보
SELECT SYSDATE FROM DUAL;

-- ADD_MONTHS : 몇개월 전(-)/후(+)를 반환
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; -- 4개월 후
SELECT ADD_MONTHS(SYSDATE, -4) FROM DUAL; -- 4개월 전

-- MONTHS_BETWEEN : 두 날짜데이터간의 개월 차를 반환
SELECT MONTHS_BETWEEN(SYSDATE, '2024-03-26') FROM DUAL;
SELECT MONTHS_BETWEEN('2024-03-26', SYSDATE) FROM DUAL;

-- LAST_DAY : 해당 월의 마지막 날짜
SELECT LAST_DAY(SYSDATE) FROM DUAL; 
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, 4)) FROM DUAL; 

-- NEXT_DAY : 해당 시점 기준 가장 가까운 요일
SELECT NEXT_DAY(SYSDATE, '일') FROM DUAL; 
SELECT NEXT_DAY(SYSDATE, '일요일') FROM DUAL; 
SELECT NEXT_DAY(SYSDATE, '수요일') FROM DUAL; 

-- 날짜 더하기 / 빼기
SELECT SYSDATE + 10 FROM DUAL;
SELECT SYSDATE - 10 FROM DUAL;
SELECT TO_DATE('2020-10-01') + 10 FROM DUAL; 
SELECT TO_DATE('2020-10-01') - 10 FROM DUAL; 

-- 날짜 반올림
SELECT ROUND(SYSDATE) FROM DUAL; 
SELECT ROUND(SYSDATE, 'YYYY') FROM DUAL; 
SELECT ROUND(SYSDATE, 'MM') FROM DUAL; 
SELECT ROUND(SYSDATE, 'DD') FROM DUAL; 
SELECT ROUND(SYSDATE, 'HH') FROM DUAL; 
SELECT ROUND(SYSDATE, 'MI') FROM DUAL; 

-- TRUNC : 날짜 버림
SELECT TRUNC(SYSDATE) FROM DUAL;
SELECT TRUNC(SYSDATE, 'MM') FROM DUAL;

-- 형변환 함수
-- 문자, 숫자, 날짜 타입을 다른타입으로 변환하는 함수

-- TO_CHAR : 문자타입으로 변환
SELECT TO_CHAR(SYSDATE), SYSDATE FROM DUAL; 
SELECT TO_CHAR(100) FROM DUAL;
SELECT 100||'원' FROM DUAL;
SELECT 100||100 FROM DUAL;

-- TO_NUMBER : 숫자타입으로 변환
SELECT TO_NUMBER('100') FROM DUAL; 
--SELECT TO_NUMBER('백') FROM DUAL; 

-- TO_DATE : 날짜타입으로 변환
SELECT TO_DATE('2024-10-10') FROM DUAL; 
--SELECT TO_DATE('2024-10-10 11:10:10.000') FROM DUAL; 
SELECT TO_DATE('2024/10/10') FROM DUAL; 
SELECT TO_DATE('2024 10 10') FROM DUAL; 

-- NULL 처리 함수
-- NVL : 널값을 다른 값으로 대체
-- NVL(컬럼, 대체값)
SELECT NVL(NULL, '데이터없음') FROM DUAL; 

-- NVL2 : 널값이면 뒤의 값, 널이 아니면 앞의 값
SELECT NVL2(NULL, '데이터있음', '데이터없음') FROM DUAL; 

-- 기타함수
-- DECODE : 컬럼의 값에 따라 다른 값을 반환
SELECT DEPARTMENT_ID, NVL(
	DECODE(DEPARTMENT_ID,
		10,'뉴욕',
		20, '델라스',
		30, '시카고'),
	'정보없음'
)
FROM EMPLOYEES;

-- CASE ~ WHEN ~ THEN ~ ELSE ~ END
SELECT DEPARTMENT_ID,
	CASE WHEN DEPARTMENT_ID=10 THEN '뉴욕'
		 WHEN DEPARTMENT_ID=20 THEN '델라스'
		 WHEN DEPARTMENT_ID=30 THEN '시카고'
		 ELSE '정보없음'
	END AS 도시명
FROM EMPLOYEES;
