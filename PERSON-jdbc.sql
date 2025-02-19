-- PERSON

CREATE SEQUENCE SEQ_PERSON;

CREATE TABLE PERSON(
	PID NUMBER PRIMARY KEY,
	PNAME VARCHAR2(200),
	PAGE NUMBER(3)
);

INSERT INTO PERSON VALUES(SEQ_PERSON.NEXTVAL, '홍길동', 30);
INSERT INTO PERSON VALUES(SEQ_PERSON.NEXTVAL, '강감찬', 20);
COMMIT;

SELECT * FROM PERSON;

-- PROCEDURE
CREATE OR REPLACE PROCEDURE CHANGENAME(P_PID NUMBER, P_NAME IN OUT VARCHAR2)
AS
BEGIN 
	UPDATE PERSON SET PNAME=P_NAME WHERE PID=P_PID;
END;

CREATE OR REPLACE FUNCTION GETNAME(P_PID NUMBER)
RETURN VARCHAR2
AS
	V_PNAME VARCHAR2(50);
BEGIN 
	SELECT PNAME INTO V_PNAME
	FROM PERSON WHERE PID=P_PID;
	RETURN V_PNAME;
END;










