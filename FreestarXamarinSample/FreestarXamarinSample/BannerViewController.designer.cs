// WARNING
//
// This file has been generated automatically by Visual Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using Foundation;
using System.CodeDom.Compiler;

namespace FreestarXamarinSample
{
	[Register ("SecondViewController")]
	partial class BannerViewController
	{
		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIView LargeBannerContainer { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton LargeBannerLoadBtn { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton LargeBannerShowBtn { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIView SmallBannerContainer { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton SmallBannerLoadBtn { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton SmallBannerShowBtn { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (LargeBannerContainer != null) {
				LargeBannerContainer.Dispose ();
				LargeBannerContainer = null;
			}

			if (LargeBannerLoadBtn != null) {
				LargeBannerLoadBtn.Dispose ();
				LargeBannerLoadBtn = null;
			}

			if (LargeBannerShowBtn != null) {
				LargeBannerShowBtn.Dispose ();
				LargeBannerShowBtn = null;
			}

			if (SmallBannerContainer != null) {
				SmallBannerContainer.Dispose ();
				SmallBannerContainer = null;
			}

			if (SmallBannerLoadBtn != null) {
				SmallBannerLoadBtn.Dispose ();
				SmallBannerLoadBtn = null;
			}

			if (SmallBannerShowBtn != null) {
				SmallBannerShowBtn.Dispose ();
				SmallBannerShowBtn = null;
			}
		}
	}
}
