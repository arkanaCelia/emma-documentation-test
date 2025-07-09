# NativeAds

EMMA NativeAd allows you to get the information of a NativeAd corresponding to a template that has been defined and configured in the EMMA platform.

## How to implement

We will obtain all the NativeAd information available to the user regarding the ``templateId``, according to the conditions that have been configured on the EMMA platform. The ``EMMANativeAd`` object contains all the fields configured in EMMA for this NativeAd template, to obtain them the following method will be used:
```swift
import UIKit
import EMMA_iOS

class NativeAdExampleViewController: UIViewController, EMMAInAppMessageDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getNativeAd(templateId: String) {
        let nativeAdRequest = EMMANativeAdRequest()
        nativeAdRequest.templateId = templateId
        EMMA.inAppMessage(nativeAdRequest, with: self)
    }

    func getBatchNativeAd(templateId: String) {
        let nativeAdRequest = EMMANativeAdRequest()
        nativeAdRequest.templateId = templateId
        nativeAdRequest.isBatch = true
        EMMA.inAppMessage(nativeAdRequest, with: self)
    }

    // MARK: - InAppMessage Delegate
    func onReceived(_ nativeAd: EMMANativeAd!) {
        let content = nativeAd.nativeAdContent as? [String:AnyObject]
        if let title = content?["Title"] as? String) {
            print("Received NativeAd with Title: \(title)")
            // Draw Native Ad and Send Impression
            EMMA.sendImpression(.campaignNativeAd, withId: String(nativeAd.idPromo))
        }
    }

    func onBatchNativeAdReceived(_ nativeAds: [EMMANativeAd]!) {
        nativeAds.forEach { (nativeAd) in
            if let tag = nativeAd.tag {
                print("Received batch nativead with tag: \(tag)")
            }
        }
    }

    func openNativeAd(nativeAd: EMMANativeAd) {
        // This method executes CTA Action and sends NativeAd Click
        EMMA.openNativeAd(String(nativeAd.idPromo))
    }

    func sendNativeAdClick(nativeAd: EMMANativeAd) {
        // Send manual click. Useful if we want to override CTA action
        EMMA.sendClick(.campaignNativeAd, withId: String(nativeAd.idPromo))
    }

    func onShown(_ campaign: EMMACampaign!) {

    }

    func onHide(_ campaign: EMMACampaign!) {

    }

    func onClose(_ campaign: EMMACampaign!) {

    }
}
```
``onReceived`` is called if there is a NativeAd corresponding to the template with identifier “templateId”.

``onBatchReceived`` is called when the NativeAd call is made with the batch parameter set to true and one or more NativeAds corresponding to the template with identifier "templateId" exist.

``EMMANativeAd`` contains all the fields configured in EMMA for this NativeAd template, to obtain them the following method will be used:

```swift
let content = nativeAd.nativeAdContent as? [String:AnyObject]
let title = content?["Title"] as? String
let image = content?["Main picture"] as? String
let cta = content?["CTA"] as? String
printSide(title, image, cta)
```

In the case of configuring a container template, the NativeAd values can be obtained as follows:

``` swift
let content = nativeAd.nativeAdContent
if let container = content?["container"] as? Array<[String: String]> {
   container.forEach { (containerFields: [String : String]) in
     let title = containerFields?["Title"]
     let image = containerFields?["Main picture"]
     let cta = containerFields?["CTA"]
     printSide(title, image, cta)
   }
}
```
Once all the required fields have been obtained, the view can be created to paint this NativeAd on the screen depending on the design that you want to apply to it. Once the NativeAd has been painted on the screen, it is necessary to call this method to obtain the impressions in the reporting:

``` swift
EMMA.sendImpression(.campaignNativeAd, withId: String(nativeAd.idPromo))
```
### Open a Native Ad
```swift
func openNativeAd(nativeAd: EMMANativeAd) {
    // This method executes CTA Action and sends NativeAd Click
    EMMA.openNativeAd(String(nativeAd.idPromo))
}
```

With this call, the content of the link configured in the NativeAd will be displayed from the EMMA platform. The openNativeAd method internally sends the event click to EMMA.

Alternatively, if this method is not used, the click can be sent by calling the method:

``` swift
func sendNativeAdClick(nativeAd: EMMANativeAd) {
    // Send manual click. Useful if we want to override CTA action
    EMMA.sendClick(.campaignNativeAd, withId: String(nativeAd.idPromo))
}
```

