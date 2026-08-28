

document.addEventListener('DOMContentLoaded', () => {
  
  authService.guardRoute();

  
  router.registerView('resumen', dashboardView);
  router.registerView('usuarios', userListView);
  router.registerView('usuario-detalle', userDetailView);
  router.registerView('verificaciones', verificationsView);
  router.registerView('revisar-verificacion', reviewVerificationView);
  router.registerView('categorias', categoryListView);
  router.registerView('nueva-categoria', categoryFormView);
  router.registerView('perfil', profileView);

  
  document.querySelectorAll('.bottom-tab-item').forEach(btn => {
    btn.addEventListener('click', () => {
      const targetRoute = btn.getAttribute('data-tab');
      if (targetRoute === 'catalogo') {
        router.navigateTo('categorias');
      } else if (targetRoute) {
        router.navigateTo(targetRoute);
      }
    });
  });

  
  router.navigateTo('resumen');
});
