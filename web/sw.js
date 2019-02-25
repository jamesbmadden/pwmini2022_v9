caches.delete('mini22');
var CACHE = 'mini22_v9';

 self.addEventListener('install', function(evt) {
  console.log('The service worker is being installed.');
   evt.waitUntil(precache());
});
 self.addEventListener('fetch', function(evt) {
  var rUrl = evt.request.url;
  if (rUrl.indexOf('googleapis.com') >= 0 || rUrl.indexOf('/__') >= 0 || rUrl.indexOf('/api') >= 0) {
    return;
  }
  evt.respondWith(fromNetwork(evt.request, 400).catch(function () {
    return fromCache(evt.request);
  }));
});
 function precache() {
  return caches.open(CACHE).then(function (cache) {
    return cache.addAll([
      'index.html',
      'main.dart.js',
      'styles.css',
      'src/icon/google.svg'
    ]);
  });
}
function fromNetwork(request, timeout) {
  return new Promise(function (fulfill, reject) {
     var timeoutId = setTimeout(reject, timeout);
     fetch(request).then(function (response) {
      clearTimeout(timeoutId);
      fulfill(response);
     }, reject);
  });
}
function fromCache(request) {
  return caches.open(CACHE).then(function (cache) {
    return cache.match(request).then(function (matching) {
      return matching || Promise.reject('no-match');
    });
  });
}