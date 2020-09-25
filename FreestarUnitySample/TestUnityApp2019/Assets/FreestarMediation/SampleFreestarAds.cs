using UnityEngine;
using UnityEngine.UI;
using Freestar;

/**
 * Modify for your own application.  Corresponds to Assets/Scenes/FreestarAdsSampleScene
 * which is a scene that contains a button to load ads.
 * If you want to run the sample, hook up this script to the Canvas
 * and then hook up the loadRewardedAd method to the button.
*/

namespace Freestar
{

    public class SampleFreestarAds : MonoBehaviour, FreestarRewardedAdCallbackReceiver, FreestarInterstitialAdCallbackReceiver, FreestarBannerAdCallbackReceiver
    {

        private const string TAG = "SampleFreestarAds";

        public static SampleFreestarAds instance;

        private void Awake()
        {
            instance = this;
        }

        private void Start()
        {
            log("Start");

            FreestarUnityBridge.SetAdRequestTestMode(true, "xxxxxxxx");  //OPTIONAL TEST MODE
            FreestarUnityBridge.ShowPartnerChooser(true); //ONLY FOR TESTING PURPOSES; TURN OFF FOR PRODUCTION!

#if UNITY_ANDROID
            FreestarUnityBridge.initWithAPIKey("XqjhRR");  //Android TEST KEY  Replace with yours in production.
#endif

#if UNITY_IOS
           FreestarUnityBridge.initWithAPIKey("X4mdFv");  //iOS TEST KEY  Replace with yours in production.
#endif

            FreestarUnityBridge.setBannerAdListener(this);
            FreestarUnityBridge.setInterstitialAdListener(this);
            FreestarUnityBridge.setRewardedAdListener(this);
        }

        void OnApplicationFocus(bool hasFocus)
        {
            if (hasFocus)
            {
                FreestarUnityBridge.Resume();
            }
            else
            {
                FreestarUnityBridge.Pause();
            }
        }

        public void onInterstitialAdLoaded(string placement)
        {
            //interstitial ad is ready!  You can display now, or you can wait until a later time.
            updateStatusUI("Interstitial Ad Winner: " + FreestarUnityBridge.GetInterstitialAdWinner(placement) + " Placement: [" + placement + "]");
            showInterstitialAd();
        }
        public void onInterstitialAdFailed(string placement)
        {
            updateStatusUI("Interstitial Ad: no-fillunRegisterAdListener");
            //no need to pre-fetch the next ad here.  this will be done internally and automatically.
        }
        public void onInterstitialAdShown(string placement)
        {

        }
        public void onInterstitialAdClicked(string placement)
        {

        }
        public void onInterstitialAdDismissed(string placement)
        {

        }

        public void onRewardedAdLoaded(string placement)
        {
            updateStatusUI("Rewarded Ad Winner: " + FreestarUnityBridge.GetRewardedAdWinner(placement) + " Placement: [" + placement + "]");

            //reward ad is ready!  You can display now, or you can wait until a later time.
            showRewardedAd();
        }
        public void onRewardedAdFailed(string placement)
        {
            updateStatusUI("Rewarded Ad: no-fill");  //no-fill or no internet
                                                     //no need to pre-fetch the next ad here.  this will be done internally and automatically.
        }
        public void onRewardedAdShown(string placement)
        {

        }
        public void onRewardedAdFinished(string placement)
        {
            //TODO: REWARD THE USER HERE
        }
        public void onRewardedAdDismissed(string placement)
        {
            //no need to pre-fetch the next ad here.  this will be done internally and automatically.
            //TODO: OR REWARD THE USER HERE
        }

        public void onBannerAdShowing(string placement, int adSize)
        {
            log("onBannerAdShowing placement=[" + placement + "] adSize: "+ adSize);
        }

        public void onBannerAdClicked(string placement, int adSize)
        {
            log("onBannerAdClicked placement=[" + placement + "] adSize: " + adSize);
        }

        public void onBannerAdFailed(string placement, int adSize)
        {
            log("onBannerAdFailed placement=[" + placement + "] adSize: " + adSize);
        }


        //===============Interstitial Ad Methods===============

        public void loadInterstitialAd()     //called when Interstitial button clicked
        {
            log("Load Interstitial Ad...");
            FreestarUnityBridge.loadInterstitialAd("");
        }

        private void showInterstitialAd()
        {
            log("Show Interstitial Ad...");
            FreestarUnityBridge.showInterstitialAd("");
        }

        public void loadSmallBannerAd()
        {
            log("Load Small Banner Ad...");
            if (FreestarUnityBridge.IsBannerAdShowing(null, FreestarConstants.BANNER_AD_SIZE_300x250))
                FreestarUnityBridge.CloseBannerAd(null, FreestarConstants.BANNER_AD_SIZE_300x250);

            FreestarUnityBridge.ShowBannerAd(null, FreestarConstants.BANNER_AD_SIZE_320x50, FreestarConstants.BANNER_AD_POSITION_BOTTOM);
        }

        public void loadMRECBannerAd()
        {
            log("Load MREC Banner Ad...");
            if (FreestarUnityBridge.IsBannerAdShowing(null, FreestarConstants.BANNER_AD_SIZE_320x50))
                FreestarUnityBridge.CloseBannerAd(null, FreestarConstants.BANNER_AD_SIZE_320x50);

            FreestarUnityBridge.ShowBannerAd(null, FreestarConstants.BANNER_AD_SIZE_300x250, FreestarConstants.BANNER_AD_POSITION_BOTTOM);
        }

        //===============Rewarded Video Ad Methods===============
        /**
         * Called when Load Rewarded Ad button is clicked
         */
        public void loadRewardedAd()
        {
            log("Load Reward Ad...");
            FreestarUnityBridge.loadRewardedAd("");
        }

        private void showRewardedAd()           //called when btnShowReward Clicked
        {
            log("Show Reward Ad...");
            FreestarUnityBridge.showRewardedAd("", 30, "coins", "", "qwer1234");
        }

        private void updateStatusUI(string newStatus)
        {
            try
            {
                Text textView = GameObject.Find("MyStatusText").GetComponent<Text>();
                if (textView != null && textView.text != null)
                {
                    textView.text = newStatus;
                }
            }
            catch (System.Exception e)
            {
                log("updateStatusUI failed: " + e);
            }
        }

        //Be sure to unRegister before loading a new scene.
        private void unRegisterAdListener()
        {
            FreestarUnityBridge.removeBannerAdListener();
            FreestarUnityBridge.removeRewardedAdListener();
            FreestarUnityBridge.removeInterstitialAdListener();
        }

        private void OnDestroy()
        {
            log("OnDestroy Remove Ad event listener");
            unRegisterAdListener();
        }

        private void log(string msg)
        {
            Debug.Log(TAG + " " + msg);
        }

    }

}