document.addEventListener('DOMContentLoaded', () => {
  
  authService.guardRoute();

  if (document.getElementById('verificationsCardsContainer')) {
    initVerificationsList();
  }

  if (document.getElementById('reviewApplicantName')) {
    initReviewVerification();
  }
});

let currentVerifTab = 'pendientes';

function initVerificationsList() {
  const tabs = document.querySelectorAll('#verificationsFilterTabs .filter-tab-pill');
  tabs.forEach(tab => {
    const statusVal = tab.getAttribute('data-status');
    if (statusVal === currentVerifTab) {
      tab.classList.add('active');
    } else {
      tab.classList.remove('active');
    }

    tab.onclick = () => {
      tabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      currentVerifTab = statusVal;
      renderVerificationsList();
    };
  });

  renderVerificationsList();
}

function renderVerificationsList() {
  const container = document.getElementById('verificationsCardsContainer');
  if (!container) return;

  const all = adminStore.getVerifications();
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

  container.innerHTML = filtered.map(req => {
    const user = adminStore.getUserById(req.idUsuario) || {};
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

function initReviewVerification() {
  const params = new URLSearchParams(window.location.search);
  const idSolicitud = parseInt(params.get('idSolicitud') || params.get('id') || '1', 10);
  currentVerificationRequest = adminStore.getVerificationById(idSolicitud) || adminStore.getVerifications()[0];
  currentVerificationUser = adminStore.getUserById(currentVerificationRequest.idUsuario) || adminStore.getUsers()[0];

  const req = currentVerificationRequest;
  const user = currentVerificationUser;

  if (!req || !user) return;

  const nameEl = document.getElementById('reviewApplicantName');
  const subEl = document.getElementById('reviewApplicantSubtext');
  const avatarEl = document.getElementById('reviewApplicantAvatar');

  if (nameEl) nameEl.textContent = req.nombreUsuario;
  if (subEl) subEl.textContent = req.rolSubtext;
  if (avatarEl) avatarEl.src = user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';

  const docIdImg = document.getElementById('reviewDocIdentidadImg');
  const docVerifImg = document.getElementById('reviewDocVerifImg');
  const defaultDoc = 'https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600';
  const defaultSelfie = 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600';

  if (docIdImg) docIdImg.src = user.documentos?.identidad || defaultDoc;
  if (docVerifImg) docVerifImg.src = user.documentos?.verificacion || defaultSelfie;

  const farmName = document.getElementById('reviewFarmName');
  const farmRuc = document.getElementById('reviewFarmRuc');
  const farmExt = document.getElementById('reviewFarmExt');

  if (farmName) farmName.textContent = user.finca?.nombre || 'Agropecuaria La Esperanza S.A.';
  if (farmRuc) farmRuc.textContent = user.finca?.ruc || '3004123456-7';
  if (farmExt) farmExt.textContent = user.finca?.extension || '50 Hectáreas';

  const approveBtn = document.getElementById('btnApproveVerificationAction');
  const rejectBtn = document.getElementById('btnRejectVerificationAction');

  if (approveBtn) {
    approveBtn.onclick = handleApprove;
  }

  if (rejectBtn) {
    rejectBtn.onclick = handleReject;
  }
}

function handleApprove() {
  const comment = document.getElementById('reviewCommentsInput')?.value || '';
  const res = adminStore.approveVerification(currentVerificationRequest.idSolicitud, comment);

  if (res.success) {
    Toast.success(`¡Verificación de ${currentVerificationRequest.nombreUsuario} aprobada exitosamente!`);
    setTimeout(() => {
      window.location.href = 'verificaciones.html';
    }, 500);
  } else {
    Toast.error('Error al procesar la aprobación');
  }
}

function handleReject() {
  const comment = document.getElementById('reviewCommentsInput')?.value.trim();
  if (!comment) {
    Toast.warning('Por favor agrega un comentario o motivo para el rechazo.');
    document.getElementById('reviewCommentsInput')?.focus();
    return;
  }

  const res = adminStore.rejectVerification(currentVerificationRequest.idSolicitud, comment);
  if (res.success) {
    Toast.error(`Solicitud de ${currentVerificationRequest.nombreUsuario} rechazada.`);
    setTimeout(() => {
      window.location.href = 'verificaciones.html';
    }, 500);
  } else {
    Toast.error('Error al procesar el rechazo');
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
