(() => {
  'use strict';
  App.CEPAutocomplete = {
    initialize: () => {
      function clear_address_fields() {
        $('#account_home_address').val('');
        $('#account_city').val('');
        $('#account_uf').val('');
      }

      $('#account_cep').blur((handler) => {
        const cep = handler.target.value.replace(/\D/g, '');
        const $input = $(handler.target);
        $input.removeClass('is-invalid-input');

        if (cep.length == 8) {
          const url = `https://viacep.com.br/ws/${cep}/json/`;
          fetch(url)
            .then(response => response.json())
            .then(data => {
              if (!data.erro) {
                $('#account_home_address').val(data.logradouro);
                $('#account_city').val(data.localidade);
                $('#account_uf').val(data.uf);
              } else {
                $input.addClass('is-invalid-input');
                clear_address_fields();
                alert('CEP inválido');
              }
            });
        } else {
          $input.addClass('is-invalid-input');
          clear_address_fields();
        }

      })
    }
  }
}).call(this);
