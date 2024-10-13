WITH TransaccionesUltimos6Meses AS (
    SELECT 
        t.num_doc,
        SUM(t.monto) AS total_transacciones
    FROM 
        transacciones t
    WHERE 
        t.fecha_transaccion >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY 
        t.num_doc
),
ClientesConTransacciones AS (
    SELECT 
        cl.tipo_doc,
        cl.num_doc,
        cl.nombre,
        cl.tipo_persona,
        cl.ingresos_mensuales,
        t.total_transacciones
    FROM 
        clientes cl
    JOIN 
        TransaccionesUltimos6Meses t ON cl.num_doc = t.num_doc
    WHERE 
        t.total_transacciones > 2 * cl.ingresos_mensuales
),
Percentil95 AS (
    SELECT 
        tipo_persona,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_transacciones) 
            OVER (PARTITION BY tipo_persona) AS percentil_95
    FROM 
        ClientesConTransacciones
)
SELECT DISTINCT
    c.tipo_doc,
    c.num_doc,
    c.nombre,
    c.tipo_persona,
    c.ingresos_mensuales,
    c.total_transacciones
FROM 
    ClientesConTransacciones c
JOIN 
    (SELECT DISTINCT tipo_persona, percentil_95 FROM Percentil95) p 
    ON c.tipo_persona = p.tipo_persona
WHERE 
    c.total_transacciones > p.percentil_95;
