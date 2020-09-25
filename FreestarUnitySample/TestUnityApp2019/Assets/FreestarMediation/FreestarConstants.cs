using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System;

namespace Freestar
{

   static class FreestarConstants
   {
       //AD UNIT TYPES
       public const string BANNER_AD_TYPE = "BANNER";
       public const string INTERSTITIAL_AD_TYPE = "FULLSCREEN_INTERSTITIAL";
       public const string REWARDED_AD_TYPE = "FULLSCREEN_REWARDED";

       //AD SIZES
       public const int BANNER_AD_SIZE_320x50 = 0;
       public const int BANNER_AD_SIZE_300x250 = 1;
       public const int FULLSCREEN_AD_SIZE = 2;

       //AD POSITION
       public const int BANNER_AD_POSITION_BOTTOM = 0;
       public const int BANNER_AD_POSITION_MIDDLE = 1;
       public const int BANNER_AD_POSITION_TOP = 2;

       //EVENTS
       public const string FREESTAR_SUCCESSFULLY_INITIALIZED = "FREESTAR_SUCCESSFULLY_INITIALIZED";
       public const string FREESTAR_FAILED_TO_INITIALIZE = "FREESTAR_FAILED_TO_INITIALIZE";
   
       public const string INTERSTITIAL_AD_LOADED = "INTERSTITIAL_AD_LOADED";
       public const string INTERSTITIAL_AD_FAILED = "INTERSTITIAL_AD_FAILED";
       public const string INTERSTITIAL_AD_SHOWN = "INTERSTITIAL_AD_SHOWN";
       public const string INTERSTITIAL_AD_DISMISSED = "INTERSTITIAL_AD_DISMISSED";
       public const string INTERSTITIAL_AD_CLICKED = "INTERSTITIAL_AD_CLICKED";
   
       public const string REWARDED_AD_LOADED = "REWARDED_AD_LOADED";
       public const string REWARDED_AD_FAILED = "REWARDED_AD_FAILED";
       public const string REWARDED_AD_SHOWN = "REWARDED_AD_SHOWN";
       public const string REWARDED_AD_SHOWN_ERROR = "REWARDED_AD_SHOWN_ERROR";
       public const string REWARDED_AD_DISMISSED = "REWARDED_AD_DISMISSED";
       public const string REWARDED_AD_COMPLETED = "REWARDED_AD_COMPLETED";
   
       public const string BANNER_AD_SHOWING = "BANNER_AD_SHOWING";
       public const string BANNER_AD_FAILED = "BANNER_AD_FAILED";
       public const string BANNER_AD_CLICKED = "BANNER_AD_CLICKED";       

   }

}