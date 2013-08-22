define(function(require) {
  var $, Fn, chai, mixin;
  chai = require('chai');
  mixin = require('/dev/jquery.mixin.js');
  $ = require('jquery');
  Fn = require('/dev/fns.js');
  chai.should();
  describe("Fn", function() {
    describe("generateID()", function() {
      it("Without parameters the ID should have 8 chars", function() {
        return Fn.generateID().should.have.length(8);
      });
      it("With a parameter (1-20) the ID should have the length (1-20) of the parameter", function() {
        var i, _i, _results;
        _results = [];
        for (i = _i = 1; _i < 20; i = ++_i) {
          _results.push(Fn.generateID(i).should.have.length(i));
        }
        return _results;
      });
      return it("An ID starts with a letter", function() {
        return Fn.generateID().should.match(/^[a-zA-Z]/);
      });
    });
    describe("deepCopy()", function() {
      var originalArray, originalObject;
      originalArray = ["sint", "niklaas", 14, ["la", "li"]];
      originalObject = {
        Sint: "Niklaas",
        Jan: "Maat",
        During: 12,
        la: {
          li: "leuk"
        }
      };
      it("should create an equal copy of an object", function() {
        var copy;
        copy = Fn.deepCopy(originalObject);
        return copy.should.eql(originalObject);
      });
      it("should create an equal copy of an array", function() {
        var copy;
        copy = Fn.deepCopy(originalArray);
        return copy.should.eql(originalArray);
      });
      return it("should not reference", function() {
        var copy;
        copy = Fn.deepCopy(originalObject);
        copy.la.li = "lachen";
        return copy.should.not.eql(originalObject);
      });
    });
    describe("timeoutWithReset()", function() {
      return it("should fire only once", function(done) {
        var cb_called;
        cb_called = 0;
        Fn.timeoutWithReset(18, function() {
          return cb_called++;
        });
        Fn.timeoutWithReset(22, function() {
          return cb_called++;
        });
        return setTimeout((function() {
          cb_called.should.equal(1);
          return done();
        }), 50);
      });
    });
    describe("stripTags(str)", function() {
      return it("should strip the tags from a string", function() {
        var str;
        str = "This is <b>very</b> <input /> strange";
        Fn.stripTags(str).should.not.contain("<b>");
        Fn.stripTags(str).should.not.contain("</b>");
        return Fn.stripTags(str).should.not.contain("<input />");
      });
    });
    return describe("onlyNumbers", function() {
      return it("should strip all non numbers from a string", function() {
        var str;
        str = "<10>_$%11 There were 12 little piggies, what! 14? Yeah! 13";
        return Fn.onlyNumbers(str).should.equal("1011121413");
      });
    });
  });
  return describe("$", function() {
    describe("(el:contains(query))", function() {
      var $div;
      $div = null;
      before(function() {
        var text;
        text = '<span>Dit is test tekst!</span><span>Tekst is test dit!</span><span>Dit is test text!</span><span>Text is test dit!</span>';
        return $div = $('<div id="testdiv" />').html(text);
      });
      it('should find two els when searching for "tekst"', function() {
        return $div.find('span:contains(tekst)').length.should.equal(2);
      });
      it('should find one el when searching for "test text"', function() {
        return $div.find('span:contains(test text)').length.should.equal(1);
      });
      return it('should find four els when searching for "dit"', function() {
        return $div.find('span:contains(dit)').length.should.equal(4);
      });
    });
    describe("(el).scrollTo(pos)", function() {
      var $div, pos;
      pos = void 0;
      $div = void 0;
      before(function() {
        $div = $("<div id=\"scrollablediv\" style=\"width: 100px; height: 100px; overflow: auto\" />");
        $div.html("<p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p>some<br>text</p><p id=\"anchor\" style=\"color: red;\">some<br>text</p><p>some<br>text</p>");
        $("#sandbox").html($div);
        return pos = $("#anchor").position();
      });
      beforeEach(function() {
        return $div.scrollTop(0);
      });
      it("should scroll", function(done) {
        var scrolled;
        scrolled = false;
        $div.scroll(function() {});
        scrolled = true;
        return $div.scrollTo(pos.top, {
          duration: 100,
          complete: function() {
            scrolled.should.be.ok;
            return done();
          }
        });
      });
      return it("should scroll into position", function(done) {
        return $div.scrollTo(pos.top, {
          duration: 100,
          complete: function() {
            $("#anchor").position().top.should.equal(0);
            return done();
          }
        });
      });
    });
    return describe("(el).highlight()", function() {
      var $span;
      $span = void 0;
      before(function() {
        return $span = $("<span />").html("test span");
      });
      it("sets the highlight class", function() {
        $span.highlight(200);
        return $span.hasClass("highlight").should.be.ok;
      });
      return it("removes the highlight class after 0.2s delay", function(done) {
        return setTimeout((function() {
          $span.hasClass("highlight").should.not.be.ok;
          return done();
        }), 300);
      });
    });
  });
});
