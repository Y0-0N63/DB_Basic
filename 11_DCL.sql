/* DCL (Data Control Language) : 데이터를 다루기 위한 권한을 다루는 언어
 * - 계정에 DB, DB객체에 대한 접근 권한을 부여(GRANT)하고 회수(REVOKE)하는 언어
 * 
 * * 권한의 종류
 * 1) 시스템 권한 : DB접속, 객체 생성 권한
 * 		CREATE SESSION   : 데이터베이스 접속 권한
 * 		CREATE TABLE     : 테이블 생성 권한
 * 		CREATE VIEW      : 뷰 생성 권한
 *    	CREATE SEQUENCE  : 시퀀스 생성권한
 * 		CREATE PROCEDURE : 함수(프로시져) 생성 권한
 * 		CREATE USER		 : 사용자(계정) 생성 권한
 * 		DROP USER 		 : 사용자(계정) 삭제 권한
 * 
 * 2) 객체 권한 : 특정 객체를 조작할 수 있는 권한
 * 		권한 종류 			설정 객체
 * 		SELECT           TABLE, VIEW, SEQUENCE
 *    	INSERT           TABLE, VIEW
 * 		UPDATE			 TABLE, VIEW
 * 		DELETE			 TABLE, VIEW
 * 		ALTER			 TABLE, SEQUENCE
 * 		REFERENCES 		 TABLE
 * 		INDEX			 TABLE
 * 		EXECUTE			 PROCEDURE */

/* USER - 계정 (사용자)
 * - 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정으로 모든 권한과 책임을 가지는 계정
 * 					ex) sys(최고관리자), system(sys에서 권한 몇개가 제외된 관리자)
 * - 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의	작업을 수행할 수 있는 계정으로 업무에 필요한 최소한의 권한만을 가지는것을 원칙으로 함
 * 					ex) kh, workbook 등 */

-- 1. (sys) 사용자 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -- 이전 버전의 SQL문 작성 방식 허용 (계정명 간단히 작성하기 위해)

-- 새로운 사용자 생성 작성법
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
CREATE USER cby_sample IDENTIFIED BY sample1234;

-- 2. 새 연결(접속) 추가
-- ORA-01045: 사용자 CBY_SAMPLE는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다
--> 접속 권한이 없으므로 부여해야 함

-- 3. 접속 권한 부여 (sys -> 사용자 계정)
-- [권한 부여 작성법]
-- GRANT 권한, 권한, ... TO 사용자명;
GRANT CREATE SESSION TO cby_sample;

-- 4. 다시 연결(접속) 시도 > 성공!

-- 5. (sample) 테이블 생성
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(30)
);
-- ORA-01031: 권한이 불충분합니다
-- CREATE TABLE : 테이블 생성 권한이 있어야 함 + 데이터를 저장할 수 있는 공간(TABLESPACE)도 할당해야 > sys가

-- 6. (sys) 테이블 생성 권한 부여 + TABLESPACE 할당
GRANT CREATE TABLE TO cby_sample;
ALTER USER cby_sample DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
-- SYSTEM 테이블 스페이스를 사용자 cby_sample의 저장소로 무제한 사용 가능하게끔 하는 명령

-- 7. (sample)
CREATE TABLE TB_TEST(
	PK_COL NUMBER PRIMARY KEY,
	CONTENT VARCHAR2(30)
); -- 테이블 생성 성공

SELECT * FROM TB_TEST;

-- ROLE(역할) : 권한 묶음 > 묶어둔 권한을 특정 계정에 부여 > 해당 계정은 지정된 권한을 이용해 특정 역할을 갖게 됨
-- (sys) sample 계정에 CONNECT, RESOURCE ROLE 부여	
GRANT CONNECT, RESOURCE TO cby_sample;
-- CONNECT : DB 접속 관련 권한을 묶어돈 ROLE
-- RESOURCE : DB 사용을 위한 기본 객체 생성 권한을 묶어둔 ROLE

-- CONNECT 롤이 포함하고 있는 권한
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'CONNECT';
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE = 'RESOURCE';

-- 객체 권한
-- kh/sample 사용자 계정끼리 서로 객체에 접근할 수 있게 권한 부여하기
-- 1. (sample) kh 계정의 EMPLOYEE 테이블 조회하기
SELECT * FROM EMPLOYEE; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
SELECT * FROM kh_cby.EMPLOYEE; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--> sample 계정은 kh계정의 테이블 접근 권한이 없어서 조회 불가

-- 2. (kh) sample 계정에 EMPLOYEE 테이블 조회 권한 부여
-- [객체 권한 부여 방법]
-- GRANT 객체권한 ON 객체명 TO 사용자명;
GRANT SELECT ON EMPLOYEE TO cby_sample;

-- 3. (sample) 다시 kh 계정의 EMPLOYEE 조회
SELECT * FROM kh_cby.EMPLOYEE; --> 조회 성공

-- 4. (kh) sample 계정에 부여했던 EMPLOYEE 테이블 조회 권한 회수 (REVOKE)
REVOKE SELECT ON EMPLOYEE FROM cby_sample;
SELECT * FROM kh_cby.EMPLOYEE; -- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다 (조회 불가능=권한 회수 완료)
