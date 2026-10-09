document.addEventListener('DOMContentLoaded', async () => {
  
  authService.guardRoute();

  if (document.getElementById('verificationsCardsContainer')) {
    await initVerificationsList();
  }

  if (document.getElementById('reviewApplicantName')) {
    await initReviewVerification();
  }
});

let currentVerifTab = 'pendientes';

async function initVerificationsList() {
  const tabs = document.querySelectorAll('#verificationsFilterTabs .filter-tab-pill');
  tabs.forEach(tab => {
    const statusVal = tab.getAttribute('data-status');
    if (statusVal === currentVerifTab) {
      tab.classList.add('active');
    } else {
      tab.classList.remove('active');
    }

    tab.onclick = async () => {
      tabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      currentVerifTab = statusVal;
      await renderVerificationsList();
    };
  });

  await renderVerificationsList();
}

async function renderVerificationsList() {
  const container = document.getElementById('verificationsCardsContainer');
  if (!container) return;

  let res = { items: [] };
  try {
    res = await adminStore.getVerifications(1, 100);
  } catch(e) {
    console.error("No se pudieron cargar las verificaciones", e);
  }
  const all = res.items || [];
  let filtered = all;

  if (currentVerifTab === 'pendientes') {
    filtered = all.filter(v => v.estado === 0);
  } else if (currentVerifTab === 'aprobadas') {
    filtered = all.filter(v => v.estado === 1);
  } else if (currentVerifTab === 'rechazadas') {
    filtered = all.filter(v => v.estado === 2);
  }

  if (filtered.length === 0) {
    container.innerHTML = `
      <div style="text-align:center; padding:30px 16px; color:var(--text-secondary);">
        No hay solicitudes en esta sección.
      </div>
    `;
    return;
  }

  const allUsersRes = await adminStore.getUsers(1, 1000);
  const allUsers = allUsersRes.items || [];

  container.innerHTML = filtered.map(req => {
    const user = allUsers.find(u => u.id === Number(req.idUsuario)) || {};
    const statusBadge = req.estado === 0
      ? `<span class="badge-pill badge-pendiente"><span class="status-dot-amber"></span> Pendiente</span>`
      : req.estado === 1
        ? `<span class="badge-pill badge-productor">Aprobada</span>`
        : `<span class="badge-pill" style="background:#fee2e2; color:#991b1b;">Rechazada</span>`;

    return `
      <div class="applicant-review-card">
        <div class="applicant-card-header">
          <div class="applicant-profile-group">
            <img src="${user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'}" alt="${req.nombreUsuario}" class="applicant-avatar-round" />
            <div>
              <div class="applicant-name-title">${req.nombreUsuario}</div>
              <div style="font-size:0.8rem; color:var(--text-secondary);">${req.rolSubtext}</div>
            </div>
          </div>
          ${statusBadge}
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid var(--border-subtle); padding-top:10px;">
          <span style="font-size:0.75rem; color:var(--text-secondary);">${req.fechaRelativa}</span>
          <a href="revisar-verificacion.html?idSolicitud=${req.idSolicitud}" class="btn-primary" style="width:auto; padding:8px 20px; font-size:0.85rem; text-decoration:none;">
            <span>Revisar</span>
          </a>
        </div>
      </div>
    `;
  }).join('');
}

let currentVerificationRequest = null;
let currentVerificationUser = null;

async function initReviewVerification() {
  const params = new URLSearchParams(window.location.search);
  const idSolicitud = parseInt(params.get('idSolicitud') || params.get('id') || '1', 10);
  
  currentVerificationRequest = await adminStore.getVerificationById(idSolicitud);
  if (!currentVerificationRequest) {
    try {
      const res = await adminStore.getVerifications(1, 1);
      currentVerificationRequest = res.items[0];
    } catch(e) {}
  }
  
  if (currentVerificationRequest) {
    currentVerificationUser = await adminStore.getUserById(currentVerificationRequest.idUsuario);
  }

  const req = currentVerificationRequest;
  const user = currentVerificationUser;

  if (!req || !user) return;

  const nameEl = document.getElementById('reviewApplicantName');
  const subEl = document.getElementById('reviewApplicantSubtext');
  const avatarEl = document.getElementById('reviewApplicantAvatar');

  if (nameEl) nameEl.textContent = req.nombreUsuario;
  if (subEl) subEl.textContent = req.rolSubtext;
  // Use photo URL from backend if available
  if (avatarEl) avatarEl.src = req.fotoPerfil || user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';

  const docIdImg = document.getElementById('reviewDocIdentidadImg');
  const docVerifImg = document.getElementById('reviewDocVerifImg');
  const defaultDoc = 'https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600';
  const defaultSelfie = 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600';

  // Use actual photo URLs from the verification request (DatosRepartidor)
  if (docIdImg) docIdImg.src = req.fotoCedula || defaultDoc;
  if (docVerifImg) docVerifImg.src = req.fotoPerfil || defaultSelfie;

  // Add click handlers for lightbox
  if (docIdImg) docIdImg.onclick = () => viewImageLightbox(docIdImg.src, 'Cédula de identidad');
  if (docVerifImg) docVerifImg.onclick = () => viewImageLightbox(docVerifImg.src, 'Foto de perfil');

  // Show additional verification data
  const cedulaEl = document.getElementById('reviewCedula');
  const placaEl = document.getElementById('reviewPlaca');
  const tipoVehiculoEl = document.getElementById('reviewTipoVehiculo');
  const marcaVehiculoEl = document.getElementById('reviewMarcaVehiculo');
  const municipioEl = document.getElementById('reviewMunicipio');
  const departamentoEl = document.getElementById('reviewDepartamento');
  const bancoEl = document.getElementById('reviewBanco');
  const cuentaEl = document.getElementById('reviewCuenta');

  if (cedulaEl) cedulaEl.textContent = req.numeroCedula || '—';
  if (placaEl) placaEl.textContent = req.placaVehiculo || '—';
  if (tipoVehiculoEl) tipoVehiculoEl.textContent = req.tipoVehiculo || '—';
  if (marcaVehiculoEl) marcaVehiculoEl.textContent = req.marcaVehiculo || '—';
  if (municipioEl) municipioEl.textContent = req.municipio || '—';
  if (departamentoEl) departamentoEl.textContent = req.departamento || '—';
  if (bancoEl) bancoEl.textContent = req.bancoNombre || '—';
  if (cuentaEl) cuentaEl.textContent = req.numeroCuenta || '—';

  // Record policial and licencia
  const recordImg = document.getElementById('reviewRecordPolicialImg');
  const licenciaImg = document.getElementById('reviewLicenciaImg');
  if (recordImg) {
    recordImg.src = req.recordPolicial || 'https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600';
    recordImg.onclick = () => viewImageLightbox(recordImg.src, 'Record Policial');
  }
  if (licenciaImg) {
    licenciaImg.src = req.licencia || 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600';
    licenciaImg.onclick = () => viewImageLightbox(licenciaImg.src, 'Licencia de conducir');
  }

  const approveBtn = document.getElementById('btnApproveVerificationAction');
  const rejectBtn = document.getElementById('btnRejectVerificationAction');

  if (approveBtn) {
    approveBtn.onclick = handleApprove;
  }

  if (rejectBtn) {
    rejectBtn.onclick = handleReject;
  }
}

async function handleApprove() {
  const comment = document.getElementById('reviewCommentsInput')?.value || '';
  const btn = document.getElementById('btnApproveVerificationAction');
  if(btn) btn.disabled = true;
  
  const res = await adminStore.approveVerification(currentVerificationRequest.idSolicitud, comment);

  if (res.success) {
    Toast.success(`¡Verificación de ${currentVerificationRequest.nombreUsuario} aprobada exitosamente!`);
    setTimeout(() => {
      window.location.href = 'verificaciones.html';
    }, 500);
  } else {
    Toast.error('Error al procesar la aprobación');
    if(btn) btn.disabled = false;
  }
}

async function handleReject() {
  const comment = document.getElementById('reviewCommentsInput')?.value.trim();
  if (!comment) {
    Toast.warning('Por favor agrega un comentario o motivo para el rechazo.');
    document.getElementById('reviewCommentsInput')?.focus();
    return;
  }

  const btn = document.getElementById('btnRejectVerificationAction');
  if(btn) btn.disabled = true;

  const res = await adminStore.rejectVerification(currentVerificationRequest.idSolicitud, comment);
  if (res.success) {
    Toast.error(`Solicitud de ${currentVerificationRequest.nombreUsuario} rechazada.`);
    setTimeout(() => {
      window.location.href = 'verificaciones.html';
    }, 500);
  } else {
    Toast.error('Error al procesar el rechazo');
    if(btn) btn.disabled = false;
  }
}

function viewImageLightbox(src, alt = 'Documento') {
  const modal = document.getElementById('imageLightboxModal');
  const img = document.getElementById('lightboxImg');
  if (modal && img) {
    img.src = src;
    img.alt = alt;
    modal.classList.add('active');
  }
}

function closeImageLightbox() {
  const modal = document.getElementById('imageLightboxModal');
  if (modal) modal.classList.remove('active');
}
