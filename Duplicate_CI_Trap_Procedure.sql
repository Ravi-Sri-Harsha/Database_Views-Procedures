create or replace PROCEDURE DUPLICATE_CI_TRAP AS
cursor c1(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='unix';
cursor c2(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='nt';
cursor c3(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='node';
cursor c4(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='storagearray';
cursor c5(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='vmware_esx_server';
cursor c6(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='enclosure';
cursor c7(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='netdevice';
cursor c8(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='switch';
cursor c9(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='router';
-- cursor c10(v_class varchar2) is select cmdb_id from cdm_root_1 where TO_DATE('01-JAN-1970','DD-MON-YYYY') + (A_LAST_MODIFIED_TIME /1000/60/60/24)>=sysdate-1 and A_ROOT_CLASS='ESLServer';
V_COUNT      NUMBER(35) := 0;
V_TMP_NAME   VARCHAR2(100) := NULL;
BEGIN
FOR rec in c1('unix')
LOOP
  select a_name into V_TMP_NAME from cdm_unix_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_unix_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate Unix CI Count: '||V_COUNT);
    update cdm_unix_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;


FOR rec in c2('nt')
LOOP
  select a_name into V_TMP_NAME from cdm_nt_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_nt_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate Windows CI Count: '||V_COUNT);
    update cdm_nt_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c3('node')
LOOP
  select a_name into V_TMP_NAME from cdm_node_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_node_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate Node CI Count: '||V_COUNT);
    update cdm_node_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c4('storagearray')
LOOP
  select a_name into V_TMP_NAME from cdm_storagearray_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_storagearray_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate storage array CI Count: '||V_COUNT);
    update cdm_storagearray_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c5('vmware_esx_server')
LOOP
  select a_name into V_TMP_NAME from cdm_vmware_esx_server_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_vmware_esx_server_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate esx server CI Count: '||V_COUNT);
    update cdm_vmware_esx_server_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c6('enclosure')
LOOP
  select a_name into V_TMP_NAME from cdm_enclosure_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_enclosure_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate enclosure CI Count: '||V_COUNT);
    update cdm_enclosure_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;



FOR rec in c7('netdevice')
LOOP
  select a_name into V_TMP_NAME from cdm_netdevice_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_netdevice_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate netdevice CI Count: '||V_COUNT);
    update cdm_netdevice_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c8('switch')
LOOP
  select a_name into V_TMP_NAME from cdm_switch_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_switch_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate Switch CI Count: '||V_COUNT);
    update cdm_switch_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

FOR rec in c9('router')
LOOP
  select a_name into V_TMP_NAME from cdm_router_1 where cmdb_id=rec.cmdb_id;
  select count(*) into V_COUNT from cdm_router_1 where a_name=V_TMP_NAME;
IF V_COUNT > 1 THEN
    insert into UCMDB_HISTORY_RENAME (CMDB_ID,A_NAME,A_COMMENTS) values (rec.cmdb_id,V_TMP_NAME,'Duplicate router CI Count: '||V_COUNT);
    update cdm_router_1 set a_pg_sm_sync = 5 where cmdb_id=rec.cmdb_id;
END IF;
END LOOP;
COMMIT;
V_COUNT:=NULL;
V_TMP_NAME:=NULL;

END DUPLICATE_CI_TRAP;