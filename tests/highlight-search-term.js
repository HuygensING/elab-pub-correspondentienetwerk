var config = require('./config.js');

module.exports = {
  "Highlight search term" : function (browser) {
    browser
      .url(config.baseUrl+"/search")
      .waitForElementVisible('.resultview .entries ul.page', 10000)
      .setValue('.search-input input[name="search"]', 't*st')
      .click('.search-input i.fa-search')
      .pause(2000)
      .click('.resultview .entries > ul.page > li:nth-child(5) .keywords > ul > li:first-child')
      .pause(2000)
      .assert.containsText('span.highlight-term', 'troest')
      .getLocation('span.highlight-term', function(termResult) {
        this.getLocation('article .panels', function(panelsResult) {
          this.assert.equal(termResult.value.y, panelsResult.value.y + 40);
        });
      })
      .end();
      
  }
};