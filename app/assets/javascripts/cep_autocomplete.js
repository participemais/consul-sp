(() => {
  'use strict';
  App.CEPAutocomplete = {
    initialize: () => {
      $('#account_cep').blur((handler) => {
        const cep = handler.target.value.replace(/\D/g, '');

        if (cep.length == 8) {
          const url = `https://viacep.com.br/ws/${cep}/json/`;
          fetch(url)
            .then(response => response.json())
            .then(data => {
              $("#account_home_address").val(data.logradouro);
              $("#account_city").val(data.localidade);
              $("#account_uf").val(data.uf);
            });
        }

      })
    }
  }
}).call(this);
