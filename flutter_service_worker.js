'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "f393d3c16b631f36852323de8e583132",
"CNAME": "0bf532c42d7dc65e356d36653ef56c27",
"main.dart.js": "cc26cb0748fe35b91af706a76678538e",
"splash/img/light-3x.png": "8b2eefdeaf133b308c79e35abc7873c9",
"splash/img/light-1x.png": "7afb1f394caa68dca2ab7f7ce4fa9a84",
"splash/img/light-2x.gif": "4977b93bc5df5fbc9582346b06881926",
"splash/img/light-2x.png": "42e33999a974a78e7b4616bfac176b42",
"splash/img/light-1x.gif": "bfe242cc94a9cae978cf481c75edc3c3",
"splash/img/dark-3x.png": "8b2eefdeaf133b308c79e35abc7873c9",
"splash/img/dark-1x.gif": "bfe242cc94a9cae978cf481c75edc3c3",
"splash/img/dark-3x.gif": "86b4cd29fa03c58c22105a663b9db4a0",
"splash/img/dark-1x.png": "7afb1f394caa68dca2ab7f7ce4fa9a84",
"splash/img/light-4x.gif": "aae83990a35d97924823d7324dc32334",
"splash/img/dark-4x.gif": "aae83990a35d97924823d7324dc32334",
"splash/img/dark-4x.png": "232f439b9cc419d6b76a27fa8a8b8192",
"splash/img/dark-2x.gif": "4977b93bc5df5fbc9582346b06881926",
"splash/img/light-4x.png": "232f439b9cc419d6b76a27fa8a8b8192",
"splash/img/dark-2x.png": "42e33999a974a78e7b4616bfac176b42",
"splash/img/light-3x.gif": "86b4cd29fa03c58c22105a663b9db4a0",
"assets/FontManifest.json": "160e70a04d63fba7a8f37ac1095e403a",
"assets/AssetManifest.bin": "efa6990fc5095181a9eb488b68f28b1f",
"assets/fonts/Inter-Black.ttf": "118c5868c7cc1370fcf5a1fc2f569883",
"assets/fonts/Inter-Bold.ttf": "ba74cc325d5f67d0efbeda51616352db",
"assets/fonts/Amaranth-Italic.ttf": "c85c1fd776003a6893dabf7bb234fec1",
"assets/fonts/Amaranth-Regular.ttf": "5f274104168dac1f3c25b18ffb59878f",
"assets/fonts/Avenir-Heavy.ttf": "1950c9e43b1737cb535ed2aaa354da06",
"assets/fonts/Avenir.ttf": "77ce85fec67e99ffc50ed8edac7a4890",
"assets/fonts/Inter-Medium.ttf": "cad1054327a25f42f2447d1829596bfe",
"assets/fonts/Inter-Light.ttf": "a3fe4e0f9fdf3119c62a34b1937640dd",
"assets/fonts/NunitoSans-Variable.ttf": "e7f409eb0d8afdc0e025cc2bd0987e4f",
"assets/fonts/Inter-ExtraBold.ttf": "72ac147c98056996b2a31e95a56d6e66",
"assets/fonts/Inter-Thin.ttf": "4558ff85abeab91af24c86aab81509a7",
"assets/fonts/Inter-Regular.ttf": "ea5879884a95551632e9eb1bba5b2128",
"assets/fonts/Inter-SemiBold.ttf": "465266b2b986e33ef7e395f4df87b300",
"assets/fonts/Amaranth-Bold.ttf": "0de7f8709503676ff5699e995ce2fec9",
"assets/fonts/Inter-ExtraLight.ttf": "7a177fa21fece72dfaa5639d8f1c114a",
"assets/fonts/MaterialIcons-Regular.otf": "f434f6f88e945c47f8780fc7d48bfe72",
"assets/fonts/Amaranth-BoldItalic.ttf": "e782869d62430d706b843604dbb5300c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "f2163b9d4e6f1ea52063f498c8878bb9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/assets/allergychecks.png": "a86f682875067cb1f269b7e14573a994",
"assets/assets/cprSplashhh.gif": "e310bcb58e8dcf7b4787a4160bade0f9",
"assets/assets/assessThumb.jpg": "aee3dc52a1a8758a95ba5d161d754bf0",
"assets/assets/cprSplash.gif": "5cd014123a74c7153bf00ece2923f21e",
"assets/assets/thumbnails/yes.png": "5ac3b7a10a2dade9f55393d3bf50ff9a",
"assets/assets/thumbnails/defib.jpg": "24d5b855ec9e92d4fdadc9a52ae72943",
"assets/assets/thumbnails/recovery.jpg": "ea22518d0e590a6692a04e2d56d2d6b7",
"assets/assets/thumbnails/breathingAssess.jpg": "4c0a54e6e38cd0ee1cb774329dfe89ac",
"assets/assets/thumbnails/drabc.jpg": "7452f36a41fca998e99af91ed5cf8176",
"assets/assets/thumbnails/closedloop.jpg": "8d0d4db4e16f677a98dff553fbd409db",
"assets/assets/thumbnails/cpr.jpg": "71029cffa543c6f89d5d8abb40f9d1b2",
"assets/assets/thumbnails/no.png": "9018fbfd96e13750ccdc11c9331a3d61",
"assets/assets/newIcon.png": "fdad6c2bc9faa957601027cca905acdb",
"assets/assets/cardiacEmergencyThumb.jpg": "dd81dd2c9fcb530d52616421ea6db7f4",
"assets/assets/drabcThumb.jpg": "3692c4b5390f091d83131d77aa2b2eca",
"assets/assets/drabc.png": "9408b14de25a7693ab8665eb80cfa4d9",
"assets/assets/newBg.avif": "617176aa535353d92a57d58596a5f79e",
"assets/assets/cprThumb.jpg": "78f6499633f8548fa9d8a50d3d1d0290",
"assets/assets/newLogo.svg": "6ea4591b00a93b213759b3321202ac48",
"assets/assets/bg.jpg": "6362371fa5d48e0887654bc78b93f42d",
"assets/assets/cpricon.gif": "aecaab0dec11894acc9762aec94a0c29",
"assets/assets/inhaler.png": "d394adced031a712eebb6af8bc563a4c",
"assets/assets/closedloopcomms.mp4": "c662df96ce0efb5a6575aea2fdd2a36c",
"assets/assets/newLogo%2520-%2520Copy.svg": "e935c7193c42f4e873e3bac32abac428",
"assets/assets/newLogo%2520-%2520Copy%2520(3).svg": "c450570e5ed4fe36d69ead617afb01b1",
"assets/assets/questionmark.png": "c701dc2adca1ad537d9a3b537f66a825",
"assets/assets/videos/cpr.mp4": "bffdff70bae224725f45ec1b9f2bbbee",
"assets/assets/videos/closedloopcomms.mp4": "c662df96ce0efb5a6575aea2fdd2a36c",
"assets/assets/videos/patientbreathing.mp4": "1514c7972211359716b06fafa283a35d",
"assets/assets/videos/drabccardiac.mp4": "3e172f06d68db3933def2b7d9b638fb2",
"assets/assets/cprSplashh.gif": "feb0bfc778aebae5c3cc7fe984e3debb",
"assets/assets/cpr.png": "ffde2449f0794954150d235962e177b0",
"assets/assets/newBg2.jpg": "3cafbf39791fda058d3f92fda394df30",
"assets/assets/newBg.png": "5fc2a733b41aea1539c62bdcc58b6205",
"assets/assets/cprSplash.png": "5cb4439d6b43914cc690bb51cbf2c693",
"assets/assets/flowchart.png": "343a4f128aef3f696b3f390ff3de5232",
"assets/assets/recovery.png": "ff3b23d8e672a267dc992269c22973b1",
"assets/assets/newBg.jpg": "9d7ace31dc7c33527d34c663835e980a",
"assets/assets/newVideos/2drabccardiac.mp4": "bb618a790fbf0b1be444f68327da070c",
"assets/assets/newVideos/6recovpos.mp4": "d0246a74b9a23b3c7556530284a41bab",
"assets/assets/newVideos/4defib.mp4": "81ffd7ddc0d37e8c7162f35fc9502bc9",
"assets/assets/newVideos/3cpr.mp4": "6ad83eca5f17695692cc342be66cb2a0",
"assets/assets/newVideos/5clc.mp4": "0341859c7f01d5253428baf2a916f694",
"assets/assets/newVideos/no.mp4": "cc8633556c37cea628ca493ddf3c5c38",
"assets/assets/newVideos/1assessBreathing.mp4": "43515d18c9ab5bfc95aa75b58c9cf881",
"assets/assets/newVideos/yes.mp4": "d3d30025c34fa31c92cfec3b66fa20bc",
"assets/NOTICES": "b87183edb17c22ef76f6e6c3d0d9350f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "77f945f45a3c52d5c71f329dd67a544f",
"assets/AssetManifest.bin.json": "8f2cd81e3bfb69af4e6dd749f1ddc484",
"index.html": "7a4a9f4adae596a98ead5bbe2d73052c",
"/": "7a4a9f4adae596a98ead5bbe2d73052c",
"manifest.json": "eb36b0ab481a237f2dde36f1384495a8",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-maskable-192.png": "3f56beb88adea6c00847c289e236707a",
"icons/screenshot2.png": "239c9b30faad424c57aed293acae63aa",
"icons/Icon-192.png": "3f56beb88adea6c00847c289e236707a",
"icons/screenshot1.png": "4e6f637387ad7aa52cf65a236ea95e5c",
"icons/screenshot3.png": "fc4e1c09878463b76022f8bc85bf95ec",
"icons/Icon-512.png": "2f44e9b5c4e8e567348972c4a6ae031c",
"icons/screenshot4.png": "2245455d42f4838092c5c48bfea26b55",
"icons/Icon-maskable-512.png": "2f44e9b5c4e8e567348972c4a6ae031c",
"favicon.png": "1724095cbbc28352fd5641f136c93f06",
"version.json": "12410d8d373ce174c740702961313046",
"flutter_bootstrap.js": "01569d8c771acaae41269f2c9592a335"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
