-- ============================================================
-- Módulo 05: Performance e Índices
-- ============================================================

-- Verificar fragmentação de índices
SELECT 
    OBJECT_NAME(ips.object_id)          AS Tabela,
    i.name                              AS Indice,
    ips.index_type_desc,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(
    DB_ID(), NULL, NULL, NULL, 'DETAILED') ips
INNER JOIN sys.indexes i 
    ON i.object_id = ips.object_id 
    AND i.index_id = ips.index_id
WHERE ips.avg_fragmentation_in_percent > 10
  AND ips.page_count > 100
ORDER BY ips.avg_fragmentation_in_percent DESC;

-- Índices ausentes (sugeridos pelo SQL Server)
SELECT 
    migs.avg_user_impact,
    migs.user_seeks,
    mid.statement              AS Tabela,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_details mid
INNER JOIN sys.dm_db_missing_index_groups mig 
    ON mig.index_handle = mid.index_handle
INNER JOIN sys.dm_db_missing_index_group_stats migs 
    ON migs.group_handle = mig.index_group_handle
ORDER BY migs.avg_user_impact DESC;

-- Criar índice covering (non-clustered)
CREATE NONCLUSTERED INDEX IX_SalesOrder_CustomerDate
ON Sales.SalesOrderHeader (CustomerID, OrderDate)
INCLUDE (TotalDue, Status);
