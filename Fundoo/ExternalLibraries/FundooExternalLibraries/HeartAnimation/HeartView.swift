//
//  HeartView.swift
//  FloatingHearts
//
//  Created by Xinzhe Wang on 1/16/18.
//  Copyright © 2018 IntBridge. All rights reserved.
//

import UIKit
import Foundation


// MARK: Themes
struct HeartTheme {
    let fillColor: UIColor
    let strokeColor: UIColor
    static var selectedColor = String()
    //using white borders for this example. Set your colors.
    static func theme() -> HeartTheme {
        return HeartTheme(fillColor: UIColor().hexValue(hex: selectedColor), strokeColor: UIColor(white: 1.0, alpha: 0.8))

    }
}

// MARK: HeartView

enum RotationDirection: CGFloat {
    case Left = -1
    case Right = 1
}

let PI = CGFloat(Double.pi)

public class HeartView: UIView {
    
    private struct Durations {
        static let Full: TimeInterval = 4.0
        static let Bloom: TimeInterval = 0.5
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Animations
    
    public func animateInView(view: UIView) {
        guard let rotationDirection = RotationDirection(rawValue: CGFloat(1 - Int(2 * randomNumber(2)))) else { return }
        prepareForAnimation()
        performBloomAnimation()
        performSlightRotationAnimation(direction: rotationDirection)
        addPathAnimation(inView: view)
    }
    
    private func prepareForAnimation() {
        transform = CGAffineTransform(scaleX: 0, y: 0)
        alpha = 0
    }
    
    private func performBloomAnimation() {
        spring(duration: Durations.Bloom, delay: 0.0, damping: 0.6, velocity: 0.8) {
            self.transform = CGAffineTransform.identity
            self.alpha = 0.9
        }
    }
    
    private func performSlightRotationAnimation(direction: RotationDirection) {
        let rotationFraction = randomNumber(10)
        UIView.animate(withDuration: Durations.Full, animations: {
        }) { (finished) in
            self.transform = CGAffineTransform(rotationAngle: direction.rawValue * PI / (16 + rotationFraction * 0.2))
        }
    }
    
    private func travelPath(inView view: UIView) -> UIBezierPath? {
        guard let endPointDirection = RotationDirection(rawValue: CGFloat(1 - Int(2 * randomNumber(2)))) else { return nil }
        
        let heartCenterX = center.x
        let heartSize = bounds.width
        let viewHeight = view.bounds.height
        
        //random end point
        let endPointX = heartCenterX + (endPointDirection.rawValue * randomNumber(2 * heartSize))
        let endPointY = viewHeight / 8.0 + randomNumber(viewHeight / 4.0)
        let endPoint = CGPoint(x: endPointX, y: endPointY)
        
        //random Control Points
        let travelDirection = CGFloat(1 - Int(2 * randomNumber(2)))
        let xDelta = (heartSize / 2.0 + randomNumber(2 * heartSize)) * travelDirection
        let yDelta = max(endPoint.y ,max(randomNumber(8 * heartSize), heartSize))
        let controlPoint1 = CGPoint(x: heartCenterX + xDelta, y: viewHeight - yDelta)
        let controlPoint2 = CGPoint(x: heartCenterX - 2 * xDelta, y: yDelta)
        
        let path = UIBezierPath()
        path.move(to: center)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        return path
    }
    
    private func addPathAnimation(inView view: UIView) {
        guard let heartTravelPath = travelPath(inView: view) else { return }
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.path = heartTravelPath.cgPath
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        let durationAdjustment = 4 * TimeInterval(heartTravelPath.bounds.height / view.bounds.height)
        let duration = Durations.Full + durationAdjustment
        keyFrameAnimation.duration = duration
        layer.add(keyFrameAnimation, forKey: "positionOnPath")
        
        animateToFinalAlpha(withDuration: duration)
    }
    
    private func animateToFinalAlpha(withDuration duration: TimeInterval = Durations.Full) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    override public func draw(_ rect: CGRect) {
        
        #if true
        
        let theme = HeartTheme.theme()
        let imageBundle = Bundle(for: HeartView.self)
        let heartImage = UIImage(named: "heart_like", in: imageBundle, compatibleWith: nil)

        let heartImageBorder = UIImage(named: "heartBorder_like", in: imageBundle, compatibleWith: nil)
        
        //Draw background image (mimics border)
        theme.strokeColor.setFill()
        heartImageBorder?.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        //Draw foreground heart image
        theme.fillColor.setFill()
        heartImage?.draw(in: rect, blendMode: .normal, alpha: 1.0)
        #else
        //Just for fun. Draw heart using Bezier path
        drawHeartInRect(rect)
        #endif
    }
    
    private func drawHeartInRect(rect: CGRect) {
        
        let theme = HeartTheme.theme()
        
        theme.strokeColor.setStroke()
        theme.fillColor.setFill()
        
        let drawingPadding: CGFloat = 4.0
        let curveRadius = floor((rect.width - 2*drawingPadding) / 4.0)
        
        //Creat path
        let heartPath = UIBezierPath()
        
        //Start at bottom heart tip
        let tipLocation = CGPoint(x: floor(rect.width / 2.0), y: rect.height - drawingPadding)
        heartPath.move(to: tipLocation)
        
        //Move to top left start of curve
        let topLeftCurveStart = CGPoint(x: drawingPadding, y: floor(rect.height / 2.4))
        heartPath.addQuadCurve(to: topLeftCurveStart, controlPoint: CGPoint(x: topLeftCurveStart.x, y: topLeftCurveStart.y + curveRadius))
        
        //Create top left curve
        heartPath.addArc(withCenter: CGPoint(x: topLeftCurveStart.x + curveRadius, y: topLeftCurveStart.y), radius: curveRadius, startAngle: PI, endAngle: 0, clockwise: true)
        
        //Create top right curve
        let topRightCurveStart = CGPoint(x: topLeftCurveStart.x + 2*curveRadius, y: topLeftCurveStart.y)
        heartPath.addArc(withCenter: CGPoint(x: topRightCurveStart.x + curveRadius, y: topRightCurveStart.y), radius: curveRadius, startAngle: PI, endAngle: 0, clockwise: true)
        
        //Final curve to bottom heart tip
        let topRightCurveEnd = CGPoint(x: topLeftCurveStart.x + 4*curveRadius, y: topRightCurveStart.y)
        heartPath.addQuadCurve(to: tipLocation, controlPoint: CGPoint(x: topRightCurveEnd.x, y: topRightCurveEnd.y + curveRadius))
        
        heartPath.fill()
        
        heartPath.lineWidth = 1
        heartPath.lineCapStyle = .round
        heartPath.lineJoinStyle = .round
        heartPath.stroke()
    }
}


