-- ============================================================
-- Módulo 03: CTEs e Window Functions
-- ============================================================

-- CTE simples — legibilidade e reutilização
WITH PedidosPorCliente AS (
    SELECT 
        CustomerID,
        TotalPedidos = COUNT(*),
        TotalGasto   = SUM(TotalDue)
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    TotalPedidos,
    TotalGasto,
    Ranking = RANK() OVER (ORDER BY TotalGasto DESC)
FROM PedidosPorCliente
ORDER BY Ranking;

-- ROW_NUMBER para pegar apenas o registro mais recente por grupo
WITH RankeadosPorData AS (
    SELECT 
        ProductID,
        ListPrice,
        ModifiedDate,
        rn = ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY ModifiedDate DESC)
    FROM Production.ProductListPriceHistory
)
SELECT ProductID, ListPrice, ModifiedDate
FROM RankeadosPorData
WHERE rn = 1; -- apenas o preço mais recente por produto

-- Acumulado com SUM OVER
SELECT 
    OrderDate,
    TotalDue,
    AcumuladoNoMes = SUM(TotalDue) OVER (
        PARTITION BY YEAR(OrderDate), MONTH(OrderDate)
        ORDER BY OrderDate
        ROWS UNBOUNDED PRECEDING
    )
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;
