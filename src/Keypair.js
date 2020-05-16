// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Belt_Option = require("bs-platform/lib/js/belt_Option.js");
var Cache$CodaNetwork = require("./Cache.js");
var Storage$CodaNetwork = require("./Storage.js");
var CodaSDK$O1labsClientSdk = require("@o1labs/client-sdk/src/CodaSDK.bs.js");

function create(nickname) {
  var keysRaw = CodaSDK$O1labsClientSdk.genKeys(/* () */0);
  return {
          publicKey: Belt_Option.getExn(Js_dict.get(keysRaw, "publicKey")),
          privateKey: Belt_Option.getExn(Js_dict.get(keysRaw, "privateKey")),
          nickname: nickname
        };
}

function write(keypair) {
  var filename = Belt_Option.getWithDefault(keypair.nickname, keypair.publicKey);
  return Cache$CodaNetwork.write(/* Keypair */0, filename, JSON.stringify(keypair));
}

function uplaod(keypair) {
  var filename = Belt_Option.getWithDefault(keypair.nickname, keypair.publicKey);
  var partial_arg = JSON.stringify(keypair);
  return (function (param) {
      return Storage$CodaNetwork.upload(Storage$CodaNetwork.keypairBucket, filename, partial_arg, param);
    });
}

var CodaSDK = 0;

exports.CodaSDK = CodaSDK;
exports.create = create;
exports.write = write;
exports.uplaod = uplaod;
/* Cache-CodaNetwork Not a pure module */
