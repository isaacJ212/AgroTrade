document.addEventListener('DOMContentLoaded', async () => {
    try {
        await Promise.all([
            fetchMetrics(),
            fetchSubscriptions(),
            fetchTransactions()
        ]);

        const roleFilter = document.getElementById('roleFilter');
        if (roleFilter) {
            roleFilter.addEventListener('change', (e) => fetchSubscriptions(e.target.value));
        }
    } catch (error) {
        console.error('Error inicializando suscripciones:', error);
    }
});

async function fetchMetrics() {
    try {
        const res = await apiService.get('/Suscripciones/metrics');
        const data = res.data || res.Data;
        if (res && data) {
            if (document.getElementById('dashStatActivas')) {
                document.getElementById('dashStatActivas').textContent = data.activas !== undefined ? data.activas : (data.Activas || 0);
            }
            if (document.getElementById('dashStatCanceladas')) {
                document.getElementById('dashStatCanceladas').textContent = data.canceladas !== undefined ? data.canceladas : (data.Canceladas || 0);
            }
            if (document.getElementById('dashStatIngresos')) {
                const ingresos = data.ingresosGenerados !== undefined ? data.ingresosGenerados : (data.IngresosGenerados || 0);
                document.getElementById('dashStatIngresos').textContent = '$' + ingresos.toFixed(2);
            }
        }
    } catch (e) {
        console.error(e);
        if (typeof Toast !== 'undefined') Toast.error('Error cargando métricas');
    }
}




async function fetchSubscriptions(roleId = '') {
    try {
        const url = roleId ? `/Suscripciones/all?roleId=${roleId}` : '/Suscripciones/all';
        const res = await apiService.get(url);
        const tbody = document.getElementById('suscripcionesTableBody') || document.getElementById('subTableBody');
        if (!tbody) return;
        
        tbody.innerHTML = '';
        
        const data = res.data || res.Data;
        if (res && data && data.length > 0) {
            data.forEach(sub => {
                const tr = document.createElement('tr');
                const fecha = sub.fechaInicio || sub.FechaInicio || new Date();
                const fInicio = new Date(fecha).toLocaleDateString();
                const estado = sub.estado || sub.Estado || 'Activo';
                const estadoClass = estado.toLowerCase() === 'activa' ? 'status-dot-green' : 'status-dot-amber';
                const tarifaVal = sub.tarifaPago !== undefined ? sub.tarifaPago : (sub.TarifaPago || 0);
                const tarifa = tarifaVal.toFixed(2);
                
                tr.innerHTML = `
                    <td><strong>${sub.nombreUsuario || sub.NombreUsuario || 'Usuario'}</strong></td>
                    <td><span class="badge-pill" style="background:#e0f2fe; color:#0284c7;">${sub.tipoPlan || sub.TipoPlan || 'Plan'}</span></td>
                    <td>$${tarifa}/mes</td>
                    <td>${fInicio}</td>
                    <td><span class="${estadoClass}"></span> ${estado}</td>
                `;
                tbody.appendChild(tr);
            });
        } else {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">No hay suscripciones</td></tr>';
        }
    } catch (e) {
        console.error(e);
        if (typeof Toast !== 'undefined') Toast.error('Error cargando suscripciones');
    }
}

async function fetchTransactions() {
    try {
        const res = await apiService.get('/Suscripciones/transacciones');
        const tbody = document.getElementById('transTableBody');
        if (!tbody) return; 
        
        tbody.innerHTML = '';
        
        const data = res.data || res.Data;
        if (res && data && data.length > 0) {
            data.forEach(t => {
                const tr = document.createElement('tr');
                const fecha = t.fechaTransaccion || t.FechaTransaccion || new Date();
                const fTrans = new Date(fecha).toLocaleDateString();
                const montoVal = t.montoPagado !== undefined ? t.montoPagado : (t.MontoPagado || 0);
                const monto = montoVal.toFixed(2);
                
                tr.innerHTML = `
                    <td>#TRN-${t.idSuscripcion || t.IdSuscripcion || 'N/A'}</td>
                    <td>${t.nombreUsuario || t.NombreUsuario || 'Usuario'}</td>
                    <td>${t.plan || t.Plan || 'Plan'}</td>
                    <td><strong>$${monto}</strong></td>
                    <td>${fTrans}</td>
                    <td><span style="color:#15803d; font-weight:500;">Completado</span></td>
                `;
                tbody.appendChild(tr);
            });
        } else {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;">No hay transacciones</td></tr>';
        }
    } catch (e) {
        console.error(e);
        if (typeof Toast !== 'undefined') Toast.error('Error cargando transacciones');
    }
}
