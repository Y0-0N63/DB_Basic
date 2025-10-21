-- 함수 : 컬럼의 값을 읽어 연산을 한 결과를 반환하는 것
-- 단일행 함수 : N개의 값을 읽어서 연산 후 N개의 결과를 반환
-- 그룹 함수 : N개의 값을 읽어서 연산 후 1개의 결과를 반환 (합계, 평균, 최대, 최소 등)
-- 함수는 SELECT 문의 SELECT절, WHERE 절, ORDER BY절, GORUP BY절, HAVING 절에서 사용 가능

-- 단일행 함수

-- LENGTH(컬럼명|문자열) : 길이 반환
-- EMPLOYEE 테이블에서 모든 사원의 EMAIL, EMAIL의 길이(몇 글자인지) 조회
SELECT EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;

-- INSTR(컬럼명 | 문자열, '찾을 문자열', [, 찾기 시작할 위치], [, 순번])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치 반환

-- 문자열(AABAACAABBAA)을 앞에서부터 검색해 첫 번째 B위치 조회
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 3

-- 문자열을 5번째 문자부터 검색해 처음으로 검색되는 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL; -- 9

--  문자열을 5번째 문자부터 검색해 두 번째로 검색되는 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5, 2) FROM DUAL; -- 10

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@' 위치 조회
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') FROM EMPLOYEE;

-- SUBSTR(컬럼명 | 문자열, 잘라내기 시작할 위치 [, 잘라낼 길이])
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내어 반환 > 잘라낼 길이 생략 시 끝까지 잘라냄

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디만 조회
SELECT EMP_NAME 이름, SUBSTR(EMAIL, 	1, INSTR(EMAIL, '@') - 1) 이메일 FROM EMPLOYEE;

-- TRIM([[옵션] 문자열 | 컬럼명 FROM ] 컬럼명 | 문자열)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자 제거 > 양쪽 공백 제거에 주로 사용
-- [옵션] : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)
SELECT TRIM('         H E L L O         ') FROM DUAL; -- H E L L O
-- '####안녕####'
SELECT TRIM(BOTH '#' FROM '####안녕####') FROM DUAL; -- 안녕
SELECT TRIM(LEADING '#' FROM '####안녕####') FROM DUAL; -- 안녕####
SELECT TRIM(TRAILING '#' FROM '####안녕####') FROM DUAL; -- ####안녕

-- 숫자 관련 함수

-- ABS(숫자 | 컬럼명) : 절대값
SELECT ABS(-10) FROM DUAL; -- 10
SELECT '절대값 같음' FROM DUAL WHERE ABS(10) = ABS(-10);

-- MOD(숫자 | 컬럼명, 숫자 | 컬럼명) : 나머지 값 반환
-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 때 나머지 값 조회
SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 0;

-- ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
-- 소수점 위치 미작성시 소수점 첫 번째 자리에서 반올림
SELECT ROUND(123.456) FROM DUAL; -- 123
-- 소수점 첫 번째 자리까지 표기하기(= 소수점 두 번째 자리에서 반올림)
SELECT ROUND(123.456, 1) FROM DUAL; - -123.5

-- CEIL(숫자 | 컬럼명) : 올림
-- FLOOR(숫자, 컬럼명) : 내림
-- 둘 다 소수점 처째 자리에서 올림, 내림 처리
SELECT CEIL(123.1), FLOOR(123.9) FROM DUAL; -- 124, 123

-- TRUNC(숫자 | 컬럼명 [, 위치]) : 특정 위치 아래를 절삭
SELECT TRUNC(123.456) FROM DUAL; -- 소수점 아래 무조건 절삭, 123
SELECT TRUNC(123.456, 1) FROM DUAL; -- 소수점 첫째 자리 아래를 무조건 절삭, 123.4

-- 날짜 (Date) 관련 함수
-- SYSDATE : 시스템상의 현재 시간(년, 월, 일, 시, 분, 초)을 반환
-- SYSDATE > 를 가상 컬럼이라고도 부름 (실제로 만든 건 아니고 DB에서 만든 것이기 때문!)
SELECT SYSDATE FROM DUAL; -- 2025-10-20 09:14:59.000

-- SYSTIMESTAMP : SYSDATE + MS 단위 추가(UTC 정보)
SELECT SYSTIMESTAMP FROM DUAL; -- 2025-10-20 09:16:13.164 +0900

-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환
SELECT ABS(ROUND(MONTHS_BETWEEN(SYSDATE, '2026-02-27'), 1)) "수강 기간(개월)" FROM DUAL; -- -4.21326836917562724014336917562724014337 > -4.2 > 4.2

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무한 개월수, 근무년차 조회
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무한 개월수",
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "근무 년차" FROM EMPLOYEE -- || : 연결 연산자(문자열 이어쓰기)

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더하기 (음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; -- 2026-02-20 09:30:05.000
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; -- 2025-09-20 09:30:53.000

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함
SELECT LAST_DAY(SYSDATE) FROM DUAL; -- 2025-10-31 09:32:12.000
SELECT LAST_DAY('2020-02-01') FROM DUAL; --2020-02-29 00:00:00.000

-- EXTRACT() : 년, 월, 일 정보를 추출하여 반환
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

-- EMPLOYEE 테이블에서 각 사원의 이름, 입사일 조회(입사년도, 월, 일)
-- 2010년 10월 10일
SELECT HIRE_DATE FROM EMPLOYEE;
SELECT EMP_NAME,
EXTRACT(YEAR FROM HIRE_DATE) || '년' || EXTRACT(MONTH FROM HIRE_DATE) || '월' || EXTRACT(DAY FROM HIRE_DATE) || '일' AS 입사일
FROM EMPLOYEE;

-- 형변환 함수
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE)끼리 형변환 가능
-- 문자열로 변환
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경

-- 숫자 -> 문자 변환 시 포맷 패턴
-- 9 : 숫자 한 칸을 의미, 여러 개 작성 시 오른쪽 정렬
-- 0 : 숫자 한 칸을 의미, 여러 개 작성 시 오른쪽 정렬, 빈칸에 0 추가
-- L : 현재 DB에 설정된 나라의 화폐 기호
SELECT TO_CHAR(1234) FROM DUAL; -- 문자 기호(A-Z), 1234
SELECT 1234 FROM DUAL; -- 숫자 기호(123), 1234
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- ' 1234'
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- '01234'

SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL; -- 1,000,000원
SELECT TO_CHAR(1000000, '9,999,999L') FROM DUAL; -- 1,000,000￦
SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL; -- ￦1,000,000

-- YYYY : 년도 / YY : 년도(짧게)
-- MM : 월, DD : 일, AM or PM : 오전 or 오후, HH : 시간, HH24 : 24시간 표기법
-- MI : 분, SS : 초, DAY : 요일(전체), DY : 요일(요일명만 표시)
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY') FROM DUAL; -- 2025/10/20 10:08:15 월요일
SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL; -- 10/20 (월)
-- SELECT TO_CHAR(SYSDATE, 'YYYY년 MM월 DD일 (DY)') FROM DUAL; -- ORA-01821: 날짜 형식이 부적합합니다 > 쌍따옴표 이용해 단순한 문자로 인식시켜주기
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL; -- 2025년 10월 20일 (월)

-- 날짜로 변환 TO_DATE
-- TO_DATE(문자, [포맷]) : 문자형 -> 날짜
-- TO_DATE(숫자, [포맷]) : 숫자형 -> 날짜
-- 지정된 포맷으로 날짜 인식
SELECT TO_DATE('2025-10-20') FROM DUAL; -- 2025-10-20 00:00:00.000
SELECT TO_DATE(20251020) FROM DUAL; -- 2025-10-20 00:00:00.000

-- 패턴 적용해 작성된 문자열의 각 문자가 어떤 날짜 형식인지 인식시켜야 함!
-- SELECT TO_DATE('251020 101830') FROM DUAL; -- ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
SELECT TO_DATE('251020 101830', 'YYMMDD HH24MISS') FROM DUAL; -- 2025-10-20 10:18:30.000

-- Y 패턴 : 현재 세기 (21세기 == 20XX년도 == 2000년대)
SELECT TO_DATE('800505', 'YYMMDD') FROM DUAL; -- 2080-05-05 00:00:00.000
SELECT TO_DATE('800505', 'RRMMDD') FROM DUAL; -- 1980-05-05 00:00:00.000
SELECT TO_DATE('490505', 'YYMMDD') FROM DUAL; -- 2049-05-05 00:00:00.000
SELECT TO_DATE('490505', 'RRMMDD') FROM DUAL; -- 2049-05-05 00:00:00.000

-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일 조회
-- 사원 이름, 생년월일 (1965년 10월 08일)
-- 1) 주민번호(EMP_NO)에서 > 앞 글자까지 추출 (621231-1985634에서 621231만 추출하기)
SELECT EMP_NAME,
SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1)
AS 생년월일 FROM EMPLOYEE; -- 621231

-- 2) 추출한 생년월일을 TO_DATE 타입으로 변경 > RR 패턴을 이용해 1900년대로 변환하기
SELECT EMP_NAME,
TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1), 'RRMMDD')
AS 생년월일 FROM EMPLOYEE; -- 1962-12-31 00:00:00.000

-- 3) TO_CHAR를 이용하여 문자열로 반환
SELECT EMP_NAME,
TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1), 'RRMMDD'), 'YYYY"년" MM"월" DD"일"')
AS 생년월일 FROM EMPLOYEE; -- 1962년 12월 31일

-- 숫자 형변환
-- TO_NUMBER(문자데이터, [포맷]) : 문자형 데이터를 숫자 데이터로 변경
-- 날짜 데이터 -> 숫자형으로 변환할 시 > TO_CHAR(날짜) 이용하여 문자형으로 변경 후 > TO_NUMBER(문자) 숫자로 변경해야
SELECT '1,000,000' + 500000 FROM DUAL; -- 수치가 부적합합니다 : ','로 인하여 완전한 문자열로 인식하기 때문에
SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL; -- 1500000

-- NULL 처리 함수
-- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값) : NULL인 컬럼 값을 다른 값으로 변경
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * NVL(BONUS, 0) FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값1, 바꿀값2)
-- 해당 컬럼의 값이 있으면 바꿀값1로 변경, NULL이면 바꿀값2로 변경

-- EMPLOYEE 테이블에서 보너스를 받으면 'O', 받지 않으면 'X' 조회
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 수령" FROM EMPLOYEE;

-- 선택 함수
-- 여러가지 경우에 따라 알맞은 결과를 선택할 수 있음
-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ..., 아무것도 일치하지 않을 때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환

-- 직원의 성별 구하기
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성') 성별 FROM EMPLOYEE;

-- 직원 급여 인상하기 : 직급 코드가 J7 > 20%, J6 > 15%, J5 > 10%, 그 외 > 5% 인상하기
-- 이름, 직급 코드, 급여, 인상률, 인상된 급여 조회하기
SELECT EMP_NAME, JOB_CODE, DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') 인상률,
DECODE(JOB_CODE, 'J7', SALARY * 1.2, 'J6', SALARY * 1.15, 'J5', SALARY * 1.1, SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE;

-- CASE 표현식
-- CASE WHEN 조건 THEN 결과값 WHEN 조건식 THEN 결과값 ... ELSE 결과값 END
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값을 반환 > 이때, 조건은 범위 값으로 지정 가능

-- EMPLOYEE 테이블에서 급여가 500만 원 이상이면 > '대', 300만 원 이상 500만 원 미만 > '중', 급여가 300만 원 미만 > '소'
-- 사원 이름, 급여, 급여 받는 정도 조회
SELECT EMP_NAME, SALARY,
CASE WHEN SALARY >= 5000000 THEN '대' WHEN SALARY >= 3000000 THEN '중' ELSE '소' END "급여 받는 정도"
FROM EMPLOYEE;

-- 그룹 함수
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의 1개의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 70,096,240

-- AVG() : 평균
-- 전 직원 급여 평균 조회
SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE; -- 3047662.60869565217391304347826086956522 > 3047663

-- 부서코드가 'D9'인 사원들의 급여 합, 평균 조회
SELECT SUM(SALARY), ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- MIN(컬럼명) : 최소값
-- MAX(컬럼명) : 최대값
-- 타입 제한이 없음 > 숫자 : 대/소, 날짜 : 과거/미래, 문자열 : 문자 순서(A...Z, ㄱ...ㅎ)

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일 조회
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL) FROM EMPLOYEE;

-- 급여 최대값, 가장 늦은 입사일, 알파벳 순서가 가장 늦은 이메일 조회
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL) FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 급여를 가장 많이 받는 사원의 이름, 급여, 직급 코드 조회
-- 서브 쿼리 + 그룹 함수
SELECT EMP_NAME, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

-- COUNT() : 행의 개수를 헤아려서 반환
-- COUNT(컬럼명) : NULL을 제외한 실제값이 기록된 행 개수 반환
-- COUNT(*) : NULL을 포함한 전체 행의 개수 반환
-- COUNT(DISTINCT 컬럼명) : 중복을 제거한 행 개수 반환
SELECT COUNT(*) FROM EMPLOYEE;