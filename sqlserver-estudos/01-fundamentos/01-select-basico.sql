-- ============================================================
-- Módulo 01: SELECT Básico
-- ============================================================
-- Objetivo: Recuperar e filtrar dados com clareza e precisão
-- Referência: DP-900 Módulo 2 / DP-300 Módulo 1
-- ============================================================

-- 1. Seleção simples com ordenação
SELECT 
    ProductID,
    Name,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- 2. Filtragem com WHERE
SELECT 
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2023-01-01'
  AND TotalDue > 1000;

-- 3. CASE para categorização dinâmica
SELECT 
    Name,
    ListPrice,
    Categoria = CASE 
        WHEN ListPrice = 0     THEN 'Gratuito'
        WHEN ListPrice < 50    THEN 'Econômico'
        WHEN ListPrice < 500   THEN 'Intermediário'
        ELSE 'Premium'
    END
FROM Production.Product;

-- 4. GROUP BY com HAVING
SELECT 
    CustomerID,
    TotalPedidos  = COUNT(*),
    TicketMedio   = AVG(TotalDue),
    TotalGasto    = SUM(TotalDue)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 5000
ORDER BY TotalGasto DESC;
