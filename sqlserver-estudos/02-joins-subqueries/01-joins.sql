-- ============================================================
-- Módulo 02: JOINs
-- ============================================================
-- Metodologia pré-query:
--   O que ver?     Pedidos com nome do cliente e produto
--   Quais tabelas? SalesOrderHeader, Customer, SalesOrderDetail, Product
--   O que une?     CustomerID, SalesOrderID, ProductID
-- ============================================================

-- INNER JOIN — apenas correspondências em ambos os lados
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    c.CustomerID,
    p.Name              AS Produto,
    sod.OrderQty,
    sod.UnitPrice
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer         c   ON c.CustomerID    = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product     p   ON p.ProductID     = sod.ProductID;

-- LEFT JOIN — todos os clientes, mesmo sem pedidos
SELECT 
    c.CustomerID,
    TotalPedidos = COUNT(soh.SalesOrderID)
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalPedidos DESC;

-- Subquery correlacionada — clientes acima da média geral
SELECT CustomerID, TotalDue
FROM Sales.SalesOrderHeader soh
WHERE TotalDue > (
    SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader
)
ORDER BY TotalDue DESC;
