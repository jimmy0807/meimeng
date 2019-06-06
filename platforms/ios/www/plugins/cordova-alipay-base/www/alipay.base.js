cordova.define("cordova-alipay-base.AlipayBase", function(require, exports, module) {
var exec = require('cordova/exec');

module.exports = {
	Base:{
		pay: function (order, successCallback, errorCallback) {
			cordova.exec(successCallback, errorCallback, "AlipayBase", "pay", [order]);
		}
	}
};

});
