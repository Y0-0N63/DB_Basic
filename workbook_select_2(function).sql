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
SELECT STUDENT_NO, STUDENT_NAME FROM TB_STUDENT
WHERE (TRUNC(MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6), 'YYYYMMDD'))/12) > 19);

-- 6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('2020-12-25'), 'DAY') FROM DUAL;

-- 7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD')은 각각 몇 년 몇 월 며칠을 의미할까?
SELECT TO_DATE('99/10/11', 'YY/MM/DD') FROM DUAL; -- 2099-10-11 00:00:00.000
SELECT TO_DATE('49/10/11', 'YY/MM/DD') FROM DUAL; -- 2049-10-11 00:00:00.000
-- 또, TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD')은 각각 몇 년 몇 월 며칠을 의미할까?
SELECT TO_DATE('99/10/11', 'RR/MM/DD') FROM DUAL; -- 1999-10-11 00:00:00.000
SELECT TO_DATE('49/10/11', 'RR/MM/DD') FROM DUAL; -- 2049-10-11 00:00:00.000

-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장 작성
SELECT STUDENT_NO, STUDENT_NAME FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%';

-- 9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 '평점'이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
SELECT STUDENT_NO FROM TB_STUDENT WHERE STUDENT_NO = 'A517178' AND STUDENT_NAME = '한아름';
SELECT ROUND((SUM(POINT) / COUNT(POINT)), 1) 평점 FROM TB_GRADE 
WHERE STUDENT_NO = (SELECT STUDENT_NO FROM TB_STUDENT WHERE STUDENT_NO = 'A517178' AND STUDENT_NAME = '한아름');

-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)"의 형태로 헤더를 만들어 결과값이 출력되도록 하시오
SELECT DEPARTMENT_NO 학과번호, COUNT(DEPARTMENT_NO) "학생수(명)"
FROM TB_STUDENT GROUP BY(DEPARTMENT_NO) ORDER BY DEPARTMENT_NO;

-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL문을 작성하시오
SELECT COUNT(*) FROM TB_STUDENT WHERE COACH_PROFESSOR_NO IS NULL;

-- 12. 학번이 A112113인 김고운 학생의 년도별 평점을 구하는 SQL문 작성
-- 단, 헤더는 '년도', '년도별 평점', 점수는 반올림하여 소수점 이하 한 자리까지만 표시
SELECT * FROM TB_GRADE;
SELECT SUBSTR(TERM_NO, 1, 4) 년도, ROUND(SUM(POINT) / COUNT(TERM_NO), 1) "년도별 평점"
FROM TB_GRADE WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO , 1, 4)
ORDER BY 년도;

-- 13. 학과별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL문 작성
SELECT DEPARTMENT_NO 학과코드명, SUM(DECODE(ABSENCE_YN, 'Y', 1, 'N', 0)) "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 14. 춘 대학교에 다니는 동명이인 학생들의 이름을 찾는 SQL문 작성
SELECT STUDENT_NAME "동일이름", COUNT(*) AS "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME HAVING COUNT(*) > 1
ORDER BY 동일이름;

-- 15. 학번이 A112113인 김고운 학생의 년도, 학기별 평점과 년도별 누적 평점, 총평점을 구하는 SQL문 작성
-- 단, 평점은 소수점 1자리까지만 반올림하여 표시
SELECT * FROM TB_STUDENT;