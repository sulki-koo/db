CREATE TABLE TODO(
	TDNO NUMBER PRIMARY KEY,-- 연번
	TDDATE TIMESTAMP,  -- 작성일시
	TDWRITER VARCHAR2(200), -- 작성자
	TDCOUNTENT VARCHAR2(4000), -- 내용
	TDYN CHAR(1) -- 완료여부
);

CREATE SEQUENCE TODO_SEQ;

INSERT INTO TODO VALUES(TODO_SEQ.NEXTVAL, SYSDATE, '홍길동', '바벨2000회', 'N');
INSERT INTO TODO VALUES(TODO_SEQ.NEXTVAL, SYSDATE, '강감찬', '노젓기3000회', 'N');
COMMIT;
SELECT * FROM TODO;







