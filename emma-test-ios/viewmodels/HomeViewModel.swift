//
//  HomeViewModel.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 30/6/25.
//

//

import Foundation
import EMMA_iOS
import Combine

/// ViewModel class for managing the Home view behavior and business logic.
class HomeViewModel: ObservableObject {
    
    // Published properties and enum for UI state management
    
    /// Indicates whether an EMMA session has started.
    @Published var sessionStarted: Bool = false
    
    /// Flag to control toast visibility.
    @Published var showToast = false
    
    /// Message to display in toast notifications.
    @Published var toastMessage = ""
    
    /// Enumeration to manage active sheets in the UI.
    enum ActiveSheet: Identifiable {
        case userInfo
        case nativeAd
        case coupons

        var id: String {
            switch self {
            case .userInfo: return "userInfo"
            case .nativeAd: return "nativeAd"
            case .coupons: return "coupons"
            }
        }
    }

    @Published var activeSheet: ActiveSheet? = nil
    
    // --- User and transaction properties ---
    
    // Behavior
    let userid = "Celia"
    let mail = "celia@emma.io"
    
    // Transactions
    @Published var transactionStarted = false
    @Published var isProductAdded = false
    @Published var quantity: Float = 0.0
    @Published var totalPrice: Float = 0.0
    let orderId = "Order_ID_test"
    let customerId = "Customer_ID_test"
    let productId = "Product_ID_test"
    let productName = "Product_name_test"
    
    // Tags
    @Published var userAge: String = ""
    
    // User info
    @Published var setcustomerId: String = ""
    @Published var userInfo: [String: Any] = [:]
    
    // Selected language
    @Published var selectedLanguage = "es"
    
    // In-App messages
    @Published var nativeAd: EMMANativeAd? = nil
    @Published var coupons: [EMMACoupon] = []
    @Published var coupon: EMMACoupon? = nil

    private var cancellables = Set<AnyCancellable>()

    /// Initializes the ViewModel, checking session status and subscribing to attribution updates.
    init() {
        checkSession()
        AttributionManager.shared.attributionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.toastMessage = message
                self?.showToast = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.showToast = false
                }
            }
            .store(in: &cancellables)
         
    }
    
    //                   //
    // --- Functions --- //
    //                   //


    // --- MARK: Session
    
    /// Checks whether the EMMA session is started.
    func checkSession() {
        sessionStarted = EMMA.isSessionStarted()
        print("VM - sessionStarted: \(sessionStarted)")
    }
    
    /// Starts an EMMA session if it's not already started.
    func startSessionIfNeeded() {
        if !sessionStarted {
            let config = EMMAConfiguration()
            config.sessionKey = "3DBF55A0B7BC550874edfbac6d5dc49f8"
            EMMA.startSession(with: config)

            // wait 0,5 secs before checking if EMMA session is started
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkSession()
            }
        }
    }
    
    // --- MARK: Behavior
    
    /// Registers a new user in EMMA. Using the method ``EMMA.registerUser(userId:forMail:andExtras:)`` allows to send information about the registrations in the application.
    func registerUser() {
        EMMA.registerUser(userId: userid, forMail: mail, andExtras: nil)
        showToast(message: "Register test: User \(userid) with email \(mail) registered.")
    }
    
    /// Logs in a user in EMMA. The method ``EMMA.loginUser(userId:forMail:andExtras:)`` allows to send information about login events.
    ///
    /// If we have a successive `login` event with the same data, we can use the method ``EMMA.loginDefault()``. This method would be useful in the case of an "Auto-Login", for example.
    func loginUser() {
        EMMA.loginUser(userId: userid, forMail: mail, andExtras: nil)
        showToast(message: "Login test: User \(userid) with email \(mail) logged in.")
    }
    
    // --- MARK: Transactions
    /// Starts a new order transaction. The method to start the transaction is ``EMMA.startOrder(orderId:andCustomer:withTotalPrice:withExtras:assignCoupon:)`
    func startOrder() {
        transactionStarted = true
        EMMA.startOrder(orderId: orderId, andCustomer: customerId, withTotalPrice: totalPrice, withExtras: nil, assignCoupon: nil)
        
        showToast(message: "Order started with order id: \(orderId)  and customer id: \(customerId)." )
    }
    
    /// Adds a product to the ongoing order, once the transaction is started. To do this we will use the method ``EMMA.addProduct(productId:andName:withQty:andPrice:withExtras:)``.
    ///
    /// It is important that the ``startOrder()`` is executed  before this method.
    func addProduct() {
        isProductAdded = true
        quantity += 1
        totalPrice = quantity * 10.0
        EMMA.addProduct(productId: productId, andName: productName, withQty: quantity, andPrice: totalPrice, withExtras: nil)
        showToast(message: "Product added with id: \(productId) and name: \(productName)")
    }
    
    /// Cancels the ongoing order. In this case, we will use the method ``EMMA.cancelOrder(orderId:)`
    func cancelOrder() {
        transactionStarted = false
        isProductAdded = false
        quantity = 0.0
        totalPrice = 0.0
        
        EMMA.cancelOrder(orderId: orderId)
        showToast(message: "Order with id: \(orderId) cancelled.")
    }
    
    /// Tracks and finalizes the ongoing order. Once we have all the products added, we execute the transaction measurement with the ``EMMA.trackOrder()`` method.
    func trackOrder() {
        EMMA.trackOrder()
        showToast(message: "Tracking order. Total products purchased: \(Int(quantity)). Total price: \(Int(totalPrice))€")
        transactionStarted = false
        isProductAdded = false
        quantity = 0.0
        totalPrice = 0.0
    }
    
    // --- MARK: Customized event
    
    /// Tracks a custom event using a predefined token.
    func trackEvent() {
        let eventToken = "83fdb9ae1fbdd2f8f95eb5d426b2e63e"
        EventManager.shared.trackCustomEvent(token: eventToken)
        showToast(message: "Tracking event with token \(eventToken)")
    }
    
    // --- MARK: User properties: TAG
    
    /// Tracks the user's age as a custom property (tag) in EMMA.
    func setAge() {
        if !userAge.isEmpty{
            EMMA.trackExtraUserInfo(info: ["AGE": userAge])
            showToast(message: "Age set as a TAG, with value = \(userAge)")
        } else {
            showToast(message: "Please enter an age")
        }
    }
    
    // --- MARK: User info
    
    /// Retrieves the current EMMA User ID.
    func getUserID(){
        EMMA.getUserId { (user_id) in
                guard let uid = user_id else {
                    self.showToast(message: "Error getting user id")
                    return
                }
            self.showToast(message: "Your EMMA USER ID is \(uid)")
            }
    }
    
    /// Retrieves the device ID used by EMMA.
    func getDeviceID(){
        let deviceId = EMMA.deviceId()
        showToast(message: "Your device ID is \(deviceId)")
    }
    
    /// Fetches the full user profile from EMMA.
    func getAllUserInfo(){
        EMMA.getUserInfo { (user_profile) in
            guard let profile = user_profile else {
                self.showToast(message: "Error getting user profile")
                return
            }
            
            // to dictionary
            var info: [String: Any] = [:]
            for (key, value) in profile {
                info["\(key)"] = value
            }
            
            DispatchQueue.main.async {
                self.userInfo = info
                self.activeSheet = .userInfo
            }
        }
    }
    
    /// Sets a custom Customer ID for the user.
    func setCustomerID(){
        EMMA.setCustomerId(customerId: customerId)
        showToast(message: "Customer ID set to: \(customerId)")
    }
    
    // --- MARK: Attribution
    
    /// Requests attribution information from EMMA.
    func requestAttribution() {
        AttributionManager.shared.requestAttributionInfo()
    }
    
    // --- MARK: Set user language
    
    /// Manually sets the user's preferred language by calling ``EMMA.setUserLanguage()``
    ///
    /// This method allows overwriting the default language of the device to set a custom language to be used in all SDK requests. This is useful in applications that allow the user to select a different language than the one configured on the device.
    /// The language code in ISO 639-1 format must be used: es (Spanish), en (English), fr (French), de (German), it (Italian), zh-Hans (Simplified Chinese), zh-Hant (Traditional Chinese), etc.
    func setLanguage(){
        EMMA.setUserLanguage(selectedLanguage)
        showToast(message: "Language changed to \(selectedLanguage)")
    }
    
    // --- MARK: InApp Messages
    
    // NativeAd
    
    func getNativeAd(templateId: String) {
        print("getNativeAd inits")
        NativeAdManager.shared.onAdReceived = { [weak self] nativeAd in
            DispatchQueue.main.async {
                if let ad = nativeAd {
                    self?.nativeAd = ad
                    self?.activeSheet = .nativeAd
                    print("if inits")
                } else {
                    self?.showToast(message: "No NativeAd found")
                    print("else init")
                }
            }
        }
        NativeAdManager.shared.getNativeAd(templateId: templateId)
        print("getNativeAd finish")
    }
    
    func onReceived(_ nativeAd: EMMANativeAd!) {
        guard let nativeAd = nativeAd else {
            self.showToast(message: "No NativeAd found")
            return
        }
        print("Received NativeAd with idPromo: \(nativeAd.idPromo)")
        EMMA.sendImpression(campaignType: .campaignNativeAd, withId: String(nativeAd.idPromo))
        DispatchQueue.main.async {
            self.nativeAd = nativeAd
        }
    }
    
    func onShown(_ campaign: EMMACampaign!) {}
    func onHide(_ campaign: EMMACampaign!) {}
    func onClose(_ campaign: EMMACampaign!) {}
    
    // Start View
    func getStartView() {
        let startViewinAppRequest = EMMAInAppRequest(type: .Startview)
        // Optional. You can filter by label
        //startViewinAppRequest.label = "<LABEL>"
        /*
         By default Startview presents on UIApplication.shared.delegate?.window?.rootViewController
         You can customize this behavior uncommenting following line
        */
        //EMMA.setRootViewController(UIViewController!)
        EMMA.inAppMessage(request: startViewinAppRequest)
    }
    
    // AdBall
    func getAdBall() {
        let adballRequest = EMMAInAppRequest(type: .Adball)
        EMMA.inAppMessage(request: adballRequest)
    }
    
    // Banner
    func getBanner() {
        let bannerRequest = EMMAInAppRequest(type: .Banner)
        EMMA.inAppMessage(request: bannerRequest)
    }
    
    // Strip
    func getStrip() {
        let stripRequest = EMMAInAppRequest(type: .Strip)
        EMMA.inAppMessage(request: stripRequest)
    }
    
    // Coupons
    func getCoupons() {
        CouponManager.shared.onCouponsReceived = { [weak self] coupons in
            DispatchQueue.main.async {
                if let firstCoupon = coupons.first {
                    self?.coupon = firstCoupon
                    self?.activeSheet = .coupons
                } else {
                    self?.showToast(message: "No coupon available")
                }
            }
        }
        
        CouponManager.shared.onError = { [weak self] in
            self?.showToast(message: "Error retrieving coupons")
        }
        
        CouponManager.shared.getCoupons()
    }
    
    // Dynamic Tab Bar
    func getDynamicTabBar() {
        // You must define your UITabBarController
        // Uncomment following line!
        // EMMA.setPromoTabBarController(UITabBarController!)

        // Sets default promo tab index if not defined in EMMA Platform
        //EMMA.setPromoTabBarIndex(index: 5)

        // Sets a tab bar item to be shown if not defined in EMMA Platform
        // EMMA.setPromoTabBarItem(UITabBarItem!)
        let dynamicTabBarRequest = EMMAInAppRequest(type: .PromoTab)
        EMMA.inAppMessage(request: dynamicTabBarRequest)
    }
    
    
    // Manual toast in the view
    func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showToast = false
        }
    }


    
}
