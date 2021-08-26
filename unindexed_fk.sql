-- Plagiarized from Ask Tom!
-- https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:27412348051
SELECT owner,
       table_name,
       constraint_name,
          cname1
       || NVL2( cname2, ',' || cname2, NULL )
       || NVL2( cname3, ',' || cname3, NULL )
       || NVL2( cname4, ',' || cname4, NULL )
       || NVL2( cname5, ',' || cname5, NULL )
       || NVL2( cname6, ',' || cname6, NULL )
       || NVL2( cname7, ',' || cname7, NULL )
       || NVL2( cname8, ',' || cname8, NULL ) columns
FROM ( SELECT b.owner,
              b.table_name,
              b.constraint_name,
              MAX( DECODE( position, 1, column_name, NULL ) ) cname1,
              MAX( DECODE( position, 2, column_name, NULL ) ) cname2,
              MAX( DECODE( position, 3, column_name, NULL ) ) cname3,
              MAX( DECODE( position, 4, column_name, NULL ) ) cname4,
              MAX( DECODE( position, 5, column_name, NULL ) ) cname5,
              MAX( DECODE( position, 6, column_name, NULL ) ) cname6,
              MAX( DECODE( position, 7, column_name, NULL ) ) cname7,
              MAX( DECODE( position, 8, column_name, NULL ) ) cname8,
              COUNT( * ) col_cnt
       FROM (SELECT owner,
                    table_name,
                    constraint_name,
                    column_name,
                    position
             FROM dba_cons_columns) a,
                  dba_constraints   b
             WHERE ( b.owner LIKE 'OMX%' OR b.owner = 'SCHEDULER' ) -- OMx Schemas
               AND a.constraint_name = b.constraint_name
               AND b.constraint_type = 'R'
             GROUP BY b.owner,
                         b.table_name,
                         b.constraint_name ) cons
WHERE col_cnt > ALL (SELECT COUNT( * )
                     FROM dba_ind_columns i
                     WHERE i.table_name = cons.table_name
                       AND i.column_name IN (cname1, cname2, cname3, cname4, cname5, cname6, cname7, cname8)
                       AND i.column_position <= cons.col_cnt
                     GROUP BY i.index_name)
ORDER BY owner,
         table_name,
         constraint_name
/
