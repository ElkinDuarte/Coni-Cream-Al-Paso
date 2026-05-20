const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.json({ message: 'AlPaso API funcionando ✓' });
});

// Módulos activos
app.use('/auth', require('./src/modules/auth/auth.routes'));

// Módulos pendientes (se activan conforme se desarrollan)
// app.use('/pedidos',    require('./src/modules/pedidos/pedidos.routes'));
// app.use('/inventario', require('./src/modules/inventario/inventario.routes'));
// app.use('/sobrante',   require('./src/modules/sobrante/sobrante.routes'));
// app.use('/reportes',   require('./src/modules/reportes/reportes.routes'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});