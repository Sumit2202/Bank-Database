CREATE TABLE TRANSACTION
(
transID varchar2(10),
transDate date,
transType char(1),
transAmount decimal(10,2),
accountID varchar2(10),
CONSTRAINT transaction_transID_PK PRIMARY KEY(transID),
CONSTRAINT transaction_transType_CK CHECK (transType IN ('D','w')),
CONSTRAINT transaction_accountID_FK FOREIGN KEY(accountID) REFERENCES ACCOUNT(accountID)
);  

INSERT INTO TRANSACTION VALUES(1111111111, TO_DATE('2017-01-16','YYYY-MM-DD'), 'D',345.23,9988776655);
INSERT INTO TRANSACTION VALUES(2222222222, TO_DATE('2015-02-21','YYYY-MM-DD'), 'w',123.44,8877665544);
INSERT INTO TRANSACTION VALUES(3333333333, TO_DATE('2018-05-08','YYYY-MM-DD'), 'w',222.11,7766554433);
INSERT INTO TRANSACTION VALUES(4444444444, TO_DATE('2018-11-17','YYYY-MM-DD'), 'D',233.22,6655443322);
INSERT INTO TRANSACTION VALUES(5555555555, TO_DATE('2017-09-29','YYYY-MM-DD'), 'w',98.00,5544332211);

CREATE TABLE CUSTOMER
(
custId varchar2(10),
fullName varchar2(25) NOT NULL,
billAddress varchar2(50) NOT NULL,
phone number(10),
CONSTRAINT customer_custID_PK PRIMARY KEY(custID),
CONSTRAINT customer_phone_CK CHECK (phone > 999999999 and phone < 10000000000)
);
INSERT INTO CUSTOMER VALUES(1212121212,'JIMMY WHITE','12 JAKE STREET',8745666442);
INSERT INTO CUSTOMER VALUES(1313131313,'BILL ROY','34 SHILL AVENUE',8537889535);
INSERT INTO CUSTOMER VALUES(1414141414,'JAMES WELL','85 DRAIN CIRCUIT',9535873063);
INSERT INTO CUSTOMER VALUES(1515151515,'NAVED SHAIKH','33 MILNER AVENUE',5788325906);
INSERT INTO CUSTOMER VALUES(1616161616,'BABBU MAAN','82 PANDORA CIRCLE',4729660021);


CREATE TABLE ACCOUNT
(
accountID varchar2(10),
creditLimit decimal(10,2) NOT NULL,
dateOpened DATE,
custID varchar2(10),
branchID varchar2(10),
CONSTRAINT account_accountID_PK PRIMARY KEY(accountID),
CONSTRAINT account_custID_FK FOREIGN KEY(custID) REFERENCES CUSTOMER(custID),
CONSTRAINT account_branchID_FK FOREIGN KEY(branchID) REFERENCES BRANCH(branchID)
);
INSERT INTO ACCOUNT VALUES(9988776655, 2000.00, TO_DATE('2016-01-15','YYYY-MM-DD'),1212121212,1122334455);
INSERT INTO ACCOUNT VALUES(8877665544, 2500.00, TO_DATE('2017-08-30','YYYY-MM-DD'),1313131313,2233445566);
INSERT INTO ACCOUNT VALUES(7766554433, 1500.00, TO_DATE('2016-02-27','YYYY-MM-DD'),1414141414,3344556677);
INSERT INTO ACCOUNT VALUES(6655443322, 1500.00, TO_DATE('2014-06-06','YYYY-MM-DD'),1515151515,4455667788);
INSERT INTO ACCOUNT VALUES(5544332211, 2000.00, TO_DATE('2018-03-22','YYYY-MM-DD'),1616161616,5566778899);


CREATE TABLE BRANCH
(
branchID varchar2(10),
managerName varchar2(20) NOT NULL,
location varchar2(15) NOT NULL,
phone number(10),
CONSTRAINT branch_branchID_PK PRIMARY KEY(branchID),
CONSTRAINT branch_phone_CK CHECK (phone > 999999999 and phone < 10000000000)
);

INSERT INTO BRANCH VALUES(1122334455,'RAMESH SHARMA','SCARBOROUGH',4564356732);
INSERT INTO BRANCH VALUES(2233445566,'M.R. ARORA','MARKHAM',4565456433);
INSERT INTO BRANCH VALUES(3344556677,'W.W. SALT','OAKVILLE',6765435665);
INSERT INTO BRANCH VALUES(4455667788,'SURESH SINGH','BRAMPTON',4675342567);
INSERT INTO BRANCH VALUES(5566778899,'RAMU SHARMA','TORONTO',4564689975);
select * from branch;

CREATE TABLE SAVINGSACCOUNT
(
accountID varchar2(10),
balance decimal(10,2),
interestRate decimal(10,2) default '5.5',
CONSTRAINT savingsAccount_accountID_PK PRIMARY KEY(accountID),
CONSTRAINT savingsAccount_accountID_FK FOREIGN KEY(accountID) REFERENCES ACCOUNT(accountID)
);
INSERT INTO SAVINGSACCOUNT VALUES(9988776655,2354.56,4.6);
INSERT INTO SAVINGSACCOUNT VALUES(8877665544,5325.33,5.5);
INSERT INTO SAVINGSACCOUNT VALUES(7766554433,654.21,5.5);
INSERT INTO SAVINGSACCOUNT VALUES(6655443322,23553.67,5.9);
INSERT INTO SAVINGSACCOUNT VALUES(5544332211,856.40,6.4);

CREATE TABLE CHEQUINGACCOUNT
(
accountID varchar2(10),
balance decimal(10,2),
CONSTRAINT chequingAccount_accountID_PK PRIMARY KEY(accountID),
CONSTRAINT chequingAccount_accountID_FK FOREIGN KEY(accountID) REFERENCES ACCOUNT(accountID)
);
INSERT INTO CHEQUINGACCOUNT VALUES(9988776655,2354.56);
INSERT INTO CHEQUINGACCOUNT VALUES(8877665544,5325.33);
INSERT INTO CHEQUINGACCOUNT VALUES(7766554433,654.21);
INSERT INTO CHEQUINGACCOUNT VALUES(6655443322,23553.67);
INSERT INTO CHEQUINGACCOUNT VALUES(5544332211,856.40);

COMMIT;

comm
desc account;

COMMIT;

SELECT * FROM branch;

select fullname,balance from customer 
join account using(custid) join chequingAccount using(accountid) where balance>2000;

select fullname,balance from customer
join account using(custid) join savingsAccount using(accountid) where balance>2000;

select fullname,transid,transAmount from  customer 
join account using(custid) join transaction using (accountid);

select fullname,managername,location from customer
join account using(custid) join branch using (branchid);

select transid,transamount,transtype,dateOpened,location from transaction
join account using (accountid) join branch using(branchid); 

select transid,transamount,transtype,dateOpened,balance,interestrate from transaction 
join account using(accountid) join savingsaccount using (accountid); 







select max(balance) as MAX, round(avg(balance),2) as average, min(balance) as MIN from savingsaccount;


select accountid,avg(balance) as average
from customer join account using(custid) join savingsAccount using (accountid) group by accountid;
SELECT COUNT(ACCOUNTID),BALANCE FROM SAVINGSACCOUNT GROUP BY BALANCE;

SELECT AVG(BALANCE), min(balance), max(balance), BRANCHID
FROM savingsaccount join account using(accountid) join branch using(branchid) group by branchid;



select fullname from customer where regexp_like(billAddress, '12(*)');

select fullname,billAddress from customer
where custid>(select custid from customer where custid=1515151515);


select accountid,min(balance) 
from chequingaccount group by accountid having min(balance)>2500;

select balance,customer.fullname from savingsaccount 
join account using(accountid) join customer using(custid)
group by customer.fullname having (balance>2500) ;

select
  regexp_replace('82 PANDORA CIRCLE','PANDORA CIRCLE',
                 'HELLO STREET') as "new address"
from customer where billAddress = '82 PANDORA CIRCLE';


SELECT FULLNAME ,custid,SAVINGSACCOUNT.BALANCE
FROM customer JOIN ACCOUNT USING(CUSTID) JOIN SAVINGSACCOUNT USING(ACCOUNTID) 
WHERE (BALANCE) < ANY  (SELECT BALANCE FROM SAVINGSACCOUNT where BALANCE>2500);

select * from customer;


