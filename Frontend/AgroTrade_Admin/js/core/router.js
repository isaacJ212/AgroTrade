

class AppRouter {
  constructor() {
    this.currentRoute = 'resumen';
    this.historyStack = ['resumen'];
    this.views = {};
  }

  registerView(name, viewController) {
    this.views[name] = viewController;
  }

  navigateTo(routeName, params = null) {
    
    if (this.currentRoute !== routeName) {
      this.historyStack.push(routeName);
    }
    this.currentRoute = routeName;

    
    document.querySelectorAll('.app-screen-view').forEach(screen => {
      screen.classList.add('hidden');
    });

    const targetScreen = document.getElementById(`screen-${routeName}`);
    if (targetScreen) {
      targetScreen.classList.remove('hidden');
    }

    
    this.updateBottomNav(routeName);

    
    const content = targetScreen?.querySelector('.content-body');
    if (content) content.scrollTop = 0;

    
    if (this.views[routeName] && typeof this.views[routeName].onEnter === 'function') {
      this.views[routeName].onEnter(params);
    }
  }

  navigateBack() {
    if (this.historyStack.length > 1) {
      this.historyStack.pop(); 
      const prevRoute = this.historyStack[this.historyStack.length - 1];
      this.currentRoute = prevRoute;
      
      document.querySelectorAll('.app-screen-view').forEach(screen => {
        screen.classList.add('hidden');
      });

      const targetScreen = document.getElementById(`screen-${prevRoute}`);
      if (targetScreen) {
        targetScreen.classList.remove('hidden');
      }

      this.updateBottomNav(prevRoute);

      if (this.views[prevRoute] && typeof this.views[prevRoute].onEnter === 'function') {
        this.views[prevRoute].onEnter();
      }
    } else {
      this.navigateTo('resumen');
    }
  }

  updateBottomNav(route) {
    
    const tabMap = {
      'resumen': 'resumen',
      'usuarios': 'usuarios',
      'usuario-detalle': 'usuarios',
      'categorias': 'catalogo',
      'nueva-categoria': 'catalogo',
      'verificaciones': 'resumen',
      'revisar-verificacion': 'resumen',
      'perfil': 'perfil'
    };

    const activeTab = tabMap[route] || 'resumen';

    document.querySelectorAll('.bottom-tab-item').forEach(item => {
      const tab = item.getAttribute('data-tab');
      item.classList.toggle('active', tab === activeTab);
    });
  }
}

const router = new AppRouter();
