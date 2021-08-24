declare
  l_num accn.accn_number%TYPE;
  l_tid accn.transaction_id%TYPE;
  l_time date;
  l_transcreate_date date;
  l_sql mole.temp_transaudit.SQL_TEXT%TYPE; 
  l_count NUMBER;
  
  CURSOR c_accns IS
  select accn.transaction_id, accn_number
  from accn
  where accn.transaction_id in (select transaction_id from trans where trans_date is not null and transaction_type = 'accn')
  ;
  -- where rownum < 100;
  
  r_accn c_accns%ROWTYPE;
  
BEGIN
  l_count := 0;
  open c_accns;
  
  loop
    fetch c_accns into r_accn;
    exit when c_accns%NOTFOUND;
    l_tid := r_accn.transaction_id;
    l_num := r_accn.accn_number;
    
    BEGIN 
       select TIMESTAMP, SQL_TEXT 
       into l_time, l_sql
       from mole.temp_transaudit 
       where sql_text like'INSERT %'  || l_num || '%' 
          and object_name = 'ACCN'
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
  
  close c_accns;
end;  
