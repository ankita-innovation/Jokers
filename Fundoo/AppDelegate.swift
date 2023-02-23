//
//  AppDelegate.swift
//  Randoo
//
//  Created by HTS-Product on 28/01/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import SwiftyJSON
import Firebase
import FirebaseDynamicLinks
import FirebaseAuthUI
import FirebasePhoneAuthUI
import GTMSessionFetcher
import LocalAuthentication
import Alamofire
import AVFoundation

var isSocketConnected = false
var launchURL :URL? = nil
var isWatchingLive = false
let localAuthenticationContext = LAContext()
// qwerty
var isNewUser = false

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,SRWebSocketDelegate,MessagingDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    
    var baseUUId = UUID()
    var isCurrentChattingUser = String()
    var isLockedscreen = ""
    var postRequest: DataRequest?
    var windowwidth = 0.0
    var windowheight = 0.0
    var newNotificationViewed = Bool()
    var pickedFromGallery = Bool()
    var postRefresh = false
    var messengerID = ""
    
    var Translatetext = false
    var chattranslate : String!
    var chattranslatecode : String!
    var newlanguagecodevalue = ""

    // MARK: - App delegate Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        do {
//            try HLSVideoCache.shared.clearCache()
//        } catch let error {
//            print("Error: \(error)")
//        }
        
        self.initialSetup()
        userDefault.set("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3QxMDBAZ21haWwuY29tIiwidXNlcm5hbWUiOiJ0ZXN0MTAwIiwiaWQiOiI2M2Y3MWY4ZmQyNjUwMTY5MzM5ZGMyODIiLCJpYXQiOjE2NzcxMzk5ODgsImV4cCI6MTY3ODAwMzk4OH0.w-ySwp6JOIC_IAIkJorjYG2Gfmc_Y_1aDXpxWdHZItQ", forKey: USER_DEFAULT_userLoginToken_Key)

        self.navigateToRightScreen()
        // Config firebase
        UserDefaults.standard.setValue("", forKey: "MsgNotification")
        DispatchQueue.main.async {
            NetworkStatus.shared.start()
        }
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        var options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        let languagevalue = UserModel.shared.getLanguagename()
        if (languagevalue != nil){
            newlanguagecodevalue = "en"
            chattranslate = UserModel.shared.getLanguagename()
            UserModel.shared.SetLanguagename(id: UserModel.shared.getLanguagename() ?? "")
            UserModel.shared.SetLanguageCode(id: UserModel.shared.getLanguageCode() ?? "")
        }
        else{
            newlanguagecodevalue = "en"
            chattranslate = "None"
            UserModel.shared.SetLanguagename(id: chattranslate)
            UserModel.shared.SetLanguageCode(id: newlanguagecodevalue)
        }
        print ("chattranslate",chattranslate)
        print ("newlanguagecodevalue",newlanguagecodevalue)
        
        application.registerForRemoteNotifications()
        connectSockets()
        
        TextViewAround.executeWorkaround()
        
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        GTMSessionFetcher.setLoggingEnabled(true)
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = IOS_BUNDLE_ID
        // Initialize the Google Mobile Ads SDK.
        //        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        
        //        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
        //
        //            self.redirectToMsgView()
        //            }
        //       self.initialSetup()
        if UserModel.shared.passcode()! {
            let lockObj = LockScreen()
            lockObj.modalPresentationStyle = .fullScreen
            self.window?.rootViewController!.present(lockObj, animated: false, completion: nil)
        }
        return true
    }
    
    func navigateToRightScreen(){
        
        
        if userDefault.value(forKey: USER_DEFAULT_userLoginToken_Key) != nil{//} && UserDefaultsToStoreUserInfo.getuserID() != emptyStr{
            print("user_id.1", userDefault.value(forKey: USER_DEFAULT_userLoginToken_Key))
//
//
//            let otherVCObj = TabViewController(nibName: "TabViewController", bundle: nil)
//            let navController = UINavigationController.init(rootViewController: otherVCObj)
//
//            self.window?.rootViewController = navController
//            self.navigationController?.pushViewController(otherVCObj, animated: true)
            
            
            let storyboard = UIStoryboard(name: enumStoryBoard.tabBar.rawValue, bundle: nil)
            let MainView = storyboard.instantiateViewController(withIdentifier: enumViewControllerIdentifier.tabBarVC.rawValue) as! TabBarVC

            let navController = UINavigationController.init(rootViewController: MainView)

            self.window?.rootViewController = navController
            
        }else{
            print("user_id.2", userDefault.value(forKey: USER_DEFAULT_userLoginToken_Key))

            let storyboard = UIStoryboard(name: enumStoryBoard.initial.rawValue, bundle: nil)
            let MainView = storyboard.instantiateViewController(withIdentifier: enumViewControllerIdentifier.initialVC.rawValue) as! InitialVC

            let navController = UINavigationController.init(rootViewController: MainView)

            self.window?.rootViewController = navController
        }
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
        self.newNotificationViewed = true
        //if !isSocketConnected{
        self.connectSockets()
        Utility.shared.clearNotifications()
        // }
        
        
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("did enter background *************************")
        
        //        self.newNotificationViewed = true
        //        if !isSocketConnected{
        //            self.connectSockets()
        //            Utility.shared.clearNotifications()
        //        }
        //        connectSockets()
        //        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        //        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        //        voipRegistry.delegate = self;
        //        TextViewAround.executeWorkaround()
        
        if isSocketConnected {
            isSocketConnected = false
            HSChatSocket.sharedInstance.disconnect()
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("did become active foreground")
        // if !isSocketConnected{
        self.connectSockets()
        // }
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("did become active")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.newNotificationViewed = true
        
        //  if !isSocketConnected{
        self.connectSockets()
        HSChatSocket.sharedInstance.makeAlive()
        Utility.shared.clearNotifications()
        self.showNetworkAlert()
        //  }
        if !Connectivity.isConnectedToInternet() {
            let alert = AlertController(title: nil, message: Utility.shared.getAppLanguage()?.value(forKey: "URLSessionTask failed with error: The Internet connection appears to be offline.") as? String ?? "URLSessionTask failed with error: The Internet connection appears to be offline.", preferredStyle: .alert)
            NotificationCenter.default.addObserver(alert, selector: #selector(AlertController.hideAlertController), name: Notification.Name("DismissAllAlertsNotification"), object: nil)
            alert.addAction(UIAlertAction(title: (Utility.shared.getAppLanguage()?.value(forKey: "setting") as? String ?? "setting"), style: .cancel, handler: { UIAlertAction in
                guard let profileUrl = URL(string: "App-Prefs:root=General") else {
                    return
                }
                if UIApplication.shared.canOpenURL(profileUrl) {
                    UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                        print(" Profile Settings opened: \(success)")
                    })
                }
            }))
            self.window?.rootViewController!.present(alert, animated: false, completion: nil)
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //        Utility.shared.setDefaultFilter()
        self.saveContext()
        
        print("App is completely closed")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        } else if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if dynamicLink.url != nil{
                let code = dynamicLink.url!.absoluteString.replacingOccurrences(of: "\(SITE_URL)/appstore?referal_code=", with: "")
                UserModel.shared.setInvite(code: code as NSString)
            }
            return true
        } else {
            return false
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            let inviteStr = dynamiclink!.url!.absoluteString
            if inviteStr.contains("referal_code"){ // referral invite link
                let code = dynamiclink!.url!.absoluteString.replacingOccurrences(of: "\(INVITE_URL)/appstore?referal_code=", with: "")
                UserModel.shared.setInvite(code: code as NSString)
            }else{ // video invite link
                if UserModel.shared.userID() != nil {
                    let id = dynamiclink!.url!.absoluteString.replacingOccurrences(of: "\(INVITE_URL)/appstore?stream_name=", with: "")
                    print("stream name \(id)")
                    self.getStreamInfo(stream_id: id)
                }
            }
        }
        return handled
    }
    
    @available(iOS 9.0, *)
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
    }
    
    //intial setup
    func initialSetup()  {
    
        // UI Setup
        let screenSize = UIScreen.main.bounds
        windowwidth = Double(screenSize.width)
        windowheight = Double(screenSize.height)
        pickedFromGallery = false
        
        self.isCurrentChattingUser = ""
        UserModel.shared.setLive(status: ONLINE)
        //language
        if UserModel.shared.getLanguage() == nil{
            UserModel.shared.setLanguage(lan: DEFAULT_LANGUAGE)
        }else{
            UserModel.shared.setLanguage(lan: UserModel.shared.getLanguage()!)
        }
        UserModel.shared.setCall(enable: false)
        
        Utility.shared.configLanguage()
        Utility.shared.getDefaultDetails()
        //initial view
        //qwerty
        let homeViewController = SplashVc()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let nav = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = nav
/*
        self.setInitialViewController()
*/
        //app permission
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.appPermissions()
        }
        
        //keyboard
        IQKeyboardManager.shared.enable = true
        
        if UserModel.shared.userID() != nil {
            Utility.shared.checkBlocked()
        }
        self.checkLocalAuthenticaionAvailablity()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        UserModel.shared.setFCM(id: fcmToken ?? "")
        Utility.shared.pushsignIn()
        // device_token = fcmToken ?? ""
        //        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        //        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("FIRBASE PUSH KIT TOKEN \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
//        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
                        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    //MARK:FCM PUSH NOTIFICATION ACTION when app open
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("FCM MESSAGE \(userInfo)")
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        newNotificationViewed = false
        print(userInfo)
        
        //        if application.applicationState == .background || application.applicationState == .inactive {
        //            self.redirectToMsgView()
        //            }
        //completionHandler(UIBackgroundFetchResult.newData)
        
        // This noredtification is not auth related, developer should handle it.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let msgDict = notification.request.content.userInfo["notification_data"] as? String {
            let msgDict = self.convertToDictionary(text: notification.request.content.userInfo["notification_data"] as? String ?? "")
            print("PRESENT MESSAGE \(msgDict)")
            var showMsg = true
            let scope = msgDict!.value(forKey: "scope") as! String
            if scope == "admin"{
                Utility.shared.getAdminMsg()
                NotificationCenter.default.post(name: UIApplication.didFinishLaunchingNotification, object: "myObject", userInfo: nil)
                if APP_NAME == self.isCurrentChattingUser {
                    showMsg = false
                }
            }else if scope == "txtchat"{
                let user_id = msgDict!.value(forKey: "user_id") as! String
                if user_id == self.isCurrentChattingUser {
                    showMsg = false
                }
            }
            if showMsg{
                completionHandler([.alert, .badge, .sound])
            }
        }
        else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    //MARK: push notificatio tap action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if !isSocketConnected{
            self.connectSockets()
        }
        
        UserDefaults.standard.setValue("true", forKey: "user_tapped_notification")
        UserDefaults.standard.synchronize()
        let msgDict = self.convertToDictionary(text: response.notification.request.content.userInfo["notification_data"] as! String)
        print("user notification\(msgDict)")
        let scope = msgDict?.value(forKey: "scope") as! String
        
        //        if !isLive{
        if scope == "txtchat"{
            messengerID = msgDict?.value(forKey: "user_id") as! String
            self.redirectToMsgView()
            
            //                let user_id = msgDict?.value(forKey: "user_id") as! String
            //                let user_name = msgDict?.value(forKey: "user_name") as! String
            //                let user_image = msgDict?.value(forKey: "user_image") as! String
            //                Utility.shared.setMsg(scope: scope, name: user_name, id: user_id, img: user_image)
        }else if scope == "like" || scope == "gift"{
            self.redirectToTabBar()
//            self.redirectToSingleVideoPage(videoID: Video_ID, isFrom: "")
        }
        else if scope == "comment" || scope == "mention"{
            self.redirectToTabBar()
//            self.redirectToSingleVideoPage(videoID: Video_ID, isFrom: "notification")
        }
        else if scope == "admin"{
            Utility.shared.getAdminMsg()
//            Utility.shared.setMsg(scope: scope, name: "\(APP_NAME) \(Utility().getAppLanguage()?.value(forKey: "team") as! String)" , id: APP_NAME, img: "")
//            messengerID = "Fundoo"
            self.redirectToAdminMsgView()
            
            
        }else if scope == "follow" {
            self.redirectToTabBar()
        }else if scope == "match" || scope == "interest"{
            Utility.shared.setInterest(scope: scope)
        }else if scope == "followeronlive" || scope == "streaminvitation"{
            let stream_id = msgDict?.value(forKey: "stream_name") as! String
//            self.getStreamInfo(stream_id: stream_id)
            self.redirectToSingleVideoPage(videoID: stream_id, isFrom: "")
        }
        else if scope == "follow" {
            redirectToTabBar()
        } else if scope != "followeronlive" || scope != "streaminvitation"{
            
            if UIApplication.shared.applicationState == .active || self.isLockedscreen == ""{
                UserDefaults.standard.setValue("false", forKey: "tapped_from_backgroud")
                UserDefaults.standard.synchronize()
                self.redirectToMsgView()
            }
            else{
                if UIApplication.shared.applicationState == .inactive || UIApplication.shared.applicationState == .background{
                    UserDefaults.standard.setValue("false", forKey: "tapped_from_backgroud")
                    UserDefaults.standard.synchronize()
                    self.redirectToView()
                }
                //                let notificationData = response.notification.request.content.userInfo
                //                self.isNotification = "background"
                //                UserDefaults.standard.setValue("", forKey: "tapped_from_backgroud")
                //                UserDefaults.standard.synchronize()
                //                   self.redirectToView()
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //                    if !UserModel.shared.passcode()! {
                //                        if self.isShowLive != "true"{
                //                            self.redirectToView()
                //                        }
                //                    }
                //                }
                //                //        }
            }
            
        }
        completionHandler()
    }
    func redirectToAdminMsgView() {
        let messageArray: NSArray = Entities.sharedInstance.getChats()
        let msgDetail = MessageDetailPage()
        msgDetail.isFromNotification = true
        let chats = messageArray.object(at: 0)
        let model = chats as! Recents
        msgDetail.contactID = model.user_id!
        msgDetail.contactName = model.user_name!
        msgDetail.contactImg = model.user_image!
        msgDetail.isBlocked = model.isBlocked
        msgDetail.modalPresentationStyle = .fullScreen
        if let vc = self.window?.visibleViewController() {
            self.window?.rootViewController?.present(msgDetail, animated: true, completion: nil)
        }
        else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = msgDetail
        }
        
    }
    func redirectToTabBar() {
        if let vc = self.window?.visibleViewController(), (vc == StoryFeedVC() || vc == TrendingPage() || vc == NotificationPage() || vc == ProfileViewController()){
            if let viewController = vc as? TabViewController {
//                viewController.runtimeTabBarChanges(tabbarBackground_imge_color: UIColor.white, selectedTint: .white, unselectedTint: FOLLOW_BACKGROUND_COLOR)
                viewController.selectedIndex = 3
            }
        }
        else {
            let vc = TabViewController()
            vc.selectedIndex = 3
//            vc.runtimeTabBarChanges(tabbarBackground_imge_color: UIColor.white, selectedTint: .white, unselectedTint: FOLLOW_BACKGROUND_COLOR)
            appDelegate.window?.rootViewController = vc
        }
    }
    func redirectToMsgView() {
        UserDefaults.standard.setValue("", forKey: "MsgNotification")
        let messageArray: NSArray = Entities.sharedInstance.getChats()
        var ind: Int?
        for i in (0..<messageArray.count) {
            let dict  = messageArray[i] as! Recents
            if let value = dict.user_id, value == messengerID {
                ind = i
            }
        }
        if ind != nil {
            if let vc = self.window?.visibleViewController() {
                let msgDetail = MessageDetailPage()
                msgDetail.isFromNotification = true
                let model = messageArray[ind!] as! Recents
                msgDetail.contactID = model.user_id!
                msgDetail.contactName = model.user_name!
                msgDetail.contactImg = model.user_image!
                msgDetail.isBlocked = model.isBlocked
                msgDetail.modalPresentationStyle = .fullScreen
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.window?.rootViewController!.present(msgDetail, animated: true, completion: nil)
                }
            }
            else {
                let msgDetail = MessageDetailPage()
                msgDetail.isFromNotification = true
                msgDetail.isFromNotification = true
                let model = messageArray[ind!] as! Recents
                msgDetail.contactID = model.user_id!
                msgDetail.contactName = model.user_name!
                msgDetail.contactImg = model.user_image!
                msgDetail.isBlocked = model.isBlocked
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.makeKeyAndVisible()
                window?.rootViewController = msgDetail
            }
        }
        
    }
    
    func redirectToNotifyView() {
        if UserModel.shared.profileStatus() != nil {
            //            window = UIWindow(frame: UIScreen.main.bounds)
            //            window?.makeKeyAndVisible()
            if let vc = UIApplication.shared.keyWindow?.rootViewController as? TabViewController{
                vc.selectedIndex = 3
//                vc.runtimeTabBarChanges(tabbarBackground_imge_color: UIColor.white, selectedTint: UIColor.white, unselectedTint: TABBAR_COLOR)
                appDelegate.window?.rootViewController = vc
                
            }
            
            
            //            let viewController = NotificationPage()
            //            window?.rootViewController = viewController
        }
    }
    
    func redirectToSingleVideoPage(videoID video_id: String, isFrom:String) {
        if UserModel.shared.profileStatus() != nil {
            let viewController = ShowAllViewController()
            viewController.removeStoryData = { [weak self] videoID in
                
            }
            viewController.isFromNotification = true
            viewController.videoID = video_id
            if isFrom != "" {
                viewController.isFromComment = true
            }
            if let vc = self.window?.visibleViewController() {
                if let viewController = vc as? ShowAllViewController {
                    viewController.isFromNotification = true
                    viewController.videoID = video_id
                    viewController.getData(offset: 0)
                }
                else {
                    if let viewController = vc as? StoryFeedVC {
                        DispatchQueue.main.async {
                            viewController.isPlayVideo = false
                            viewController.stopAllPlayer()
                        }
                    }
                    self.window?.rootViewController!.present(viewController, animated: true, completion: nil)
                }
            }
            else {
                window = UIWindow(frame: UIScreen.main.bounds)
                window?.makeKeyAndVisible()
                window?.rootViewController = viewController
            }
        }
        
    }
    
    func redirectToView()  {
        //delay based on app state
        if isSocketConnected{
            self.setInitialViewController()
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.redirectToView()
            }
        }
    }
    
    //get details from server
    func getStreamInfo(stream_id:String){
        let Obj = BaseWebService()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(stream_id, forKey: "name")
        Obj.baseService(subURl: STREAM_INFO_API, params: requestDict as? Parameters, onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            if status == "true"{
                var isAccess = Bool()
                let mode = dict?.value(forKey: "mode") as! String
                if mode == "private"{
                    let publisher_id = dict?.value(forKey: "publisher_id") as! String
                    let groupmembers = dict?.value(forKey: "group_members") as! NSArray
                    if groupmembers.contains(UserModel.shared.userID()!) || publisher_id == UserModel.shared.userID(){
                        isAccess = true
                    }else{
                        isAccess = false
                    }
                }else{
                    isAccess = true
                }
                if isAccess{
                    UserDefaults.standard.setValue("true", forKey: "user_tapped_notification")
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.setValue("true", forKey: "tapped_from_backgroud")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.shared.setVideo(dict: dict!)
                        if !UserModel.shared.passcode()! {
                            self.redirectToView()
                        }
                    }
                }else{
                    let alertVC = CPAlertVC(title:APP_NAME, message: Utility().getAppLanguage()?.value(forKey: "private_video_alert") as! String)
                    alertVC.animationType = .bounceUp
                    alertVC.addAction(CPAlertAction(title: Utility().getAppLanguage()?.value(forKey: "okay") as! String, type: .normal, handler: {
                    }))
                    alertVC.show(into: self.window?.rootViewController)
                }
            }else{
                print("notification alert")
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
                //                let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "video_deleted_alert") as? String, preferredStyle: UIAlertController.Style.alert)
                //                      let dismiss = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "okay") as? String, style: UIAlertAction.Style.cancel, handler: nil)
                //                      otherAlert.addAction(dismiss)
                //
                //                self.window?.rootViewController?.present(otherAlert, animated: true, completion: nil)
                
                let alertVC = CPAlertVC(title:APP_NAME, message: Utility().getAppLanguage()?.value(forKey: "video_deleted_alert") as! String)
                alertVC.animationType = .bounceUp
                alertVC.addAction(CPAlertAction(title: Utility().getAppLanguage()?.value(forKey: "okay") as! String, type: .normal, handler: {
                }))
                alertVC.show(into: self.window?.rootViewController)
            }
        })
    }
    
    // MARK: - Methods to set Initial flow of the app
    
    //check user logged in or out
    func setInitialViewController()  {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewController = self.checkUserProfileStatus()
        /*
        let root = UINavigationController(rootViewController: viewController)
        root.navigationBar.isTranslucent = false
         */
        window?.rootViewController = viewController
    }
    
//    func moveLoginPage()  {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        let viewController = LoginPage()
//        let root = UINavigationController(rootViewController: viewController)
//        //        root.navigationBar.isTranslucent = false
//        window?.rootViewController = root
//    }
//
    func checkUserProfileStatus()->UIViewController {
        if UserModel.shared.profileStatus() != nil {
            return TabViewController()
        }else if UserModel.shared.firstLogin() != nil{
            return TabViewController()
        }else{
            return InitialVC()
        }
    }
    
    func appPermissions()  {
        //camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
        }
        //micro
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            
        })
        //Photo album
        PhotoAlbum.init()
    }
    
    func checkLocalAuthenticaionAvailablity() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        } else {
            UserModel.shared.setPasscode(status: false)
        }
    }

    
    // MARK: - SOCKET LISTENERS
    
    func connectSockets()  {
        if  UserModel.shared.userID() != nil{
            if chatSocket.readyState.rawValue != 1{
                HSChatSocket.sharedInstance.connect()
            }
            chatSocket.delegate = self
        }
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("SOCKET CONNECTED \(webSocket.url.absoluteString)")
        isSocketConnected = true
        if self.isChat(socket: webSocket.url.absoluteString) {
            HSChatSocket.sharedInstance.makeAlive()
            //  appDelegate.connectSockets()
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("SOCKET NOT CONNECTED \(error.localizedDescription) URL \(webSocket.url.absoluteString)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print("GOT MSG \(String(describing: message))")
        let jsonString = message as! String
        let data = jsonString.data(using: .utf8)!
        do {
            let  msg = try JSON(data: data)
            let type = msg["type"].stringValue
            if type == "_callRejected" {
                HSChatSocket.sharedInstance.passDetails(type: type, dict:msg.dictionaryObject! as NSDictionary )
            }
            else if type == "_receiveChat" {
                Utility.shared.addToLocal(dict: msg.dictionaryObject! as NSDictionary)
            }else if type == "_offlineChat"{
                print("offline msg \(msg.dictionaryObject!)")
                Utility.shared.addOfflineMsg(dict:  msg.dictionaryObject! as NSDictionary)
            }else if type == "_receiveReadStatus"{
                Utility.shared.updateReadStatus(dict:msg.dictionaryObject! as NSDictionary)
            }else if type == "_offlineReadStatus"{
                Utility.shared.addOfflineReadStatus(dict:msg.dictionaryObject! as NSDictionary)
            }else if type == "_onlineListStatus"{
                HSChatSocket.sharedInstance.passDetails(type: type, dict:msg.dictionaryObject! as NSDictionary)
            }else{
                HSChatSocket.sharedInstance.passDetails(type: type, dict:msg.dictionaryObject! as NSDictionary)
            }
            
        } catch  {
            
        }
    }
    
    //check if socket is chat socket or random socket
    func isChat(socket:String) -> Bool {
        let chatSocket = "\(WEB_SOCKET_CHAT_URL)\(UserModel.shared.userID()!)"
        if socket == chatSocket {
            return true
        }
        return false
    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
                
            } else {
                
                return vc;
            }
        }
    }
}
extension AppDelegate {
    
    func showNetworkAlert() {
        NetworkStatus.shared.listener = { [weak self] (status) in
            DispatchQueue.main.async{
                if status {
                    NotificationCenter.default.post(name: Notification.Name("DismissAllAlertsNotification"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("CheckReachability"), object: nil)
                }
                else {
                    if let alert = self?.window?.rootViewController as? AlertController {
                        alert.message = Utility.shared.getAppLanguage()?.value(forKey: "URLSessionTask failed with error: The Internet connection appears to be offline.") as? String ?? "URLSessionTask failed with error: The Internet connection appears to be offline."
                    }
                    else {
                        guard  let self = self else {
                            let alert = AlertController(title: nil, message: Utility.shared.getAppLanguage()?.value(forKey: "URLSessionTask failed with error: The Internet connection appears to be offline.") as? String ?? "URLSessionTask failed with error: The Internet connection appears to be offline.", preferredStyle: .alert)
                            NotificationCenter.default.addObserver(alert, selector: #selector(AlertController.hideAlertController), name: Notification.Name("DismissAllAlertsNotification"), object: nil)
                            alert.addAction(UIAlertAction(title: (Utility.shared.getAppLanguage()?.value(forKey: "setting") as? String ?? "setting"), style: .cancel, handler: { UIAlertAction in
                                guard let profileUrl = URL(string: "App-Prefs:root=General") else {
                                    return
                                }
                                if UIApplication.shared.canOpenURL(profileUrl) {
                                    UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                                        print(" Profile Settings opened: \(success)")
                                    })
                                }
                            }))
                            self?.window?.rootViewController!.present(alert, animated: false, completion: nil)
                            return
                        }
                        let alert = AlertController(title: nil, message: Utility.shared.getAppLanguage()?.value(forKey: "URLSessionTask failed with error: The Internet connection appears to be offline.") as? String ?? "URLSessionTask failed with error: The Internet connection appears to be offline.", preferredStyle: .alert)
                        NotificationCenter.default.addObserver(alert, selector: #selector(AlertController.hideAlertController), name: Notification.Name("DismissAllAlertsNotification"), object: nil)
                        alert.addAction(UIAlertAction(title: (Utility.shared.getAppLanguage()?.value(forKey: "setting") as? String ?? "setting"), style: .cancel, handler: { UIAlertAction in
                            guard let profileUrl = URL(string: "App-Prefs:root=General") else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(profileUrl) {
                                UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                                    print(" Profile Settings opened: \(success)")
                                })
                            }
                        }))
                        self.window?.rootViewController!.present(alert, animated: false, completion: nil)
                    }
                    
                }
            }
        }
    }
}

class AlertController: UIAlertController {
    @objc func hideAlertController() {
        self.dismiss(animated: true, completion: nil)
    }
}

