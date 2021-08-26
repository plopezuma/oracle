BEGIN
  FOR x IN (SELECT * FROM dba_jobs)
  LOOP
    dbms_ijob.broken( x.job, true );
  END LOOP;
END;

--alter system set job_queue_processes=0 scope=both;