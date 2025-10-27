-- GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ...
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함
-- 그룹함수는 단 한개의 결과값만 산출 > 그룹이 여러개일 경우 오류 발생
-- 여러 개의 결과값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용
-- **GROUP BY 사용시 주의사항**
-- SELECT 절 명시한 조회하고자 하는 컬럼 중 그룹 함수를 사용하지 않은 컬럼은 **무조건** GROUP BY절에 작성되어야 오류가 나지 않는다!

-- EMPLOYEE 테이블에서 부서 코드, 부서별 급여 합 조회
-- 1) 부서 코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE; -- 23개의 행 출력
-- 2) 급여의 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 1개의 행 출력

SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE; -- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
-- DEPT_CODE 컬럼을 그룹으로 묶어 > 그룹별로 급여의 합계를 구함
SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서(FROM) 직급 코드가 같은 사람의(GROUP BY JOB_CODE)
-- 직급 코드, 급여 평균, 인원수(SELECT)를 직급 코드 오름차순(ORDER BY)으로 조회
SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*) FROM EMPLOYEE GROUP BY JOB_CODE ORDER BY JOB_CODE ASC;

-- EMPLOYEE 테이블에서(FROM) 성별(남/여)과 각 성별별 인원 수(GROUP BY DECODE(SUBSTR(...) 급여 합(SELECT)을 인원 수 오름차순으로 조회(ORDER BY)
-- 해석 순서로 인하여 > ORDER BY와 달리 GROUP BY는 별칭으로 식별할 수 없음! (SELECT 해석 이전에 GROUP BY가 먼저 해석됨)
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, COUNT(*) "인원 수", SUM(SALARY) "급여 합"
FROM EMPLOYEE GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') ORDER BY "인원 수";

-- WHERE 절 GROUP BY 절 혼합하여 사용하기
-- WHERE절 : 각 컬럼값에 대한 조건
-- HAVING절 : 그룹에 대한 조건

-- EMPLOYEE 테이블에서(FROM) 부서 코드가 D5, D6인 부서(WHERE -> GROUP BY)의 부서 코드, 평균 급여, 인원 수 조회(SELECT)
SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D6') -- 부서 코드가 D5, D6인
GROUP BY DEPT_CODE; -- 부서의 (WHERE절에서 구한 부서 코드가 D5, D6인 데이터들을 그룹으로 묶음)

SELECT * FROM EMPLOYEE;
-- EMPLOYEE 테이블에서(FROM) 2000년도 이후 입사자들의 직급별(GROUP BY JOB_CODE) 직급 코드, 급여합을 조회(SELECT)
SELECT JOB_CODE, SUM(SALARY) FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000
GROUP BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE WHERE SUBSTR(TO_CHAR(HIRE_DATE, 'YYYY'), 1, 4) >= '2000'
--HIRE_DATE >= TO_DATE('2000-01-01')
--EXTRACT(YEAR FROM HIRE_DATE) >= 2000
GROUP BY JOB_CODE;

-- 여러 컬럼을 묶어서 그룹으로 지정 가능 > 그룹 내 그룹 가능
-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 인원수 조회
-- 부서 코드 오름차순, 직급 코드 내림차순으로 정렬해 > 부서 코드, 직급 코드, 인원수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹화, 나눠진 그룹 내에서 JOB_CODE로 그룹화
ORDER BY DEPT_CODE, JOB_CODE DESC;

-- HAVING 절 : 그룹 함수로 구해 올 그룹에 대한 조건을 설정할 때 사용

-- EMPLOYEE 테이블에서(FROM) 부서별 평균 급여가 3백만 원 이상인 부서의 부서 코드, 평균 급여 조회
-- 단, 부서 코드 오름차순 정렬
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
-- WHERE SALARY >= 3000000 -- 한 사람의 급여가 삼백만 원 이상인지 (요구사항 X)
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000 -- DEPT_CODE 그룹 중 급여 평균이 삼백만 원 이상인 그룹만 조회 (요구사항 O)
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급의 직급 코드, 인원수 조회
-- 단, 직급 코드 오름차순 정렬
SELECT JOB_CODE, COUNT(*) FROM EMPLOYEE
GROUP BY JOB_CODE HAVING COUNT(*) <= 5 -- HAVING 절에는 그룹 함수가 반드시 작성된다
ORDER BY 1; -- ORDER BY 절에는 별칭, 컬럼명, 컬럼 순서로 사용 가능!

-- 집계 함수 (ROLLUP, CUBE)
-- 그룹별 산출 결과 값의 집계를 계산하는 함수 (그룹별로 중간 집계 결과를 추가)
-- GROUP BY 절에서만 사용할 수 있는 함수

-- ROLLUP : GROUP BY 절에서 가장 먼저 작성된 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;	

-- CUBE : GROUP BY 절에 작성된 모든 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


/* SET OPERATOR (집합 연산자) 
-- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자
- UNION (합집합) : 두 SELECT 결과를 하나로 합침. 단, 중복은 한 번만 작성
- INTERSECT (교집합) : 두 SELECT 결과 중 중복되는 부분만 조회
- UNION ALL : UNION + INTERSECT , 합집합에서 중복 부분 제거 X
- MINUS (차집합) : A에서 A,B 교집합 부분을 제거하고 조회 */


-- EMPLOYEE 테이블에서 부서 코드가 'D5'인 사원의 사번, 이름 부서 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION
-- 급여가 300만 원 초과인 사원의 사번, 이름, 부서 코드, 급여 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

-- 주의 사항
-- 집합연산자를 사용하기 위한 select문들은 조회하는 컬럼의 타입, 개수 모두 동일해야 한다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000; -- ORA-01789: 질의 블록은 부정확한 수의 결과 열 가지고 있습니다.

-- 서로 다른 테이블이지만 컬럼의 타입, 개수만 일치하면 집합연산자 사용 가능!
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE
UNION
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;