# T-SQL Cheat Sheet

## Estrutura de uma query completa
```sql
SELECT  colunas
FROM    tabela
JOIN    outra ON chave
WHERE   condição
GROUP BY agrupamento
HAVING  condição_após_agrupamento
ORDER BY coluna DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

## JOINs — quando usar cada um
| JOIN  | Quando usar |
|-------|-------------|
| INNER | Só registros com correspondência nos dois lados |
| LEFT  | Todos da esquerda, mesmo sem par à direita |
| RIGHT | Todos da direita, mesmo sem par à esquerda |
| FULL  | Todos de ambos, com ou sem correspondência |
| CROSS | Produto cartesiano (todas as combinações) |

## Window Functions
```sql
ROW_NUMBER() OVER (PARTITION BY col ORDER BY col)
RANK()       OVER (PARTITION BY col ORDER BY col)
DENSE_RANK() OVER (PARTITION BY col ORDER BY col)
SUM(val)     OVER (PARTITION BY col ORDER BY col ROWS UNBOUNDED PRECEDING)
LAG(col, 1, 0)  OVER (ORDER BY data)   -- valor anterior
LEAD(col, 1, 0) OVER (ORDER BY data)   -- valor seguinte
```

## DMVs mais usados
```sql
-- Queries mais pesadas no servidor
SELECT TOP 10
    qs.total_elapsed_time / qs.execution_count AS media_ms,
    qs.execution_count,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 200) AS query
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY media_ms DESC;

-- Índices fragmentados
SELECT OBJECT_NAME(object_id), avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED')
WHERE avg_fragmentation_in_percent > 30;
```

## Dicas DP-300 / DP-900
- `sys.dm_exec_*` → monitoramento em tempo real
- `sys.indexes` → metadados de índices
- `REBUILD` → fragmentação > 30% | `REORGANIZE` → entre 10% e 30%
- Backup: FULL → DIFFERENTIAL → LOG
