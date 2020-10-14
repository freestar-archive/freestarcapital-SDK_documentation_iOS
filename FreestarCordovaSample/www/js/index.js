/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

// Wait for the deviceready event before using any of Cordova's device APIs.
// See https://cordova.apache.org/docs/en/latest/cordova/events/events.html#deviceready
document.addEventListener('deviceready', onDeviceReady, false);

document.getElementById("interstitialAd").addEventListener('click', onInterstitialAdButtonClicked);
document.getElementById("rewardedAd").addEventListener('click', onRewardedAdButtonClicked);
document.getElementById("smallBanner").addEventListener('click', smallBannerAdButtonClicked);
document.getElementById("largeBanner").addEventListener('click', largeBannerAdButtonClicked);

document.addEventListener('onInterstitialLoaded', onInterstitialLoaded, false);
document.addEventListener('onRewardedVideoLoaded', onRewardedVideoLoaded, false);
document.addEventListener('onBannerAdFailed', onBannerAdFailed, false);

document.fstrSmallBannerPos = 0;
document.fstrLargeBannerPos = 0;

function smallBannerAdButtonClicked() {
   window.plugins.freestarPlugin.closeBannerAd(null, window.plugins.freestarPlugin.BANNER_AD_SIZE_300x250);
   
   window.plugins.freestarPlugin.showBannerAd(null,
      window.plugins.freestarPlugin.BANNER_AD_SIZE_320x50,
      document.fstrSmallBannerPos);

   document.fstrSmallBannerPos++;
   document.fstrSmallBannerPos %= 3;
}

function largeBannerAdButtonClicked() {
   window.plugins.freestarPlugin.closeBannerAd(null, window.plugins.freestarPlugin.BANNER_AD_SIZE_300x250);
   
   window.plugins.freestarPlugin.showBannerAd(null,
      window.plugins.freestarPlugin.BANNER_AD_SIZE_300x250,
      document.fstrLargeBannerPos);

   //so the buttons aren't permanently covered by the ad
   if (document.fstrLargeBannerPos == window.plugins.freestarPlugin.BANNER_AD_POSITION_BOTTOM) {
      setTimeout(function(){
         window.plugins.freestarPlugin.closeBannerAd(null, window.plugins.freestarPlugin.BANNER_AD_SIZE_300x250);
      },
      60000);
   } 
   document.fstrLargeBannerPos++;
   document.fstrLargeBannerPos %= 3;
}

function onInterstitialAdButtonClicked() {
   window.plugins.freestarPlugin.loadInterstitialAd(null);
}

function onRewardedAdButtonClicked() {
   window.plugins.freestarPlugin.loadRewardedAd(null);
}

function onRewardedVideoLoaded(data) {
   console.log("FreestarPlugin.js: onRewardedVideoLoaded: "+ data.placement);
   window.plugins.freestarPlugin.showRewardedAd(data.placement, "MySecret1234", "MyUserId", "Gold Coins", "100");
}

function onInterstitialLoaded(data) {
   console.log("FreestarPlugin.js: onInterstitialLoaded: "+ data.placement);
   window.plugins.freestarPlugin.showInterstitialAd(data.placement);
}

function onBannerAdFailed(data) {
   console.log("FreestarPlugin.js: onBannerAdFailed: placement: "+ data.placement
                  + " ad size: " + data.banner_ad_size + " "
                  + " error: " + data.error);
   Alert.alert('onBannerAdFailed');
}

function onDeviceReady() {
    // Cordova is now initialized. Have fun!
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    document.getElementById('deviceready').classList.add('ready');
    setTestModeEnabled(true, 'asdfasdf');
}
