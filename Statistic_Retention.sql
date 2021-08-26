set serveroutput on

DECLARE
  v_stats_retn  NUMBER;
  v_stats_date  DATE;
BEGIN
  v_stats_retn := DBMS_STATS.GET_STATS_HISTORY_RETENTION;
  DBMS_OUTPUT.PUT_LINE('The retention setting is ' || v_stats_retn || '.');
  v_stats_date := DBMS_STATS.GET_STATS_HISTORY_AVAILABILITY;
  DBMS_OUTPUT.PUT_LINE('The earliest restore date is ' || v_stats_date || '.');
END;
/


Output:

The retention setting is 31.                                                    
The earliest restore date is 09/17/2017 14:05:37.                               

PL/SQL procedure successfully completed.


