//
//  ContentView.swift
//  emma-test-ios
//
//  Created by Celia Pérez Vargas on 26/6/25.
//


import SwiftUI
import EMMA_iOS

struct HomeView: View {
    
    // --- variables --- //
    @StateObject private var viewModel = HomeViewModel()
    
    // Tags
    @State private var userAge: String = ""
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {  // Espacio entre elementos verticales
                
            // --- MARK: Home banner
                
                Image("emmaBanner")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top)
                
            
            // --- MARK: Behavior
                
                VStack {
                    Text("Behavior events")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("These events are common to all applications, and are automatically created when EMMA integration is performed. Try with these buttons some of the events.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    // Register + Login + StartSession
                    Text("Simulate a register or a login in the app.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    HStack{
                        
                        //btnRegister
                        Button("Register") {
                            viewModel.registerUser()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        //btnLogin
                        Button("Login") {
                            viewModel.loginUser()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        //btnStartsession
                        Button(viewModel.sessionStarted ? "Session started" : "Start session") {
                            viewModel.startSessionIfNeeded()
                        }
                        .padding()
                        .background(viewModel.sessionStarted ? Color.gray : Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .disabled(viewModel.sessionStarted)
                        
                    }
                    
                    
                    Text("EMMA allows you to measure any transaction or purchase made in your app.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    HStack{
                        
                        //btnStartOrder
                        Button("Start Order") {
                            viewModel.startOrder()
                        }
                        .padding()
                        .background(viewModel.transactionStarted ? Color.gray : Color.emmaGreen)
                        .disabled(viewModel.transactionStarted)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        Button("Add Product") {
                            viewModel.addProduct()
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(viewModel.transactionStarted ? Color.emmaGreen : Color.gray)
                        .disabled(!viewModel.transactionStarted)
                        .cornerRadius(10)
                        
                    }
                    
                    HStack{
                        
                        //btnCancelOrder
                        Button("Cancel Order") {
                            viewModel.cancelOrder()
                        }
                        .padding()
                        .background(viewModel.transactionStarted ? Color.emmaGreen : Color.gray)
                        .disabled(!viewModel.transactionStarted)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        //btnTrackOrder
                        Button("Track Order") {
                            viewModel.trackOrder()
                        }
                        .padding()
                        .background(viewModel.isProductAdded ? Color.emmaGreen : Color.gray)
                        .disabled(!viewModel.isProductAdded)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                    }
                    if viewModel.transactionStarted {
                        // table show transaction
                        HStack(alignment: .top) {
                            // Column 1: Product name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Product name")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                Text(viewModel.productName)
                                    .font(.body)
                                    .foregroundColor(Color.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            // Column 2: Quantity
                            VStack(alignment: .center, spacing: 8) {
                                Text("Quantity")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                Text("\(Int(viewModel.quantity))")
                                    .font(.body)
                                    .foregroundColor(Color.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            // Column 3: Price
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Price")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                Text("\(Int(viewModel.totalPrice))")
                                    .font(.body)
                                    .foregroundColor(Color.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .opacity(viewModel.transactionStarted ? 1 : 0)
                    }
                    
                    
                }
                
                
            // --- MARK: Custom Events
                
                VStack {
                    Text("Customized Event")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("These are all those actions or sections within the application that are unique to your application. You must configure a Customized Event on EMMA and get the Event token there.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Clic on the button to track a customized event.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    Button("Track event") {
                        viewModel.trackEvent()
                        
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
            
                
            // --- MARK: User properties: TAG
                
                VStack {
                    Text("User properties (TAG)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("With this method you can update or add extra parameters in order to get better segmentation in the Users with tag filtering.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    // Register + Login + StartSession
                    Text("Change your age tag.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    TextField("Write your age", text: $viewModel.userAge)
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding(.top)
                    
                    Button("Set age") {
                        viewModel.setAge()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
                
                
            // --- MARK: User info
                
                VStack {
                    Text("User info")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("We can retrieve the EMMA user ID, the device ID or set the customer ID independently of the login/registration.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Get the info with these buttons, or set the customer ID manually.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    HStack{
                        Button("Get user ID") {
                            viewModel.getUserID()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        Button("Get device ID") {
                            viewModel.getDeviceID()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                    }
                    
                    Button("Get all user info") {
                        viewModel.getAllUserInfo()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    TextField("Write a customer ID", text: $viewModel.setcustomerId)
                    .padding()
                    .frame(width: 250, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    .multilineTextAlignment(.center)
                    .keyboardType(.default)
                    .padding(.top)
                    
                    Button("Set customer ID") {
                        viewModel.setCustomerID()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
                
                
            // --- MARK: Set user language
                
                VStack {
                    Text("Set language")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("This method allows overwriting the default language of the device to set a custom language to be used in all SDK requests.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Manually sets the user's preferred language.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    Picker(selection: $viewModel.selectedLanguage, label: Text("Language")) {
                        Text("Spanish").tag("es")
                        Text("English").tag("en")
                        Text("French").tag("fr")
                        Text("German").tag("de")
                        Text("Italian").tag("it")
                        Text("Chinese").tag("zh-Hans")
                    }
                    .pickerStyle(.menu)
                    
                    Button("Set language") {
                        viewModel.setLanguage()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
                
            // --- MARK: Installation attribution
                    
                VStack {
                    Text("Attribution info")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("It is possible to get the installation attribution data for each user")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        
                    Text("Clic on the button to get attribution info.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    Button("View attribution info") {
                        viewModel.requestAttribution()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                        
                    }
                
                
            // --- MARK: In-App Messages
                
                VStack {
                    Text("InApp Messages")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("EMMA includes 8 different communication formats that you can integrate to impact your users on iOS.")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("You must configure them in EMMA and be sure they are ACTIVE to see them in this test. Clic on the buttons to see each message in-app.")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.customGrey)
                        .multilineTextAlignment(.center)
                        .padding([.top, .leading, .trailing])
                    
                    HStack{
                        Button("NativeAd") {
                            print("asking for native ad from button")
                            viewModel.getNativeAd(templateId: "plantilla-prueba-celia")
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        Button("StartView") {
                            viewModel.getStartView()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                    }
                    HStack{
                        Button("AdBall") {
                            viewModel.getAdBall()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        Button("Banner") {
                            viewModel.getBanner()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                    }
                    HStack{
                        Button("Strip") {
                            viewModel.getStrip()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        Button("Coupon") {
                            viewModel.getCoupons()
                        }
                        .padding()
                        .background(Color.emmaGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                    }
                    Button("DynamicTab") {
                        viewModel.getDynamicTabBar()
                    }
                    .padding()
                    .background(Color.emmaGreen)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
                
                Spacer()  // pushing elements up
                .padding()
                
            }// end of VStack principal
            
            .onAppear {
                //waits 1sec after the view appears to check if the session is started
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.checkSession()
                }
                
                
            }
                
        }// end of scrollview
        
        // Sheet with userinfo or nativeAd
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .userInfo:
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.userInfo.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text("\(key): \(String(describing: value))")
                                .font(.body)
                                .padding(.vertical, 2)
                        }
                    }
                    .padding()
            }
            case .nativeAd:
                if let nativeAd = viewModel.nativeAd {
                    NativeAdView(nativeAd: nativeAd)
                } else {
                    Text("No ad to show")
                        .padding()
                }
            case .coupons:
                if let coupon = viewModel.coupon {
                    CouponView(coupon: coupon)
                } else {
                    Text("No coupon to show")
                        .padding()
                }
                
            }
        }

        
        // Toast for UI information
        .overlay(
            Group {
                if viewModel.showToast {
                    ToastView(message: viewModel.toastMessage)
                        .padding(.bottom, 60)
                }
            },
            alignment: .bottom
        )

            
    }//end of body
    
    // --- other functions --- //
    
        
}

