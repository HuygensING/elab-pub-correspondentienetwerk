module.exports = {
  "Highlight annotation" : function (browser) {
    browser
      .url("http://localhost:9000/annotations")
      .waitForElementVisible('.contents section ol li:nth-child(2) .link a', 1000)
      .click('.contents section ol li:nth-child(2) .link a')
      .waitForElementVisible('.annotations ol li[data-id="9063676"]', 1000)
      .assert.cssClassPresent('.annotations ol li[data-id="9063676"]', 'show')
      .getLocation('sup[data-id="9063676"]', function(result) {
        this.assert.equal(result.value.y, 372);
      })
      .end();
      
  }
};