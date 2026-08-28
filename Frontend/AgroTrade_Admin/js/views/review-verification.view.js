

class ReviewVerificationView {
  constructor() {
    this.currentReq = null;
    this.currentUser = null;
  }

  onEnter(params) {
    const idSolicitud = params?.idSolicitud || 1;
    this.currentReq = adminStore.getVerificationById(idSolicitud) || adminStore.getVerifications()[0];
    this.currentUser = adminStore.getUserById(this.currentReq.idUsuario) || adminStore.getUsers()[0];
    this.render();
    this.bindActions();
  }

  render() {
    const req = this.currentReq;
    const user = this.currentUser;
    if (!req || !user) return;

    
    document.getElementById('reviewApplicantName').textContent = req.nombreUsuario;
    document.getElementById('reviewApplicantSubtext').textContent = req.rolSubtext;
    const avatarEl = document.getElementById('reviewApplicantAvatar');
    if (avatarEl) avatarEl.src = user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';

    
    const docIdImg = document.getElementById('reviewDocIdentidadImg');
    const docVerifImg = document.getElementById('reviewDocVerifImg');
    const defaultDoc = 'https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600';
    const defaultSelfie = 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600';

    if (docIdImg) docIdImg.src = user.documentos?.identidad || defaultDoc;
    if (docVerifImg) docVerifImg.src = user.documentos?.verificacion || defaultSelfie;

    
    document.getElementById('reviewFarmName').textContent = user.finca?.nombre || 'Agropecuaria La Esperanza S.A.';
    document.getElementById('reviewFarmRuc').textContent = user.finca?.ruc || '3004123456-7';
    document.getElementById('reviewFarmExt').textContent = user.finca?.extension || '50 Hectáreas';

    
    document.querySelectorAll('.checklist-checkbox').forEach(cb => cb.checked = false);
    const commentInput = document.getElementById('reviewCommentsInput');
    if (commentInput) commentInput.value = '';
  }

  bindActions() {
    const approveBtn = document.getElementById('btnApproveVerificationAction');
    const rejectBtn = document.getElementById('btnRejectVerificationAction');

    if (approveBtn) {
      approveBtn.onclick = () => this.handleApprove();
    }

    if (rejectBtn) {
      rejectBtn.onclick = () => this.handleReject();
    }
  }

  handleApprove() {
    const comment = document.getElementById('reviewCommentsInput')?.value || '';
    const res = adminStore.approveVerification(this.currentReq.idSolicitud, comment);

    if (res.success) {
      Toast.success(`¡Verificación de ${this.currentReq.nombreUsuario} aprobada exitosamente!`);
      setTimeout(() => router.navigateBack(), 400);
    } else {
      Toast.error('Error al procesar la aprobación');
    }
  }

  handleReject() {
    const comment = document.getElementById('reviewCommentsInput')?.value.trim();
    if (!comment) {
      Toast.warning('Por favor agrega un comentario o motivo para el rechazo.');
      document.getElementById('reviewCommentsInput')?.focus();
      return;
    }

    const res = adminStore.rejectVerification(this.currentReq.idSolicitud, comment);
    if (res.success) {
      Toast.error(`Solicitud de ${this.currentReq.nombreUsuario} rechazada.`);
      setTimeout(() => router.navigateBack(), 400);
    } else {
      Toast.error('Error al procesar el rechazo');
    }
  }

  viewImage(src, alt = 'Documento') {
    const modal = document.getElementById('imageLightboxModal');
    const img = document.getElementById('lightboxImg');
    if (modal && img) {
      img.src = src;
      img.alt = alt;
      modal.classList.add('active');
    }
  }

  closeImage() {
    const modal = document.getElementById('imageLightboxModal');
    if (modal) modal.classList.remove('active');
  }
}

const reviewVerificationView = new ReviewVerificationView();
