const pool = require('../../database/db');

/**
 * Busca un comerciante por número de documento.
 * Retorna también el nombre del rol desde TMRoles.
 */
const buscarComerciantePorDocumento = async (numero_documento) => {
    const query = `
        SELECT 
            c.numero_documento,
            c.nombre,
            c.primer_apellido,
            c.clave,
            c.rol_comerciante,
            r.rol AS nombre_rol,
            c.cods
        FROM privado."TMComerciantes" c
        INNER JOIN privado."TMRoles" r ON c.rol_comerciante = r.cod_rol
        WHERE c.numero_documento = $1
    `;
    const { rows } = await pool.query(query, [numero_documento]);
    return rows[0] || null;
};

/**
 * Registra un nuevo comerciante en la BD.
 * El hash de la clave se genera en el controller con bcryptjs.
 */
const crearComerciante = async ({ numero_documento, nombre, primer_apellido, claveHash }) => {
    const query = `
        INSERT INTO privado."TMComerciantes" 
            (numero_documento, nombre, primer_apellido, clave, rol_comerciante, cods)
        VALUES ($1, $2, $3, $4, 2, 1)
        RETURNING numero_documento, nombre, primer_apellido, rol_comerciante, cods
    `;
    const { rows } = await pool.query(query, [
        numero_documento,
        nombre,
        primer_apellido || null,
        claveHash,
    ]);
    return rows[0];
};

/**
 * Verifica si ya existe un comerciante con ese número de documento.
 */
const existeComerciante = async (numero_documento) => {
    const { rows } = await pool.query(
        `SELECT 1 FROM privado."TMComerciantes" WHERE numero_documento = $1`,
        [numero_documento]
    );
    return rows.length > 0;
};

module.exports = { buscarComerciantePorDocumento, crearComerciante, existeComerciante };
