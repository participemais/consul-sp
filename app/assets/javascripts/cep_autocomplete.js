(() => {
  'use strict';
  App.CEPAutocomplete = {
    initialize: () => {
      const $address = $('#account_home_address');
      const $city = $('#account_city');
      const $uf = $('#account_uf');
      const $neighbourhood = $('#account_neighbourhood');

      function clear_address_fields() {
        $address.val('');
        $city.val('');
        $uf.val('');
      }

      $('#account_cep').blur((handler) => {
        const cep = handler.target.value.replace(/\D/g, '');
        const $cep = $(handler.target);
        $cep.removeClass('is-invalid-input');

        if (cep.length == 8) {
          const url = `https://viacep.com.br/ws/${cep}/json/`;
          fetch(url)
            .then(response => response.json())
            .then(data => {
              if (!data.erro) {
                $('.hide-fields').fadeIn(1000);
                $address.val(data.logradouro);
                $city.val(data.localidade);
                $uf.val(data.uf);
                $neighbourhood.val(data.bairro);
              } else {
                $('.hide-fields').fadeOut(1500);
                $cep.addClass('is-invalid-input');
                clear_address_fields();
                alert('CEP inválido');
              }
            });
        } else {
          $('.hide-fields').fadeOut(1500);
          $cep.addClass('is-invalid-input');
          clear_address_fields();
        }
      })
    }
  }
}).call(this);
