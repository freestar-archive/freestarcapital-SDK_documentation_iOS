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
	[Register ("RewardedViewController")]
	partial class RewardedViewController
	{
		[Outlet]
		UIKit.UIButton LoadRwdBtn { get; set; }

		[Outlet]
		UIKit.UIButton ShowRwdBtn { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (LoadRwdBtn != null) {
				LoadRwdBtn.Dispose ();
				LoadRwdBtn = null;
			}

			if (ShowRwdBtn != null) {
				ShowRwdBtn.Dispose ();
				ShowRwdBtn = null;
			}
		}
	}
}
