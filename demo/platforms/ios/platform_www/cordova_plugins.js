cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-ir.CordovaIR",
    "file": "plugins/cordova-plugin-ir/www/cordovaIR.js",
    "pluginId": "cordova-plugin-ir",
    "clobbers": [
      "cordova.plugins.ir"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.2",
  "cordova-plugin-ir": "0.1.0"
};
// BOTTOM OF METADATA
});