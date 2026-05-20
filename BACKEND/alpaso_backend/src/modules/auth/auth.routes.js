const { Router } = require('express');
const { login, register, perfil } = require('./auth.controller');
const { verificarToken, soloRol } = require('../../middleware/auth.middleware');

const router = Router();

/**
 * @route  POST /auth/login
 * @desc   Inicia sesión y retorna un JWT
 * @access Público
 */
router.post('/login', login);

/**
 * @route  POST /auth/register
 * @desc   Registra un nuevo comerciante (solo el Administrador puede hacerlo)
 * @access Privado — requiere token de Administrador (rol 1)
 */
router.post('/register', verificarToken, soloRol(1), register);

/**
 * @route  GET /auth/perfil
 * @desc   Devuelve los datos del usuario autenticado
 * @access Privado — requiere token válido
 */
router.get('/perfil', verificarToken, perfil);

module.exports = router;
