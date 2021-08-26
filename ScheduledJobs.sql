set linesize 250
set pagesize 500
col log_user       for a15
col job            for 9999999  head 'Job'
col broken         for a1       head 'B'
col failures       for 99       head "fail"
col last_date      for a28      head 'Last Date'
col this_date      for a18      head 'This Date'
col next_date      for a28      head 'Next Date'
col interval       for 9999999.000 head 'Run Interval'
col what           for a90

select j.log_user,
     j.job,
     j.broken,
     j.failures,
     j.last_date||':'||j.last_sec last_date,
     --j.this_date||':'||j.this_sec this_date,
     j.next_date||':'||j.next_sec next_date,
     j.next_date - j.last_date interval,
     j.what
from (select dj.LOG_USER, dj.JOB, dj.BROKEN, dj.FAILURES, 
             dj.LAST_DATE, dj.LAST_SEC, dj.THIS_DATE, dj.THIS_SEC, 
             dj.NEXT_DATE, dj.NEXT_SEC, dj.INTERVAL, dj.WHAT
        from dba_jobs dj) j;