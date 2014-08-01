//module.exports = {
//  'jQuery UI sortable': function(browser) {
//    browser
//      .url('http://jqueryui.com/resources/demos/sortable/default.html')
//      .waitForElementVisible('#sortable > li:first-child', 1000)
//      .moveToElement('#sortable > li:first-child', 10, 10)
//      .mouseButtonDown()
//      .moveTo(0, 60)
//      .mouseButtonUp()
//      .assert.containsText('#sortable > li:nth-child(2)', 'Item 1')
//      .end()
//  }
//}