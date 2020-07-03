(() => {
  'use strict';
  App.Masks = {
    initialize: () => {
      const translation = {
        'A': { pattern: /[01]/ },
        'B': { pattern: /[12]/ },
        'C': { pattern: /[0-3]/ },
        'W': { pattern: /[a-z]/i },
        'Z': { pattern: /[a-z\d]/i }
      };

      $('input.js-date-of-birth-mask').mask('C0/A0/B000', { translation });
      $('input.js-cpf-mask').mask('000.000.000-00');
      $('input.js-cep-mask').mask('00000-000');
      $('input.js-rnm-mask').mask('W000000-Z', { translation });
    }
  }
}).call(this);
