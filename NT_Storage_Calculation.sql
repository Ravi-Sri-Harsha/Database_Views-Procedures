create or replace PROCEDURE NT_STORAGECALC AS 

vCounter NUMBER :=0;
vProcessNameStart    VARCHAR(100) := 'Start Calculation of NT CI Type';
vProcessNameEnd    VARCHAR(100) := 'End Calculation of NT CI Type';

vStorageAllocated NUMBER;
vStorageFree NUMBER;
vStorageUsed NUMBER;

  BEGIN
    
  insert into ref_process(RE_PROCESS_NAME,RE_COUNTER,re_execution_date)
  values(vProcessNameStart,vCounter,sysdate);

  FOR rec in (select * from CDM_NT_1)
 
  LOOP
      IF rec.A_DISCOVERED_MODEL like '%Virtual%' THEN
         Select sum(A_LOGICALVOLUME_SIZE) into vStorageAllocated from CDM_LOGICAL_VOLUME_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_LOGICALVOLUME_FSTYPE not in ('Device Driven');
         Select sum(A_LOGICALVOLUME_FREE) into vStorageFree from CDM_LOGICAL_VOLUME_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_LOGICALVOLUME_FSTYPE not in ('Device Driven');
      ELSE
         Select sum(A_LOGICALVOLUME_SIZE) into vStorageAllocated from CDM_LOGICAL_VOLUME_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_LOGICALVOLUME_FSTYPE not in ('Device Driven') and (A_DRIVE_LABEL not in('C','D') or A_DRIVE_LABEL is NULL);
         Select sum(A_LOGICALVOLUME_FREE) into vStorageFree from CDM_LOGICAL_VOLUME_1 where INLINE_COMPOSITION_END1=rec.CMDB_ID and A_LOGICALVOLUME_FSTYPE not in ('Device Driven') and (A_DRIVE_LABEL not in('C','D') or A_DRIVE_LABEL is NULL);
      END IF;

      vStorageUsed := vStorageAllocated - vStorageFree;
                   
      Update CDM_NT_1 set A_PG_STORAGEALLOCATED=to_char(vStorageAllocated),A_PG_STORAGEFREE=to_char(vStorageFree),A_PG_StorageUsed=to_char(vStorageUsed) where CMDB_ID=rec.CMDB_ID;
      vCounter := vCounter + 1;
               
                      
  END LOOP;
  insert into ref_process(RE_PROCESS_NAME,RE_COUNTER,re_execution_date)
  values(vProcessNameEnd,vCounter,sysdate);
commit;
  
END NT_STORAGECALC;