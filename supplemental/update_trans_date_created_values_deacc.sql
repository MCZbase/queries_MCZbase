declare
  l_nat trans.nature_of_material%TYPE;
  l_rem trans.trans_remarks%TYPE;
  l_col trans.collection_id%TYPE;
  l_tid trans.transaction_id%TYPE;
  l_time date;
  l_transcreate_date date;
  l_sql mole.temp_transaudit.SQL_TEXT%TYPE; 
  l_count NUMBER;
  
  CURSOR c_deaccessions IS
  select transaction_id, nature_of_material, trans_remarks, collection_id
  from trans
    where transaction_type = 'deaccession'
  ;
  -- and rownum < 100;
  
  r_deaccession c_deaccessions%ROWTYPE;
  
BEGIN
  l_count := 0;
  open c_deaccessions;
  
  loop
    fetch c_deaccessions into r_deaccession;
    exit when c_deaccessions%NOTFOUND;
    l_tid := r_deaccession.transaction_id;
    l_nat := r_deaccession.nature_of_material;
    l_rem := r_deaccession.trans_remarks;
    l_col := r_deaccession.collection_id;
    
    BEGIN 
       select TIMESTAMP, SQL_TEXT 
       into l_time, l_sql
       from mole.temp_transaudit 
       where sql_text like'INSERT %deacc%'
		  and sql_bind like '%' || l_nat || '%):' || l_col ||  ' #3%' || l_rem || '%'
          and object_name = 'TRANS'
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
        -- dbms_output.put_line(l_transcreate_date);
        l_count := l_count + 1;
    END IF;
  END LOOP;
  dbms_output.put_line(l_count);
  
  close c_deaccessions;
end;  
