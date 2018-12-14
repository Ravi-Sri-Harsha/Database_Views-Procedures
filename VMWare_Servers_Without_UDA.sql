SELECT nt.A_NAME,nt.A_STATUS,nt.a_primary_ip_address,nt.A_OS_Name 
FROM CDM_NT_1 nt
WHERE nt.A_DATA_SOURCE LIKE '%VMware VirtualCenter Topology by VIM%' AND
(nt.A_STATUS<>'Decommissioned' or nt.A_STATUS is null) AND
nt.CMDB_ID NOT IN 
(SELECT nt.CMDB_ID
FROM
CMDB_V10.cdm_nt_1 nt, CDM_UDA_1 uda, CDM_COMPOSITION_1 composition
WHERE 
nt.A_DATA_SOURCE LIKE '%VMware VirtualCenter Topology by VIM%' AND
(nt.A_STATUS<>'Decommissioned' or nt.A_STATUS is null) AND 
composition.END2_ID = uda.CMDB_ID AND 
composition.END1_ID = nt.CMDB_ID)
UNION ALL
SELECT unix.A_NAME,unix.A_STATUS,unix.a_primary_ip_address,unix.A_OS_Name
FROM 
CMDB_V10.cdm_unix_1 unix 
WHERE 
unix.A_DATA_SOURCE LIKE '%VMware VirtualCenter Topology by VIM%' AND
(unix.A_STATUS<>'Decommissioned' or unix.A_STATUS is null) AND
unix.A_Name not like '%trapx%' AND
unix.CMDB_ID NOT IN 
(SELECT unix.cmdb_id 
FROM 
CMDB_V10.cdm_unix_1 unix, CMDB_V10.cdm_COMPOSITION_1 composition, CMDB_V10.cdm_uda_1 uda 
WHERE
unix.A_DATA_SOURCE LIKE '%VMware VirtualCenter Topology by VIM%' AND 
(unix.A_STATUS<>'Decommissioned' OR unix.A_STATUS is null) AND 
unix.A_Name NOT LIKE '%trapx%' AND 
composition.END2_ID = uda.CMDB_ID AND 
composition.END1_ID = unix.CMDB_ID)