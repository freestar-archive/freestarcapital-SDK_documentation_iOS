using UnityEngine;

#if UNITY_ANDROID
namespace Freestar
{
    //Class used for receive Freestar Ad Event from Java to Unity using AndroidJavaProxy implementation
    public class FreestarAndroidListener : AndroidJavaProxy
    {
        //Delegate for passing Freestar Ad Events to Publisher
        public delegate void FreestarAdDelegate(string placement, string adType, int adSize, string eventName);
        public event FreestarAdDelegate FreestarAdDelegateEventHandler;

        //Singleton listener instance to set the delegate for Ad Event
        private static FreestarAndroidListener instance;

        //FreestarListener is Unity Plugin Listener used by publisher to get the Ad Event
        //base("com.Freestar.unity.plugin.IFreestarAdListener") is the JAVA SDK Interface
        //which has onFreestarAdEvent callback method called by Java Plugin when Ad Event occur
        private FreestarAndroidListener() : base("com.freestar.android.unity.FreestarAdUnityListener")
        {
            Debug.Log("FreestarAdUnityListener Initialized...");
        }

        public static FreestarAndroidListener GetInstance()
        {
            if (instance == null)
            {
                instance = new FreestarAndroidListener();
            }

            return instance;
        }

        //This method is called when JAVA Plugin send the Ad Event to the Unity Plugin
        //And passes the callback to the publisher if delegate is set
        void onFreestarAdEvent(string placement, string adType, int adSize, string eventName)   //Received Ad Event from Java
        {
            Debug.Log("Freestar Ad Event In Unity: "  + eventName
                                                      + " AdType: " + adType
                                                      + " AdSize: " + adSize
                                                      + " Placement: [" + placement + "]");
            if (FreestarAdDelegateEventHandler != null)
            {
                FreestarAdDelegateEventHandler(placement, adType, adSize, eventName);      //Pass Ad Event to Publisher
            }
        }
    }
}
#endif
