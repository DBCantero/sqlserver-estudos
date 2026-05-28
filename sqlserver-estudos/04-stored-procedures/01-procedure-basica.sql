-- ============================================================
-- Módulo 04: Stored Procedures e Functions
-- ============================================================

-- Procedure com parâmetros de entrada
CREATE OR ALTER PROCEDURE sp_RelatorioVendasPorPeriodo
    @DataInicio DATE,
    @DataFim    DATE,
    @CustomerID INT = NULL  -- parâmetro opcional
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        soh.SalesOrderID,
        soh.OrderDate,
        soh.CustomerID,
        soh.TotalDue
    FROM Sales.SalesOrderHeader soh
    WHERE soh.OrderDate BETWEEN @DataInicio AND @DataFim
      AND (@CustomerID IS NULL OR soh.CustomerID = @CustomerID)
    ORDER BY soh.OrderDate;
END;
GO

-- Execução
EXEC sp_RelatorioVendasPorPeriodo 
    @DataInicio = '2023-01-01',
    @DataFim    = '2023-12-31';

-- Table-Valued Function
CREATE OR ALTER FUNCTION fn_TopProdutosPorVendas(@Top INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (@Top)
        p.ProductID,
        p.Name,
        TotalVendido = SUM(sod.OrderQty),
        ReceitaTotal = SUM(sod.LineTotal)
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name
    ORDER BY ReceitaTotal DESC
);
GO

SELECT * FROM fn_TopProdutosPorVendas(10);
