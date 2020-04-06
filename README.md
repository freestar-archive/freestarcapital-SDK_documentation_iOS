# Freestar Ads Mediation SDK iOS Platforms

Please see <a href="https://github.com/freestarcapital/SDK_documentation_iOS/wiki">our Wiki</a> for all of our iOS related documentation:

https://github.com/freestarcapital/SDK_documentation_iOS/wiki

## Changelog

##### 2020-03-26
Version 3.2.4: bug fixes for banner ads, app archiving.

Wiki now includes a page for integrating Freestar ads into a Xamarin iOS app.

##### 2020-03-20
Version 3.2.1: modifications to API for convenience
1. Fullscreen ads (interstitial and rewarded) are now instance objects, and multiple instances can be created within the same app session, rather than being called by static methods. One should, however, be careful to only display one fullscreen ad at a time.
2. An explicit `loadPlacement:` method has been added to the banner ad, and can be called before adding the banner ad to the app's view hierarchy. In case the ad has been added to the view hierarchy before it is loaded, there is also an explicit `show` method that can be invoked once the ad is loaded.
3. All ads now have the `winningPartnerName` method that can be used to retrieve the ad auction winner, if the ad has a fill.
