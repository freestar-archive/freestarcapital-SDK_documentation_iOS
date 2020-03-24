using System;

using UIKit;

namespace FreestarXamarinSample
{
    public partial class FirstViewController : UIViewController
    {
        public FirstViewController(IntPtr handle) : base(handle)
        {
        }

        private FreestarFullscreenAdListener il; //interstitial
        private FreestarFullscreenAdListener rl; //rewarded

        public UIViewController RewardAdViewControllerForPresentingModalView => this;

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.
            il = new FreestarFullscreenAdListener(LoadIntBtn, ShowIntBtn, this);
            il.SetupIntestitial();

            rl = new FreestarFullscreenAdListener(LoadRwdBtn, ShowRwdBtn, this);
            rl.SetupRewarded();
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }
}