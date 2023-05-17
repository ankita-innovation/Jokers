//
//  HSViewController+UIViewController.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation

extension UIViewController{
  
    //show status alert based local json
    func statusAlert(msg:String)  {
        CRNotifications.showNotification(textColor: .white, backgroundColor: PRIMARY_COLOR, image: UIImage.init(named: "brodcastInfo_icon"), title: APP_NAME, message: Utility.shared.getAppLanguage()?.value(forKey: msg) as! String, dismissDelay: 2)
    }
    //from server
    func statusServer(alert:String)  {

        CRNotifications.showNotification(textColor: .white, backgroundColor: PRIMARY_COLOR, image: UIImage.init(named: "brodcastInfo_icon"), title: APP_NAME, message: alert, dismissDelay: 2)

    }
    
    //show alert
    func showAlert(msg:String)  {
        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: msg) as? String, preferredStyle: UIAlertController.Style.alert)
        let dismiss = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "ok") as? String, style: UIAlertAction.Style.cancel, handler: nil)
        otherAlert.addAction(dismiss)
        present(otherAlert, animated: true, completion: nil)
    }
    
    //MARK:location restriction alert
    func cameraPermissionAlert(vc:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!)  {
        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "camera_permission") as? String, preferredStyle: UIAlertController.Style.alert)
        let dismiss = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "cancel") as? String, style: UIAlertAction.Style.cancel, handler: nil)
        otherAlert.addAction(dismiss)
        
        let setting = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "setting") as? String, style: UIAlertAction.Style.default, handler:goSetting)
        otherAlert.addAction(setting)
        vc.present(otherAlert, animated: true, completion: nil)
    }
    
    func photoPermissionAlert(vc:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!)  {
        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "photo_permission") as? String, preferredStyle: UIAlertController.Style.alert)
        let dismiss = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "cancel") as? String, style: UIAlertAction.Style.cancel, handler: nil)
        otherAlert.addAction(dismiss)
        
        let setting = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "setting") as? String, style: UIAlertAction.Style.default, handler:goSetting)
        otherAlert.addAction(setting)
        
        vc.present(otherAlert, animated: true, completion: nil)
    }
    //MARK:location restriction alert
    func microPhonePermissionAlert(vc:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!)  {
        let otherAlert = UIAlertController(title: nil, message: Utility().getAppLanguage()?.value(forKey: "microphone_permission") as? String, preferredStyle: UIAlertController.Style.alert)
        let dismiss = UIAlertAction(title:Utility().getAppLanguage()?.value(forKey: "cancel") as? String, style: UIAlertAction.Style.cancel, handler: nil)
        otherAlert.addAction(dismiss)
        
        let setting = UIAlertAction(title: Utility().getAppLanguage()?.value(forKey: "setting") as? String, style: UIAlertAction.Style.default, handler:goSetting)
        otherAlert.addAction(setting)
        vc.present(otherAlert, animated: true, completion: nil)
    }

    func goSetting(alert: UIAlertAction){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func centerPoint()->UIButton {
        let transitionBtn = UIButton()
        transitionBtn.frame = CGRect.init(x: FULL_WIDTH/2, y: FULL_HEIGHT/2, width: 0.1, height: 0.1);
        transitionBtn.backgroundColor = PRIMARY_COLOR
        self.view.addSubview(transitionBtn)
        return transitionBtn
    }
    
    //check if socket is chat socket or random socket
    func isChat(socket:String) -> Bool {
        let chatSocket = "\(WEB_SOCKET_CHAT_URL)\(UserModel.shared.userID()!)"
        if socket == chatSocket {
            return true
        }
        return false
    }

    
    
}
