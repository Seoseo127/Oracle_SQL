/* ******** CURSOR(커서) **************
데이터베이스 커서(Cursor)는 일련의 데이터에 순차적으로 액세스할 때 
검색 및 "현재 위치"를 포함하는 데이터 요소

묵시적커서 : SELECT, INSERT, UPDATE, DELETE 문장이 실행될 때
     DBMS가 CURSOR(커서)의 Open, Fetch, Close 자동 처리
명시적커서 : 프로그램내에서 명시적으로 커서(CURSOR)를 선언한 경우

<커서(CURSOR) 사용 절차>
1. 선언(CURSOR 커서명 IS SELECT문)
2. 커서오픈(OPEN 커서명)
3. 데이타추출(FETCH 커서명 INTO)
4. 커서닫기(CLOSE 커서명)
------------------------------------------
- SQL%ROWCOUNT : 행의 수
- SQL%FOUND : 1개 이상일 경우 (결과값이 있으면 true)
- SQL%NOTFOUND : 결과값이 하나도 없을때 true
- SQL%ISOPEN : 항상 false, 암시적 커서가 열려 있으면 true
**************************************/
create or replace PROCEDURE DISP_ORDERS
AS
    --1. 선언(CURSOR 커서명 IS SELECT문)
    CURSOR C_ORDERS IS 
    SELECT O.ORDERID, C.NAME, B.BOOKNAME
         , O.SALEPRICE, O.ORDERDATE
    FROM ORDERS O
         INNER JOIN BOOK B
         ON O.BOOKID = B.BOOKID
         INNER JOIN CUSTOMER C
         ON O.CUSTID = C.CUSTID
    ORDER BY O.ORDERID;  
    
    --사용할 변수 선언
    V_ORDERID ORDERS.ORDERID%TYPE;
    V_NAME CUSTOMER.NAME%TYPE;
    V_BOOKNAME BOOK.BOOKNAME%TYPE;
    V_SALEPRICE ORDERS.SALEPRICE%TYPE;
    V_ORDERDATE ORDERS.ORDERDATE%TYPE;
BEGIN
    --2. 커서오픈(OPEN 커서명)
    OPEN C_ORDERS;
    
    LOOP
        --3. 데이타추출(FETCH 커서명 INTO)
        FETCH C_ORDERS 
        INTO V_ORDERID, V_NAME, V_BOOKNAME, V_SALEPRICE, V_ORDERDATE;
        
        IF (C_ORDERS%FOUND) THEN
            DBMS_OUTPUT.PUT_LINE('::데이터 있음');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('::데이터 없음---------');
        END IF;
        
        EXIT WHEN C_ORDERS%NOTFOUND; --커서에 데이터가 없으면 반복 종료
        
        --커서에서 가져온 데이터 화면 출력
        DBMS_OUTPUT.PUT_LINE(V_ORDERID ||','|| V_NAME ||','|| V_BOOKNAME ||','|| 
                V_SALEPRICE ||','|| V_ORDERDATE);
    END LOOP;
    
    --4. 커서닫기(CLOSE 커서명)
    CLOSE C_ORDERS;
    
    --==============================
    DBMS_OUTPUT.PUT_LINE('===== FOR문 사용 자동처리 ========');
    --FOR ~ IN 커서명 LOOP ~ END LOOP;
    FOR ORD IN C_ORDERS LOOP
        DBMS_OUTPUT.PUT_LINE(ORD.ORDERID ||','|| ORD.NAME ||','|| ORD.BOOKNAME ||','|| 
                ORD.SALEPRICE ||','|| ORD.ORDERDATE);
    END LOOP;
END;










