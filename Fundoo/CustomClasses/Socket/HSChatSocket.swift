//
//  HSChatSocket.swift
//  Randoo
//
//  Created by HTS-Product on 31/05/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import UIKit

var chatSocket = SRWebSocket()
protocol socketDelegate {
    func gotSocketInfo(type:String,dict:NSDictionary?)
}

class HSChatSocket {
    static let sharedInstance = HSChatSocket()
    var delegate : socketDelegate?
    
    //open socket
    func connect()  {
        let socketURL = URL.init(string: "\(WEB_SOCKET_CHAT_URL)\(UserModel.shared.userID()!)")
        chatSocket = SRWebSocket.init(url: socketURL)
        chatSocket.open()
    }
    
    func disconnect()  {
               chatSocket.close()
    }
           
    
    //update user live status
    func makeAlive()  {
//        print("make live")
        if Utility.shared.isConnectedToNetwork() {
            
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                let req = NSMutableDictionary()
                req.setValue("_updateLive", forKey: "type")
                req.setValue(UserModel.shared.getLiveStatus(), forKey: "live_status")
                req.setValue(Utility.shared.getUTCTime(), forKey: "timestamp")
                req.setValue(UserModel.shared.userID(), forKey: "user_id")
                print("make param: \(req)")
                chatSocket.send(self.convert(dict: req))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.makeAlive()
            }
        }
    }
    
    // send typing status
    func typing(status:String,receiver_id:String)  {
        if isSocketConnected && chatSocket.readyState.rawValue == 1{
            if Utility.shared.isConnectedToNetwork() {
                let req = NSMutableDictionary()
                req.setValue("_userTyping", forKey: "type")
                req.setValue(receiver_id, forKey: "receiver_id")
                req.setValue(UserModel.shared.userID(), forKey: "user_id")
                req.setValue(status, forKey: "typing_status")
                chatSocket.send(self.convert(dict: req))
            }
        }
    }
    
    //check partner live status
    func checkOnline(receiver_id:String)  {
        if Utility.shared.isConnectedToNetwork() {
            
            let req = NSMutableDictionary()
            req.setValue("_profileLive", forKey: "type")
            req.setValue(receiver_id, forKey: "receiver_id")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("check online \(req)")
                chatSocket.send(self.convert(dict: req))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.checkOnline(receiver_id: receiver_id)
                }
                
            }
        }
    }
    //check partner live status
    func onlineList(ids:NSMutableArray)  {
        if Utility.shared.isConnectedToNetwork() {
            
            let req = NSMutableDictionary()
            req.setValue("_onlineList", forKey: "type")
            req.setValue(ids, forKey: "users_list")
            req.setValue(UserModel.shared.userID(), forKey: "user_id")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("onlinelist \(req)")
                chatSocket.send(self.convert(dict: req))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.onlineList(ids: ids)
                }
            }
        }
    }
  
    //update read status
    func updateRead(receiver_id:String)  {
        if Utility.shared.isConnectedToNetwork() {
            
            let req = NSMutableDictionary()
            req.setValue("_updateRead", forKey: "type")
            req.setValue(receiver_id, forKey: "receiver_id")
            req.setValue(UserModel.shared.userID(), forKey: "user_id")
            req.setValue("\(UserModel.shared.userID()!)\(receiver_id)", forKey: "chat_id")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("updateRead \(req)")
                chatSocket.send(self.convert(dict: req))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.updateRead(receiver_id: receiver_id)
                }
            }
        }
    }
    //send sticker
    func notifyUser(receiver_id:String,type:String)  {
        if Utility.shared.isConnectedToNetwork() {
            
            let req = NSMutableDictionary()
            req.setValue("_userNotify", forKey: "type")
            req.setValue(UserModel.shared.userID(), forKey: "user_id")
            req.setValue(receiver_id, forKey: "receiver_id")
            req.setValue(type, forKey: "msg_type")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("notifyuser \(req)")
                chatSocket.send(self.convert(dict: req))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.notifyUser(receiver_id: receiver_id, type: type)
                }
            }
        }
    }
    //send msg
    func sendMsg(receiverID:String,msgType:String,msg:String,name:String,img:String,attachment:Data?,Duration: CGFloat = 0)  {
        do{
            let jsonDecoder = JSONDecoder()
            let profile = try jsonDecoder.decode(ProfileModel.self, from: UserModel.shared.userData()!)
            let time = Utility.shared.getUTCTime()
            let req = NSMutableDictionary()
            req.setValue("_sendChat", forKey: "type")
            req.setValue(time, forKey: "chat_time")
            req.setValue(UserModel.shared.userID(), forKey: "user_id")
            req.setValue(profile.user_image, forKey: "user_image")
            req.setValue(profile.name, forKey: "user_name")
            req.setValue(receiverID, forKey: "receiver_id")
            req.setValue("user_chat", forKey: "chat_type")
            req.setValue(Duration, forKey: "duration")
            req.setValue("\(UserModel.shared.userID()!)\(receiverID)", forKey: "chat_id")
            req.setValue(msgType, forKey: "msg_type")
            let msgID = Utility.shared.randomID()
            req.setValue(msgID, forKey: "msg_id")
            let cryptLib = CryptLib()
            let encryptedText = cryptLib.encryptPlainTextRandomIV(withPlainText:msg, key: ENCRYPT_KEY)
            req.setValue(encryptedText, forKey: "message")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("send message")
                print(req)
                chatSocket.send(self.convert(dict: req)) // send socket
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.sendMsg(receiverID: receiverID, msgType: msgType, msg: msg, name: name, img: img, attachment: attachment)
                }
            }
            //local storage
            req.removeObject(forKey: "user_image")
            req.removeObject(forKey: "user_name")
            req.setValue(img, forKey: "user_image")
            req.setValue(name, forKey: "user_name")
            if msgType != "missed" {
                Utility.shared.addToLocal(dict: req)
            }
            /*
            if msgType == "image" {
                Entities.sharedInstance.updateDownload(msg_id: msgID, imgData: attachment!)
            }
            */
        }catch{
            
        }
    }
    //initate call
    func manageCall(receiverID:String,room:String,type:String,chat_type:String)  {
        
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
            req.setValue(chat_type, forKey: "chat_type")
            req.setValue(type, forKey: "call_type")
            req.setValue(Utility.shared.getUTCTime(), forKey: "created_at")
            req.setValue("ios", forKey: "platform")
            req.setValue(room, forKey: "room_id")
            if isSocketConnected && chatSocket.readyState.rawValue == 1{
                print("call \(req)")
                chatSocket.send(self.convert(dict: req))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.manageCall(receiverID: receiverID, room: room, type: type, chat_type: chat_type)
                }
            }
        }catch{
            
        }
    }
    
    func passDetails(type:String,dict:NSDictionary?) {
        HSChatSocket.sharedInstance.makeAlive()
        self.delegate?.gotSocketInfo(type: type, dict: dict)
    }
    
    //convert dict to json string
    func convert(dict:NSMutableDictionary)-> String {
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: [])
        var myString: String? = nil
        myString = String(data: jsonData!, encoding: .utf8)
        print("SEND SOCKET \(myString!)")
        return myString!
    }
    
}
