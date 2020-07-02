/**********************************************************************
						PROVIDER
*************************************************************************/
--- Facets System
SELECT DISTINCT [PRPR_ID] as [Facets_PRPR_ID]
      ,[PROVIDER_NPI] as [Facets_PROVIDER_NPI]
      ,RTRIM(LTRIM(SUBSTRING([IN_NETWORK_NETWORK_ID],4,3))) as Facets_Health_Plan
      ,[IN_NETWORK_PCP_IND]  as [Facets_IN_NETWORK_PCP_IND]
	  ,[IN_NETWORK_AGAG_ID]	 as [Facets_IN_NETWORK_AGAG_ID]
      ,[IN_NETWORK_EFF_DT]	 as [Facets_IN_NETWORK_EFF_DT]
      ,[IN_NETWORK_TERM_DT]	 as [Facets_IN_NETWORK_TERM_DT]
FROM [MDS Integration].[dbo].[UkeyProviderDemo]
WHERE PRPR_ID like '1000%'
  AND FileDate='20200615'
  AND PROVIDER_TERM_DT ='12/31/9999'
  AND ISNULL(IN_NETWORK_AGAG_ID,'')!=''
  --AND ISNULL(IN_NETWORK_AGAG_ID,'')!='DONOTUSE'
  AND provider_npi='1093707721'
ORDER BY [PRPR_ID],RTRIM(LTRIM(SUBSTRING([IN_NETWORK_NETWORK_ID],4,3))) DESC

-- MDS System
SELECT  U.Ukey as [MDS_PRPR_ID]
        ,p.NPI as MDS_NPI
		,SUBSTRING(PA.[Health Plan Network_Name],5,3) as MDS_Health_Plan
        ,CASE WHEN ISNULL(P.[Specialist Type_Name],'')='PCP' THEN 'Y' ELSE 'N' END MDS_IN_NETWORK_PCP_IND
		,CASE WHEN SUBSTRING(PA.[Health Plan Network_Name],5,3)='PPO' THEN [PPO AGAG_ID]
              WHEN SUBSTRING(PA.[Health Plan Network_Name],5,3)='HMO' AND ISNULL(P.[Specialist Type_Name],'')='PCP' THEN [HMO PCP Y AGAG_ID]
              WHEN SUBSTRING(PA.[Health Plan Network_Name],5,3)='HMO' AND ISNULL(P.[Specialist Type_Name],'')!='PCP' THEN [HMO PCP N AGAG_ID]
           ELSE '' END as [MDS_IN_NETWORK_AGAG_ID]
        ,CONVERT(VARCHAR,pac.[Effective Date],101) as [MDS_IN_NETWORK_EFF_DT]
	    ,ISNULL(CONVERT(VARCHAR,pac.[Term Date],101),'12/31/9999') as [MDS_IN_NETWORK_TERM_DT]
            
FROM mds.mdm.practitioner as P
INNER JOIN tmg_ukey  as U on P.NPI=U.Provider_NPI
INNER JOIN mds.mdm.practitioneraffiliation as pa on p.code=pa.Practitioner_Code  
                                                    AND pa.[Health Plan Network_Name] like 'CNC%'
LEFT JOIN mds.mdm.PractitionerAffiliationContractRate as pac on pac.[Practitioner Affiliation Code_Code]=pa.code
INNER JOIN mds.mdm.PractitionerContractRate as PC on pac.[Practitioner Contract Rate Code_Code]=pc.code
WHERE 
--p.Status_Name='Active-Valid'
 [ProviderType_Name] NOT IN ('Group')
AND
 P.NPI='1093707721'
ORDER BY U.UKey, PA.[Health Plan Network_Name] DESC

/**********************************************************************
						FACILITY
*************************************************************************/
--- Facets System
SELECT DISTINCT [PRPR_ID] as [Facets_PRPR_ID]
      ,[PROVIDER_NPI] as [Facets_PROVIDER_NPI]
	 -- ,[PROVIDER_ENTITY]
      ,RTRIM(LTRIM(SUBSTRING([IN_NETWORK_NETWORK_ID],4,3))) as Facets_Health_Plan
      ,[IN_NETWORK_PCP_IND]  as [Facets_IN_NETWORK_PCP_IND]
	  ,[IN_NETWORK_AGAG_ID]	 as [Facets_IN_NETWORK_AGAG_ID]
      ,[IN_NETWORK_EFF_DT]	 as [Facets_IN_NETWORK_EFF_DT]
      ,[IN_NETWORK_TERM_DT]	 as [Facets_IN_NETWORK_TERM_DT]
FROM [MDS Integration].[dbo].[UkeyProviderDemo]
WHERE PRPR_ID like '1000%'
  AND FileDate='20200615'
  AND PROVIDER_TERM_DT ='12/31/9999'
  AND ISNULL(IN_NETWORK_AGAG_ID,'')!=''
  --AND ISNULL(IN_NETWORK_AGAG_ID,'')!='DONOTUSE'
  AND provider_npi='1558453290'
ORDER BY [PRPR_ID],RTRIM(LTRIM(SUBSTRING([IN_NETWORK_NETWORK_ID],4,3))) DESC

-- MDS System
SELECT  U.Ukey as [MDS_PRPR_ID]
        ,p.NPI as MDS_NPI
		,SUBSTRING(PA.[Health Plan Network_Name],5,3) as MDS_Health_Plan
        , 'N' as MDS_IN_NETWORK_PCP_IND
		,CASE WHEN SUBSTRING(PA.[Health Plan Network_Name],5,3)='PPO' THEN [PPO AGAG_ID]
              WHEN SUBSTRING(PA.[Health Plan Network_Name],5,3)='HMO'  THEN [HMO PCP N AGAG_ID]
           ELSE '' END as [MDS_IN_NETWORK_AGAG_ID]
        ,CONVERT(VARCHAR,pac.[Effective Date],101) as [MDS_IN_NETWORK_EFF_DT]
	    ,ISNULL(CONVERT(VARCHAR,pac.[Term Date],101),'12/31/9999') as [MDS_IN_NETWORK_TERM_DT]
            
FROM mds.mdm.Facility as P
INNER JOIN tmg_ukey  as U on P.NPI=U.Provider_NPI
INNER JOIN mds.mdm.Facilityaffiliation as pa on p.code=pa.Facility_Code  
                                                    AND pa.[Health Plan Network_Name] like 'CNC%'
LEFT JOIN mds.mdm.FacilityAffiliationContractRate as pac on pac.[Facility Affiliation Code_Code]=pa.code
INNER JOIN mds.mdm.FacilityContractRate as PC on pac.[Facility Contract Rate Code_Code]=pc.code
WHERE --p.Status_Name='Active-Valid'
--AND [ProviderType_Name] NOT IN ('Group')
 P.NPI='1558453290'
ORDER BY U.UKey, PA.[Health Plan Network_Name] DESC
