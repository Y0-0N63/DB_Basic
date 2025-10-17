/*
SELECT (DML or DQL) : 조회
데이터를 조회한 결과 > Result Set (= SELECT 구문에 의해 조회(SELECT)된 행들의 집합)
Result Set은 0개(조건에 맞는 행이 하나도 없는 경우) 이상의 행이 포함됨

[작성법]
SELECT 컬럼명 FROM 테이블명; = 테이블의 특정 컬럼 조회
*/

-- EMPLOYEE 테이블에서 모든(*, ALL) 컬럼 조회하기
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 직원 이름, 휴대전화번호 컬럼만 조회하기
-- 잘못된 컬럼명 작성했을 경우 > SQL Error [904] [42000]: ORA-00904: "PHONE2": 부적합한 식별자
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- 컬럼 값 산술 연산
-- 컬럼 값 : 테이블 내 한 셀에 작성된 값(DATA 자체)

-- EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여, 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;

-- Java와 달리 문자열과 숫자가 혼합될 수 없음 >	 SQL Error [1722] [42000]: ORA-01722: 수치가 부적합합니다
-- >> 산술 연산은 숫자 타입(NUMBER 타입)만 가
SELECT EMP_NAME + 10 FROM EMPLOYEE;

-- DUAL(DUmmy tAbLe, 임시 조회용 테이블)에서 문자열로 작성된 1과 숫자 타입으로 작성된 1이 같은가? > 같음
-- 문자열 안에 들어있는 숫자는 자동으로 형변환되어 숫자 타입으로 인식되기 때문!
SELECT '같음' FROM DUAL WHERE 1 = '1';

-- VARCHAR2 타입이어도 실제로 숫자 값이 들어있어 숫자 타입으로 인식됨 > 산술 계산 가능
SELECT EMP_ID + 10 FROM EMPLOYEE;

-- 날짜(DATE) 타입 조회
-- SYSDATE : 시스템상의 현재 시간(날짜)를 나타내는 상수
SELECT SYSDATE FROM DUAL;

-- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회	
SELECT EMP_NAME, HIRE_DATE, SYSDATE FROM EMPLOYEE;

-- 날짜 + 산술 연산 (+ , -)
-- 2025-10-16 10:38:22.000 | 2025-10-17 10:38:22.000 | 2025-10-18 10:38:22.000
-- SYSDATE에 +, - 연산 시 일 단위로 계산 진행
SELECT SYSDATE - 1, SYSDATE, SYSDATE + 1 FROM DUAL;

-- <컬럼 별칭 지정>
-- 컬럼명 [AS] 별칭 : 별칭에 띄어쓰기, 특수 문자 없이 문자만 존재하는 경우
-- 컬럼명 [AS] "별칭" : 별칭 띄어쓰기, 특수 문자 모두 가능
SELECT SYSDATE - 1 "하루 전", SYSDATE AS 현재시간, SYSDATE + 1 내일 FROM DUAL;

-- DB 리터럴
SELECT EMP_NAME, SALARY, '원입니다' FROM EMPLOYEE;

-- DISTINCT : 조회 시 컬럼에 포함된 중복 값 한 번만 표기
-- 주의 사항 1) DISTINCT 구문은 SELECT마다 한 번씩만 작성 가능
-- 주의 사항 2) DISTINCT 구문은 SELECT 가장 앞에 작성되어야
SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

-- SELECT 해석 순서 : FROM > 조건 > 컬럼 조회 > 정렬
-- 3. SELECT 절 : SELECT 컬럼명
-- 1. FROM 절 : FROM 테이블명
-- 2. WHERE 절(조건절) : WHERE 컬럼명 연산자 값;
-- 4. ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [NULLS FIRST | LAST]

-- EMPLOYEE 테이블에서(FORM) 급여가 3백만 원 초과인(조건) 사원의 사번, 이름, 급여, 부서 코드 조회(SELECT)
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE WHERE SALARY > 3000000;

-- 비교 연산자 : >, ㅡ, >=, <=, =, (!=, <>)-> 같지 않다
-- 대입 연산자 : :=

-- EMPLOYEE 테이블에서 부서 코드가 'D9'인 사원의 사번(EMP_ID), 이름(EMP_NAME), 부서 코드(DEPT_CODE), 직급 코드(JOB_CODE)를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- 논리 연산자 (AND, OR)
-- EMPLOYEE 테이블에서 급여가 300만 원 미만 or 500만 원 이상인 사원의 사번, 이름, 급여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY < 3000000 OR SALARY > 5000000;

-- EMPLOYEE 테이블에서 급여가 300만 이상이고, 500만 미만인 사원의 사번, 이름, 급여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY >= 3000000 AND SALARY <= 5000000;

-- BETWEEN A AND B : A 이상, B 이하
-- EMPLOYEE 테이블에서 급여가 300만 이상이고, 600만 이하인 사원의 사번, 이름, 급여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY BETWEEN 3000000 AND 6000000;
SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY NOT BETWEEN 3000000 AND 6000000;

-- DATE에 BETWEEN 이용하기
-- EMPLOYEE 테이블에서 입사일이 1990-01-01~1999-12-31 사이인 직원의 이름, 입사일(HIRE_DATE) 조회하기
SELECT EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31';

-- LIKE : 비교하려는 값이 특정한 패턴을 만족시키면 조회하는 연산자
-- [작성법]
-- WHERE 컬럼명 LIKE '패턴이 적용된 값'
-- LIKE 패턴을 나타내는 문자 : '%'(포함), '_'(글자수)
-- 예시) 'A%' : A로 시작하는 문자열, '%A' : A로 끝나는 문자열, '%A%' : A를 포함하는 문자열
-- 'A_' : A로 시작하는 두 글자 문자열, '____A' : A로 끝나는 다섯 글자 문자열, '__A__' : 세 번째 문자가 A인 다섯 글자 문자열
-- '_____' : 다섯 글자 문자열

-- EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블에서 전화번호가 010으로 시작하지 않는 사원의 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';

-- ESCAPE 문자 : #, ^
-- : ESCAPE 문자 뒤에 작성된 _는 일반 문자인 '_'로 해석됨
-- EMPLOYEE 테이블에서 EMAIL의 _앞 글자가 세 글자인 사원만 이름, 이메일 조회
SELECT EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___#_%' ESCAPE '#';

-- EMPLOYEE 테이블에서 이메일 '_' 앞이 4글자이면서 부서 코드가 'D9' 또는 'D6'이고 입사일이 1990-01-01 ~ 2000-12-31'이고
-- 급여가 270만 원 이상인 사원의 사번, 이름, 이메일, 부서 코드, 입사일, 급여 조회
-- AND가 OR보다 우선순위가 높음
SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, SALARY FROM EMPLOYEE
WHERE EMAIL LIKE '_____#_%' ESCAPE '#'
AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6')
AND HIRE_DATE BETWEEN '1990-01-01' AND '2020-12-31' AND SALARY >= 2700000;

-- 연산자 우선 순위
/* 
 * 1. 
 * 2. 
 * 3. 비교 연산자 ( > < >= <= = != <>)
 * 4. IS NULL / IS NOT NULL / LIKE / IN / NOT IN
 * 5. BETWEEN AND / NOT BETWEEN AND
 * 6. NOT (논리 연산자)
 * 7. AND
 * 8. OR
*/

/*IN 연산자
 * 비교하려는 값 - 목록에 작성된 값 중 일치하는 것이 있으면 조회하는 연산자
 * [작성법]
 * WHERE 컬럼명 IN(값1, 값2, 값3...) 
 *  == WHERE 컬럼명 = '값1' OR 컬럼명 = '값2';
 */

/*
 * IS NULL / IS NOT NULL
 * IS NULL : NULL인 경우 조회, IS NOT NULL : NULL이 아닌 경우 조회
 * */

-- EMPLOYEE 테이블에서 부서 코드가 D1, D6, D9인 사원의 사번, 이름, 부서 코드 조회하기
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IN ('D1', 'D6', 'D9'); -- 9명
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE NOT IN ('D1', 'D6', 'D9'); -- 12명
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE NOT IN ('D1', 'D6', 'D9') OR DEPT_CODE IS NULL; --14명

-- EMPLOYEE 테이블에서 보너스가 있는 사원의 이름, 보너스 조회
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NULL;

/*
 * ORDER BY 절
 * - SELECT문의 조회 결과(RESULT SET)를 정렬할 때 사용하는 구문
 * **SELECT문 해석 시 가장 마지막에 해석됨**
 * ASC : 오름차순(기본값)
 * DESC : 내림차순
 * */

-- EMPLOYEE 테이블에서 급여 오름차순으로 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY;

-- EMPLOYEE 테이블에서(FROM) 급여가 200만 원 이상인(WHERE) 사원의 사번, 이름, 급여 조회(SELECT)
-- 단, 급여 내림차순(ORDER BY)으로 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 2000000 ORDER BY 3 DESC;

-- 입사일 순서대로 이름, 입사일 조회 (별칭 사용)
SELECT EMP_NAME 이름, HIRE_DATE 입사일 FROM EMPLOYEE ORDER BY 입사일;

-- 정렬 중첩 : 대분류 정렬 후, 소분류 정렬
-- 부서 코드 오름차순 정렬 후 > 급여 내림차순 정렬
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE ORDER BY DEPT_CODE, SALARY DESC;