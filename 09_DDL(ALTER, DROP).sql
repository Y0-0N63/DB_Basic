-- DDL(Data Definition Language) : 데이터 정의 언어
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

-- ALTER를 통해 테이블에서 수정할 수 있는 것
-- 1) 제약 조건(추가, 삭제) : 제약조건 자체를 수정하는 구문은 별도로 존재하지 않음 > 삭제 후 추가해야 함
-- 2) 컬럼(추가/수정/삭제) :
-- 3) 이름 변경 (테이블명, 컬럼명, 제약조건명)

-- 1) 제약조건(추가/삭제)
-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
--			ADD [CONSTRAINT 제약조건명] 제약조건
--			[REFERENCES 테이블명[(컬럼명)]]; <- FK인 경우에 추가

-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- DEPARTMENT 테이블 복사하기 (컬럼명, 데이터타입, NOT NULL만 복사)
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 설정된 UNQIUE 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- ***DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제***
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
-- ORA-00904: : 부적합한 식별자
--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아니라, 컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식
--> MODIFY 구문을 사용해 NULL 제어해야

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL; -- DEPT_TITLE 컬럼에 NULL 비허용
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL; -- DEPT_TITLE 컬럼에 NULL 허용