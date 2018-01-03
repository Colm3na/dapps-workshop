require(`quasar/dist/quasar.${__THEME}.css`);

import Vue from 'vue';
import Quasar from 'quasar-framework';
import router from './router';

Vue.config.productionTip = false;
Vue.use(Quasar);

if (__THEME === 'mat') {
  require('quasar-extras/roboto-font');
}

import 'quasar-extras/material-icons';

Quasar.start(() => {
  /* eslint-disable no-new */
  new Vue({
    el: '#q-app',
    router,
    /* eslint-disable import/no-unresolved */
    render: h => h(require('./App').default),
  });
});
