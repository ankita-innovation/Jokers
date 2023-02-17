//
//  EntitiesManagement.swift
//  Randoo
//
//  Created by HTS-Product on 12/02/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import CoreData

protocol storeDelegate {
    func gotStoredInfo(type:String,msg:Messages?)
}

//let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class Entities {
    static let sharedInstance = Entities()

    var delegate : storeDelegate?

    //add recent chat home
    func addRecent(name:String,user_id:String,time:String,msg:String,user_image:String,msg_id:String,msg_type:String,chat_type:String)  {
        let entity = NSEntityDescription.entity(forEntityName: "Recents", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(name, forKey: "user_name")
        newUser.setValue(user_id, forKey: "user_id")
        newUser.setValue(time, forKey: "time")
        let cryptLib = CryptLib()
        let decryptedMsg = cryptLib.decryptCipherTextRandomIV(withCipherText: msg, key: ENCRYPT_KEY)
        newUser.setValue(msg_id, forKey: "msg_id")
        newUser.setValue(decryptedMsg, forKey: "msg")
        newUser.setValue(msg_type, forKey: "msg_type")
        newUser.setValue("\(UserModel.shared.userID()!)\(user_id)", forKey: "chat_id")
        newUser.setValue(user_image, forKey: "user_image")
        newUser.setValue(false, forKey: "isBlocked")
        newUser.setValue(false, forKey: "isRead")
        newUser.setValue(chat_type, forKey: "chat_type")
        print("entitiesManagement: \(newUser)")
        print("checking for login time crash \(Entities.sharedInstance.getLast(user_id: APP_NAME))")
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE RECENT")
        }
    }

    //updated recent chat home
    func updateRecent(name:String,user_id:String,time:String,msg:String,user_image:String,msg_id:String,msg_type:String)  {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let recents =  result[0] as! Recents
            let cryptLib = CryptLib()
            let decryptedMsg = cryptLib.decryptCipherTextRandomIV(withCipherText: msg, key: ENCRYPT_KEY)
            if appDelegate.chattranslate == "None"{
                recents.setValue(decryptedMsg, forKey: "msg")
                recents.setValue(decryptedMsg, forKey: "translate_text")
                recents.setValue(msg_type, forKey: "msg_type")
                recents.setValue(time, forKey: "time")
                recents.setValue(user_image, forKey: "user_image")
                recents.setValue(name, forKey: "user_name")
                recents.setValue(msg_id, forKey: "msg_id")
                recents.setValue(false, forKey: "isRead")
            }else {
            Utility.shared.translate(msg: (decryptedMsg!), callback: { translatedTxt in
                print(UserModel.shared.userID() ?? (Any).self)
                print(user_id)
//                 recents.setValue(translatedTxt, forKey: "msg")
            recents.setValue(decryptedMsg, forKey: "msg")
                if user_id == UserModel.shared.userID() || appDelegate.isCurrentChattingUser == "" {
                    recents.setValue(decryptedMsg, forKey: "translate_text")
                    recents.setValue(false, forKey: "chat_translation")
                }else{
                    
                    print("translate_text_for:\(translatedTxt)")
                    
                    recents.setValue(translatedTxt, forKey: "translate_text")
                    recents.setValue(true, forKey: "chat_translation")
                }

            recents.setValue(msg_type, forKey: "msg_type")
            recents.setValue(time, forKey: "time")
            recents.setValue(user_image, forKey: "user_image")
            recents.setValue(name, forKey: "user_name")
            recents.setValue(msg_id, forKey: "msg_id")
            recents.setValue(false, forKey: "isRead")
                            print("recents list \(recents)")
            })
            }
        } catch {
            print("Failed")
        }
        do {
            try context.save()
        } catch {
            print("FAILED TO UPDATE RECENT")
        }
    }
    //updated read status
    func read(user_id:String)  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let recents =  result[0] as! Recents
                recents.setValue(true, forKey: "isRead")
                try context.save()
            }
        } catch {
            print("Failed")
        }

    }
    //get chat
    func info(user_id:String)-> Recents?  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let recents =  result[0] as! Recents
                return recents
            }else{
                return nil
            }
        } catch {
            print("Failed")
        }
        return nil
    }

    //updated block status
    func block(user_id:String,status:Bool)  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let recents =  result[0] as! Recents
                recents.setValue(status, forKey: "isBlocked")
                try context.save()
            }
        } catch {
            print("Failed")
        }

    }
    //add msg
    func addMsg(name:String,user_id:String,time:String,msg:String,user_image:String,msg_id:String,msg_type:String,status:String,receiver_id:String, isFromSocket: Bool = false, Duration: CGFloat = 0)  {
        let entity = NSEntityDescription.entity(forEntityName: "Messages", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        let cryptLib = CryptLib()
               let decryptedMsg = cryptLib.decryptCipherTextRandomIV(withCipherText: msg, key: ENCRYPT_KEY)

//               var decryptedMsg = msg
        Utility.shared.translate(msg: (decryptedMsg!), callback: { translatedTxt in
            newUser.setValue(name, forKey: "user_name")
            newUser.setValue(user_id, forKey: "user_id")
            newUser.setValue(time, forKey: "time")
            newUser.setValue(msg_id, forKey: "msg_id")
            newUser.setValue(decryptedMsg, forKey: "msg")
            newUser.setValue(false, forKey: "chat_translation")
            newUser.setValue(Duration, forKey: "duration")

            newUser.setValue(msg_type, forKey: "msg_type")

            if user_id == UserModel.shared.userID()! {
                print("chked1")
                //newUser.setValue(decryptedMsg, forKey: "msg")
                newUser.setValue("\(UserModel.shared.userID()!)\(receiver_id)", forKey: "chat_id")
            }else{
                print("chked2")
                newUser.setValue("\(UserModel.shared.userID()!)\(user_id)", forKey: "chat_id")
            }
            print(UserModel.shared.userID() ?? (Any).self)
            print(user_id)
            if user_id == UserModel.shared.userID() || appDelegate.isCurrentChattingUser == ""{
                newUser.setValue(decryptedMsg, forKey: "msg")
                newUser.setValue(decryptedMsg, forKey: "translate_text")
                newUser.setValue(false, forKey: "chat_translation")
            }
            else{
                if isFromSocket {
                    newUser.setValue(decryptedMsg, forKey: "msg")
                    newUser.setValue(translatedTxt, forKey: "translate_text")
                    newUser.setValue(true, forKey: "chat_translation")
                }
//                newUser.setValue(decryptedMsg, forKey: "msg")
//                newUser.setValue(translatedTxt, forKey: "translate_text")
            }
            newUser.setValue(user_image, forKey: "user_image")
            newUser.setValue(receiver_id, forKey: "receiver_id")

            do {
                try context.save()
                self.getMsg(msg_id: msg_id)
            } catch {
                print("FAILED TO SAVE MESSAGE")
            }

        })
    }

    //update online
    func updateOnline(user_id:String,status:Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "user_id = %@", user_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let recent =  result[0] as! Recents
                recent.setValue(status, forKey: "isOnline")
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
    //update online
    func updateTyping(user_id:String,status:Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "user_id = %@", user_id)
        request.returnsObjectsAsFaults = false
        do {

            let result = try context.fetch(request)
            if result.count != 0 {
                let recent =  result[0] as! Recents
                recent.setValue(status, forKey: "isTyping")
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
    //stop all typing status initially
    func stopTyping()  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        let sort = NSSortDescriptor(key: #keyPath(Recents.time), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
            for chat in result{
                let recent = chat as! Recents
                recent.setValue(false, forKey: "isTyping")
            }
            }

        } catch {
            print("Failed")
        }
    }

    //update read msg
    func updateRead(msg_id:String) {
        print("updateRead%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "msg_id = %@", msg_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let msg =  result[0] as! Messages
                msg.setValue(true, forKey: "read_status")
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }

    //updated block status
    func updateDownload(msg_id:String,imgData:Data) -> Messages? {
        print("updateDownload%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "msg_id = %@", msg_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let msg =  result[0] as! Messages
            msg.setValue(imgData, forKey: "attachment")
            msg.setValue(true, forKey: "isDownload")
            try context.save()
            return msg
        } catch {
            print("Failed")
        }
       return nil
    }

    //get msg
    func getMsg(msg_id:String)  {
        print("getMsg%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "msg_id = %@", "\(msg_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.delegate?.gotStoredInfo(type: "msg",msg:(result[0] as! Messages))
            print(result[0])
        } catch {
            print("Failed")
        }
    }
    //get msg
    func getAllMsg(chat_id:String,offset:Int)->NSMutableArray  {
        print("getALLMsg%%%%")
        let msgList = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(chat_id)")
        request.fetchLimit = 20
        request.fetchOffset = offset
        let sort = NSSortDescriptor(key: #keyPath(Messages.time), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            msgList.addObjects(from: result.reversed())
            return msgList
        } catch {
            print("Failed")
        }
        return msgList
    }


    //get all recent chats from list
    func getChats()->NSMutableArray  {
        let chats = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        let chat_sort = NSSortDescriptor(key: #keyPath(Recents.chat_type), ascending: true)

        let time_sort = NSSortDescriptor(key: #keyPath(Recents.time), ascending: false)
        request.sortDescriptors = [chat_sort,time_sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var isAdminAdded = false
            for recent in result{
                let model = recent as! Recents
                if model.user_id == APP_NAME{
                    if !isAdminAdded {
                        isAdminAdded = true
                        chats.add(model)
                    }
                }else{
                    chats.add(model)
                }
            }

            return chats
        } catch {
            print("Failed")
        }
        return chats
    }
    //get ids for online list
    func getIds()->NSMutableArray  {
        let userIDs = NSMutableArray()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        let sort = NSSortDescriptor(key: #keyPath(Recents.time), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for recent in result{
                let model = recent as! Recents
                if model.user_id != APP_NAME{
                userIDs.add(model.user_id as Any)
                }
            }
            return userIDs
        } catch {
            print("Failed")
        }
        return userIDs
    }

    //check if user is exist
    func userExist(user_id:String)->Bool  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "user_id = %@", "\(user_id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if(result.count == 0){
                print("new user")
                return false
            }else{
                print("existing user")
                return true
            }
        } catch {

            print("Failed")
        }
        return false
    }


    //get all recent chats from list
    func getLastMsgID(user_id:String,type:String)->String  {
        print("getLastMsgID%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        let firstCondition = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        var secondCondition = NSPredicate()
        if type == "instant" {
             secondCondition = NSPredicate(format: "user_id = %@", UserModel.shared.userID()!)
        }else{
             secondCondition = NSPredicate(format: "read_status = \(true)")
        }
        let joinPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [firstCondition, secondCondition])
        request.predicate = joinPredicate
        let sort = NSSortDescriptor(key: #keyPath(Messages.time), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
                return ""
            }else{
            let msg = result[0] as! Messages
            print("last msg \(msg.msg!)")
            self.updateRead(msg_id: msg.msg_id!)
            return msg.msg_id!
            }
        } catch {
            print("Failed")
        }
        return ""
    }
    //get last msg
    func getLast(user_id:String)->Messages?  {
        print("getKast%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(UserModel.shared.userID()!)\(user_id)")
        let sort = NSSortDescriptor(key: #keyPath(Messages.time), ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{

                return nil
            }else{
                return (result[0] as! Messages)
            }
        } catch {
            print("Failed")
        }
        return nil
    }


    //clear chat
    func clear(chat_id:String)    {
        print("clear%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "chat_id = %@", "\(chat_id)")
        let clearRequest = NSBatchDeleteRequest(fetchRequest: request)
        do
        {
            try context.execute(clearRequest)
            try context.save()
        }
        catch _ {
            print("Could not delete")
        }
    }
    //updated msg clear
    func emptyRecent(user_id:String)  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        request.predicate = NSPredicate(format: "user_id = %@", user_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let recent =  result[0] as! Recents
            recent.setValue("", forKey: "msg")
            try context.save()
        } catch {
            print("Failed")
        }
    }

    //CUSTOMIZATION
    func language(chat_id:String)  {
        print("language%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "chat_id = %@", chat_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("result backBtn \(result)")
            if result.count != 0 {
                /*let msg =  result[0] as! Messages
                msg.setValue(false, forKey: "chat_translation")
                msg.setValue("", forKey: "translate_text")
                print("translate_text backBtn \(msg)")
                try context.save()*/
                for chat in result{
                    let msg = chat as! Messages
                    if msg.chat_translation {
                        msg.setValue(false, forKey: "chat_translation")
                    }

                    print("translate_text backBtn \(msg)")
                    try context.save()
                }
            }
        } catch {
            print("Failed")
        }
    }

    //CUSTOMIZATION
    func languageChanged(chat_id:String)  {
        print("languageChanged%%%%")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        request.predicate = NSPredicate(format: "chat_id = %@", chat_id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("result backBtn \(result)")
            if result.count != 0 {
                /*let msg =  result[0] as! Messages
                msg.setValue(false, forKey: "chat_translation")
                msg.setValue("", forKey: "translate_text")
                print("translate_text backBtn \(msg)")
                try context.save()*/
                for chat in result{
                    let msg = chat as! Messages
                    msg.setValue(false, forKey: "chat_translation")
                    msg.setValue("", forKey: "translate_text")
                    print("translate_text backBtn \(msg)")
                    try context.save()
                }
            }
        } catch {
            print("Failed")
        }
    }

}





