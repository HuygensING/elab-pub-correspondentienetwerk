module.exports = {
  "Reset Faceted Search" : function (browser) {
    browser.myReset = function () {
      browser.click('ul.facets-menu li.reset button')
        .pause(2000)
        .assert.containsText('.results-placeholder > header > h3', 'Found 64 entries')

      return browser;
    }

    browser.mySearch = function (value, count) {
      browser.clearValue('.search-input input[name="search"]')
        .setValue('.search-input input[name="search"]', value)
        .click('.search-input i.fa-search')
        .pause(2000)
        .assert.containsText('.results-placeholder > header > h3', 'Found '+count+' entries')

      return browser;
    }

    browser
      .url("http://localhost:9000/search")
      .waitForElementVisible('.resultview .entries ul.page', 10000)
      .mySearch('t*st', 13)
      .myReset()
      .mySearch('jaar', 43)
      .myReset()
      .mySearch('t*st', 13)
      .myReset()
      .mySearch('t*st', 13)
      .end();
      
  }
};