using System;
using com.freestar.ios.ads;
using ObjCRuntime;
using UIKit;

namespace FreestarXamarinSample
{
    public class FreestarInterstitialAdListener<IFreestarInterstitialDelegate> : FreestarInterstitialDelegate
    {
        private UIButton loadButton;
        private UIButton showButton;
        private FreestarInterstitialAd ad;
        private UIViewController presenter;

        public FreestarInterstitialAdListener(
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

        // - InterstitialDelegate

        public override void FreestarInterstitialClosed(FreestarInterstitialAd ad)
        {
            this.showButton.Enabled = false;
        }

        public override void FreestarInterstitialLoaded(FreestarInterstitialAd ad)
        {
            this.showButton.Enabled = true;
        }

        public override void FreestarInterstitialFailed(FreestarInterstitialAd ad, FreestarNoAdReason reason)
        {
            //throw new NotImplementedException();
        }

        public override void FreestarInterstitialShown(FreestarInterstitialAd ad)
        {
            //throw new NotImplementedException();
        }

        public override void FreestarInterstitialClicked(FreestarInterstitialAd ad)
        {

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
