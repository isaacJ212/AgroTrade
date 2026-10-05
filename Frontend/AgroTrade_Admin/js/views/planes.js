document.addEventListener('DOMContentLoaded', async () => {
  const api = new ApiService();
  const modal = document.getElementById('planModal');
  const form = document.getElementById('planForm');

  async function loadPlanes() {
    try {
      const res = await api.get('/Suscripciones/planes');
      const tbody = document.getElementById('planesTableBody');
      tbody.innerHTML = '';
      if (res && res.data) {
        res.data.forEach(p => {
          const tr = document.createElement('tr');
          tr.innerHTML = `
            <td><strong>${p.nombrePlan}</strong><br><small>${p.descripcion}</small></td>
            <td>$${p.precio.toFixed(2)}</td>
            <td>$${p.coste.toFixed(2)}</td>
            <td><span class="badge-pill" style="background:${p.isActive ? '#dcfce7' : '#fee2e2'}; color:${p.isActive ? '#15803d' : '#b91c1c'};">${p.isActive ? 'Activo' : 'Inactivo'}</span></td>
            <td>
               <button class="btn-outline btn-edit-plan" data-plan='${JSON.stringify(p)}' style="padding:4px 8px; font-size:12px;">Editar</button>
            </td>
          `;
          tbody.appendChild(tr);
        });

        document.querySelectorAll('.btn-edit-plan').forEach(btn => {
          btn.addEventListener('click', (e) => {
             const plan = JSON.parse(e.target.getAttribute('data-plan'));
             openModal(plan);
          });
        });
      }
    } catch (e) {
      console.error(e);
      Toast.error('Error al cargar planes');
    }
  }

  function openModal(plan = null) {
    if (plan) {
      document.getElementById('modalTitle').textContent = 'Editar Plan';
      document.getElementById('planId').value = plan.id;
      document.getElementById('planName').value = plan.nombrePlan;
      document.getElementById('planDesc').value = plan.descripcion;
      document.getElementById('planBen').value = plan.beneficios;
      document.getElementById('planPrice').value = plan.precio;
      document.getElementById('planCost').value = plan.coste;
      document.getElementById('planActive').checked = plan.isActive;
    } else {
      document.getElementById('modalTitle').textContent = 'Crear Plan';
      form.reset();
      document.getElementById('planId').value = '';
      document.getElementById('planActive').checked = true;
    }
    modal.style.display = 'block';
  }

  function closeModal() {
    modal.style.display = 'none';
  }

  document.getElementById('btnCreatePlan').addEventListener('click', () => openModal());
  document.getElementById('btnCancelPlan').addEventListener('click', () => closeModal());

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('planId').value;
    
    const payload = {
        nombrePlan: document.getElementById('planName').value,
        descripcion: document.getElementById('planDesc').value,
        beneficios: document.getElementById('planBen').value,
        precio: parseFloat(document.getElementById('planPrice').value),
        coste: parseFloat(document.getElementById('planCost').value),
        isActive: document.getElementById('planActive').checked
    };

    try {
        if (id) {
            // Edit
            const res = await fetch(`${api.baseUrl}/Suscripciones/planes/${id}`, {
                method: 'PUT',
                headers: api.getHeaders(),
                body: JSON.stringify(payload)
            });
            if (!res.ok) throw new Error('Error al editar');
            Toast.success('Plan actualizado con éxito');
        } else {
            // Create
            const res = await fetch(`${api.baseUrl}/Suscripciones/planes`, {
                method: 'POST',
                headers: api.getHeaders(),
                body: JSON.stringify(payload)
            });
            if (!res.ok) throw new Error('Error al crear');
            Toast.success('Plan creado con éxito');
        }
        closeModal();
        loadPlanes();
    } catch (err) {
        console.error(err);
        Toast.error('No se pudo guardar el plan');
    }
  });

  loadPlanes();
});
