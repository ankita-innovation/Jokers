//
//  Utility.swift
//  Randoo
//
//  Created by HTS-Product on 06/02/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import UIKit
import Lottie
import SystemConfiguration
import Photos
import AVFoundation
import StoreKit

import NVActivityIndicatorView

var lottieView = LOTAnimationView()
var onlineTimer = Timer()
var str : String!

var indicatorView1 = NVActivityIndicatorView.init(frame: CGRect(x:FULL_WIDTH/2-30,y:FULL_HEIGHT/2-30,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: PRIMARY_COLOR, padding: 50)

class Utility: NSObject {
    static let shared = Utility()
    static let language = Utility().getAppLanguage()
    var primeTempArray = NSMutableArray()
    var productIDs: Array<String?> = []
    var selectedProduct = SKProduct()


    func showLoader()  {
        lottieView.isHidden  = false
        lottieView.play{ (finished) in
            // Do Something
        }
    }
    func hideLoader()  {
        lottieView.stop()
        //        lottieView.isHidden  = true
    }

    func addLoader(customView:UIView)  {
        lottieView = LOTAnimationView(name: "findLoader")
        if UIDevice.current.hasNotch {
            lottieView.frame = CGRect.init(x: 0, y: FULL_HEIGHT/2-115, width: FULL_WIDTH, height: 230)
        }else{
            lottieView.frame = CGRect.init(x: 0, y: FULL_HEIGHT/2-105, width: FULL_WIDTH, height: 210)
        }
        lottieView.loopAnimation = true
        customView.addSubview(lottieView)
        lottieView.isHidden  = true
    }
    //qwerty
    func addLoaderWithName(customView:UIView, Name: String)  {
        lottieView = LOTAnimationView(name: Name)
        lottieView.frame = customView.frame
        lottieView.loopAnimation = false
        lottieView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        lottieView.contentMode = .scaleAspectFill
        customView.addSubview(lottieView)
        lottieView.isHidden  = false
        lottieView.play{ (finished) in
            // Do Something
        }
    }

    //MARK: Get Random like heart color
    func likeHexColorCode() -> String {
        let likeColorArray = ["#05ac90","#ac5b05","#ac1905","#8305ac","#ac0577","#0563ac","#7bac05"]
        let randomIndex = Int(arc4random_uniform(UInt32(likeColorArray.count)))
        return (likeColorArray[randomIndex] )
    }
    
    //MARK: Configure app language
    func configLanguage()  {
        if let path = Bundle.main.path(forResource:UserModel.shared.getLanguage(), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                print(jsonResult)
                self.setDefaultLanguage(languageDict: jsonResult as! NSDictionary)
            } catch {
                print("error occurs")
                // handle error
            }
        }
        
    }
     
 
    func startAnimation1(viewController:UIViewController) {
        indicatorView1.startAnimating()
        
        UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = false
        viewController.view.isUserInteractionEnabled =  false
         
    }
    
    func stopAnimation1(viewController:UIViewController)
    {
        indicatorView1.stopAnimating()
        
        UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
        viewController.view.isUserInteractionEnabled =  true
         
    }
    
    
    
    //MARK:set App language
    func setDefaultLanguage(languageDict: NSDictionary){
        UserDefaults.standard.set(languageDict, forKey: "app_language")
    }
    func getAppLanguage() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "app_language") as? NSDictionary
    }
    func setAppLanguage(languageStr: NSString){
        UserDefaults.standard.set(languageStr, forKey: "language")
    }
    func getLanguage() -> NSString? {
        return UserDefaults.standard.value(forKey: "language") as? NSString
    }


    //MARK:set PrimePackage
    func setPrime(package: NSDictionary){
        UserDefaults.standard.set(package, forKey: "first_prime_package")
    }
    func primePackage() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "first_prime_package") as? NSDictionary
    }


    //banner ad id
    func setAds(unitId: String){
        UserDefaults.standard.set(unitId, forKey: "ads_unit_id")
    }
    func adUnitId() -> String? {
        return UserDefaults.standard.value(forKey: "ads_unit_id") as? String
    }
    //video ad id
    func setVidoeAds(id: String){
        UserDefaults.standard.set(id, forKey: "video_ads_unit_id")
    }
    func adsVideoID() -> String? {
        return UserDefaults.standard.value(forKey: "video_ads_unit_id") as? String
    }

    //google ads
    func adsEnable(status: Bool){
        UserDefaults.standard.set(status, forKey: "ads_enable")
    }
    func isAdsEnable() -> Bool? {
        if UserModel().premium()! {
            return false
        }
        return UserDefaults.standard.value(forKey: "ads_enable") as? Bool
    }
    //MARK:NOTIFICATION REDIRECTION
    func setMsg(scope:String,name:String,id:String,img:String){
        self.notificationRedirection(enable: true)
        let dict = NSMutableDictionary()
        dict.setValue(scope, forKey: "scope")
        dict.setValue(name, forKey: "user_name")
        dict.setValue(id, forKey: "user_id")
        dict.setValue(img, forKey: "user_image")
        UserDefaults.standard.set(dict, forKey: "notification_info")
    }
    func setVideo(dict:NSDictionary){
        self.notificationRedirection(enable: true)
        let newDict = NSMutableDictionary.init(dictionary: dict)
        newDict.setValue("video", forKey: "scope")
        UserDefaults.standard.set(newDict, forKey: "notification_info")
    }
    func setCall(dict:NSDictionary){
        self.notificationRedirection(enable: true)
        UserDefaults.standard.set(dict, forKey: "notification_info")
    }
    func setFollow(scope:String,id:String){
        self.notificationRedirection(enable: true)
        let dict = NSMutableDictionary()
        dict.setValue(scope, forKey: "scope")
        dict.setValue(id, forKey: "user_id")
        UserDefaults.standard.set(dict, forKey: "notification_info")
    }
    func setInterest(scope:String){
        self.notificationRedirection(enable: true)
        let dict = NSMutableDictionary()
        dict.setValue(scope, forKey: "scope")
        UserDefaults.standard.set(dict, forKey: "notification_info")
    }
    func notificationRedirection(enable:Bool) {
        UserDefaults.standard.set(enable, forKey: "notification_redirect")
    }
    func isNotificationRedirect()->Bool? {
        if (UserDefaults.standard.value(forKey: "notification_redirect") != nil){
            return (UserDefaults.standard.value(forKey: "notification_redirect") as! Bool)
        }
        return nil
    }

    func getNotificationInfo() -> NSDictionary? {
        return (UserDefaults.standard.value(forKey: "notification_info") as! NSDictionary)
    }

    func clearRedirectionInfo()  {
        UserDefaults.standard.set(false, forKey: "notification_redirect")
    }

    //MARK: Convert string to dict
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    //MARK: Network rechability
//    func isConnectedToNetwork() -> Bool {
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            return false
//        }
//
//        // Working for Cellular and WIFI
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        let ret = (isReachable && !needsConnection)
//        return ret
//
//    }

    //Network Reachability Modified

     func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }

    // push notification register
    func pushsignIn(){
        if UserModel.shared.userID() != nil{
            let Obj = BaseWebService()
            let requestDict = NSMutableDictionary.init()
            requestDict.setValue(UserModel.shared.VOIP(), forKey: "voip_token")
            requestDict.setValue(UserModel.shared.FCM(), forKey: "fcm_token")
            requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
            requestDict.setValue("0", forKey: "device_type")//android or ios
            requestDict.setValue(DEVICE_MODE, forKey: "device_mode")//push notification
            requestDict.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
            requestDict.setValue(UIDevice.current.model, forKey: "device_model")
            
            print("paramerter for login...", requestDict)
            
            
            
            Obj.baseService(subURl: PUSH_SIGNIN_API, params: requestDict as? Parameters, onSuccess: {response in
                let dict = response.result.value as? NSDictionary
                let status = dict?.value(forKey: "status") as! String
                if status == "true"{
                }
            }){ error in
                print("error...", error)
            }
        }
    }
    
    //push notification register
    func pushsignOut(){
        if UserModel.shared.userID() != nil && UserModel.shared.VOIP() != nil{
            let Obj = BaseWebService()
            Obj.delete(subURl: "\(PUSH_SIGNOUT_API)/\(UIDevice.current.identifierForVendor!.uuidString)", onSuccess: {response in

            })
        }
    }

    //get app default details
    func getDefaultDetails()  {
        let Obj = BaseWebService()
        Obj.getDetails(subURl: "\(APP_DEFAULT_API)/ios", onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            print(dict)
                    
            if status == "true"{
                UserModel.shared.setDefaults(dict: dict!)
                giftsDetails.removeAll()
                if let giftsArray = dict?.value(forKey: "gifts") as? [Any] {
                    for gift in giftsArray {
                        guard let details = gift as? [String: Any] else { return }
                        let model: GiftsModel = Utility.shared.jsonToModel(json: details as NSDictionary)
                        giftsDetails.append(model)
                    }
                }
                
                self.primeStoreInfo()
               // self.setAds(unitId:dict?.value(forKey: "google_ads_client") as! String)
                self.setAds(unitId:dict?.value(forKey: "google_ads_client") as! String)
                self.setVidoeAds(id: dict?.value(forKey: "video_ads_client") as! String)
                let showAds = dict?.value(forKey: "show_ads") as! String
                if showAds == "1"{
                    self.adsEnable(status: true)
                }else{
                    self.adsEnable(status: false)
                }
            }
        })
    }

    //get formatted json from array
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    //set Default filter
//    func setDefaultFilter()  {
//        if UserModel.shared.userID() != nil{
//            //set default filter location
//            let defaultDict:NSDictionary = UserModel.shared.getDefaults()!
//            //set location names
//            let locationArray = NSMutableArray()
//            locationArray.addObjects(from: defaultDict.value(forKey: "locations") as! [Any])
//            let allLoc = Utility().getAppLanguage()?.value(forKey: "select_all") as! String
//            locationArray.add(allLoc)
//            UserDefaults.standard.setValue(locationArray, forKey: "location")
//            //set partner ids
//            let partnerArray = NSMutableArray()
//            partnerArray.add(UserModel.shared.userID() as Any)
//            UserDefaults.standard.setValue(partnerArray, forKey: "partner_list")
//            //set other filter values
//            UserDefaults.standard.setValue("18", forKey: "min_age")
//            UserDefaults.standard.setValue("99", forKey: "max_age")
//            UserDefaults.standard.setValue("0", forKey: "filter_applied")
//            UserDefaults.standard.setValue("both", forKey: "gender")
//            UserDefaults.standard.synchronize()
//        }
//    }

    func height(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height:  CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }

    //convert timestamp with required format
    func timeStamp(time:Date,format:String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone.current //Set timezone that you want
        dateFormat.locale = NSLocale.current
        dateFormat.dateFormat = format
        return dateFormat.string(from: time)
    }

    func makeFormat(to:Date) -> String {
        let calendar = NSCalendar.current
        if calendar.isDateInToday(to) {
            return "Today, \(self.timeStamp(time: to, format: "hh:mm a"))"
        }else if calendar.isDateInYesterday(to){
            return "Yesterday, \(self.timeStamp(time: to, format: "hh:mm a"))"
        }else{
            return self.timeStamp(time: to, format: "dd/MM/yyyy hh:mm a")
        }
    }


    //get current utc time
    func getUTCTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.string(from: date)
        return utcTimeZoneStr
    }
    //get random id
    func randomID()-> String  {
        let timestamp = NSDate().timeIntervalSince1970
        return "\(UserModel.shared.userID()!)\(String(format: "%.0f", timestamp.rounded()))"
    }
    func newID()-> String  {
        let timestamp = NSDate().timeIntervalSince1970
        return "\(UserModel.shared.userID()!)234324SFSD\(String(format: "%.0f", timestamp.rounded()))"
    }
    
    func goToLoginPage()  {
        
        let storyboard = UIStoryboard(name: enumStoryBoard.initial.rawValue, bundle: nil)
        let MainView = storyboard.instantiateViewController(withIdentifier: enumViewControllerIdentifier.initialVC.rawValue) as! InitialVC

        let navController = UINavigationController.init(rootViewController: MainView)

        appDelegate.window?.rootViewController = navController
    }
    
    //MARK: Check string is empty
    func checkEmpty(str:String) -> Bool {
        if  (str == "") || (str == "NULL") || (str == "(null)") || (str == "<null>") || (str == "Json Error") || (str.isEmpty) ||  str.trimmingCharacters(in: .whitespaces).isEmpty || str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty  {
            return true
        }
        return false
    }
    //invite credits
    func inviteCredits()  {
        let obj = BaseWebService()
        obj.getDetails(subURl: "\(INVITE_CREDITS)/\(UserModel.shared.getInviteCode()!)", onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            if status == "true"{
                UserModel.shared.deleteInviteCode()
            }
        })
    }
    //check auto newal subacription inapp purchase
    func iapActiveStatus() {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                let dict = ["receipt-data" : receiptString, "password" : APP_SPECIFIC_SHARED_SECRET] as [String : Any]
                do  {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    if let iapBaseURL = Foundation.URL(string:IAP_VALIDATION_URL) {
                        var request = URLRequest(url: iapBaseURL)
                        request.httpMethod = "POST"
                        request.httpBody = jsonData
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        let task = session.dataTask(with: request) { data, response, error in
                            if let receivedData = data,
                                let httpResponse = response as? HTTPURLResponse,
                                error == nil,
                                httpResponse.statusCode == 200 {
                                do {
                                    print("Receipt response \(dict)")

                                    if let jsonResponse = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject> {
                                        var dict = NSDictionary()
                                        dict = jsonResponse as NSDictionary
                                        let receiptArray = dict.value(forKey: "latest_receipt_info") as! NSArray
                                        if receiptArray.count != 0{
                                            print(receiptArray)
                                            let receiptDict = receiptArray.lastObject as! NSDictionary
                                            print("last dict \(receiptDict)")
                                            let last_expiryDate = receiptDict["expires_date_ms"]
                                            let updateOBj = BaseWebService()
                                            let request = NSMutableDictionary()
                                            request.setValue(UserModel.shared.userID(), forKey: "user_id")
                                            request.setValue(receiptDict["product_id"], forKey: "package_id")
                                            request.setValue(last_expiryDate, forKey: "renewal_time")
                                            request.setValue("ios", forKey: "platform")
                                            updateOBj.baseService(subURl: RENEWAL_SUBSCRIPTION, params:  request as? Parameters, onSuccess: {response in
                                                let dict = response.result.value as? NSDictionary
                                                let status = dict?.value(forKey: "status") as! String
                                                if status == "true"{
                                                    UserModel.shared.updateProfile()
                                                }
                                            }){ error in
                                                print("error...", error)
                                            }
                                        }
                                    } else { print("Failed to cast serialized JSON to Dictionary<String, AnyObject>") }
                                }
                                catch { print("Couldn't serialize JSON with error: " + error.localizedDescription) }
                            }
                        }
                        task.resume()
                    } else { print("Couldn't convert string into URL. Check for special characters.") }
                }
                catch { print("Couldn't create JSON with error: " + error.localizedDescription) }
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
    }


    //initate call
    func endCall(receiverID:String,room:String,type:String,chat_type:String)  {
        DispatchQueue.main.async {
            do{
                let jsonDecoder = JSONDecoder()
                let profile = try jsonDecoder.decode(ProfileModel.self, from: UserModel.shared.userData()!)
                let req = NSMutableDictionary()
                req.setValue("_createCall", forKey: "type")
                req.setValue(Utility.shared.getUTCTime(), forKey: "timestamp")
                req.setValue(UserModel.shared.userID(), forKey: "user_id")
                req.setValue(profile.user_image, forKey: "user_image")
                req.setValue(profile.name, forKey: "user_name")
                req.setValue(receiverID, forKey: "receiver_id")
                req.setValue("video", forKey: "chat_type")
                req.setValue(type, forKey: "call_type")
                req.setValue(Utility.shared.getUTCTime(), forKey: "created_at")
                req.setValue("ios", forKey: "platform")
                req.setValue(room, forKey: "room_id")
               let Obj = BaseWebService()
             Obj.baseService(subURl: END_CALL_API, params: req as? Parameters, onSuccess: {response in
                            let dict = response.result.value as? NSDictionary
                            let status = dict?.value(forKey: "status") as! String
                            if status == "true"{
                            }
                        }){ error in
                            print("error...", error)
                        }
            }catch{

            }
        }

       }

    func clearNotifications(){
//        let center = UNUserNotificationCenter.current()
//        center.removeAllDeliveredNotifications() // To remove all delivered notifications
    }
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }

    func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                    
                        /*
                        let alertVC = CPAlertVC(title:APP_NAME, message: Utility().getAppLanguage()?.value(forKey: "Download_sucess") as! String)
                        alertVC.animationType = .bounceUp
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
   
                        }))
                        alertVC.show(into: UIApplication.shared.keyWindow?.rootViewController)
                        */
                        
                        /*
                        let alert = UIAlertController(title: "", message: (Utility().getAppLanguage()?.value(forKey: "Download_sucess") as! String), preferredStyle: .alert)
                        let action = UIAlertAction(title: (Utility().getAppLanguage()?.value(forKey: "ok") as! String) , style: .cancel) { (UIAlertAction) in

                        }
                        alert.addAction(action)
                        //self.present(alert, animated: true, completion: nil)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                         */
                        print("Saved successfully")
                         
                    }
                    completion?(error)
                }
            }
        }
    }

    func getMediaDuration(url: URL!) -> Float64{
        let asset : AVURLAsset = AVURLAsset(url: url)
        let duration : CMTime = asset.duration
        return CMTimeGetSeconds(duration)
    }


    func turnOnNetworkPopUp() {
//        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "turn_on_network") as? String, preferredStyle: UIAlertController.Style.alert)
////        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "turn_on_network_refresh") as? String, preferredStyle: UIAlertController.Style.alert)
//
//        let okayBtn = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "ok") as? String, style: UIAlertAction.Style.default, handler: onOnlineTimer)
////        let okayBtn = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "ok") as? String, style: UIAlertAction.Style.default, handler: nil)
//        otherAlert.addAction(okayBtn)
//        UIApplication.shared.keyWindow?.rootViewController?.present(otherAlert, animated: true, completion: nil)
    }

    func onOnlineTimer(alert: UIAlertAction!) {
        onlineTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.fetchDataWhenConnected), userInfo: nil, repeats: true)
    }

    @objc func fetchDataWhenConnected() {
        if isConnectedToNetwork() {
            onlineTimer.invalidate()
            let TapPage = TabViewController()
            TapPage.presentingPageWithIndex(indexedValue: 0)
            UIApplication.shared.windows.first?.rootViewController = TapPage
           UIApplication.shared.windows.first?.makeKeyAndVisible()
//            API.shared.fetchData(apiType: .foryou, offset: 0, completion: {
//                StoryFeedVC.shared.refreshAfterConected()
//            })
//            API.shared.fetchData(apiType: .following, offset: 0, completion: {
//                StoryFeedVC.shared.refreshAfterConected()
//            })
        }
    }

    //MARK: - DataDecode convert data to model
    /// Description
    /// - Parameter json: pass json value to any model but get error when mismatched key or type.
    fileprivate func dataDecode<T: Decodable>(data: Data)  -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse value as \(T.self):\n\(error)")
        }
    }

    //MARK: - DataEncode convert model to data
    /// Description
    /// - Parameter model: pass model value.
    fileprivate func dataEncode<T: Encodable>(model: T) -> Data {
        do {
            let decoder = JSONEncoder()
            return try decoder.encode(model)
        } catch {
            fatalError("Couldn't parse value as \(T.self):\n\(error)")
        }
    }

    func modelToJson<T: Encodable>(model: T) -> Parameters? {
         let data = dataEncode(model: model)

         do {
             return try JSONSerialization.jsonObject(with: data, options: []) as? Parameters
         } catch {
             fatalError(error.localizedDescription)
         }
    }

    func jsonToModel<T: Decodable>(json: NSDictionary) -> T {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return dataDecode(data: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension Int {
    var kmFormatted: String {
        let thousandNum = self/1000
        let millionNum = self/1000000
        if self >= 1000 && self < 1000000{
            if(thousandNum == thousandNum){
                return("\(thousandNum)K")
            }
            return("\(thousandNum)K")
        }
        if self > 1000000{
            if(millionNum == millionNum){
                return("\(millionNum)M")
            }
            return ("\(millionNum)M")
        }
        else{
            if(self == self){
                return ("\(self)")
            }
            return ("\(self)")
        }
    }



}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
//MESSAGE SECTION
extension Utility{
    func addToLocal(dict:NSDictionary) {
        var userid = dict.value(forKey: "user_id") as! String
        let receiverid = dict.value(forKey: "receiver_id") as! String
        if userid == UserModel.shared.userID(){
            userid = receiverid
        }

        if (userid == UserModel.shared.userID()) && (receiverid == UserModel.shared.userID()){
        }else{
            //RECENT CHATS *********************
            if !Entities.sharedInstance.userExist(user_id: userid) {
                Entities.sharedInstance.addRecent(name: dict.value(forKey: "user_name") as! String,
                                                  user_id: userid,
                                                  time: dict.value(forKey: "chat_time") as! String,
                                                  msg: dict.value(forKey: "message") as! String,
                                                  user_image: dict.value(forKey: "user_image") as! String,
                                                  msg_id: dict.value(forKey: "msg_id") as! String,
                                                  msg_type: dict.value(forKey: "msg_type") as! String,chat_type:"user_chat")
            }else{
                Entities.sharedInstance.updateRecent(name: dict.value(forKey: "user_name") as! String,
                                                     user_id: userid,
                                                     time: dict.value(forKey: "chat_time") as! String,
                                                     msg: dict.value(forKey: "message") as! String,
                                                     user_image: dict.value(forKey: "user_image") as! String,
                                                     msg_id: dict.value(forKey: "msg_id") as! String,
                                                     msg_type: dict.value(forKey: "msg_type") as! String)
            }

            //CHECK AND ADD DATE STICKY IN MESSAEGS*********
            var lastMsg:Messages?
            lastMsg = Entities.sharedInstance.getLast(user_id: userid)
            var stickyAdded = false
            if lastMsg != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let currentMsgTime = formatter.date(from: dict.value(forKey: "chat_time") as! String)
                let lastMsgTime = formatter.date(from: (lastMsg?.time)!)
                let currentDate = Utility.shared.timeStamp(time: currentMsgTime!, format: "MMMM dd yyyy")
                let lastDate = Utility.shared.timeStamp(time: lastMsgTime!, format: "MMMM dd yyyy")
                if currentDate != lastDate {
                    self.addStickyDate(dict: dict)
                    stickyAdded = true
                }
            }else{
                self.addStickyDate(dict: dict)
                stickyAdded = true
            }

            var msgID = String()
            var msgTime = String()

            if stickyAdded{
                msgID = Utility.shared.newID()
                msgTime = Utility.shared.getUTCTime()
            }else{
                msgID = dict.value(forKey: "msg_id") as! String
                msgTime = dict.value(forKey: "chat_time") as! String

            }

            //MESSAGE SECTION ******************
            Entities.sharedInstance.addMsg(name: dict.value(forKey: "user_name") as! String,
                                           user_id: dict.value(forKey: "user_id") as! String,
                                           time: msgTime,
                                           msg: dict.value(forKey: "message") as! String,
                                           user_image: dict.value(forKey: "user_image") as! String,
                                           msg_id:msgID,
                                           msg_type: dict.value(forKey: "msg_type") as! String,
                                           status: "unread",
                                           receiver_id:receiverid, isFromSocket: true,Duration: dict.value(forKey: "duration") as? CGFloat ?? CGFloat(0))
        }

    }

    //add offline msg
    func addOfflineMsg(dict:NSDictionary)  {
        let msgArray = dict.value(forKey: "records") as! NSArray
        for msg in msgArray {
            self.addToLocal(dict: msg as! NSDictionary)
        }
    }

    //update  read status
    func updateReadStatus(dict:NSDictionary)  {
        let user_id = dict.value(forKey: "user_id") as! String
        _ = Entities.sharedInstance.getLastMsgID(user_id:user_id,type:"instant")
        HSChatSocket.sharedInstance.passDetails(type: "_receiveReadStatus", dict:dict)
    }

    //add offline read status
    func addOfflineReadStatus(dict:NSDictionary)  {
        let readChatsArray  = dict.value(forKey: "records") as! NSArray
        for chats in readChatsArray {
            self.updateReadStatus(dict: chats as! NSDictionary)
        }
    }
    //add sticky header
    func addStickyDate(dict:NSDictionary) {
        print("msg id date \(dict.value(forKey: "msg_id") as! String)")

        var userid = dict.value(forKey: "user_id") as! String
        let receiverid = dict.value(forKey: "receiver_id") as! String
        if userid == UserModel.shared.userID(){
            userid = receiverid
        }
        Entities.sharedInstance.addMsg(name: dict.value(forKey: "user_name") as! String,
                                       user_id: dict.value(forKey: "user_id") as! String,
                                       time: dict.value(forKey: "chat_time") as! String,
                                       msg: dict.value(forKey: "message") as! String,
                                       user_image: dict.value(forKey: "user_image") as! String,
                                       msg_id: dict.value(forKey: "msg_id") as! String,
                                       msg_type: "sticky",
                                       status: "unread",
                                       receiver_id:receiverid)
    }

    func addAdminInitialMsg()  {
        print("CALLED ADMIN MSG")
        if str != "ok"{
            
        let user_id = APP_NAME
        let user_name = "\(user_id) Team"
        let defaultDict = UserModel.shared.getDefaults()
        let msg = defaultDict?.value(forKey: "welcome_message") as! String
        
        let cryptLib = CryptLib()
        let encryptedText = cryptLib.encryptPlainTextRandomIV(withPlainText:msg, key: ENCRYPT_KEY)
        let timestamp = NSDate().timeIntervalSince1970
        
        Entities.sharedInstance.addRecent(name: user_name,
                                          user_id:user_id,
                                          time: Utility.shared.getUTCTime(),
                                          msg: encryptedText!,
                                          user_image: "",
                                          msg_id: Utility.shared.randomID(),
                                          msg_type:"text",chat_type:"admin_chat")
        //initial date
        Entities.sharedInstance.addMsg(name:user_name,
                                       user_id: user_id,
                                       time: Utility.shared.getUTCTime(),
                                       msg: encryptedText!,
                                       user_image: "",
                                       msg_id: Utility.shared.newID(),
                                       msg_type: "sticky",
                                       status: "unread",
                                       receiver_id:String(format: "%.0f", timestamp.rounded()))
        //new msg
        Entities.sharedInstance.addMsg(name:user_name,
                                       user_id: user_id,
                                       time: Utility.shared.getUTCTime(),
                                       msg: encryptedText!,
                                       user_image: "",
                                       msg_id: Utility.shared.randomID(),
                                       msg_type: "text",
                                       status: "unread",
                                       receiver_id:String(format: "%.0f", timestamp.rounded()))
        
            self.getAdminMsg()
            str = "ok"
         }else{

         }
    }


    //check blocked status
    func checkBlocked()  {
        let Obj = BaseWebService()
        Obj.getDetails(subURl: "\(CHECK_ACTIVE_API)/\(UserModel.shared.userID()!)", onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            if status == "false"{

                let alertVC = CPAlertVC(title:APP_NAME, message: Utility().getAppLanguage()?.value(forKey: "acc_blocked") as! String)
                alertVC.animationType = .bounceUp
                alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                    UserModel.shared.logoutFromAll()
                    Utility.shared.goToLoginPage()
                }))
                alertVC.show(into: UIApplication.shared.keyWindow?.rootViewController)

            }
        })
    }
    //get all admin messages
    func getAdminMsg()  {
        let last_msg = Entities.sharedInstance.getLast(user_id: APP_NAME)
        if last_msg != nil {
            do{
                let jsonDecoder = JSONDecoder()
                if let data = UserModel.shared.userData() {
                    let profile = try jsonDecoder.decode(ProfileModel.self, from: data)
                    let Obj = BaseWebService()
                    Obj.getDetails(subURl: "\(ADMIN_MSG_API)/\(UserModel.shared.userID()!)/ios/\(profile.created_at!)/\(last_msg!.receiver_id!)", onSuccess: {response in
                        let dict = response.result.value as? NSDictionary
                        let status = dict?.value(forKey: "status") as! String
                        if status == "true"{
                            let msgArray = dict!.value(forKey: "message_data") as! NSArray
                            for admin in msgArray {
                                self.addAdminMsgs(dict: admin as! NSDictionary)
                            }
                        }
                    })
                }
            }catch{
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.addAdminInitialMsg()
            }
        }
    }

    func addAdminMsgs(dict:NSDictionary) {
        if (dict.value(forKey: "msg_platform") as? String ?? "ios") != "android" {
            let userid = APP_NAME
            let user_name = "\(userid) Team"
            let receiverid = dict.value(forKey: "msg_at") as! NSNumber
            let msg = dict.value(forKey: "msg_data") as! String
            let cryptLib = CryptLib()
            let encryptedText = cryptLib.encryptPlainTextRandomIV(withPlainText:msg, key: ENCRYPT_KEY)
            Entities.sharedInstance.updateRecent(name: user_name,
                                                 user_id: userid,
                                                 time: dict.value(forKey: "created_at") as! String,
                                                 msg: encryptedText!,
                                                 user_image: "",
                                                 msg_id: dict.value(forKey: "msg_id") as! String,
                                                 msg_type: dict.value(forKey: "msg_type") as! String)
            //CHECK AND ADD DATE STICKY IN MESSAEGS*********
            var lastMsg:Messages?
            lastMsg = Entities.sharedInstance.getLast(user_id: userid)
            var stickyAdded = false
            if lastMsg != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let currentMsgTime = formatter.date(from: dict.value(forKey: "created_at") as! String)
                let lastMsgTime = formatter.date(from: (lastMsg?.time)!)
                let currentDate = Utility.shared.timeStamp(time: currentMsgTime!, format: "MMMM dd yyyy")
                let lastDate = Utility.shared.timeStamp(time: lastMsgTime!, format: "MMMM dd yyyy")
                if currentDate != lastDate {
                    let time = dict.value(forKey: "msg_at") as! NSNumber
                    Entities.sharedInstance.addMsg(name:user_name,
                                                   user_id: userid,
                                                   time: dict.value(forKey: "created_at") as! String,
                                                   msg: encryptedText!,
                                                   user_image: "",
                                                   msg_id: Utility.shared.randomID(),
                                                   msg_type: "sticky",
                                                   status: "unread",
                                                   receiver_id:time.stringValue)
                    stickyAdded = true
                }
            }

            var msgID = String()
            if stickyAdded{
                msgID = Utility.shared.newID()
            }else{
                msgID = dict.value(forKey: "msg_id") as! String
            }

            //MESSAGE SECTION ******************
            Entities.sharedInstance.addMsg(name: user_name,
                                           user_id: userid,
                                           time: dict.value(forKey: "created_at") as! String,
                                           msg: encryptedText!,
                                           user_image: "",
                                           msg_id:msgID,
                                           msg_type: dict.value(forKey: "msg_type") as! String,
                                           status: "unread",
                                           receiver_id:receiverid.stringValue)
        }
    }




    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false,type:NSString) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)


        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1) {
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) min ago"
        } else if (components.minute! >= 1) {
            if (numericDates){
                return "1 min ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec ago"
        } else {
            return "Just now"
        }

    }


    func timeSinceDate(_ date:Date, numericDates:Bool = false,type:NSString) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        if (components.year! >= 2) {
            return "\(components.year!)y"
        } else if (components.year! >= 1) {
            return "1y"
        } else if (components.month! >= 2) {
            return "\(components.month!)m"
        } else if (components.month! >= 1) {
            return "1m"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)w"
        } else if (components.weekOfYear! >= 1) {
            return "1w"
        } else if (components.day! >= 2) {
            return "\(components.day!)d"
        } else if (components.day! >= 1) {
            return "1d"
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h"
        } else if (components.hour! >= 1) {
            return "1h"
        } else if (components.minute! >= 2) {
            return "\(components.minute!)m"
        } else if (components.minute! >= 1) {
            return "1m"
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "1s"
        }
    }

    //MARK: Check string is empty
    func checkEmptyWithString(value:String) -> Bool {
        if  (value == "") || (value == "NULL") || (value == "(null)") || (value == "<null>") || (value == "Json Error") || (value == "0") || (value.isEmpty) ||  value.trimmingCharacters(in: .whitespaces).isEmpty || value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty  || value == nil{
            return true
        }
        return false
    }
    //MARK: Alert view
    public func showAlertWithTitle(alertTitle:NSString, alertMsg:NSString,viewController:UIViewController){

        let alertVC = CPAlertVC(title: alertTitle as String, message: alertMsg as String)
        alertVC.animationType = .bounceUp
        alertVC.show(into: viewController)
    }
    func translate(msg: String, callback:@escaping (_ translatedText:String) -> ()) {
       // callback(msg)
        
        var request = URLRequest(url: URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(GOOGLE_API_KEY)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
       // request.addValue("com.app.moulook" , forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        let targetLanguage = UserModel.shared.getLanguageCode()
        let jsonRequest = [
            "q": msg,
            "target": targetLanguage as Any,
        ] as [String : Any]

        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted) {
            request.httpBody = jsonData
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Something went wrong: \(String(describing: error?.localizedDescription))")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if let data = data {
                        print("Response [\(httpResponse.statusCode)] - \(data)")
                    }
                    do {
                        if let data = data {
                            if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let jsonData = json["data"] as? [String : Any] {
                                    if let translations = jsonData["translations"] as? [NSDictionary] {
                                        if let translation = translations.first as? [String : Any] {
                                            print("translatedText \(translation)")
                                            if let translatedText = translation["translatedText"] as? String {
                                                callback(translatedText)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Serialization failed: \(error.localizedDescription)")
                    }
                }
            }

            task.resume()
        }
        
    }
    //MARK: -Show Toast
    func showToastMessage(message : String,viewController: UIViewController, originY: CGFloat = 0.0, height: CGFloat = 50) {

        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.size.width - 40, height: height))
        toastLabel.center = viewController.view.center
        toastLabel.frame.origin.y = originY == 0.0 ? viewController.view.frame.size.height - 160 : originY
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = liteReg
        toastLabel.text = Utility().getAppLanguage()?.value(forKey: message) as? String
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.frame.size.height / 2;
        toastLabel.clipsToBounds  =  true
        viewController.view.addSubview(toastLabel)
        viewController.view.bringSubviewToFront(toastLabel)
        UIView.animate(withDuration: originY == 0.0 ? 4.0 : 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


    func AllowText(text: String) -> Bool {
        let regEx = "[A-Za-z0-9_\\n\\b\\s.]"
        let regtext = NSPredicate(format:"SELF MATCHES %@", regEx)
        let result = regtext.evaluate(with: text)
        return result
    }
    func gradient(size:CGSize) -> CAGradientLayer {
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = size
        gradientLayer.colors = GRADIENT_PRIMARY_COLOR
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.2)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            //Use diffrent colors
        return gradientLayer
    }
}

//MARK: STRING EXTENSION

extension String {
    func containsOnlyEmojis() -> Bool {
        if count == 0 {
            return false
        }
        for character in self {
            if !character.isEmoji {
                return false
            }
        }
        return true
    }

    func containsEmoji() -> Bool {
        for character in self {
            if character.isEmoji {
                return true
            }
        }
        return false
    }





}

extension Character {
    // An emoji can either be a 2 byte unicode character or a normal UTF8 character with an emoji modifier
    // appended as is the case with 3️⃣. 0x238C is the first instance of UTF16 emoji that requires no modifier.
    // `isEmoji` will evaluate to true for any character that can be turned into an emoji by adding a modifier
    // such as the digit "3". To avoid this we confirm that any character below 0x238C has an emoji modifier attached
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }


}
//MARK: GET PRIME INFO FROM STORE
extension Utility: SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate{
    
    func primeStoreInfo()  {
        let defaultDict = UserModel.shared.getDefaults()
        self.primeTempArray.addObjects(from: defaultDict?.value(forKey: "membership_packages") as! [Any])
        
        for prime in self.primeTempArray {
            let gemdict = prime as! NSDictionary
            let productid = gemdict.value(forKey: "subs_product_id")
            self.productIDs.append((productid as! String))
        }
        self.requestProductInfo()
    }
    
    //check in app product information by using productids
    func requestProductInfo() {
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs as [Any])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject> as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    //refresh delegate
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            var trans = SKPaymentTransaction()
            trans = transaction
            if transaction.transactionState == .purchased {
                // Pro Purchased
                print("check already done \(transaction.payment.productIdentifier)")
            }
        }
    }
    
    //store kit delegates
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            productIDs.removeAll()
            let product = response.products[0]
            let primeDict = NSMutableDictionary()
            primeDict.setValue(product.price.stringValue, forKey: "price")
            primeDict.setValue(product.priceLocale.currencySymbol!, forKey: "currency")
            print("Product:: \(product.productIdentifier)")
            var subs_validity = ""
            for data in self.primeTempArray {
                if let data1 =  data as? NSDictionary {
                    if (data1.value(forKey: "subs_product_id") as? String ?? "") == (product.productIdentifier) {
                        subs_validity = data1.value(forKey: "subs_validity") as? String ?? "1M"
                        primeDict.setValue(subs_validity, forKey: "validity")
                        Utility.shared.setPrime(package: primeDict)
                        return
                    }
                }
            }
            
        }
        else {
            print("There are no products.")
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("iap details \(transaction.transactionState), \(transaction.payment.productIdentifier)")
            if transaction.transactionState == .purchased {
                // Pro Purchased
                print("check  \(transaction.payment.productIdentifier)")
            }
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
    func unitName(unitRawValue:UInt) -> String {
        switch unitRawValue {
        case 0: return "D"
        case 1: return "W"
        case 2: return "M"
        case 3: return "Y"
        default: return ""
        }
    }
}
