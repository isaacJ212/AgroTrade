document.addEventListener('DOMContentLoaded', async () => {
  const api = new ApiService();

  async function loadMetrics() {
    try {
      const res = await api.get('/Suscripciones/metrics');
      if (res && res.data) {
        document.getElementById('statTotalSub').textContent = res.data.totalSuscripciones;
        document.getElementById('statActiveSub').textContent = res.data.suscripcionesActivas;
        document.getElementById('statTotalRevenue').textContent = '$' + res.data.ingresosTotales.toFixed(2);
        document.getElementById('statMonthlyRevenue').textContent = '$' + res.data.ingresosMensualesEstimados.toFixed(2);
      }
    } catch (e) {
      console.error(e);
      Toast.error('Error al cargar métricas');
    }
  }

  async function loadSubscriptions(roleId = '') {
    try {
      let url = '/Suscripciones/all';
      if (roleId) {
        url += `?roleId=${roleId}`;
      }
      const res = await api.get(url);
      const tbody = document.getElementById('subTableBody');
      tbody.innerHTML = '';
      if (res && res.data) {
        res.data.forEach(sub => {
          const tr = document.createElement('tr');
          tr.innerHTML = `
            <td>${sub.nombreUsuario}</td>
            <td><span class="badge-pill" style="background:#f1f5f9;">${sub.nombrePlan}</span></td>
            <td>$${sub.precioPlan.toFixed(2)} / ${sub.tipoIntervalo}</td>
            <td>${new Date(sub.fechaInicio).toLocaleDateString()}</td>
            <td><span class="badge-pill" style="background:${sub.estado?.toLowerCase() === 'activo' ? '#dcfce7' : '#fee2e2'}; color:${sub.estado?.toLowerCase() === 'activo' ? '#15803d' : '#b91c1c'};">${sub.estado}</span></td>
          `;
          tbody.appendChild(tr);
        });
      }
    } catch (e) {
      console.error(e);
      Toast.error('Error al cargar suscripciones');
    }
  }

  async function loadTransactions() {
    try {
      const res = await api.get('/Suscripciones/transacciones');
      const tbody = document.getElementById('transTableBody');
      tbody.innerHTML = '';
      if (res && res.data) {
        res.data.forEach(t => {
          const tr = document.createElement('tr');
          tr.innerHTML = `
            <td>#TR-${t.idSuscripcion}</td>
            <td>${t.nombreUsuario}</td>
            <td>${t.plan}</td>
            <td>$${t.montoPagado.toFixed(2)}</td>
            <td>${new Date(t.fechaTransaccion).toLocaleDateString()}</td>
            <td><span class="status-dot-amber" style="background: ${t.estado?.toLowerCase() === 'activo' ? '#10b981' : '#f59e0b'}; margin-right:5px;"></span>${t.estado}</td>
          `;
          tbody.appendChild(tr);
        });
      }
    } catch (e) {
      console.error(e);
      Toast.error('Error al cargar transacciones');
    }
  }

  document.getElementById('roleFilter').addEventListener('change', (e) => {
    loadSubscriptions(e.target.value);
  });

  loadMetrics();
  loadSubscriptions();
  loadTransactions();
});
