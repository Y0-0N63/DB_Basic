-- [Additional SELECT - 함수]

-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL 문장
-- 헤더는 "학번", "이름", "입학년도"가 표시되도록
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002' -- 영어영문학과
ORDER BY ENTRANCE_DATE -- 입학 년도가 빠른 순;

-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
-- 단, 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오.
-- 단, 교수 중 2000년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 함, 나이는 '만' 계산
SELECT PROFESSOR_NAME 교수이름,
TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1, 6), 'YYYYMMDD'))/12) 나이 -- 만나이 계산
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1' -- 남자만
ORDER BY 나이; -- 나이가 적은 순으로 출력

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장 작성
-- 출력 헤더는 '이름', 성이 두 자인 경우는 없다고 가정
SELECT SUBSTR(PROFESSOR_NAME, 2, 2) FROM TB_PROFESSOR;

-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 이때, 19살에 입학하면 재수하지 않은 것으로 간주
SELECT * FROM TB_STUDENT;
SELECT STUDENT_NO, STUDENT_NAME FROM TB_STUDENT
WHERE 
(TRUNC(MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6), 'YYYYMMDD'))/12) <> 19)
