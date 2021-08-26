SET SERVEROUTPUT ON
SET LINES 100
DECLARE
    v_rl_size_MB number DEFAULT 1024;  
    v_count number DEFAULT 0;
 
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('-- ==================================================');
    DBMS_OUTPUT.PUT_LINE('--                 PRIMARY DATABASE');
    DBMS_OUTPUT.PUT_LINE('-- ==================================================');
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Primary Database: DROP AND RESIZE ONLINE REDOLOGS');
    DBMS_OUTPUT.PUT_LINE('-- Useful statements:');
    DBMS_OUTPUT.PUT_LINE(' select group#,status from v$log;');
    DBMS_OUTPUT.PUT_LINE('alter system switch logfile;');
    DBMS_OUTPUT.PUT_LINE('alter system checkpoint;');
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
 
    FOR i IN (select group# 
        from v$log order by group#)
    LOOP
        v_count := 1;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('-- GROUP: ' || i.group#);
        DBMS_OUTPUT.PUT_LINE('alter database drop logfile group ' || i.group# || ';');
        FOR j IN (select member
            FROM v$logfile
            WHERE group#=i.group#)
        LOOP
            IF v_count = 1 THEN
                DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD LOGFILE GROUP ' || i.group# || '(''' || j.member || ''') SIZE ' || v_rl_size_MB || 'M REUSE;');
                v_COUNT := v_COUNT + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD LOGFILE MEMBER ''' || j.member || ''' REUSE to group ' || i.group# || ';');
            END IF; 
        END LOOP;
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- Verify the new size of redologs');
    DBMS_OUTPUT.PUT_LINE('select group#, BYTES/1024/1024 "SIZE-MB", status from  v$log;');
 
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Primary Database: DROP AND RESIZE STANDBY REDOLOGS:');
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
 
    FOR i IN (select group# 
        from v$standby_log)
    LOOP
        v_count := 1;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('-- GROUP: ' || i.group#);
        DBMS_OUTPUT.PUT_LINE('alter database drop standby logfile group ' || i.group# || ';');
        FOR j IN (select member 
            FROM v$logfile
            WHERE group#=i.group#)
        LOOP
            DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD STANDBY LOGFILE GROUP ' || i.group# || '(''' || j.member || ''') SIZE ' || v_rl_size_MB || 'M REUSE;');
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- Verify the new size of Standby redologs');
    DBMS_OUTPUT.PUT_LINE(' select group#, BYTES/1024/1024 "SIZE-MB", status from  v$standby_log;');
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
 
 
    DBMS_OUTPUT.PUT_LINE('-- ==================================================');
    DBMS_OUTPUT.PUT_LINE('--                 STANDBY DATABASE');
    DBMS_OUTPUT.PUT_LINE('-- ==================================================');
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Standby Database: DROP AND RESIZE ONLINE REDOLOGS');
    DBMS_OUTPUT.PUT_LINE('-- Useful statements:');
    DBMS_OUTPUT.PUT_LINE(' select group#,status from v$log;');
    DBMS_OUTPUT.PUT_LINE('alter database clear logfile group n;');
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
 
 
    DBMS_OUTPUT.PUT_LINE('-- Prerequisites for the standby db if DG_BROKER_START = FALSE:');
    DBMS_OUTPUT.PUT_LINE('-- Update system parameter standby_file_management to manual:');
    DBMS_OUTPUT.PUT_LINE('alter system set standby_file_management=manual;');
    DBMS_OUTPUT.PUT_LINE('-- Cancel application of redologs on the standby:');
    DBMS_OUTPUT.PUT_LINE('alter database recover managed standby database cancel;');
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    FOR i IN (select group# 
        from v$log order by group#)
    LOOP
        v_count := 1;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('-- GROUP: ' || i.group#);
        DBMS_OUTPUT.PUT_LINE('alter database clear logfile group ' || i.group# || ';');
        DBMS_OUTPUT.PUT_LINE('alter database drop logfile group ' || i.group# || ';');
        FOR j IN (select member
            FROM v$logfile
            WHERE group#=i.group#)
        LOOP
            IF v_count = 1 THEN
                DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD LOGFILE GROUP ' || i.group# || '(''' || j.member || ''') SIZE ' || v_rl_size_MB || 'M REUSE;');
                v_COUNT := v_COUNT + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD LOGFILE MEMBER ''' || j.member || ''' REUSE to group ' || i.group# || ';');
            END IF; 
        END LOOP;
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- Verify the new size of redologs');
    DBMS_OUTPUT.PUT_LINE('select group#, BYTES/1024/1024 "SIZE-MB", status from  v$log;');
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Standby Database: DROP AND RESIZE STANDBY REDOLOGS:');
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------');
 
    FOR i IN (select group# 
        from v$standby_log)
    LOOP
        v_count := 1;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('-- GROUP: ' || i.group#);
        DBMS_OUTPUT.PUT_LINE('alter database drop standby logfile group ' || i.group# || ';');
        FOR j IN (select member 
            FROM v$logfile
            WHERE group#=i.group#)
        LOOP
            DBMS_OUTPUT.PUT_LINE('ALTER DATABASE ADD STANDBY LOGFILE GROUP ' || i.group# || '(''' || j.member || ''') SIZE ' || v_rl_size_MB || 'M REUSE;');
        END LOOP;
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Post-requisites for the standby db if DG_BROKER_START = FALSE:');
    DBMS_OUTPUT.PUT_LINE('-- --------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Update system parameter standby_file_management to auto:');
    DBMS_OUTPUT.PUT_LINE('alter system set standby_file_management=auto;');
    DBMS_OUTPUT.PUT_LINE('-- Start applying redologs on the standby:');
    DBMS_OUTPUT.PUT_LINE('Active DG: alter database recover managed standby database disconnect from session using current logfile;');
	DBMS_OUTPUT.PUT_LINE('Normal DG: alter database recover managed standby database disconnect from session;');
    DBMS_OUTPUT.PUT_LINE('-- Verify the status and MRP process');
    DBMS_OUTPUT.PUT_LINE('select process,status,sequence# from v$managed_standby;');
    DBMS_OUTPUT.PUT_LINE('-- Verify the new size of Standby redologs');
    DBMS_OUTPUT.PUT_LINE(' select group#, BYTES/1024/1024 "SIZE-MB", status from  v$standby_log;');
    DBMS_OUTPUT.PUT_LINE('-- Verify the path of new Standby redologs');
    DBMS_OUTPUT.PUT_LINE(' select member from  v$logfile;');
 
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
 
    DBMS_OUTPUT.PUT_LINE('-- Unix commands to drop RL and Standby redologs ');
    DBMS_OUTPUT.PUT_LINE('-- -----------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- IF MIGRATION ONLY, here is the Unix commands to drop RL and Standby redologs:');
    DBMS_OUTPUT.PUT_LINE('-- -----------------------------------------------------------------------------');
    FOR j IN (select member 
        FROM v$logfile)
    LOOP
        DBMS_OUTPUT.PUT_LINE('rm ' || j.member);
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
     
    DBMS_OUTPUT.PUT_LINE('-- ============================================================');
    DBMS_OUTPUT.PUT_LINE('--                               THE END');
    DBMS_OUTPUT.PUT_LINE('-- ============================================================');
END;
/