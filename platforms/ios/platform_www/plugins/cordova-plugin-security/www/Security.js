cordova.define("cordova-plugin-security.Security", function(require, exports, module) {
//cordova.define("cordova-plugin-security.Security", function(require, exports, module) {
var exec = require('cordova/exec');

module.exports = {
    deviceRegister: function (data,success, error) {
        exec(success, error, "Security", "deviceRegister", [data]);
    },
    sign: function (data, success, error) {
        exec(success, error, "Security", "sign", [data]);
    },
    signCommon: function (data, success, error) {
        exec(success, error, "Security", "signCommon", [data]);
    },
    init: function (data, success, error) {
        exec(success, error, "Security", "deviceInit", [data]);
    },
    launch: function (data, success, error) {
       exec(success, error, "Security", "launch", [data]);
    }
};

//});

});
