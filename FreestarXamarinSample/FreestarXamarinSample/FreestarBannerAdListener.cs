using System;
using UIKit;
using FreestarAds;
using CoreGraphics;

namespace FreestarXamarinSample
{
    public class FreestarBannerAdListener : Foundation.NSObject, IFreestarBannerAdDelegate
    {
        private UIButton loadButton;
        private UIButton showButton;
        private FreestarBannerAd ad;
        private UIView adContainer;
        private FreestarBannerAdSize requestedSize;

        public FreestarBannerAdListener(
            UIButton _load,
            UIButton _show,
            UIView _cont,
            FreestarBannerAdSize _requestedSize)
        {
            this.loadButton = _load;
            this.showButton = _show;

            this.loadButton.TouchUpInside += (object sender, EventArgs e) => { LoadAd(); };
            this.showButton.TouchUpInside += (object sender, EventArgs e) => { ShowAd(); };

            this.showButton.Enabled = false;

            this.adContainer = _cont;
            this.requestedSize = _requestedSize;
        }

        //public void SetupSmallBanner()
        //{
        //    this.ad = new FreestarBannerAd(
        //        this, FreestarBannerAdSize.FreestarBanner320x50);
        //}

        //public void SetupLargeBanner()
        //{
        //    this.ad = new FreestarBannerAd(this, FreestarBannerAdSize.FreestarBanner300x250);
        //}

        private void LoadAd()
        {
            if (this.ad != null)
            {
                this.ad.RemoveFromSuperview();
            }
            this.ad = new FreestarBannerAd(this, this.requestedSize);
            this.ad.LoadPlacement(null);
        }

        private void ShowAd()
        {
            this.ad.Center = new CGPoint(
                this.adContainer.Frame.Width / 2,
                this.adContainer.Frame.Height / 2);
            this.adContainer.AddSubview(this.ad);
            this.showButton.Enabled = false;
        }

        //Freestar banner ad delegate
        void IFreestarBannerAdDelegate.FreestarBannerClicked(FreestarBannerAd ad)
        {
            Console.WriteLine("Freestar Banner Ad Clicked");
        }

        void IFreestarBannerAdDelegate.FreestarBannerClosed(FreestarBannerAd ad)
        {
            Console.WriteLine("Freestar Banner Ad Closed");
        }

        void IFreestarBannerAdDelegate.FreestarBannerFailed(FreestarBannerAd ad, FreestarNoAdReason reason)
        {
            Console.WriteLine("Freestar Banner Ad Load Failed");
        }

        void IFreestarBannerAdDelegate.FreestarBannerLoaded(FreestarBannerAd ad)
        {
            Console.WriteLine("Freestar Banner Ad Loaded");
            this.showButton.Enabled = true;
        }

        void IFreestarBannerAdDelegate.FreestarBannerShown(FreestarBannerAd ad)
        {
            Console.WriteLine("Freestar Banner Ad Shown");
            this.showButton.Enabled = false;
        }
    }
}
