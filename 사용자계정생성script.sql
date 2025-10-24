-- 선택한 SQL 수행 : 구문에 커서 둔 후 > Ctrl + Enter
-- 전체 SQL 수행 : Alt + x

-- 11G 이전 문법 사용 허용
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 새로운 사용자 계정 생성 (USERNAME/Password)
CREATE USER kh_shop IDENTIFIED BY kh_shop;
-- SQL Error [65096] [99999]: ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다. > 11G 이전 문법 사용해주기
-- SQL Error [1920] [42000]: ORA-01920: 사용자명 'KH_CBY'(이)가 다른 사용자나 롤 이름과 상충됩니다

-- 사용자 계정에 권한 부여
GRANT RESOURCE, CONNECT TO kh_shop;

-- 객체가 생성될 수 있는 공간 할당량 무제한 지정
ALTER USER kh_shop DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;