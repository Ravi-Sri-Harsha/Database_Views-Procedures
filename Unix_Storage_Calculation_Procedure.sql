create or replace PROCEDURE UNIX_STORAGECALC AS 

vCounter NUMBER :=0;
vProcessNameStart    VARCHAR(100) := 'Start Calculation of UNIX CI Type';
vProcessNameEnd    VARCHAR(100) := 'End Calculation of UNIX CI Type';

vLastModifiedTime NUMBER := ((sysdate-8) - date '1970-01-01') * 86400000;

vStorageAllocated NUMBER;
vStorageFree NUMBER;
vStorageUsed NUMBER;

  BEGIN
    
      insert into ref_process(RE_PROCESS_NAME,RE_COUNTER,re_execution_date)
      values(vProcessNameStart,vCounter,sysdate);

  --for rec in (select * from CDM_ROOT_1 where A_LAST_MODIFIED_TIME >= vLastModifiedTime and A_ROOT_CLASS='unix')
  --  for rec in (select * from CDM_ROOT_1 where A_ROOT_CLASS='unix')
    --for rec in (select * from CDM_ROOT_1 where CMDB_ID='BB4A12DD7BDE1C908998385B976A2E21')
  for rec in (select * from CDM_UNIX_1)
 
  LOOP
    
      IF (rec.A_DISCOVERED_OS_NAME = 'HP-UX') THEN
          Select sum(A_PG_BLOCK) into vStorageAllocated from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
          Select sum(A_PG_AVAILABLE) into vStorageFree from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
          Select sum(A_PG_USED) into vStorageUsed from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
          vStorageAllocated := vStorageAllocated/2048;
          vStorageFree := vStorageFree/2048;
          vStorageUsed := vStorageUsed/2048;
      ELSE
          IF (rec.A_DISCOVERED_MODEL like '%Virtual%') THEN
             Select sum(A_PG_BLOCK) into vStorageAllocated from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL or A_NAME like '%vg00%') and (A_Mount_Point<>'/mnt/nfs');
             Select sum(A_PG_AVAILABLE) into vStorageFree from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL or A_NAME like '%vg00%') and (A_Mount_Point<>'/mnt/nfs');
             Select sum(A_PG_USED) into vStorageUsed from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL or A_NAME like '%vg00%') and (A_Mount_Point<>'/mnt/nfs');
          Else
             Select sum(A_PG_BLOCK) into vStorageAllocated from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
             Select sum(A_PG_AVAILABLE) into vStorageFree from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
             Select sum(A_PG_USED) into vStorageUsed from CDM_FILE_SYSTEM_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_DISK_TYPE not in('Floppy','CD-ROM','NetworkDisk','tmpfs','nfs') and (A_NAME not like '%vg00%' or A_NAME is NULL) and (A_Mount_Point<>'/mnt/nfs');
          END IF;
          vStorageAllocated := vStorageAllocated/1024;
          vStorageFree := vStorageFree/1024;
          vStorageUsed := vStorageUsed/1024;
      END IF;
                        
        Update CDM_UNIX_1 set A_PG_STORAGEALLOCATED=to_char(ROUND(vStorageAllocated,0)),A_PG_STORAGEFREE=to_char(ROUND(vStorageFree,0)),A_PG_StorageUsed=to_char(Round(vStorageUsed,0)) where CMDB_ID=rec.CMDB_ID;
        vCounter := vCounter + 1;        
                      
  END LOOP;
  insert into ref_process(RE_PROCESS_NAME,RE_COUNTER,re_execution_date)
  values(vProcessNameEnd,vCounter,sysdate);
commit;
  
END UNIX_STORAGECALC;