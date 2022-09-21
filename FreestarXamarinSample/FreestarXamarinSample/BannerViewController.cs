using System;
using UIKit;
using com.freestar.ios.ads;

namespace FreestarXamarinSample
{
    public partial class BannerViewController : UIViewController
    {
        public BannerViewController(IntPtr handle) : base(handle)
        {
        }

        private FreestarBannerAdListener<IFreestarBannerAdDelegate> sl; //small banners
        private FreestarBannerAdListener<IFreestarBannerAdDelegate> ll; //large banners

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.
            sl = new FreestarBannerAdListener<IFreestarBannerAdDelegate>(
                SmallBannerLoadBtn,
                SmallBannerShowBtn,
                SmallBannerContainer,
                FreestarBannerAdSize.FreestarBanner320x50);
            ll = new FreestarBannerAdListener<IFreestarBannerAdDelegate>(
                LargeBannerLoadBtn,
                LargeBannerShowBtn,
                LargeBannerContainer,
                FreestarBannerAdSize.FreestarBanner300x250);

            //sl.SetupSmallBanner();
            //ll.SetupLargeBanner();
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }
}

