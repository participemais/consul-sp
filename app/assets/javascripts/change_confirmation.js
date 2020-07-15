(() => {
  'use strict';
  App.ChangeConfirmation = {
    warning: () => {
      function textMessage(field) {
        return `O campo de ${field} só pode ser alterado uma vez. Verifique se ele está preenchido corretamente antes de atualizá-lo.`
      }

      $(".js-document-number-confirmation").one("keyup", (handler) => {
        const field = handler.target.previousSibling.innerText;
        alert(textMessage(field));
      });

      $(".js-date-of-birth-confirmation").one("change", (handler) => {
        const field = handler.target.previousSibling.innerText.toLowerCase();
        alert(textMessage(field));
      });
    },
    initialize: () => {
      App.ChangeConfirmation.warning();
    }
  }
}).call(this);
