module.exports = {
  "Demo test Google" : function (browser) {
    browser
      .url("http://localhost:9000/search")
      .waitForElementVisible('.resultview .entries ul.page', 10000)
      .setValue('.search-input input[name="search"]', 't*st')
      .click('.search-input i.fa-search')
      .pause(2000)
      .click('.resultview .entries > ul.page > li:nth-child(5) .keywords > ul > li:first-child')
      .pause(2000)
      .assert.containsText('span.highlight-term', 'troest')
      .getLocation('span.highlight-term', function(result) {
        this.getLocation('article .panels', function(panelsResult) {
          this.assert.equal(result.value.x, 200)
          this.assert.equal(result.value.y, 200)
          this.assert.equal(panelsResult.value.y, 200)
          this.assert.equal(panelsResult.value.y, 200)
          
        })
      })
      .end();
  }
};