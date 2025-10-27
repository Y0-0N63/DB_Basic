/* [JOIN 용어 정리]
  오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                             왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

-- JOIN : 하나 이상의 테이블에서 데이터를 조회하기 위해 사용 > 수행 결과는 하나의 Result Set으로 나옴.

- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.
- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어 원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데, 두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  */

-- 사번, 이름, 부서 코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE FROM EMPLOYEE; -- "DEPT_NAME": 부적합한 식별자
-- 부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT DEPT_TITLE FROM DEPARTMENT;

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 23행이 아닌 21행만이 출력되는 이유 : DEPT_CODE가 NULL인 두 직원에게 연결할 수 있는 DEPT_ID가 존재하지 않기 때문

-- ORACLE 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 1. 내부 조인(INNER JOIN, 등가 조인(EQUAL JOIN)
-- : 연결되는 컬럼의 값이 일치하는 행들만 조인되므로 일치하는 값이 없는 행은 조인에서 제외됨
-- ORACLE 구문 / ANSI 구문(USING, ON)
-- 	1-1) 연결에 사용할 두 컬럼명이 다른 경우
-- 1-1-1) ANSI 구문 : ON 사용
-- DEPARTMENT 테이블, LOCATION 테이블 참조 > 부서명, 지역명 조회
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 1-1-2) ORACLE 구문
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 1-2) 연결에 사용할 두 컬럼명이 같은 경우 : USING 사용
-- 1-2-1) ANSI 구문
SELECT * FROM EMPLOYEE; -- JOB_CODE
SELECT * FROM JOB; -- JOB_CODE

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);	

-- 1-2-2) ORACLE 구문
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
-- WHERE JOB_CODE = JOB_CODE; -- ORA-00918: 열의 정의가 애매합니다 (누구의 컬럼인지 파악하기가 어렵다) > 테이블에 별칭을 줌
WHERE E.JOB_CODE = J.JOB_CODE;

-- 2. 외부 조인 : 두 테이블이 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함시킴
-- *반드시 OUTER JOIN을 명시해야 함 (내부 조인 > 필수는 아님)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2-1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 컬럼수를 기준으로 JOIN
-- > 왼편에 작성된 테이블의 모든 행이 결과에 포함되어야 함 (JOIN이 안되는 행도 결과에 포함된다)

-- 2-1-1) ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT OUTER JOIN DEPARTMENT -- EMPLOYEE(LEFT) 테이블을 기준으로 모든 행을 가지고 와야
ON(DEPT_CODE = DEPT_ID);
-- DEPT_TITLE이 NULL이어서 제외되었던 두 행도 출력됨

SELECT EMP_NAME, DEPT_TITLE
FROM DEPARTMENT LEFT OUTER JOIN EMPLOYEE -- DEPARTMENT에 있지만 사용된 적 없는 세 행이 NULL 값과 함께 출력되며 24행 출력
ON(DEPT_CODE = DEPT_ID);

-- 2-1-2) ORACLE 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); -- 반대쪽 테이블 컬럼에 (+) 기호 작성해야 함

-- 2-2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 컬럼수를 기준으로 JOIN
-- 2-2-1) ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT OUTER JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);

-- 2-2-2) ORACLE 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 2-3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- **ORACLE 구문은 FULL OUTER JOIN 사용 불가능**

-- 2-3-1) ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);

-- 2-3-2) ORACLE 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+); -- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다

-- 3. 교차 조인(CROSS JOIN, CARTESIAN PRODUCT(ORACLE))
-- : 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법 (곱집합)
-- > JOIN 구문을 잘못 작성하는 경우 : CROSS JOIN의 결과가 조회될 수 있음
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

-- 4. 비등가 조인 (NON EQUAL JOIN) : '='를 사용하지 않고 범위를 사용하는 JOIN문
-- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식
SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE;

-- 사원의 급여에 따라 급여 등급 파악하기
SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SALARY, SG.SAL_LEVEL
FROM EMPLOYEE 
JOIN SAL_GRADE SG
ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- 5. 자체 조인(SELF JOIN) : 같은 테이블의 조인(자기 자신과 조인을 맺음)
-- 같은 테이블이 2개 있다고 생각하고 JOIN 작성하기
-- 테이블마다 별칭 작성(미작성 시 열의 정의가 애매해다<라는 오류 발생 가능)

-- 사번, 이름, 사수의 사번, 사수의 이름 조회 > 단, 사수가 없으면 '없음', '-' 조회
-- 5-1) ANSI 표준
SELECT E1.EMP_ID 사번, E1.EMP_NAME 사원이름, NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);

-- 5-2) ORACLE 구문
SELECT E1.EMP_ID 사번, E1.EMP_NAME 사원이름, NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
SELECT JOB_CODE FROM EMPLOYEE;
SELECT JOB_CODE FROM JOB;

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
--JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB;

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
--> 잘못 조인하면 CROSS JOIN 결과가 조회됨

-- 7. 다중 조인 : N개의 테이블을 조인할 때 사용 (순서가 중요)
-- 사원 이름(EMP_NAME, EMPLOYEE), 부서명(DEPT_TITLE, DEPARTMENT), 지역명(LOCAL_NAME, LOCATION) 조회
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- ORACLE
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

-- 다중 조인 연습 문제
-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
--> 사번(EMP_ID, E), 이름(EMP_NAME, E), 직급명(JOB_CODE(E, J), JOB_NAME(J) , 부서(DEPT_CODE(E)>DEPT_TITLE(D))
-- 근무지역명(LOCATION_ID(D)>LOCAL_NAME(L), 급여(SALARY, E)
-- ANSI
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, DEPT_TITLE 부서, LOCAL_NAME 근무지역명, SALARY 급여
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';

-- ORACLE
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, DEPT_TITLE 부서, LOCAL_NAME 근무지역명, SALARY 급여
FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
WHERE E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';

-- JOIN 연습 문제
-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
-- 사원명, 주민번호, 부서명(DEPT_CODE(E) > DEPT_TITLE(D)), 직급명(JOB_CODE(E) > JOB_NAME(J))을 조회하시오.
SELECT EMP_NAME 사원명, EMP_NO 주민번호, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EMP_NO LIKE '7%'
AND SUBSTR(EMP_NO, 8, 1) = '2'
AND EMP_NAME LIKE '전%';

-- 2. 이름에 '형'자가 들어가는 직원들의 사번(EMP_ID), 사원명(EMP_NAME), 직급명(JOB_CODE(E) > JOB_NAME(J)), 부서명(DEPT_CODE(E) > DEPT_TITLE(D))을 조회하시오.
SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE '%형%';

-- 3. 해외영업 1부, 2부(DEPT ID = D5, D6)에 근무하는 사원의
-- 사원명(EMP_NAME), 직급명(JOB_CODE(E) > JOB_NAME(J)), 부서코드(DEPT_CODE), 부서명(DEPT_CODE(E) > DEPT_TITLE(D))을 조회하시오.
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_CODE 부서코드, DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');

-- 4. 보너스포인트를 받는 직원들의 
-- 사원명(EMP_NAME), 보너스포인트(BONUS), 부서명(DEPT_CODE(E) > DEPT_TITLE(D)), 근무지역명(LOCATION_ID(D) > LOCAL_NAME(L))을 조회하시오.
SELECT EMP_NAME 사원명, BONUS * 100 || '%' 보너스포인트, DEPT_TITLE 부서명, LOCAL_NAME 근무지역명
FROM EMPLOYEE
--JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
--JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE) -- 보너스 포인트가 있어도, 부서명이 없는 직원이 출력되지 않음
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 5. 부서가 있는 사원의 사원명(EMP_NAME), 직급명(JOB_CODE(E) > JOB_NAME(J)), 부서명(DEPT_CODE(E) > DEPT_TITLE(D)), 지역명(LOCATION_ID(D) > LOCAL_NAME(L)) 조회 
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--WHERE DEPT_TITLE IS NOT NULL; -- INNER JOIN을 사용하면 자동으로 부서가 있는 사원만 출력됨! (WHERE절로 작성할 필요가 없음)

-- 6. 급여등급(SAL_LEVEL(E > S)별 최소급여(MIN_SAL(S))를 초과해서 받는 직원들의
-- 사원명(EMP_NAME), 직급명(JOB_CODE(E) > JOB_NAME(J)), 급여(SALARY), 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
SELECT EMP_NAME, JOB_NAME, SALARY, -- JOB_CODE, *작성해야 NATURAL JOIN 사용 가능
--CASE WHEN BONUS IS NOT NULL THEN ((SALARY * (1 + BONUS)) * 12)
--ELSE (SALARY * 12) END "연봉(보너스 포함)"
SALARY * (1 + NVL(BONUS, 0)) * 12 연봉
FROM EMPLOYEE
JOIN SAL_GRADE USING(SAL_LEVEL)
JOIN JOB USING (JOB_CODE)
--NATURAL JOIN JOB 으로 작성 시 > 20행이 아닌 140행이 출력됨
-- NATURAL JOIN을 다중조인에서 사용할 때 : SELECT 절에 NATURAL JOIN에서 사용되었을 연결고리 컬럼을 반드시 작성해야 함!
-- EMPLOYEE - JOB JOIN할 때 JOB_CODE가 연결고리 컬럼이 됨*
WHERE SALARY > MIN_SAL;

-- 7. 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명(EMP_NAME), 부서명(DEPT_CODE(E) > DEPT_TITLE(D)), 지역명(LOCATION_ID(D) > LOCAL_NAME(L)), 국가명(NATIONAL_CODE(L)을 조회하시오.
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_CODE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_CODE IN ('KO', 'JP');

-- 8. 같은 부서에 근무하는 직원들의 사원명(EMP_NAME), 부서코드(DEPT_CODE), 동료이름(EMP_NAME)을 조회하시오.(SELF JOIN 사용)
SELECT E1.EMP_NAME 사원명, E1.DEPT_CODE 부서코드, E2.EMP_NAME 동료이름
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON (E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY 사원명;

-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 
-- 사원명(EMP_NAME), 직급명(JOB_ODE(E) > JOB_NAME(J)), 급여(SALARY)를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4', 'J7');
