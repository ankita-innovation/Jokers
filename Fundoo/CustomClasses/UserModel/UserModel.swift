//
//  UserModel.swift
//  Randoo
//
//  Created by HTS-Product on 04/02/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

//{
//    "statusCode": 200,
//    "message": [
//        "user created successfully!"
//    ],
//    "data": {
//        "id": "63f07f9b6521513824e63843"
//        "username": "test101",
//        "f_name": "test",
//        "l_name": "test",
//        "fullName": "test test",
//        "email": "test101@gmail.com",
//        "phone_number": "65656565",
//        "date_of_birth": "2022-01-01T00:00:00.000Z",
//        "gender": 1,
//        "profile_photo": "",
//        "bio": "",

//        "referral_code": "",

//        "is_active": 1,
//        "is_banned": false,
//        "is_verified": false,
//        "isDeleted": false,

//        "followers_count": 0,
//        "following_count": 0,

//        "privacy_type": 1,

//        "deletedAt": null,
//        "created_at": "2023-02-18T07:34:51.096Z",
//        "updated_at": "2023-02-18T07:34:51.096Z",
//    },
//    "additionalData": []
//}

struct User: Codable {

    let userId: String? // 1
    let username: String? // 2
    let firstName: String? // 3
    let lastName: String? // 4
    let fullName: String? // 4
    let email: String? // 6
    let phoneNumber: String? // 11
    let dob: String? // 11
    let gender: Int? // 11
    let profilePhoto: String? // 11
    let bio: String? // 11

    let referralCode: String? // 5
    
    let followersCount: Int? // 8
    let followingCount: Int? // 8
    
    let privacyType: Int? // 8

    let isActive: Int? // 8
    let isBanned: Bool? // 7
    let isVerified: Bool? // 8
    let isDeleted: Bool? // 8

    let createdAt: String? // 13
    let updatedAt: String? // 13
    let deletedAt: String? // 13

    init(userId: String, username: String, firstName: String, lastName: String, fullName: String, dob : String, phoneNumber: String, bio: String, gender: Int, profilePhoto: String, email: String, referralCode: String, followersCount: Int, followingCount: Int,privacyType:Int, isActive: Int, isBanned: Bool, isVerified: Bool, isDeleted: Bool, createdAt: String, deletedAt: String, updatedAt: String){
        
        self.userId = userId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.dob = dob
        self.profilePhoto = profilePhoto
        self.bio = bio
        
        self.referralCode = referralCode

        self.followersCount = followersCount
        self.followingCount = followingCount
        self.privacyType = privacyType
        
        self.isBanned = isBanned
        self.isActive = isActive
        self.isVerified = isVerified
        self.isDeleted = isDeleted
        
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.updatedAt = updatedAt
    }

    init(with data: [String: Any]?) {
        
        self.userId = data?["id"] as? String ?? emptyStr
        self.username = data?["username"] as? String ?? emptyStr
        self.firstName = data?["f_name"] as? String ?? emptyStr
        self.lastName = data?["l_name"] as? String ?? emptyStr
        self.fullName = data?["fullName"] as? String ?? emptyStr
        self.email = data?["email"] as? String ?? emptyStr
        self.phoneNumber = data?["phone_number"] as? String ?? emptyStr
        self.bio = data?["bio"] as? String ?? emptyStr
        self.gender = data?["gender"] as? Int ?? zero
        self.profilePhoto = data?["profile_photo"] as? String ?? emptyStr
        self.dob = data?["date_of_birth"] as? String ?? emptyStr

        self.referralCode = data?["referral_code"] as? String ?? emptyStr
        
        self.followersCount = data?["followers_count"] as? Int ?? zero
        self.followingCount = data?["following_count"] as? Int ?? zero
        self.privacyType = data?["privacy_type"] as? Int ?? zero
        
        self.isActive = data?["is_active"] as? Int ?? zero
        self.isBanned = data?["is_banned"] as? Bool ?? false
        self.isVerified = data?["is_verified"] as? Bool ?? false
        self.isDeleted = data?["isDeleted"] as? Bool ?? false

        self.updatedAt = data?["updated_at"] as? String ?? emptyStr
        self.createdAt = data?["created_at"] as? String ?? emptyStr
        self.deletedAt = data?["deletedAt"] as? String ?? emptyStr
        
    }
    
//    init(json:JSON){
//        self.userId = json["userId"].stringValue
//        self.username = json["username"].stringValue
//        self.firstName = json["firstName"].stringValue
//        self.lastName = json["lastName"].stringValue
//        self.email = json["email"].stringValue
//        self.referralCode = json["referralCode"].stringValue
//        self.isActive = json["isActive"].intValue
//        self.wallet = json["wallet"].stringValue
//        self.hasKey = json["hasKey"].intValue
//        self.phone = json["phone"].stringValue
//        self.isBlocked = json["isBlocked"].intValue
//        self.fcmToken = json["fcmToken"].stringValue
//        self.createdAt = json["createdAt"].stringValue
//        self.isPhoneVerified = json["isPhoneVerified"].boolValue
//    }
    
    func toAnyObject() -> Any {
        
        return [
            "id" : userId ?? emptyStr,
            "username": username ?? emptyStr,
            "f_name": firstName ?? emptyStr,
            "l_name": lastName ?? emptyStr,
            "fullName": fullName ?? emptyStr,
            "email": email ?? emptyStr,
            "phone_number": phoneNumber ?? emptyStr,
            "date_of_birth": dob ?? emptyStr,
            "gender": gender ?? zero,
            "bio": bio ?? emptyStr,
            "profile_photo": profilePhoto ?? emptyStr,
            "referral_code": referralCode ?? emptyStr,
            "following_count": followingCount ?? zero,
        ]
    }
    
//    "followers_count": followersCount ?? zero,
//    "privacy_type": privacyType ?? zero,
//    "is_active": isActive ?? zero,
//    "is_banned": isBanned ?? false,
//    "is_verified": isVerified ?? false,
//    "isDeleted": isDeleted ?? false,
//    "updated_at": updatedAt ?? emptyStr,
//    "created_at": createdAt ?? emptyStr,
//    "deletedAt": deletedAt ?? emptyStr,

}


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
        }){ error in
            print("error...", error)
        }
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

