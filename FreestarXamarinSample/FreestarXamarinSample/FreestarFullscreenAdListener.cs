using System;
using FreestarAds;
using ObjCRuntime;
using UIKit;

namespace FreestarXamarinSample
{
    public class FreestarFullscreenAdListener : Foundation.NSObject, IFreestarInterstitialDelegate, IFreestarRewardedDelegate
    {
        private UIButton loadButton;
        private UIButton showButton;
        private FreestarFullscreenAd ad;
        private UIViewController presenter;

        public FreestarFullscreenAdListener(
            UIButton _load,
            UIButton _show,
            UIViewController _pres)
        {
            this.loadButton = _load;
            this.showButton = _show;

            this.loadButton.TouchUpInside += (object sender, EventArgs e) => { LoadAd(); };
            this.showButton.TouchUpInside += (object sender, EventArgs e) => { ShowAd(); };

            this.showButton.Enabled = false;

            this.presenter = _pres;
        }

        public void SetupIntestitial()
        {
            this.ad = new FreestarInterstitialAd(this);
        }

        public void SetupRewarded()
        {
            FreestarReward rwd = FreestarReward.BlankReward();
            rwd.RewardAmount = 100;
            rwd.RewardName = "hippos";
            this.ad = new FreestarRewardedAd(this, rwd);
        }

        // - InterstitialDelegate

        void IFreestarInterstitialDelegate.FreestarInterstitialClosed(FreestarInterstitialAd ad)
        {
            this.showButton.Enabled = false;
        }

        void IFreestarInterstitialDelegate.FreestarInterstitialLoaded(FreestarInterstitialAd ad)
        {
            this.showButton.Enabled = true;
        }

        void IFreestarInterstitialDelegate.FreestarInterstitialFailed(FreestarInterstitialAd ad, FreestarNoAdReason reason)
        {
            //throw new NotImplementedException();
        }

        void IFreestarInterstitialDelegate.FreestarInterstitialShown(FreestarInterstitialAd ad)
        {
            //throw new NotImplementedException();
        }

        void IFreestarInterstitialDelegate.FreestarInterstitialClicked(FreestarInterstitialAd ad)
        {

        }

        //Rewarded delegate

        void IFreestarRewardedDelegate.FreestarRewardedClosed(FreestarRewardedAd ad)
        {
            this.showButton.Enabled = false;
        }

        void IFreestarRewardedDelegate.FreestarRewardedLoaded(FreestarRewardedAd ad)
        {
            this.showButton.Enabled = true;
        }

        void IFreestarRewardedDelegate.FreestarRewardedFailed(FreestarRewardedAd ad, FreestarNoAdReason reason)
        {
            //throw new NotImplementedException();
        }

        void IFreestarRewardedDelegate.FreestarRewardedShown(FreestarRewardedAd ad)
        {
            //throw new NotImplementedException();
        }

        void IFreestarRewardedDelegate.FreestarRewardedAd(FreestarRewardedAd ad, string rewardName, nint rewardAmount)
        {
            //throw new NotImplementedException();
        }

        void IFreestarRewardedDelegate.FreestarRewardedFailedToStart(FreestarRewardedAd ad, FreestarNoAdReason reason)
        {
            //throw new NotImplementedException();
        }

        private void LoadAd()
        {
            this.ad.LoadPlacement(null);
        }

        private void ShowAd()
        {
            this.ad.ShowFrom(presenter);
        }
    }
}
