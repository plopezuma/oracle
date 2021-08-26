BEGIN
  FOR x IN (SELECT * FROM dba_jobs WHERE SCHEMA_USER in (Select distinct (log_user) from dba_jobs) AND BROKEN='Y')
  LOOP
    dbms_ijob.broken( x.job, false);
    --dbms_ijob.broken( x.job, false, SYSDATE + interval '1' minute);
  END LOOP;
END;