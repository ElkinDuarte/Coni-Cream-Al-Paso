const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { buscarComerciantePorDocumento, crearComerciante, existeComerciante } = require('./auth.service');

/**
 * POST /auth/login
 * Body: { numero_documento, clave }
 */
const login = async (req, res) => {
    try {
        const { numero_documento, clave } = req.body;

        // --- Validación de campos requeridos ---
        if (!numero_documento || !clave) {
            return res.status(400).json({
                ok: false,
                mensaje: 'El número de documento y la clave son obligatorios.',
            });
        }

        // --- Buscar usuario en BD ---
        const comerciante = await buscarComerciantePorDocumento(String(numero_documento));
        if (!comerciante) {
            return res.status(401).json({ ok: false, mensaje: 'Credenciales incorrectas.' });
        }

        // --- Verificar clave (soporta tanto hash bcrypt como texto plano legacy) ---
        let claveValida = false;
        const esHash = comerciante.clave.startsWith('$2');

        if (esHash) {
            claveValida = await bcrypt.compare(clave, comerciante.clave);
        } else {
            // Contraseñas legacy en texto plano (los usuarios del seed original)
            claveValida = clave === comerciante.clave;
        }

        if (!claveValida) {
            return res.status(401).json({ ok: false, mensaje: 'Credenciales incorrectas.' });
        }

        // --- Verificar que la cuenta esté activa ---
        if (comerciante.cods !== 1) {
            return res.status(403).json({ ok: false, mensaje: 'Cuenta inactiva. Contacte al administrador.' });
        }

        // --- Generar JWT ---
        const payload = {
            numero_documento: comerciante.numero_documento,
            nombre: comerciante.nombre,
            primer_apellido: comerciante.primer_apellido,
            rol: comerciante.rol_comerciante,
            nombre_rol: comerciante.nombre_rol,
        };

        const token = jwt.sign(payload, process.env.JWT_SECRET, {
            expiresIn: process.env.JWT_EXPIRES_IN || '24h',
        });

        return res.status(200).json({
            ok: true,
            mensaje: `Bienvenido, ${comerciante.nombre}!`,
            token,
            usuario: {
                numero_documento: comerciante.numero_documento,
                nombre: comerciante.nombre,
                primer_apellido: comerciante.primer_apellido,
                rol: comerciante.rol_comerciante,
                nombre_rol: comerciante.nombre_rol,
            },
        });

    } catch (error) {
        console.error('[AUTH] Error en login:', error);
        return res.status(500).json({ ok: false, mensaje: 'Error interno del servidor.' });
    }
};

/**
 * POST /auth/register
 * Body: { numero_documento, nombre, primer_apellido?, clave }
 * Solo el Administrador (rol 1) puede registrar nuevos comerciantes.
 * La ruta estará protegida con verificarToken + soloRol(1).
 */
const register = async (req, res) => {
    try {
        const { numero_documento, nombre, primer_apellido, clave } = req.body;

        // --- Validaciones básicas ---
        if (!numero_documento || !nombre || !clave) {
            return res.status(400).json({
                ok: false,
                mensaje: 'número de documento, nombre y clave son obligatorios.',
            });
        }

        if (String(numero_documento).length > 11) {
            return res.status(400).json({
                ok: false,
                mensaje: 'El número de documento no puede superar 11 caracteres.',
            });
        }

        if (clave.length < 6) {
            return res.status(400).json({
                ok: false,
                mensaje: 'La clave debe tener al menos 6 caracteres.',
            });
        }

        // --- Verificar duplicado ---
        const yaExiste = await existeComerciante(String(numero_documento));
        if (yaExiste) {
            return res.status(409).json({
                ok: false,
                mensaje: 'Ya existe un comerciante con ese número de documento.',
            });
        }

        // --- Hashear la clave ---
        const salt = await bcrypt.genSalt(10);
        const claveHash = await bcrypt.hash(clave, salt);

        // --- Crear en BD ---
        const nuevo = await crearComerciante({
            numero_documento: String(numero_documento),
            nombre,
            primer_apellido: primer_apellido || null,
            claveHash,
        });

        return res.status(201).json({
            ok: true,
            mensaje: 'Comerciante registrado exitosamente.',
            comerciante: nuevo,
        });

    } catch (error) {
        console.error('[AUTH] Error en register:', error);
        return res.status(500).json({ ok: false, mensaje: 'Error interno del servidor.' });
    }
};

/**
 * GET /auth/perfil
 * Ruta protegida — devuelve los datos del usuario autenticado extraídos del token.
 */
const perfil = (req, res) => {
    return res.status(200).json({
        ok: true,
        usuario: req.usuario,
    });
};

module.exports = { login, register, perfil };
