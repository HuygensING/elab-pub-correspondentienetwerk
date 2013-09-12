(function() {
  define(function(require) {
    var ModalManager;
    ModalManager = (function() {
      function ModalManager() {
        this.modals = [];
      }

      ModalManager.prototype.add = function(modal) {
        var arrLength, m, _i, _len, _ref;
        _ref = this.modals;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          m = _ref[_i];
          m.$('.overlay').css('opacity', '0.2');
        }
        arrLength = this.modals.push(modal);
        modal.$('.overlay').css('z-index', 10000 + (arrLength * 2) - 1);
        modal.$('.modalbody').css('z-index', 10000 + (arrLength * 2));
        return $('body').prepend(modal.$el);
      };

      ModalManager.prototype.remove = function(modal) {
        var index;
        index = this.modals.indexOf(modal);
        this.modals.splice(index, 1);
        if (this.modals.length > 0) {
          this.modals[this.modals.length - 1].$('.overlay').css('opacity', '0.7');
        }
        return modal.remove();
      };

      return ModalManager;

    })();
    return new ModalManager();
  });

}).call(this);
