document.addEventListener('DOMContentLoaded', async () => {
    try {
        await fetchPlanes();

        const btnCreate = document.getElementById('btnCreatePlan');
        if (btnCreate) {
            btnCreate.addEventListener('click', () => openModal());
        }

        const btnCancel = document.getElementById('btnCancelPlan');
        if (btnCancel) {
            btnCancel.addEventListener('click', closeModal);
        }

        const form = document.getElementById('planForm');
        if (form) {
            form.addEventListener('submit', handleSavePlan);
        }
    } catch (error) {
        console.error('Error inicializando planes:', error);
    }
});

async function fetchPlanes() {
    try {
        const res = await apiService.get('/Suscripciones/planes');
        const tbody = document.getElementById('planesTableBody');
        tbody.innerHTML = '';
        
        if (res && res.data && res.data.length > 0) {
            res.data.forEach(p => {
                const tr = document.createElement('tr');
                const estadoClass = p.estado ? 'status-dot-green' : 'status-dot-amber';
                const estadoText = p.estado ? 'Activo' : 'Inactivo';
                
                tr.innerHTML = `
                    <td><strong>${p.nombrePlan}</strong></td>
                    <td>$${p.precio.toFixed(2)}</td>
                    <td>$${p.coste.toFixed(2)}</td>
                    <td><span class="${estadoClass}"></span> ${estadoText}</td>
                    <td>
                        <button class="btn-outline" style="padding:4px 8px; font-size:12px;" onclick='openModal(${JSON.stringify(p).replace(/'/g, "&apos;")})'>Editar</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        } else {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;">No hay planes registrados</td></tr>';
        }
    } catch (e) {
        console.error(e);
        if (typeof Toast !== 'undefined') Toast.error('Error cargando planes');
    }
}

function openModal(plan = null) {
    const modal = document.getElementById('planModal');
    const title = document.getElementById('modalTitle');
    
    if (plan) {
        title.textContent = 'Editar Plan';
        document.getElementById('planId').value = plan.idTipoPlan;
        document.getElementById('planName').value = plan.nombrePlan;
        document.getElementById('planDesc').value = plan.descripcion;
        document.getElementById('planBen').value = plan.beneficios;
        document.getElementById('planPrice').value = plan.precio;
        document.getElementById('planCost').value = plan.coste;
        document.getElementById('planActive').checked = plan.estado;
    } else {
        title.textContent = 'Crear Nuevo Plan';
        document.getElementById('planId').value = '';
        document.getElementById('planForm').reset();
        document.getElementById('planActive').checked = true;
    }
    
    modal.style.display = 'block';
}

function closeModal() {
    document.getElementById('planModal').style.display = 'none';
}

async function handleSavePlan(e) {
    e.preventDefault();
    const id = document.getElementById('planId').value;
    
    const payload = {
        nombrePlan: document.getElementById('planName').value,
        descripcion: document.getElementById('planDesc').value,
        beneficios: document.getElementById('planBen').value,
        precio: parseFloat(document.getElementById('planPrice').value),
        coste: parseFloat(document.getElementById('planCost').value),
        estado: document.getElementById('planActive').checked
    };

    try {
        if (id) {
            // Edit
            payload.idTipoPlan = parseInt(id);
            await apiService.put(`/Suscripciones/planes`, payload);
            if (typeof Toast !== 'undefined') Toast.success('Plan actualizado correctamente');
        } else {
            // Create
            await apiService.post('/Suscripciones/planes', payload);
            if (typeof Toast !== 'undefined') Toast.success('Plan creado correctamente');
        }
        
        closeModal();
        await fetchPlanes();
    } catch (error) {
        console.error('Error guardando plan:', error);
        if (typeof Toast !== 'undefined') Toast.error('Error al guardar el plan');
    }
}
