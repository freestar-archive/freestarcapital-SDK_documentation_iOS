import React, { useState } from 'react';
import { StyleSheet, Text, View, TextInput, Button } from 'react-native';
import { Alert } from 'react-native';
import FreestarReactBridge, { MrecBannerAd2 } from '@freestar/freestar-plugin-react-native';
import BannerAd from '@freestar/freestar-plugin-react-native/BannerAd';
import MrecBannerAd from '@freestar/freestar-plugin-react-native/MrecBannerAd';
import MrecBannerAd3 from '@freestar/freestar-plugin-react-native/MrecBannerAd3';
import SmallNativeAd from '@freestar/freestar-plugin-react-native/SmallNativeAd';
import MediumNativeAd2 from '@freestar/freestar-plugin-react-native/MediumNativeAd2';

// import { MrecBannerAd, MrecBannerAd2, MrecBannerAd3, MrecBannerAd4 } from '@freestar/freestar-plugin-react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import SegmentedControl from '@react-native-community/segmented-control';

// var APP_KEY = "P8RIA3";
var APP_KEY = "1d10c713-cdc8-4d98-9747-1a0724904080";

var state = {
  placementID: "",
  interstitialReady: false,
  rewardedReady: false,
  thumbnailReady: false,
  isShowingThumbnail: false,
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  label : {
    fontSize: 30,
    textAlign : 'center'
  },
  border : {
    borderColor : '#eee',
    borderWidth : 2,
    borderStyle : 'solid',
    borderRadius: 5,
    minWidth : 300
  },
  title : {
    fontSize: 30,
    fontWeight: 'bold',
    textAlign : 'center',
    color : 'blue',
    paddingTop: 40,
    paddingBottom: 10
  }
});

function enableShowFullscreen(adUnitSelection) {
  return (adUnitSelection === 0 && state.interstitialReady) || 
         (adUnitSelection === 1 && state.rewardedReady);
}

function enableShowThumbnail() {
  return (state.thumbnailReady);
}

function ThumbnailAds() {
  const [canShowThumbnail, setCanShowThumbnail] = useState(false);

  FreestarReactBridge.subscribeToThumbnailAdCallbacks((eventName) => {
    if(eventName === "onThumbnailAdLoaded") {
      state.thumbnailReady = true;
      setCanShowThumbnail(enableShowThumbnail());
    } else if (eventName === "onThumbnailAdClicked") {

    } else if (eventName === "onThumbnailAdShown") {
      state.isShowingThumbnail = true;
    } else if (eventName === "onThumbnailAdFailed") {
      Alert.alert('Thumbnail Ad not available');
      state.thumbnailReady = false;
      state.isShowingThumbnail = false;
      setCanShowThumbnail(enableShowThumbnail());
    } else if (eventName === "onThumbnailAdDismissed") {
      state.isShowingThumbnail = false;
      state.thumbnailReady = false;
      setCanShowThumbnail(enableShowThumbnail());
    } else {
       console.log("unknown Thumbnail event");
    }
  });


  return(
    <View style={styles.container}>
      <Text style={styles.title}>Freestar on ReactNative</Text>
      <TextInput
      style={[styles.label, styles.border]}
      placeholder='Placement ID'
      onChangeText={(pid) => state.placementID = pid }/>

      <View style={{ flexDirection: 'row', paddingTop: 10}}>
        <Button
          title="Load"
          titleStyle={{fontSize: 36}}
          onPress={() => {
              FreestarReactBridge.loadThumbnailAd(state.placementID);
          }}
        />
        <View style={{width: 10}} />
        <Button
          disabled={!canShowThumbnail}
          title="Show"
          onPress={() => {
              FreestarReactBridge.showThumbnailAd(state.placementID,"TopRight",10,175);
          }}
        />
      </View>
    </View>
  );
}

function FullscreenAds() {
  const [canShowFullscreen, setCanShowFullscreen] = useState(false);
  const [fullscreenSelection, setFullscreenSelection] = useState(0);

  FreestarReactBridge.subscribeToInterstitialCallbacks((eventName) => {
    if(eventName === "onInterstitialLoaded") {      
      state.interstitialReady = true;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else if (eventName === "onInterstitialClicked") {

    } else if (eventName === "onInterstitialShown") {
      if (state.isShowingThumbnail) {
        return;
      }
    } else if (eventName === "onInterstitialFailed") {
      Alert.alert('Interstitial Ad not available');
      state.interstitialReady = false;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else if (eventName === "onInterstitialDismissed") {
      state.interstitialReady = false;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else {
       console.log("unknown event");
    }
  });

  FreestarReactBridge.subscribeToRewardCallbacks((eventName, placement = "", rewardName = '', rewardAmount = 0) => {
    if (eventName === "onRewardedFailed") {
      Alert.alert('Reward Ad not available');
      state.rewardedReady = false;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else if (eventName === "onRewardedDismissed") {
      state.rewardedReady = false;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else if(eventName === "onRewardedLoaded") {
      state.rewardedReady = true;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else if (eventName === "onRewardedCompleted") {
      console.log("reward placement done: " + placement)
      console.log("reward ad completed: awarded " + rewardAmount + ' ' + rewardName);
    } else if (eventName === "onRewardedShown") {
      if (state.isShowingThumbnail) {
        return;
      }
    } else if (eventName === "onRewardedShowFailed") {
      Alert.alert('Reward Ad was available but failed to show');
      state.rewardedReady = false;
      setCanShowFullscreen(enableShowFullscreen(fullscreenSelection));
    } else {
       console.log("unknown event");
    }
  });
  
  return(
    <View style={styles.container}>
      <Text style={styles.title}>Freestar on ReactNative</Text>
      <TextInput
      style={[styles.label, styles.border]}
      placeholder='Placement ID'
      onChangeText={(pid) => state.placementID = pid }/>

      <View style={{ flexDirection: 'row', paddingTop: 10}}>
        <SegmentedControl style={styles.border}
          values={["Interstitial", "Rewarded"]}
          selectedIndex={fullscreenSelection}
          onChange={(event) => {
            setFullscreenSelection(event.nativeEvent.selectedSegmentIndex)}}
        />
        
      </View>

      <View style={{ flexDirection: 'row', paddingTop: 10}}>
        <Button
          title="Load"
          titleStyle={{fontSize: 36}}
          onPress={() => {
            if(fullscreenSelection === 0) { //interstitial
              if (state.isShowingThumbnail) {
                return;
              } else {
                FreestarReactBridge.loadInterstitialAd(state.placementID);
              }              
            } else { //rewarded
              if (state.isShowingThumbnail) {
                return;
              } else {
                FreestarReactBridge.loadRewardAd(state.placementID);
              }              
            }
          }}
        />
        <View style={{width: 10}} />
        <Button
          disabled={!canShowFullscreen}
          title="Show"
          onPress={() => {
            if(fullscreenSelection === 0) { //interstitial
              if (state.isShowingThumbnail) {
                return;
              } else {
                FreestarReactBridge.showInterstitialAd();
              }              
            } else { //rewarded
              if (state.isShowingThumbnail) {
                return;
              } else {
                FreestarReactBridge.showRewardAd(null, "Coins", 50, "myuserId", "12345678");
              }              
            }
          }}
        />
      </View>
    </View>
  );
}

function BannerAds() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Freestar on ReactNative</Text>

      <View style={{ flexDirection: 'row', paddingTop: 10}}>
      <MrecBannerAd3
         style={{width: 300, height: 250}}
         requestOptions={
            {
               size:'MREC',
               isCoppaEnabled: false,
               targetingParams: {
                     'someparam1': 'somevalue1',
                     'someparam2': 'somevalue2',
                     'someparam3': 'somevalue3',
               },
               testDeviceIds: ['deviceId1','deviceId2', 'deviceId3']
            }
         }
         onBannerAdLoaded={bannerLoaded}
         onBannerAdFailedToLoad={bannerFailed}
      />
      </View>
      
      <View style={{ flexDirection: 'row', paddingTop: 10}}>
      <MrecBannerAd
        style={{width: 300, height: 250}}
        requestOptions={
          { 
            targetingParams: {
              'someparam1': 'somevalue1',
              'someparam2': 'somevalue2',
              'someparam3': 'somevalue3',
            }
          }
        }
        onBannerAdLoaded={bannerLoaded}
        onBannerAdFailedToLoad={bannerFailed}
      />
      </View>

      <View style={{ flexDirection: 'row', paddingTop: 10}}>
      <BannerAd
        style={{width: 320, height: 50}}
        requestOptions={{ size:'BANNER' }}
        onBannerAdLoaded={bannerLoaded}
        onBannerAdFailedToLoad={bannerFailed}
      />
      </View>
    </View>

    
  );
}

function bannerLoaded({ nativeEvent }) {
  console.log('loaded ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
}

function bannerFailed({ nativeEvent }) {
  console.log('failed ' + nativeEvent.errorDesc + ' ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
  Alert.alert('failed ' + nativeEvent.errorDesc + ' ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
}

function nativeLoaded({ nativeEvent }) {
  console.log('loaded ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
}

function nativeFailed({ nativeEvent }) {
  console.log('failed ' + nativeEvent.errorDesc + ' ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
  Alert.alert('failed ' + nativeEvent.errorDesc + ' ' + nativeEvent.size + ' placement: ' + nativeEvent.placement);
}


function NativeAds() {

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Freestar on ReactNative</Text>

      <View style={{ flexDirection: 'row', paddingTop: 30}}>
      <MediumNativeAd2
         style={{width: 360, height: 350}}
         requestOptions={
            {
               targetingParams: {
                     'someparam1': 'somevalue1',
                     'someparam2': 'somevalue2',
                     'someparam3': 'somevalue3',
               },
               testDeviceIds: ['deviceId1','deviceId2', 'deviceId3']
            }
         }
         onNativeAdLoaded={nativeLoaded}
         onNativeAdFailedToLoad={nativeFailed}
      />
      </View>
      
      <View style={{ flexDirection: 'row', paddingTop: 10}}>
      <SmallNativeAd
        style={{width: 360, height: 100}}
        requestOptions={{}}
        onNativeAdLoaded={nativeLoaded}
        onNativeAdFailedToLoad={nativeFailed}
      />
      </View>
    </View>

    
  );
}

const Tab = createBottomTabNavigator();

export default function App(props) {
  FreestarReactBridge.initWithAdUnitID(APP_KEY);

  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen name="Fullscreen" component={FullscreenAds} />
        <Tab.Screen name="Banner" component={BannerAds} />
        <Tab.Screen name="Native" component={NativeAds} />
        <Tab.Screen name="Thumbnail" component={ThumbnailAds} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}
