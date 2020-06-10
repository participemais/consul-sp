(() => {
  'use strict';
  App.Masks = {
    initialize: () => {
      const translation = {
        'A': { pattern: /[01]/ },
        'B': { pattern: /[12]/ },
        'C': { pattern: /[0-3]/ },
        'Z': { pattern: /[a-zA-Z]/ }
      };

      $('input.js-date-of-birth-mask').mask('C0/A0/B000', { translation });
      $('input.js-cpf-mask').mask('000.000.000-00');
      $('input.js-cep-mask').mask('00000-000');
      $('input.js-rnm-mask').mask('Z000000-Z', { translation });
    }
  }
}).call(this);
