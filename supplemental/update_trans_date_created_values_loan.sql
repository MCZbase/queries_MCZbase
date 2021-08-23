declare
  l_num loan.loan_number%TYPE;
  l_tid loan.transaction_id%TYPE;
  l_time date;
  l_transcreate_date date;
  l_sql mole.temp_transaudit.SQL_TEXT%TYPE; 
  l_count NUMBER;
  
  CURSOR c_loans IS
  select transaction_id, loan_number
  from loan
  ;
  -- where rownum < 100;
  
  r_loan c_loans%ROWTYPE;
  
BEGIN
  l_count := 0;
  open c_loans;
  
  loop
    fetch c_loans into r_loan;
    exit when c_loans%NOTFOUND;
    l_tid := r_loan.transaction_id;
    l_num := r_loan.loan_number;
    
    BEGIN 
       select TIMESTAMP, SQL_TEXT 
       into l_time, l_sql
       from mole.temp_transaudit 
       where sql_text like'INSERT %'  || l_num || '%' 
          and object_name = 'LOAN'
          and rownum < 2;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          l_time := null;
          l_sql := null;
    END;

    IF l_time is not null THEN 
        -- dbms_output.put_line(l_tid || ' ' || l_num || ' ' || l_time || ' ' || l_sql );
        -- select date_entered into l_transcreate_date from trans where transaction_id = l_tid;
        update trans set date_entered = l_time where transaction_id = l_tid;
        --  dbms_output.put_line(l_transcreate_date);
        l_count := l_count + 1;
    END IF;
  END LOOP;
  dbms_output.put_line(l_count);
  
  close c_loans;
end;  
