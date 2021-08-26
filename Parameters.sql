set lines 200
col name for a35
col value for a25

Select name,VALUE,ISDEFAULT,ISSES_MODIFIABLE,ISSYS_MODIFIABLE from v$parameter where name='open_cursors';