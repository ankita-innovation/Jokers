//
//  UserModel.swift
//  Randoo
//
//  Created by HTS-Product on 04/02/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import CoreData

class UserModel: NSObject {
    static let shared = UserModel()
    
    
    //MARK: scrollEnabled
    func setPageScroll(enable: Bool){
        UserDefaults.standard.set(enable, forKey: "home_page_scroll")
    }
    func pageScroll() -> Bool? {
        return UserDefaults.standard.value(forKey: "home_page_scroll") as? Bool
    }
    
    
    //MARK: move to home page
    func goToHomePage()  {
        if #available(iOS 9.0, *) {
            appDelegate.setInitialViewController()
        }
    }
    //MARK: user id
    func setUserID(id: String){
        UserDefaults.standard.set(id, forKey: "local_user_id")
        UserDefaults.standard.synchronize()
    }
    func setAppLanguage(Language: String){
        UserDefaults.standard.set(Language, forKey: "language_name")
    }
    func getAppLanguage() -> String? {
        return UserDefaults.standard.value(forKey: "language_name") as? String
    }
    func SetLanguagename(id: String){
        return UserDefaults.standard.set(id, forKey: "chatlanguage_name")
    }
    //qwerty
    func getInitialReward() -> Int? {
        return UserDefaults.standard.value(forKey: "InitialReward") as? Int
    }
    func SetInitialReward(value: Int){
        return UserDefaults.standard.set(value, forKey: "InitialReward")
    }
    func getLanguagename() -> String? {
        return UserDefaults.standard.value(forKey: "chatlanguage_name") as? String
    }
    func SetLanguageCode(id: String){
        return UserDefaults.standard.set(id, forKey: "chatlanguage_code")
    }
    func getLanguageCode() -> String? {
        return UserDefaults.standard.value(forKey: "chatlanguage_code") as? String
    }

    func userID() -> String? {
        return UserDefaults.standard.value(forKey: "local_user_id") as? String
    }
    func accessToken() -> String? {
        return UserDefaults.standard.value(forKey: "local_user_id") as? String
    }
    func setUser(details: Data){
        UserDefaults.standard.set(details, forKey: "user_local_details")
    }
    func userData() -> Data? {
        return UserDefaults.standard.value(forKey: "user_local_details") as? Data
    }
    //VOIP token
    func setVOIP(id: String){
        UserDefaults.standard.set(id, forKey: "user_voip_id")
    }
    func VOIP() -> String? {
        return UserDefaults.standard.value(forKey: "user_voip_id") as? String
    }
    //FCM token
    func setFCM(id: String){
        UserDefaults.standard.set(id, forKey: "user_fcm_id")
    }
    func FCM() -> String? {
        return UserDefaults.standard.value(forKey: "user_fcm_id") as? String
    }
    //set & get partner model
    func setPartner(model: Data){
        UserDefaults.standard.set(model, forKey: "user_partner_details")
    }
    func partnerModel() -> Data? {
        return UserDefaults.standard.value(forKey: "user_partner_details") as? Data
    }
    //MARK: TURN DETAILS
    func setTurn(Details:NSDictionary,url:String){
        UserDefaults.standard.set(Details, forKey: "turn_server_config")
        UserDefaults.standard.set(url, forKey: "web_rtc_web")
    }
    //MARK: app language
    func setLanguage(lan: String){
        UserDefaults.standard.set(lan, forKey: "language_name")
    }
    func getLanguage() -> String? {
        return UserDefaults.standard.value(forKey: "language_name") as? String
    }
    //MARK: store & get user accesstoken
    func setAccessToken(userToken: NSString){
        UserDefaults.standard.set(userToken, forKey: "user_accessToken")
    }
    func getAccessToken() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_accessToken") as? NSString
    }
    //MARK: touch tool
    func setTouchToolTip(status: Bool){
        UserDefaults.standard.set(status, forKey: "touch_to_start")
    }
    func touchToolTip() -> Bool? {
        return UserDefaults.standard.value(forKey: "touch_to_start") as? Bool
    }
    //MARK: store & get initial login process
    //*********
    func setProfileStatus(status: Bool){
        UserDefaults.standard.set(status, forKey: "profile_complete_status")
    }
    func profileStatus() -> Bool? {
        return UserDefaults.standard.value(forKey: "profile_complete_status") as? Bool
    }
    //firs login
    func setFirstLogin(enable: Bool){
        UserDefaults.standard.set(enable, forKey: "firs_login")
    }
    func firstLogin() -> Bool? {
        return UserDefaults.standard.value(forKey: "firs_login") as? Bool
    }
    //first login details
    func setLogindetails(type:String,id:String){
        UserDefaults.standard.set(type, forKey: "user_login_type")
        UserDefaults.standard.set(id, forKey: "user_login_id")
    }
    func userLoginID() -> String? {
        return UserDefaults.standard.value(forKey: "user_login_id") as? String
    }
    func userLoginType() -> String? {
        return UserDefaults.standard.value(forKey: "user_login_type") as? String
    }
    func setFBdetails(dict:NSDictionary){
        UserDefaults.standard.set(dict, forKey: "user_fb_details")
    }
    func fbDetails() -> NSDictionary? {
        return UserDefaults.standard.value(forKey: "user_fb_details") as? NSDictionary
    }
    func setApple(name: String){
        UserDefaults.standard.set(name, forKey: "signin_apple_id")
    }
    func getAppleName() -> String? {
        return UserDefaults.standard.value(forKey: "signin_apple_id") as? String
    }
    func setEmail(id: String){
        UserDefaults.standard.set(id, forKey: "signin_mail_id")
    }
    func getMail() -> String? {
        return UserDefaults.standard.value(forKey: "signin_mail_id") as? String
    }
    func removeMail() {
        return UserDefaults.standard.removeObject(forKey: "signin_mail_id")
    }
    //basic info
    func setBasicInfo(enable: Bool){
        UserDefaults.standard.set(enable, forKey: "basicinfo_enabled")
    }
    func basicInfoStatus() -> Bool? {
        return UserDefaults.standard.value(forKey: "basicinfo_enabled") as? Bool
    }
    //profile pic
    func setImageupload(enable: Bool){
        UserDefaults.standard.set(enable, forKey: "profilepic_enabled")
    }
    func imageUploadStatus() -> Bool? {
        return UserDefaults.standard.value(forKey: "profilepic_enabled") as? Bool
    }
    //set currenct chat user id
    func setLive(status: String){
        UserDefaults.standard.set(status, forKey: "update_live_status")
    }
    func getLiveStatus() -> String? {
        return UserDefaults.standard.value(forKey: "update_live_status") as? String
    }
    
    //set defaultDetails
    func setDefaults(dict: NSDictionary){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(encodedData, forKey: "app_defaults_info")
    }
    func getDefaults() -> NSDictionary? {
        let decoded  = UserDefaults.standard.object(forKey: "app_defaults_info") as? Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? NSDictionary
        return decodedTeams
    }
    //passcode
    func setPasscode(status: Bool){
        UserDefaults.standard.set(status, forKey: "passcode_enable")
    }
    func passcode() -> Bool? {
        if UserDefaults.standard.value(forKey: "passcode_enable") != nil{
            return UserDefaults.standard.value(forKey: "passcode_enable") as? Bool
        }else{
            return false
        }
    }
    //premium
    func setPremium(status: Bool){
        UserDefaults.standard.set(status, forKey: "my_premium_status")
    }
    func premium() -> Bool? {
        return UserDefaults.standard.value(forKey: "my_premium_status") as? Bool
    }
    //premium
    func firstPremium(status: Bool){
        UserDefaults.standard.set(status, forKey: "already_subscribed")
    }
    func alreadypremium() -> Bool? {
        return UserDefaults.standard.value(forKey: "already_subscribed") as? Bool
    }
    //gem count
    func setGem(count: NSNumber){
        UserDefaults.standard.set(count, forKey: "my_gem_count")
    }
    func gemCount() -> Int? {
        let gemNum = UserDefaults.standard.value(forKey: "my_gem_count") as? NSNumber
        return gemNum?.intValue
    }
    
    //remaining unlocks count
    func setUnlock(count: NSNumber){
        UserDefaults.standard.set(count, forKey: "remaining_unlocks_left")
    }
    func unlocksLeft() -> Int? {
        let gemNum = UserDefaults.standard.value(forKey: "remaining_unlocks_left") as? NSNumber
        return gemNum?.intValue
    }
    //basic info
    func setCall(enable: Bool){
        UserDefaults.standard.set(enable, forKey: "video_call_enabled")
    }
    func alreadyInCall() -> Bool? {
        return UserDefaults.standard.value(forKey: "video_call_enabled") as? Bool
    }
    
    
    //basic info
    func setPrevious(caller_id: String){
        UserDefaults.standard.set(caller_id, forKey: "previous_caller_id")
    }
    func previousCallerID() -> String? {
        return UserDefaults.standard.value(forKey: "previous_caller_id") as? String
    }
    
    func setWatchVideo(endDate: Date){
        UserDefaults.standard.set(endDate, forKey: "watch_video_enddate")
    }
    func lastWatchedTime() -> Date? {
        return UserDefaults.standard.value(forKey: "watch_video_enddate") as? Date
    }
    
    
    //MARK: store,delete & get user invite code
    func setInvite(code: NSString){
        UserDefaults.standard.set(code, forKey: "invite_code")
    }
    func getInviteCode() -> NSString? {
        return UserDefaults.standard.value(forKey: "invite_code") as? NSString
    }
    func deleteInviteCode(){
        UserDefaults.standard.removeObject(forKey: "invite_code")
    }
    //**********
    //profile api service
    func updateProfile()  {
        let Obj = BaseWebService()
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(UserModel.shared.userID(), forKey: "profile_id")
        Obj.baseService(subURl: PROFILE_API, params: requestDict as? Parameters, onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            if status == "true"{
                
                UserModel.shared.setUser(details: response.data!)
                let premium_member = dict?.value(forKey: "premium_member") as! String
                if premium_member == "true"{
                    UserModel.shared.setPremium(status: true)
                }else{
                    UserModel.shared.setPremium(status: false)
                }
                let available_gems = dict?.value(forKey: "available_gems") as! NSNumber
                UserModel.shared.setGem(count: available_gems)
                
            }
        })
    }
    
    //rtc turn details  service
    func getTurnServers()  {
        let Obj = BaseWebService()
        Obj.getDetails(subURl: "\(RTC_PARAMS_API)/\(UserModel.shared.userID()!)", onSuccess: {response in
            let dict = response.result.value as? NSDictionary
            let status = dict?.value(forKey: "status") as! String
            if status == "true"{
//                let turnDict : NSDictionary = dict?.value(forKey: "params") as! NSDictionary
//                self.setTurn(Details: turnDict,url:APP_RTC_URL)
            }
        })
    }
    
    //logout user from all
    
    func logoutFromAll() {
        self.clearLocalDB()
        
        Utility.shared.pushsignOut()
        UserDefaults.standard.removeObject(forKey: "passcode_enable")
        UserDefaults.standard.removeObject(forKey: "local_user_id")
        UserDefaults.standard.removeObject(forKey: "user_local_details")
        UserDefaults.standard.removeObject(forKey: "user_partner_details")
        UserDefaults.standard.removeObject(forKey: "turn_server_config")
        UserDefaults.standard.removeObject(forKey: "user_fcm_id")
        UserDefaults.standard.removeObject(forKey: "profile_complete_status")
        UserDefaults.standard.removeObject(forKey: "user_login_type")
        UserDefaults.standard.removeObject(forKey: "user_fb_details")
        UserDefaults.standard.removeObject(forKey: "basicinfo_enabled")
        UserDefaults.standard.removeObject(forKey: "profilepic_enabled")
        UserDefaults.standard.removeObject(forKey: "my_premium_status")
        UserDefaults.standard.removeObject(forKey: "my_gem_count")
        UserDefaults.standard.removeObject(forKey: "first_prime_package")
        //        UserDefaults.standard.removeObject(forKey: "already_subscribed")
        UserDefaults.standard.removeObject(forKey: "firs_login")
        
    }
    //clear local storage
    func clearLocalDB() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1 {
            let entity = delegate.persistentContainer.managedObjectModel.entities[i]
            do {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
                try context.execute(deleterequest)
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    func setUserName(name:NSString){
        UserDefaults.standard.set(name, forKey: "user_profile_name")
    }
    func userName() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_profile_name") as? NSString
    }
    //MARK: store & get profile pic
    func setProfilePic(URL: NSString){
        UserDefaults.standard.set(URL, forKey: "user_profilepic")
    }
    func getProfilePic() -> NSString? {
        return UserDefaults.standard.value(forKey: "user_profilepic") as? NSString
    }
    //MARK: store & get antmedia
      func setAntMedia(dict: NSDictionary){
        let data = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
          UserDefaults.standard.set(data, forKey: "ant_media_dict")
      }
      func antMedia() -> NSDictionary {
        let outData = UserDefaults.standard.data(forKey: "ant_media_dict")
        let dict = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(outData!)
        return dict as! NSDictionary
      }
    func setType(key: String){
        UserDefaults.standard.set(key, forKey: "signin_type")
    }
    func getType() -> String? {
        return UserDefaults.standard.value(forKey: "signin_type") as? String
    }
    
   
    
    func setClientSecret(key: String){
        UserDefaults.standard.set(key, forKey: "client_secret")
    }
    func getClientSecret() -> String? {
        return UserDefaults.standard.value(forKey: "client_secret") as? String
    }
    
    func setAccesssToken(key: String){
        UserDefaults.standard.set(key, forKey: "token_access")
    }
    func getAccesssToken() -> String? {
        return UserDefaults.standard.value(forKey: "token_access") as? String
    }
    
    

}

