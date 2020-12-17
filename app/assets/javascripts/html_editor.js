(function() {
  "use strict";
  App.HTMLEditor = {
    destroy: function() {
      for (var name in CKEDITOR.instances) {
        CKEDITOR.instances[name].destroy();
      }
    },
    initialize: function() {
      $("textarea.html-area").each(function() {
        if ($(this).hasClass("admin")) {
          CKEDITOR.replace(this.name, { language: $("html").attr("lang"), toolbar: "admin", height: 500 });
        }
        else if ($(this).hasClass("simple")) {
          CKEDITOR.replace(this.name, { language: $("html").attr("lang"), toolbar: "simple", height: 500 });
        }
        else {
          CKEDITOR.replace(this.name, { language: $("html").attr("lang") });
        }
      });
    }
  };

  $(document).on("page:before-unload", App.HTMLEditor.destroy);
  $(document).on("page:restore", App.HTMLEditor.initialize);
}).call(this);
