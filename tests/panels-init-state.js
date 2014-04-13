module.exports = {
  "Visible panels equals checked panels" : function (browser) {
    browser
      .url("http://localhost:9000/entry/13553")
      .waitForElementVisible('article .panels', 1000)
      .elements('css selector', 'article .panels .visible', function(panelResponse) {
        this.elements('css selector', 'article .panels-menu .fa-check-square-o', function(checkboxResponse) {
          this.assert.equal(panelResponse.value.length, checkboxResponse.value.length)
        })
      })     
  },

  "Show/hide metadata" : function (browser) {
    browser
      .waitForElementVisible('button.toggle-metadata', 1000)
      .click('button.toggle-metadata')
      .pause(500)
      .assert.visible('button.toggle-metadata + ul')
      .click('button.toggle-metadata')
      .pause(500)
      .assert.hidden('button.toggle-metadata + ul')
  },


  "Hide/show annotations" : function (browser) {
    browser.myHide = function() {
      browser
        .click('.elaborate-annotated-text.visible i.toggle-annotations')
        .pause(1000)
        .assert.cssProperty('.elaborate-annotated-text.visible .annotations', 'opacity', '0')
      
      return browser
    }

    browser.myShow = function() {
      browser
        .click('.elaborate-annotated-text.visible i.toggle-annotations')
        .pause(1000)
        .assert.cssProperty('.elaborate-annotated-text.visible .annotations', 'opacity', '1')

      return browser;
    }
    browser
      .myHide()
      .myShow()
      .myHide()
      .myShow()
  },


  "Show panels menu" : function (browser) {
    browser
      .click('.panels-menu button')
      .pause(500)
      .assert.visible('.panels-menu ul')
  },

  "Show translation panel" : function (browser) {
    browser
      .click('i[data-id="Translation"]')
      .assert.cssClassPresent('article .panels > div:nth-child(5)', 'visible')
      .assert.visible('article .panels > div:nth-child(5)')
  },

  // "Move translation panel in first position" : function (browser) {
  //   browser
  //     .moveToElement('.panels-menu li[data-id="Translation"]', 10, 10)
  //     .mouseButtonDown(function() {

  //       this.moveToElement('.panels-menu > ul > li:first-child', -10, -10, function() {
  //         console.log('here')
  //         this.pause(1000)
  //         this.mouseButtonUp(function() {

  //           this.pause(1000)
  //           this.assert.cssClassPresent('article .panels > div:first-child', 'elaborate-annotated-text')
  //         })
  //       })
  //     })
      
  //     // .end();
  // }

  "Hide panels menu" : function (browser) {
    browser
      .click('.panels-menu button')
      .pause(500)
      .assert.hidden('.panels-menu ul')
      .end()
  },

};