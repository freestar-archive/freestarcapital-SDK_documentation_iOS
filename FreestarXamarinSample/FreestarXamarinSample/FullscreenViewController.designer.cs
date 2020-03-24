// WARNING
//
// This file has been generated automatically by Visual Studio from the outlets and
// actions declared in your storyboard file.
// Manual changes to this file will not be maintained.
//
using Foundation;
using System;
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
        UIKit.UIButton LoadRwdBtn { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIButton ShowIntBtn { get; set; }

        [Outlet]
        [GeneratedCode ("iOS Designer", "1.0")]
        UIKit.UIButton ShowRwdBtn { get; set; }

        void ReleaseDesignerOutlets ()
        {
            if (LoadIntBtn != null) {
                LoadIntBtn.Dispose ();
                LoadIntBtn = null;
            }

            if (LoadRwdBtn != null) {
                LoadRwdBtn.Dispose ();
                LoadRwdBtn = null;
            }

            if (ShowIntBtn != null) {
                ShowIntBtn.Dispose ();
                ShowIntBtn = null;
            }

            if (ShowRwdBtn != null) {
                ShowRwdBtn.Dispose ();
                ShowRwdBtn = null;
            }
        }
    }
}