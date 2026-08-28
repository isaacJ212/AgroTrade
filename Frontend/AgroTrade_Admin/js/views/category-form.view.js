

class CategoryFormView {
  constructor() {
    this.form = null;
  }

  onEnter() {
    this.resetForm();
    this.bindEvents();
  }

  resetForm() {
    const nameInput = document.getElementById('categoryNameInput');
    const descInput = document.getElementById('categoryDescInput');
    const descGroup = document.getElementById('categoryDescGroup');
    const errorMsg = document.getElementById('categoryDescError');

    if (nameInput) nameInput.value = '';
    if (descInput) descInput.value = '';
    if (descGroup) descGroup.classList.remove('has-error');
    if (errorMsg) errorMsg.classList.add('hidden');
  }

  bindEvents() {
    const submitBtn = document.getElementById('btnSubmitCreateCategory');
    const cancelBtn = document.getElementById('btnCancelCreateCategory');

    if (submitBtn) {
      submitBtn.onclick = () => this.handleSubmit();
    }

    if (cancelBtn) {
      cancelBtn.onclick = () => router.navigateBack();
    }
  }

  handleSubmit() {
    const nameInput = document.getElementById('categoryNameInput');
    const descInput = document.getElementById('categoryDescInput');
    const descGroup = document.getElementById('categoryDescGroup');
    const errorMsg = document.getElementById('categoryDescError');

    const name = nameInput ? nameInput.value.trim() : '';
    const desc = descInput ? descInput.value.trim() : '';

    if (!name) {
      Toast.warning('Por favor ingresa el nombre de la categoría.');
      nameInput?.focus();
      return;
    }

    if (!desc) {
      if (descGroup) descGroup.classList.add('has-error');
      if (errorMsg) errorMsg.classList.remove('hidden');
      descInput?.focus();
      return;
    }

    
    adminStore.addCategory({
      nombre: name,
      descripcion: desc,
      icono: 'apple'
    });

    Toast.success(`Categoría "${name}" creada exitosamente.`);
    setTimeout(() => {
      router.navigateTo('categorias');
    }, 300);
  }
}

const categoryFormView = new CategoryFormView();
