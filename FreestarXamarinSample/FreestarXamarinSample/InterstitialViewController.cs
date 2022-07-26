using System;
using UIKit;
using com.freestar.ios.ads;

namespace FreestarXamarinSample
{
    public partial class FirstViewController : UIViewController
    {
        public FirstViewController(IntPtr handle) : base(handle)
        {
        }

        private FreestarInterstitialAdListener<IFreestarInterstitialDelegate> il; //interstitial        

        public UIViewController RewardAdViewControllerForPresentingModalView => this;

        public override void ViewDidLoad()
        {
            base.ViewDidLoad();
            // Perform any additional setup after loading the view, typically from a nib.
            il = new FreestarInterstitialAdListener<IFreestarInterstitialDelegate>(LoadIntBtn, ShowIntBtn, this);
            il.SetupIntestitial();

            //rl = new FreestarInterstitialAdListener<IFreestarInterstitialDelegate>(LoadRwdBtn, ShowRwdBtn, this);
            //rl.SetupRewarded();
        }

        public override void DidReceiveMemoryWarning()
        {
            base.DidReceiveMemoryWarning();
            // Release any cached data, images, etc that aren't in use.
        }
    }
}