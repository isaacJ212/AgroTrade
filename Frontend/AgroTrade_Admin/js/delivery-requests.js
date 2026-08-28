
class DeliveryReviewsManager {
  constructor() {
    this.currentRequest = null;
  }

  init() {
    this.bindModalEvents();
  }



  openReviewModal(idSolicitud) {
    const request = store.getRequestById(idSolicitud);
    if (!request) {
      this.showToast('Solicitud no encontrada', 'error');
      return;
    }

    this.currentRequest = request;
    this.populateModalData(request);

    const modal = document.getElementById('reviewModal');
    if (modal) {
      modal.classList.add('active');
    }
  }

  closeReviewModal() {
    const modal = document.getElementById('reviewModal');
    if (modal) {
      modal.classList.remove('active');
    }
    this.currentRequest = null;
    const commentInput = document.getElementById('reviewCommentInput');
    if (commentInput) commentInput.value = '';
  }

  populateModalData(req) {

    const title = document.getElementById('modalApplicantName');
    const badgeRole = document.getElementById('modalApplicantRole');
    if (title) title.textContent = req.nombreUsuario;
    if (badgeRole) {
      badgeRole.textContent = req.tipoRol === 'productor' ? 'Productor' : 'Repartidor';
      badgeRole.className = `badge ${req.tipoRol === 'productor' ? 'badge-green' : 'badge-blue'}`;
    }

    
    document.getElementById('modalCedula').textContent = req.datosRepartidor?.numeroCedula || 'N/A';
    document.getElementById('modalZona').textContent = req.datosRepartidor?.zonaOperaciones || 'N/A';
    document.getElementById('modalDepartamento').textContent = req.datosRepartidor?.departamento || 'N/A';
    

    document.getElementById('modalVehiculo').textContent = req.datosRepartidor?.tipoVehiculo || 'N/A';
    document.getElementById('modalMarca').textContent = req.datosRepartidor?.marcaVehiculo || 'N/A';
    document.getElementById('modalPlaca').textContent = req.datosRepartidor?.placaVehiculo || 'N/A';

  
    document.getElementById('modalBanco').textContent = req.datosRepartidor?.bancoNombre || 'N/A';
    document.getElementById('modalCuenta').textContent = req.datosRepartidor?.numeroCuenta || 'N/A';


    const docsContainer = document.getElementById('modalDocsGallery');
    if (docsContainer) {
      const docs = [
        { label: 'Cédula de Identidad', url: req.datosRepartidor?.urlFotoCedula },
        { label: 'Licencia de Conducir', url: req.datosRepartidor?.urlLicencia },
        { label: 'Récord Policial', url: req.datosRepartidor?.urlRecordPolicial }
      ];

      docsContainer.innerHTML = docs.map(doc => `
        <div class="doc-thumb-card" onclick="deliveryManager.viewFullImage('${doc.url}', '${doc.label}')">
          <img src="${doc.url}" alt="${doc.label}" class="doc-thumb-img" loading="lazy" />
          <div class="doc-thumb-label">${doc.label}</div>
        </div>
      `).join('');
    }
  }

  bindModalEvents() {
    const closeBtn = document.getElementById('closeModalBtn');
    const modalBackdrop = document.getElementById('reviewModal');
    const approveBtn = document.getElementById('btnApproveRequest');
    const rejectBtn = document.getElementById('btnRejectRequest');
    const imageViewer = document.getElementById('imageViewerModal');
    const closeImageViewer = document.getElementById('closeImageViewerBtn');

    if (closeBtn) closeBtn.addEventListener('click', () => this.closeReviewModal());
    
    if (modalBackdrop) {
      modalBackdrop.addEventListener('click', (e) => {
        if (e.target === modalBackdrop) this.closeReviewModal();
      });
    }

    if (approveBtn) {
      approveBtn.addEventListener('click', () => this.handleDecision(1));
    }

    if (rejectBtn) {
      rejectBtn.addEventListener('click', () => this.handleDecision(2));
    }

    if (closeImageViewer && imageViewer) {
      closeImageViewer.addEventListener('click', () => {
        imageViewer.classList.remove('active');
      });
      imageViewer.addEventListener('click', (e) => {
        if (e.target === imageViewer) imageViewer.classList.remove('active');
      });
    }
  }

  viewFullImage(url, label) {
    const viewer = document.getElementById('imageViewerModal');
    const img = document.getElementById('imageViewerImg');
    if (viewer && img) {
      img.src = url;
      img.alt = label;
      viewer.classList.add('active');
    }
  }

  async handleDecision(estado) {
    if (!this.currentRequest) return;

    const commentInput = document.getElementById('reviewCommentInput');
    const comentario = commentInput ? commentInput.value.trim() : '';

    if (estado === 2 && !comentario) {
      this.showToast('Debes ingresar un motivo para rechazar la solicitud.', 'warning');
      if (commentInput) commentInput.focus();
      return;
    }

    const id = this.currentRequest.idSolicitud;
    const applicantName = this.currentRequest.nombreUsuario;
    const isApproved = estado === 1;

    const res = await apiService.reviewDeliveryRequest(id, estado, comentario);

    if (res.success) {
      this.closeReviewModal();
      const actionText = isApproved ? 'aprobada con éxito' : 'rechazada';
      this.showToast(`Solicitud de ${applicantName} ${actionText}`, isApproved ? 'success' : 'error');
      

      if (window.app) {
        window.app.renderDashboard();
      }
    } else {
      this.showToast('Error al procesar la solicitud', 'error');
    }
  }

  showToast(message, type = 'success') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    let iconSvg = '';
    if (type === 'success') {
      iconSvg = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`;
    } else if (type === 'error') {
      iconSvg = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
    } else {
      iconSvg = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;
    }

    toast.innerHTML = `${iconSvg}<span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(-10px)';
      toast.style.transition = 'all 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, 3500);
  }
}

const deliveryManager = new DeliveryReviewsManager();
