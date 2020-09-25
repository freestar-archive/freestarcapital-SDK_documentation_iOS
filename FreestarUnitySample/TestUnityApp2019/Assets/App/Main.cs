using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Freestar;

public class Main : MonoBehaviour,
                    FreestarInterstitialAdCallbackReceiver,
                    FreestarRewardedAdCallbackReceiver,
					FreestarBannerAdCallbackReceiver 
					{
  Button buttonLoadInterstitial;
  Button buttonShowInterstitial;
  Button buttonLoadReward;
  Button buttonShowReward;

  Button buttonLargeBanner;

  bool[] buttonState = {true,false,true,false};
  bool buttonStateChanged = false;

	string latitude;
	string longitude;

	public Canvas AlertCanvas;
	public Text GUITextMessage;

  bool uiSetup = false;
  bool listenerSetup = false;

  int sbPos, lbPos;

  void Update() {
    if(!uiSetup) {
      Debug.Log("settign up UI");
      SetupUI();
    }

    if(!listenerSetup) {
      SetupListener();
    }

    if(buttonStateChanged) {
      ApplyButtonState();
    }
  }

  void ApplyButtonState() {
    buttonLoadInterstitial.interactable = buttonState[0];
    buttonShowInterstitial.interactable = buttonState[1];
    buttonLoadReward.interactable = buttonState[2];
    buttonShowReward.interactable = buttonState[3];
    buttonStateChanged = false;
  }

  void ButtonSetup(string adUnitType, bool enableShow) {
    int loadIndex, showIndex;
    if(adUnitType == "interstitial") {
      loadIndex = 0;
      showIndex = 1;
    } else {
      loadIndex = 2;
      showIndex = 3;
    }

    if(enableShow) {
      buttonState[loadIndex] = false;
      buttonState[showIndex] = true;
    } else {
      buttonState[loadIndex] = true;
      buttonState[showIndex] = false;
    }

    buttonStateChanged = true;
  }

  void SetupUI() {
    buttonLoadInterstitial = GameObject.Find ("ButtonLoadInterstitial").GetComponent<Button> ();
		buttonShowInterstitial = GameObject.Find ("ButtonShowInterstitial").GetComponent<Button> ();
		buttonShowInterstitial.interactable = false;

		buttonLoadReward = GameObject.Find ("ButtonLoadReward").GetComponent<Button> ();
		buttonShowReward = GameObject.Find ("ButtonShowReward").GetComponent<Button> ();
		buttonShowReward.interactable = false;

    uiSetup = (buttonLoadInterstitial && buttonShowInterstitial &&
               buttonLoadReward && buttonShowReward);

	buttonLoadInterstitial.onClick.AddListener(buttonLoadInterstitialClicked);
	buttonShowInterstitial.onClick.AddListener(buttonShowInterstitialClicked);
	buttonLoadReward.onClick.AddListener(buttonRequestRewardClicked);
	buttonShowReward.onClick.AddListener(buttonShowRewardClicked);

	Button buttonSmallBanner = GameObject.Find ("SmallBanner").GetComponent<Button> ();
	buttonLargeBanner = GameObject.Find ("LargeBanner").GetComponent<Button> ();
	buttonSmallBanner.onClick.AddListener(showSmallBanner);
	buttonLargeBanner.onClick.AddListener(showLargeBanner);
	sbPos = 0;
	lbPos = 0;

	Button noButton = GameObject.Find ("ButtonNo").GetComponent<Button> ();
	Button yesButton = GameObject.Find ("ButtonYes").GetComponent<Button> ();
	noButton.onClick.AddListener(NoClicked);
	yesButton.onClick.AddListener(YesClicked);
  }

  void SetupListener() {
    Debug.Log("game object name: " + this.name);

    FreestarUnityBridge.setInterstitialAdListener(this);
    FreestarUnityBridge.setRewardedAdListener(this);
	FreestarUnityBridge.setBannerAdListener(this);
    listenerSetup = true;
    
    }

	IEnumerator Start()
	{

		Screen.fullScreen = false;      //Disable Fullscreen App
		AlertCanvas.enabled = false;
		GUITextMessage.enabled = false;

    string apiKey = "";
#if UNITY_IOS
      apiKey = "X4mdFv";
#endif
#if UNITY_ANDROID
        apiKey = "XqjhRR";
#endif
    FreestarUnityBridge.initWithAPIKey(apiKey);
    FreestarUnityBridge.SetAdRequestTestMode(true,"dinosaur");

    FreestarUnityBridge.setPrivacySettings(
      true,  //whether GDPR applies
      null   //consent string in format defined by IAB, or null if no consent was obtained
    );

		// First, check if user has location service enabled
		if (!Input.location.isEnabledByUser)
			yield break;

		// Start service before querying location
		Input.location.Start();

		// Wait until service initializes
		int maxWait = 20;
		while (Input.location.status == LocationServiceStatus.Initializing && maxWait > 0)
		{
			yield return new WaitForSeconds(1);
			maxWait--;
		}

		// Service didn't initialize in 20 seconds
		if (maxWait < 1)
		{
			print("Timed out");
			yield break;
		}

		// Connection has failed
		if (Input.location.status == LocationServiceStatus.Failed)
		{
			print("Unable to determine device location");
			yield break;
		}
		else
		{
			// Access granted and location value could be retrieved
			latitude =  string.Format("{0:N3}", Input.location.lastData.latitude);
			longitude = string.Format("{0:N3}", Input.location.lastData.longitude);
			print("Location: " +
            Input.location.lastData.latitude +
            " " + Input.location.lastData.longitude +
            " " + Input.location.lastData.altitude +
            " " + Input.location.lastData.horizontalAccuracy +
            " " + Input.location.lastData.timestamp);
		}

		// Stop service if there is no need to query location updates continuously
		Input.location.Stop();
	}



    public void buttonLoadInterstitialClicked() {     //Interstitial Ad Button Load Clicked
        Debug.Log("Button Load Interstitial Clicked...");
    	FreestarUnityBridge.setDemograpics(23, "23/11/1990", "m", "single", "Asian");
        FreestarUnityBridge.setLocation("999", "123123", "321321", latitude, longitude);
		FreestarUnityBridge.loadInterstitialAd ("");
    }

    public void buttonShowInterstitialClicked()     //Interstitial Ad Button Show Clicked
    {
        Debug.Log("Button Show Interstitial Clicked...");
		FreestarUnityBridge.showInterstitialAd ("");

    }

    public void buttonRequestRewardClicked()        //Reward Ad Button Request Clicked
    {
        Debug.Log("Button Request Reward Clicked...");
		FreestarUnityBridge.setDemograpics(23, "23/11/1990", "m", "single", "Asian");
		FreestarUnityBridge.setLocation("999", "123123", "321321", latitude, longitude);
		FreestarUnityBridge.loadRewardedAd ("");

    }

    public void buttonShowRewardClicked()           //Reward Ad Button Show Clicked
    {
        Debug.Log("Button Show Reward Clicked...");
		AlertCanvas.enabled = true;

		FreestarUnityBridge.showRewardedAd("",30,"coin","Chocolate1","XNydpzNLIj2pBRM8");
    }

	public void showSmallBanner() {
		FreestarUnityBridge.CloseBannerAd("", FreestarConstants.BANNER_AD_SIZE_320x50);
		FreestarUnityBridge.ShowBannerAd("", FreestarConstants.BANNER_AD_SIZE_320x50, sbPos);
		sbPos++;
		sbPos %= 3;
	}

	public void showLargeBanner() {
		if (lbPos == FreestarConstants.BANNER_AD_POSITION_TOP) {
			StartCoroutine(CloseLargeBanner(60));
		} 
		FreestarUnityBridge.CloseBannerAd("", FreestarConstants.BANNER_AD_SIZE_300x250);
		FreestarUnityBridge.ShowBannerAd("", FreestarConstants.BANNER_AD_SIZE_300x250, lbPos);
		lbPos++;
		lbPos %= 3;
	}

	//closes the large banner after delay (because when it's on top, the "LB" button is covered up)
	IEnumerator CloseLargeBanner(float time) {
		yield return new WaitForSeconds(time);
		FreestarUnityBridge.CloseBannerAd("", FreestarConstants.BANNER_AD_SIZE_300x250);
	}

	public void YesClicked ()
	{
		Debug.Log ("Yes Clicked...");
		AlertCanvas.enabled = false;

      ButtonSetup("reward", false);

			//Parma 1 : Secret Key (Get it from Vdopia Portal : Required if server-to-server callback enabled)
			//Parma 2 : User name
			//Param 3 : Reward Name or measure
			//Param 4 : Reward Amount or quantity
			FreestarUnityBridge.showRewardedAd("", 30,"coin","Chocolate1","XNydpzNLIj2pBRM8");

	}

	public void NoClicked ()
	{
		Debug.Log ("No Clicked...");
		AlertCanvas.enabled = false;
	}

	IEnumerator ShowGetRewardMessage (float delay) {
		GUITextMessage.enabled = true;
		yield return new WaitForSeconds(delay);
		GUITextMessage.enabled = false;
	}

	/// <summary>
	/// Ons the interstitial loaded.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onInterstitialAdLoaded(string id) {
		Debug.Log ("Unity id:" + id);
		// isInterstitialLoaded = true;
    ButtonSetup("interstitial", true);

	}
	/// <summary>
	/// Ons the interstitial failed.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onInterstitialAdFailed(string id) {
		//isInterstitialLoaded = false;
    ButtonSetup("interstitial", false);
		int errorID;
		if (int.TryParse (id, out errorID))
		{
			switch (errorID) {
			case 0:
				Debug.Log ("INVALID_REQUEST:" + errorID);
				break;
			case 1:
				Debug.Log ("INTERNAL_ERROR:" + errorID);
				break;
			case 2:
				Debug.Log ("NO_FILL:" + errorID);
				break;
			case 3:
				Debug.Log ("NETWORK_ERROR:" + errorID);
				break;
			case 4:
				Debug.Log ("INVALID_RESPONSE:" + errorID);
				break;
			}
		}
	}
	/// <summary>
	/// Ons the interstitial shown.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onInterstitialAdShown(string id)
	{
		Debug.Log ("Unity id:" + id);

	}
	/// <summary>
	/// Ons the interstitial clicked.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onInterstitialAdClicked(string id)
	{
		Debug.Log ("Unity id:" + id);

	}
	/// <summary>
	/// Ons the interstitial dismissed.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onInterstitialAdDismissed(string id) {
		//isInterstitialLoaded = false;
    ButtonSetup("interstitial", false);
    Debug.Log ("Unity id:" + id);

	}

	/// <summary>
	/// Rewardeds the video did load ad.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onRewardedAdLoaded(string id) {
		Debug.Log ("Unity id:" + id);
		//isRewardLoaded = true;
    ButtonSetup("reward", true);
	}

	/// <summary>
	/// Rewards the ad failed with error.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onRewardedAdFailed(string id) {
		// isRewardLoaded = false;
    ButtonSetup("reward", false);
		Debug.Log ("Unity id:" + id);

		int errorID;
		if (int.TryParse (id, out errorID)) {
			switch (errorID) {
			case 0:
				Debug.Log ("INVALID_REQUEST:" + errorID);
				break;
			case 1:
				Debug.Log ("INTERNAL_ERROR:" + errorID);
				break;
			case 2:
				Debug.Log ("NO_FILL:" + errorID);
				break;
			case 3:
				Debug.Log ("NETWORK_ERROR:" + errorID);
				break;
			case 4:
				Debug.Log ("INVALID_RESPONSE:" + errorID);
				break;
			}
		}

	}
	/// <summary>
	/// Rewardeds the video did finish.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onRewardedAdFinished(string id) {
		// isRewardCompleted = true;
    StartCoroutine(ShowGetRewardMessage (3));
		string[] array = id.Split(',');
		Debug.Log ("Unity id:" + array);
		foreach (string token in array) {
			// Parse the commands
			Debug.Log ("Reward Amount:" + array[0]);
			Debug.Log ("Reward Name:" + array[1]);
		}

		Debug.Log ("Unity id:" + id);

	}
	/// <summary>
	/// Rewardeds the video will dismiss.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onRewardedAdDismissed(string id) {
		Debug.Log ("Unity id:" + id);

	}

	/// <summary>
	/// Rewardeds the video did start video.
	/// </summary>
	/// <param name="id">Identifier.</param>
	public void onRewardedAdShown(string id) {
		Debug.Log ("Unity id:" + id);

	}

	public void onBannerAdShowing(string placement, int adSize) {
		Debug.Log(adSize == 0 ? "Small" : "Large" + " Banner Shown");
	}
	public void onBannerAdClicked(string placement, int adSize) {
		Debug.Log(adSize == 0 ? "Small" : "Large" + " Banner Clicked");
	}
	public void onBannerAdFailed(string placement, int adSize) {
		Debug.Log(adSize == 0 ? "Small" : "Large" + " Banner Failed");
	}

	public string UnityName(){
        return this.name;
    }

}
