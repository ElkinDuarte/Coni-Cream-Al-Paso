const jwt = require('jsonwebtoken');

/**
 * Middleware que verifica el token JWT en el header Authorization.
 * Si el token es válido, adjunta el payload decodificado en req.usuario.
 */
const verificarToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ 
            ok: false, 
            mensaje: 'Token no proporcionado o formato inválido. Use: Bearer <token>' 
        });
    }

    const token = authHeader.split(' ')[1];

    try {
        const payload = jwt.verify(token, process.env.JWT_SECRET);
        req.usuario = payload; // { numero_documento, nombre, rol }
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({ ok: false, mensaje: 'Token expirado. Inicie sesión nuevamente.' });
        }
        return res.status(401).json({ ok: false, mensaje: 'Token inválido.' });
    }
};

/**
 * Middleware de autorización por rol.
 * Uso: soloRol(1)  -> solo Administrador
 *      soloRol(2)  -> solo Comerciante
 *      soloRol(1, 2) -> ambos roles
 */
const soloRol = (...rolesPermitidos) => {
    return (req, res, next) => {
        if (!req.usuario) {
            return res.status(401).json({ ok: false, mensaje: 'No autenticado.' });
        }
        if (!rolesPermitidos.includes(req.usuario.rol)) {
            return res.status(403).json({ ok: false, mensaje: 'Acceso denegado. No tiene permisos suficientes.' });
        }
        next();
    };
};

module.exports = { verificarToken, soloRol };
