--def days_history="&1"
--def interval_hours="&2"
--def sort_col_nr="&3"
--def top_n="&4"

set linesize 200
def days_history='2';
def interval_hours='1';
def sort_col_nr='4';
def top_n='10';

select * from (
select hss.sql_id, 
    decode(count(unique(plan_hash_value)), 1, max(plan_hash_value), count(unique(plan_hash_value))) diff_plans,
    decode(count(unique(force_matching_signature)),1,max(force_matching_signature), count(unique(force_matching_signature))) fms,
    sum(hss.executions_delta) executions,
    round(sum(hss.elapsed_time_delta)/1000000, 3) elapsed_time_s,
    round(sum(hss.cpu_time_delta)/1000000, 3) cpu_time_s,
    round(sum(hss.iowait_delta)/1000000, 3) iowait_s,
    round(sum(hss.clwait_delta)/1000000, 3) clwait_s,
    round(sum(hss.apwait_delta)/1000000, 3) apwait_s,
    round(sum(hss.ccwait_delta)/1000000, 3) ccwait_s,
    round(sum(hss.rows_processed_delta), 3) rows_processed,
    round(sum(hss.buffer_gets_delta), 3) buffer_gets,
    round(sum(hss.disk_reads_delta), 3) disk_reads,
    round(sum(hss.direct_writes_delta), 3) direct_writes
from dba_hist_sqlstat hss, dba_hist_snapshot hs
where hss.snap_id=hs.snap_id
    and hs.begin_interval_time >= trunc(sysdate)-&days_history+1
    and hs.begin_interval_time <= trunc(sysdate)-&days_history+1+(&interval_hours/24)
group by sql_id
order by &sort_col_nr desc nulls last
)
where rownum<=&top_n;