using System;
using com.freestar.ios.ads;
using ObjCRuntime;
using UIKit;

namespace FreestarXamarinSample
{
    public class FreestarRewardedAdListener<IFreestarRewardedDelegate> : FreestarRewardedDelegate
    {
        private UIButton loadButton;
        private UIButton showButton;
        private FreestarRewardedAd ad;
        private UIViewController presenter;

        public FreestarRewardedAdListener(
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

        public void SetupRewarded()
        {
            FreestarReward rwd = FreestarReward.BlankReward();
            rwd.RewardAmount = 100;
            rwd.RewardName = "hippos";
            this.ad = new FreestarRewardedAd(this, rwd);
        }

        //Rewarded delegate

        public override void FreestarRewardedClosed(FreestarRewardedAd ad)
        {
            this.showButton.Enabled = false;
        }

        public override void FreestarRewardedLoaded(FreestarRewardedAd ad)
        {
            this.showButton.Enabled = true;
        }

        public override void FreestarRewardedFailed(FreestarRewardedAd ad, FreestarNoAdReason reason)
        {
            //throw new NotImplementedException();
        }

        public override void FreestarRewardedShown(FreestarRewardedAd ad)
        {
            //throw new NotImplementedException();
        }

        public override void FreestarRewardedAd(FreestarRewardedAd ad, string rewardName, nint rewardAmount)
        {
            //throw new NotImplementedException();
        }

        public override void FreestarRewardedFailedToStart(FreestarRewardedAd ad, FreestarNoAdReason reason)
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

