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
	[Register ("FirstViewController")]
	partial class FirstViewController
	{
		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton LoadIntBtn { get; set; }

		[Outlet]
		[GeneratedCode ("iOS Designer", "1.0")]
		UIKit.UIButton ShowIntBtn { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (LoadIntBtn != null) {
				LoadIntBtn.Dispose ();
				LoadIntBtn = null;
			}

			if (ShowIntBtn != null) {
				ShowIntBtn.Dispose ();
				ShowIntBtn = null;
			}
		}
	}
}
