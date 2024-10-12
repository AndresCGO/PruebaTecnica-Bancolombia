CREATE TABLE clientes (
    tipo_doc VARCHAR(50),
    num_doc VARCHAR(50),
    nombre VARCHAR(255),
    tipo_persona VARCHAR(50),
    ingresos_mensuales DECIMAL,
    PRIMARY KEY (tipo_doc, num_doc)
);

CREATE TABLE canales (
    codigo VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255),
    tipo VARCHAR(50),
    cod_jurisdiccion VARCHAR(50)
);

CREATE TABLE transacciones (
    fecha_transaccion DATETIME,
    cod_canal VARCHAR(50),
    tipo_doc VARCHAR(50),
    num_doc VARCHAR(50),
    naturaleza VARCHAR(50),
    monto DECIMAL,
    FOREIGN KEY (tipo_doc, num_doc) REFERENCES clientes (tipo_doc, num_doc),
    FOREIGN KEY (cod_canal) REFERENCES canales (codigo)
);
