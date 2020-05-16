// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Cache$CodaNetwork = require("./Cache.js");
var Config$CodaNetwork = require("./Config.js");
var Storage$CodaNetwork = require("./Storage.js");

function create(name) {
  return {
          name: name,
          entries: /* [] */0
        };
}

function write(keyset) {
  var filename = keyset.name;
  return Cache$CodaNetwork.write(/* Keyset */1, filename, JSON.stringify(keyset));
}

function load(name) {
  var filename = Config$CodaNetwork.keysetsDir + name;
  if (Fs.existsSync(filename)) {
    return Fs.readFileSync(filename, "utf8");
  }
  
}

function append(keyset, publicKey, nickname) {
  return {
          name: keyset.name,
          entries: /* :: */[
            {
              publicKey: publicKey,
              nickname: nickname
            },
            keyset.entries
          ]
        };
}

function appendKeypair(keyset, keypair) {
  return append(keyset, keypair.publicKey, keypair.nickname);
}

function upload(keyset) {
  var filename = keyset.name;
  return Storage$CodaNetwork.upload(Storage$CodaNetwork.keysetBucket, filename, JSON.stringify(keyset), (function (err) {
                var match = err.message;
                if (match !== undefined) {
                  console.log("Error " + (String(match) + ""));
                  return /* () */0;
                } else {
                  console.log("An unkown error occured while uploading keyset " + (String(filename) + "."));
                  return /* () */0;
                }
              }));
}

exports.create = create;
exports.write = write;
exports.load = load;
exports.append = append;
exports.appendKeypair = appendKeypair;
exports.upload = upload;
/* fs Not a pure module */
