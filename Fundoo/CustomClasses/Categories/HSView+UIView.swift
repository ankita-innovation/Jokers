//
//  HSView+UIView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 14/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import Lottie
import UIKit

extension UIView{
    //MARK: shadow effect
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
    }
    //:MARK round corner radius
    func cornerViewRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    //MARK: minimum corner radius
    func cornerViewMiniumRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    func crapView(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    //MARK: remove corner radius
    func removeCornerRadius() {
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = false
    }
    //card effect
    func applyCardEffect(){
        self.layer.masksToBounds = false
//        let shadowSize : CGFloat = 3.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: 0,
//                                                   y: 0,
//                                                   width: self.frame.size.width + shadowSize,
//                                                   height: self.frame.size.height ))
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = CGFloat(2)
        self.layer.shadowOpacity = 0.24
//        self.layer.shadowPath = shadowPath.cgPath

    }
      
    func setGradient(index:Int){
        let gradientLayer = CAGradientLayer()
        var colorsArray: [[Any]?]
        var randomIndex = Int()
      
        if index > 9{
            randomIndex = index - 9
            if index > 18{
                let indexList = [0,1, 2, 3, 4,5,6,7,8,9]
                randomIndex = indexList.randomElement()!
            }
        }else{
            randomIndex = index
        }
        colorsArray = [[UIColor.init(red: 81, green: 9, blue: 163).cgColor, UIColor.init(red: 113, green: 32, blue: 209).cgColor,UIColor.init(red: 113, green: 32, blue: 209).cgColor],
                                 [UIColor.init(red: 128, green: 16, blue: 252).cgColor, UIColor.init(red: 204, green: 61, blue: 195).cgColor,UIColor.init(red: 254, green: 78, blue: 152).cgColor],
                                 [UIColor.init(red: 236, green: 3, blue: 139).cgColor, UIColor.init(red: 244, green: 54, blue: 120).cgColor,UIColor.init(red: 254, green: 185, blue: 106).cgColor],
                                 [UIColor.init(red: 176, green: 40, blue: 175).cgColor, UIColor.init(red: 210, green: 57, blue: 187).cgColor,UIColor.init(red: 248, green: 77, blue: 202).cgColor],
                                 [UIColor.init(red: 28, green: 184, blue: 184).cgColor, UIColor.init(red: 132, green: 219, blue: 147).cgColor,UIColor.init(red: 234, green: 253, blue: 111).cgColor],
                                 [UIColor.init(red: 177, green: 37, blue: 129).cgColor, UIColor.init(red: 28, green: 184, blue: 184).cgColor,UIColor.init(red: 106, green: 48, blue: 142).cgColor],
                                 [UIColor.init(red: 158, green: 132, blue: 254).cgColor, UIColor.init(red: 38, green: 233, blue: 241).cgColor,UIColor.init(red: 236, green: 70, blue: 197).cgColor],
                                 [UIColor.init(red: 46, green: 203, blue: 116).cgColor, UIColor.init(red: 123, green: 216, blue: 150).cgColor,UIColor.init(red: 231, green: 252, blue: 112).cgColor],
                                 [UIColor.init(red: 253, green: 170, blue: 110).cgColor, UIColor.init(red: 254, green: 194, blue: 103).cgColor,UIColor.init(red: 255, green: 218, blue: 97).cgColor],
                                 [UIColor.init(red: 255, green: 100, blue: 153).cgColor, UIColor.init(red: 255, green: 136, blue: 136).cgColor,UIColor.init(red: 255, green: 212, blue: 98).cgColor]]
        
//        6. linear-gradient( 90deg, rgb(255,255,255) 0%, rgb(28,184,184) 0%, rgb(106,48,142) 0%, rgb(177,37,129) 48%, rgb(233,30,122) 100%);
//        7. linear-gradient( 90deg, rgb(106,48,142) 0%, rgb(255,255,255) 0%, rgb(236,70,197) 0%, rgb(158,132,254) 60%, rgb(38,233,241) 100%);
        
        gradientLayer.colors = colorsArray[randomIndex]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0.2,0.5,1]
            gradientLayer.frame = bounds
            layer.insertSublayer(gradientLayer, at: 0)
    }
    
   
    
    //MARK:Specific corner radius
    func specificCorner(radius:CGFloat)  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topRight , .topLeft], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
    //MARK:Specific corner left
    func cornerLeft()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topRight , .bottomRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.layer.mask = rectShape
    }
    
    //MARK: Set border
    func setViewBorder(color:UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }

    func border1(color:UIColor) {
        self.layer.borderWidth = 0.2
        self.layer.borderColor = color.cgColor
    }
    
    
    func border(color:UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func addLOT(lot_name:String,w:CGFloat,h:CGFloat)  {
        var lottieView = LOTAnimationView()
        lottieView = LOTAnimationView(name: lot_name)
        lottieView.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
        lottieView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        lottieView.loopAnimation = true
        lottieView.contentMode = .scaleAspectFill
        self.clearsContextBeforeDrawing = true
        self.addSubview(lottieView)
        lottieView.play{ (finished) in
            // Do Something
        }
    }
    func addFitLOT(lot_name:String,w:CGFloat,h:CGFloat)  {
        var lottieView = LOTAnimationView()
        lottieView = LOTAnimationView(name: lot_name)
        lottieView.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
        lottieView.loopAnimation = true
        lottieView.contentMode = .scaleAspectFit
        self.clearsContextBeforeDrawing = true
        self.addSubview(lottieView)
        lottieView.play{ (finished) in
            // Do Something
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    

    
    public func renderToImage() -> UIImage {
           let rendererFormat = UIGraphicsImageRendererFormat.default()
           rendererFormat.opaque = isOpaque
           let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

           let snapshotImage = renderer.image { _ in
               drawHierarchy(in: bounds, afterScreenUpdates: true)
           }
           return snapshotImage
       }
    
    func toast(alert:String)  {
        self.hideAllToasts()
//        self.clearToastQueue()
        self.makeToast(Utility().getAppLanguage()?.value(forKey: alert) as? String)
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = CGAffineTransform().rotated(by: radians)
        self.transform = rotation
    }
    

    func addDiamondMask(cornerRadius: CGFloat = 0) {
              let path = UIBezierPath()
              path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + cornerRadius))
              path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.midY))
              path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - cornerRadius))
              path.addLine(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.midY))
              path.close()

              let shapeLayer = CAShapeLayer()
              shapeLayer.path = path.cgPath
              shapeLayer.fillColor = UIColor.white.cgColor
              shapeLayer.strokeColor = UIColor.red.cgColor
              shapeLayer.lineWidth = cornerRadius * 2
           shapeLayer.lineJoin = CAShapeLayerLineJoin.round
           shapeLayer.lineCap = CAShapeLayerLineCap.round

              layer.mask = shapeLayer
          }
    
    func setTopViewCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func mildElevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.25
    }
    func dropShadowForView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(white: 0, alpha: 0.29).cgColor
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
    }
    
    func doubleCardEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = CGFloat(2)
        self.layer.shadowOpacity = 0.10
    }
    
     func roundParticularCorners(_ corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           self.layer.mask = mask
    }
    
    func bottomShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 2
    }
}




