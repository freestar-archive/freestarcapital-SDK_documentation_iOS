using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System;

namespace Freestar
{
    
    public class FreestarIOSBannerMessagePasser : MonoBehaviour {
        public FreestarBannerAdCallbackReceiver receiver;

        public void BannerAdShown(string data) {
            string[] elems = data.Split(',');
            this.receiver.onBannerAdShowing(elems[0], int.Parse(elems[1]));
        }

        public void BannerAdClicked(string data) {
            string[] elems = data.Split(',');
            this.receiver.onBannerAdClicked(elems[0], int.Parse(elems[1]));
        }

        public void BannerAdFailed(string data) {
            string[] elems = data.Split(',');
            this.receiver.onBannerAdFailed(elems[0], int.Parse(elems[1]));
        }
    }
    
}