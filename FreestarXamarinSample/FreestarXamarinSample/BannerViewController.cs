using System;

using UIKit;

namespace FreestarXamarinSample
{
    public partial class BannerViewController : UIViewController
    {
        public BannerViewController(IntPtr handle) : base(handle)
        {
        }

        private FreestarBannerAdListener sl; //small banners
        private FreestarBannerAdListener ll; //large banners

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.
            sl = new FreestarBannerAdListener(SmallBannerLoadBtn, SmallBannerShowBtn, SmallBannerContainer);
            ll = new FreestarBannerAdListener(LargeBannerLoadBtn, LargeBannerShowBtn, LargeBannerContainer);

            sl.SetupSmallBanner();
            ll.SetupLargeBanner();
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }
}

