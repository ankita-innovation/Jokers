//
//  HTCVideoManager.swift
//  FilterCameraModel
//
//  Created by HTS on 02/09/20.
//  Copyright © 2020 HitaSoft. All rights reserved.
//

//import UIKit
//import MediaPlayer
//import MobileCoreServices
//import AVKit
//
//class VideoData: NSObject {
//    var index:Int?
//    var image:UIImage?
//    var asset:AVAsset?
//    var isVideo = false
//}
//
//class TextData: NSObject {
//    var text = ""
//    var fontSize:CGFloat = 40
//    var textColor = UIColor.red
//    var showTime:CGFloat = 0
//    var endTime:CGFloat = 0
//    var textFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
//}
//
//class HTSVideoManager: NSObject {
//    static let shared = HTSVideoManager()
//
//    let defaultSize = CGSize(width: 1920, height: 1080) // Default video size
//    var videoDuration = 30.0 // Duration of output video when merging videos & images
//    var imageDuration = 5.0 // Duration of each image
//
//
//    typealias Completion = (URL?, Error?) -> Void
//
//    //
//    // Merge array videos
//    //
//    func merge(arrayVideos:[AVAsset], completion:@escaping Completion) -> Void {
//        doMerge(arrayVideos: arrayVideos, animation: false, completion: completion)
//    }
//
//    //
//    // Merge array videos with transition animation
//    //
//    func mergeWithAnimation(arrayVideos:[AVAsset], completion:@escaping Completion) -> Void {
//        doMerge(arrayVideos: arrayVideos, animation: true, completion: completion)
//    }
//
//    //
//    // Add background music to video
//    //
//    func merge(video:AVAsset, withBackgroundMusic music:AVAsset, completion:@escaping Completion) -> Void {
//        // Init composition
//        let mixComposition = AVMutableComposition.init()
//
//        // Get video track
//        guard let videoTrack = video.tracks(withMediaType: AVMediaType.video).first else {
//            completion(nil, nil)
//            return
//        }
//
//        let outputSize = videoTrack.naturalSize
//        let insertTime = CMTime.zero
//
//        // Get audio track
//        var audioTrack:AVAssetTrack?
//        if music.tracks(withMediaType: AVMediaType.audio).count > 0 {
//            audioTrack = music.tracks(withMediaType: AVMediaType.audio).first
//        }
//
//        // Init video & audio composition track
//        let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
//                                                                   preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//        let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
//                                                                   preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//        let startTime = CMTime.zero
//        let duration = video.duration
//
//        do {
//            // Add video track to video composition at specific time
//            try videoCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                       of: videoTrack,
//                                                       at: insertTime)
//
//            // Add audio track to audio composition at specific time
//            if let audioTrack = audioTrack {
//                try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                           of: audioTrack,
//                                                           at: insertTime)
//            }
//        }
//        catch {
//            print("Load track error")
//        }
//
//        // Init layer instruction
//        let layerInstruction = videoCompositionInstructionForTrack(track: videoCompositionTrack!,
//                                                                   asset: video,
//                                                                   standardSize: outputSize,
//                                                                   atTime: insertTime)
//
//        // Init main instruction
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        mainInstruction.timeRange = CMTimeRangeMake(start: insertTime, duration: duration)
//        mainInstruction.layerInstructions = [layerInstruction]
//
//        // Init layer composition
//        let layerComposition = AVMutableVideoComposition()
//        layerComposition.instructions = [mainInstruction]
//        layerComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//        layerComposition.renderSize = outputSize
//
//        let path = NSTemporaryDirectory().appending("mergedVideo.mp4")
//        let exportURL = URL.init(fileURLWithPath: path)
//
//        // Check exist and remove old file
//        FileManager.default.removeItemIfExisted(exportURL)
//
//        // Init exporter
//        let exporter = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
//        exporter?.outputURL = exportURL
//        exporter?.outputFileType = AVFileType.mp4
//        exporter?.shouldOptimizeForNetworkUse = true
//        exporter?.videoComposition = layerComposition
//
//        // Do export
//        exporter?.exportAsynchronously(completionHandler: {
//            DispatchQueue.main.async {
//                self.exportDidFinish(exporter: exporter, videoURL: exportURL, completion: completion)
//            }
//        })
//    }
//
//    private func doMerge(arrayVideos:[AVAsset], animation:Bool, completion:@escaping Completion) -> Void {
//        var insertTime = CMTime.zero
//        var arrayLayerInstructions:[AVMutableVideoCompositionLayerInstruction] = []
//        var outputSize = CGSize.init(width: 0, height: 0)
//
//        // Determine video output size
//        for videoAsset in arrayVideos {
//            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { continue }
//
//            let assetInfo = orientationFromTransform(transform: videoTrack.preferredTransform)
//
//            var videoSize = videoTrack.naturalSize
//            if assetInfo.isPortrait == true {
//                videoSize.width = videoTrack.naturalSize.height
//                videoSize.height = videoTrack.naturalSize.width
//            }
//
//            if videoSize.height > outputSize.height {
//                outputSize = videoSize
//            }
//        }
//
//        if outputSize.width == 0 || outputSize.height == 0 {
//            outputSize = defaultSize
//        }
//
////        // Silence sound (in case of video has no sound track)
////        let silenceURL = Bundle.main.url(forResource: "silence", withExtension: "mp3")
////        let silenceAsset = AVAsset(url:silenceURL!)
////        let silenceSoundTrack = silenceAsset.tracks(withMediaType: AVMediaType.audio).first
//
//        // Init composition
//        let mixComposition = AVMutableComposition.init()
//
//        for videoAsset in arrayVideos {
//            // Get video track
//            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { continue }
//
//            // Get audio track
//            var audioTrack:AVAssetTrack?
//            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
//                audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
//            }
//
//            // Init video & audio composition track
//            let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
//                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//            let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
//                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//            do {
//                let startTime = CMTime.zero
//                let duration = videoAsset.duration
//
//                // Add video track to video composition at specific time
//                try videoCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                           of: videoTrack,
//                                                           at: insertTime)
//
//                // Add audio track to audio composition at specific time
//                if let audioTrack = audioTrack {
//                    try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                               of: audioTrack,
//                                                               at: insertTime)
//                }
//
//                // Add instruction for video track
//                let layerInstruction = videoCompositionInstructionForTrack(track: videoCompositionTrack!,
//                                                                           asset: videoAsset,
//                                                                           standardSize: outputSize,
//                                                                           atTime: insertTime)
//
//                // Hide video track before changing to new track
//                let endTime = CMTimeAdd(insertTime, duration)
//
//                if animation {
//                    let timeScale = videoAsset.duration.timescale
//                    let durationAnimation = CMTime.init(seconds: 1, preferredTimescale: timeScale)
//
//                    layerInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: CMTimeRange.init(start: endTime, duration: durationAnimation))
//                }
//                else {
//                    layerInstruction.setOpacity(0, at: endTime)
//                }
//
//                arrayLayerInstructions.append(layerInstruction)
//
//                // Increase the insert time
//                insertTime = CMTimeAdd(insertTime, duration)
//            }
//            catch {
//                print("Load track error")
//            }
//        }
//
//        // Main video composition instruction
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: insertTime)
//        mainInstruction.layerInstructions = arrayLayerInstructions
//
//        // Main video composition
//        let mainComposition = AVMutableVideoComposition()
//        mainComposition.instructions = [mainInstruction]
//        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//        mainComposition.renderSize = outputSize
//
//        // Export to file
//        let path = NSTemporaryDirectory().appending("mergedVideo.mp4")
//        let exportURL = URL.init(fileURLWithPath: path)
//
//        // Remove file if existed
//        FileManager.default.removeItemIfExisted(exportURL)
//
//        // Init exporter
//        let exporter = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
//        exporter?.outputURL = exportURL
//        exporter?.outputFileType = AVFileType.mp4
//        exporter?.shouldOptimizeForNetworkUse = true
//        exporter?.videoComposition = mainComposition
//
//        // Do export
//        exporter?.exportAsynchronously(completionHandler: {
//            DispatchQueue.main.async {
//                self.exportDidFinish(exporter: exporter, videoURL: exportURL, completion: completion)
//            }
//        })
//
//    }
//
//    //
//    // Merge videos & images
//    //
//    func makeVideoFrom(data:[VideoData], textData:[TextData]?, completion:@escaping Completion) -> Void {
//        var outputSize = CGSize.init(width: 0, height: 0)
//        var insertTime = CMTime.zero
//        var arrayLayerInstructions:[AVMutableVideoCompositionLayerInstruction] = []
//        var arrayLayerImages:[CALayer] = []
//
//        // Black background video
//        guard let bgVideoURL = Bundle.main.url(forResource: "black", withExtension: "mov") else {
//            print("Need black background video !")
//            completion(nil,nil)
//            return
//        }
//
//        let bgVideoAsset = AVAsset(url: bgVideoURL)
//        let bgVideoTrack = bgVideoAsset.tracks(withMediaType: AVMediaType.video).first
//
//        // Silence sound (in case of video has no sound track)
//        let silenceURL = Bundle.main.url(forResource: "silence", withExtension: "mp3")
//        let silenceAsset = AVAsset(url:silenceURL!)
//        let silenceSoundTrack = silenceAsset.tracks(withMediaType: AVMediaType.audio).first
//
//        // Init composition
//        let mixComposition = AVMutableComposition.init()
//
//        // Determine video output
//        for videoData in data {
//            guard let videoAsset = videoData.asset else { continue }
//
//            // Get video track
//            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { continue }
//
//            let assetInfo = orientationFromTransform(transform: videoTrack.preferredTransform)
//
//            var videoSize = videoTrack.naturalSize
//            if assetInfo.isPortrait == true {
//                videoSize.width = videoTrack.naturalSize.height
//                videoSize.height = videoTrack.naturalSize.width
//            }
//
//            if videoSize.height > outputSize.height {
//                outputSize = videoSize
//            }
//        }
//
//        if outputSize.width == 0 || outputSize.height == 0 {
//            outputSize = defaultSize
//        }
//
//        // Merge
//        for videoData in data {
//            if videoData.isVideo {
//                guard let videoAsset = videoData.asset else { continue }
//
//                // Get video track
//                guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { continue }
//
//                // Get audio track
//                var audioTrack:AVAssetTrack?
//                if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
//                    audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
//                }
//                else {
//                    audioTrack = silenceSoundTrack
//                }
//
//                // Init video & audio composition track
//                let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
//                                                                           preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//                let audioCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
//                                                                           preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//                do {
//                    let startTime = CMTime.zero
//                    let duration = videoAsset.duration
//
//                    // Add video track to video composition at specific time
//                    try videoCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                              of: videoTrack,
//                                                              at: insertTime)
//
//                    // Add audio track to audio composition at specific time
//                    if let audioTrack = audioTrack {
//                        try audioCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration),
//                                                                  of: audioTrack,
//                                                                  at: insertTime)
//                    }
//
//                    // Add instruction for video track
//                    let layerInstruction = videoCompositionInstructionForTrack(track: videoCompositionTrack!,
//                                                                               asset: videoAsset,
//                                                                               standardSize: outputSize,
//                                                                               atTime: insertTime)
//
//                    // Hide video track before changing to new track
//                    let endTime = CMTimeAdd(insertTime, duration)
//                    let timeScale = videoAsset.duration.timescale
//                    let durationAnimation = CMTime.init(seconds: 1, preferredTimescale: timeScale)
//
//                    layerInstruction.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: CMTimeRange.init(start: endTime, duration: durationAnimation))
//
//                    arrayLayerInstructions.append(layerInstruction)
//
//                    // Increase the insert time
//                    insertTime = CMTimeAdd(insertTime, duration)
//                }
//                catch {
//                    print("Load track error")
//                }
//            }
//            else { // Image
//                let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
//                                                                           preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
//
//                let itemDuration = CMTime.init(seconds:imageDuration, preferredTimescale: bgVideoAsset.duration.timescale)
//
//                do {
//                    try videoCompositionTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: itemDuration),
//                                                              of: bgVideoTrack!,
//                                                              at: insertTime)
//                }
//                catch {
//                    print("Load background track error")
//                }
//
//                // Create Image layer
//                guard let image = videoData.image else { continue }
//
//                let imageLayer = CALayer()
//                imageLayer.frame = CGRect.init(origin: CGPoint.zero, size: outputSize)
//                imageLayer.contents = image.cgImage
//                imageLayer.opacity = 0
//                imageLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
//
//                setOrientation(image: image, onLayer: imageLayer, outputSize: outputSize)
//
//                // Add Fade in & Fade out animation
//                let fadeInAnimation = CABasicAnimation.init(keyPath: "opacity")
//                fadeInAnimation.duration = 1
//                fadeInAnimation.fromValue = NSNumber(value: 0)
//                fadeInAnimation.toValue = NSNumber(value: 1)
//                fadeInAnimation.isRemovedOnCompletion = false
//                fadeInAnimation.beginTime = insertTime.seconds == 0 ? 0.05: insertTime.seconds
//                fadeInAnimation.fillMode = CAMediaTimingFillMode.forwards
//                imageLayer.add(fadeInAnimation, forKey: "opacityIN")
//
//                let fadeOutAnimation = CABasicAnimation.init(keyPath: "opacity")
//                fadeOutAnimation.duration = 1
//                fadeOutAnimation.fromValue = NSNumber(value: 1)
//                fadeOutAnimation.toValue = NSNumber(value: 0)
//                fadeOutAnimation.isRemovedOnCompletion = false
//                fadeOutAnimation.beginTime = CMTimeAdd(insertTime, itemDuration).seconds
//                fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards
//                imageLayer.add(fadeOutAnimation, forKey: "opacityOUT")
//
//                arrayLayerImages.append(imageLayer)
//
//                // Increase the insert time
//                insertTime = CMTimeAdd(insertTime, itemDuration)
//            }
//        }
//
//        // Main video composition instruction
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: insertTime)
//        mainInstruction.layerInstructions = arrayLayerInstructions
//
//        // Init Video layer
//        let videoLayer = CALayer()
//        videoLayer.frame = CGRect.init(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
//
//        let parentlayer = CALayer()
//        parentlayer.frame = CGRect.init(x: 0, y: 0, width: outputSize.width, height: outputSize.height)
//
//        parentlayer.addSublayer(videoLayer)
//
//        // Add Image layers
//        for layer in arrayLayerImages {
//            parentlayer.addSublayer(layer)
//        }
//
//        // Add Text layer
//        if let textData = textData {
//            for aTextData in textData {
//                let textLayer = makeTextLayer(string: aTextData.text, fontSize: aTextData.fontSize, textColor: UIColor.green, frame: aTextData.textFrame, showTime: aTextData.showTime, hideTime: aTextData.endTime)
//
//                parentlayer.addSublayer(textLayer)
//            }
//        }
//
//        // Main video composition
//        let mainComposition = AVMutableVideoComposition()
//        mainComposition.instructions = [mainInstruction]
//        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//        mainComposition.renderSize = outputSize
//        mainComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentlayer)
//
//        // Export to file
//        let path = NSTemporaryDirectory().appending("mergedVideo.mp4")
//        let exportURL = URL.init(fileURLWithPath: path)
//
//        // Remove file if existed
//        FileManager.default.removeItemIfExisted(exportURL)
//
//        let exporter = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
//        exporter?.outputURL = exportURL
//        exporter?.outputFileType = AVFileType.mp4
//        exporter?.shouldOptimizeForNetworkUse = true
//        exporter?.videoComposition = mainComposition
//
//        // Do export
//        exporter?.exportAsynchronously(completionHandler: {
//            DispatchQueue.main.async {
//                self.exportDidFinish(exporter: exporter, videoURL: exportURL, completion: completion)
//            }
//        })
//    }
//}
//
//// MARK:- Private methods
//extension HTSVideoManager {
//    fileprivate func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
//        var assetOrientation = UIImage.Orientation.up
//        var isPortrait = false
//        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
//            assetOrientation = .right
//            isPortrait = true
//        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
//            assetOrientation = .left
//            isPortrait = true
//        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
//            assetOrientation = .up
//        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
//            assetOrientation = .down
//        }
//        return (assetOrientation, isPortrait)
//    }
//
//    fileprivate func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset, standardSize:CGSize, atTime: CMTime) -> AVMutableVideoCompositionLayerInstruction {
//        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
//        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
//
//        let transform = assetTrack.preferredTransform
//        let assetInfo = orientationFromTransform(transform: transform)
//
//        var aspectFillRatio:CGFloat = 1
//        if assetTrack.naturalSize.height < assetTrack.naturalSize.width {
//            aspectFillRatio = standardSize.height / assetTrack.naturalSize.height
//        }
//        else {
//            aspectFillRatio = standardSize.width / assetTrack.naturalSize.width
//        }
//
//        if assetInfo.isPortrait {
//            let scaleFactor = CGAffineTransform(scaleX: aspectFillRatio, y: aspectFillRatio)
//
//            let posX = standardSize.width/2 - (assetTrack.naturalSize.height * aspectFillRatio)/2
//            let posY = standardSize.height/2 - (assetTrack.naturalSize.width * aspectFillRatio)/2
//            let moveFactor = CGAffineTransform(translationX: posX, y: posY)
//
//            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(moveFactor), at: atTime)
//
//        } else {
//            let scaleFactor = CGAffineTransform(scaleX: aspectFillRatio, y: aspectFillRatio)
//
//            let posX = standardSize.width/2 - (assetTrack.naturalSize.width * aspectFillRatio)/2
//            let posY = standardSize.height/2 - (assetTrack.naturalSize.height * aspectFillRatio)/2
//            let moveFactor = CGAffineTransform(translationX: posX, y: posY)
//
//            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(moveFactor)
//
//            if assetInfo.orientation == .down {
//                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                concat = fixUpsideDown.concatenating(scaleFactor).concatenating(moveFactor)
//            }
//
//            instruction.setTransform(concat, at: atTime)
//        }
//        return instruction
//    }
//
//    fileprivate func setOrientation(image:UIImage?, onLayer:CALayer, outputSize:CGSize) -> Void {
//        guard let image = image else { return }
//
//        if image.imageOrientation == UIImage.Orientation.up {
//            // Do nothing
//        }
//        else if image.imageOrientation == UIImage.Orientation.left {
//            let rotate = CGAffineTransform(rotationAngle: .pi/2)
//            onLayer.setAffineTransform(rotate)
//        }
//        else if image.imageOrientation == UIImage.Orientation.down {
//            let rotate = CGAffineTransform(rotationAngle: .pi)
//            onLayer.setAffineTransform(rotate)
//        }
//        else if image.imageOrientation == UIImage.Orientation.right {
//            let rotate = CGAffineTransform(rotationAngle: -.pi/2)
//            onLayer.setAffineTransform(rotate)
//        }
//    }
//
//    fileprivate func exportDidFinish(exporter:AVAssetExportSession?, videoURL:URL, completion:@escaping Completion) -> Void {
//        if exporter?.status == AVAssetExportSession.Status.completed {
//            print("Exported file: \(videoURL.absoluteString)")
//            completion(videoURL,nil)
//        }
//        else if exporter?.status == AVAssetExportSession.Status.failed {
//            completion(videoURL,exporter?.error)
//        }
//    }
//
//    fileprivate func makeTextLayer(string:String, fontSize:CGFloat, textColor:UIColor, frame:CGRect, showTime:CGFloat, hideTime:CGFloat) -> CXETextLayer {
//        let textLayer = CXETextLayer()
//        textLayer.string = string
//        textLayer.fontSize = fontSize
//        textLayer.foregroundColor = textColor.cgColor
//        textLayer.alignmentMode = CATextLayerAlignmentMode.center
//        textLayer.opacity = 0
//        textLayer.frame = frame
//
//
//        let fadeInAnimation = CABasicAnimation.init(keyPath: "opacity")
//        fadeInAnimation.duration = 0.5
//        fadeInAnimation.fromValue = NSNumber(value: 0)
//        fadeInAnimation.toValue = NSNumber(value: 1)
//        fadeInAnimation.isRemovedOnCompletion = false
//        fadeInAnimation.beginTime = CFTimeInterval(showTime)
//        fadeInAnimation.fillMode = CAMediaTimingFillMode.forwards
//
//        textLayer.add(fadeInAnimation, forKey: "textOpacityIN")
//
//        if hideTime > 0 {
//            let fadeOutAnimation = CABasicAnimation.init(keyPath: "opacity")
//            fadeOutAnimation.duration = 1
//            fadeOutAnimation.fromValue = NSNumber(value: 1)
//            fadeOutAnimation.toValue = NSNumber(value: 0)
//            fadeOutAnimation.isRemovedOnCompletion = false
//            fadeOutAnimation.beginTime = CFTimeInterval(hideTime)
//            fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards
//
//            textLayer.add(fadeOutAnimation, forKey: "textOpacityOUT")
//        }
//
//        return textLayer
//    }
//}
//
//class CXETextLayer : CATextLayer {
//
//    override init() {
//        super.init()
//    }
//
//    override init(layer: Any) {
//        super.init(layer: layer)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(layer: aDecoder)
//    }
//
//    override func draw(in ctx: CGContext) {
//        let height = self.bounds.size.height
//        let fontSize = self.fontSize
//        let yDiff = (height-fontSize)/2 - fontSize/10
//
//        ctx.saveGState()
//        ctx.translateBy(x: 0.0, y: yDiff)
//        super.draw(in: ctx)
//        ctx.restoreGState()
//    }
//}
//
//extension FileManager {
//    func removeItemIfExisted(_ url:URL) -> Void {
//        if FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.removeItem(atPath: url.path)
//            }
//            catch {
//                print("Failed to delete file")
//            }
//        }
//    }
//
//
//
//    import Foundation
    import AVKit

    extension AVMutableComposition {
        
        func mergeVideo(_ urls: [URL], completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(nil, nil)
                return
            }
            
            let outputURL = documentDirectory.appendingPathComponent("mergedVideo_\(Date().timeIntervalSince1970).mp4")
            
            // If there is only one video, we dont to touch it to save export time.
            if let url = urls.first, urls.count == 1 {
                do {
                    try FileManager().copyItem(at: url, to: outputURL)
                    completion(outputURL, nil)
                } catch let error {
                    completion(nil, error)
                }
                return
            }
            
            let maxRenderSize = CGSize(width: 1280.0, height: 720.0)
            var currentTime = CMTime.zero
            var renderSize = CGSize.zero
            // Create empty Layer Instructions, that we will be passing to Video Composition and finally to Exporter.
            var instructions = [AVMutableVideoCompositionInstruction]()
            
            urls.enumerated().forEach { index, url in
                let asset = AVAsset(url: url)
                let assetTrack = asset.tracks.first!
                
                // Create instruction for a video and append it to array.
                let instruction = AVMutableComposition.instruction(assetTrack, asset: asset, time: currentTime, duration: assetTrack.timeRange.duration, maxRenderSize: maxRenderSize)
                instructions.append(instruction.videoCompositionInstruction)
                
                // Set render size (orientation) according first video.
                if index == 0 {
                    renderSize = instruction.isPortrait ? CGSize(width: maxRenderSize.height, height: maxRenderSize.width) : CGSize(width: maxRenderSize.width, height: maxRenderSize.height)
                }
                
                do {
                    let timeRange = CMTimeRangeMake(start: .zero, duration: assetTrack.timeRange.duration)
                    // Insert video to Mutable Composition at right time.
                    try insertTimeRange(timeRange, of: asset, at: currentTime)
                    currentTime = CMTimeAdd(currentTime, assetTrack.timeRange.duration)
                } catch let error {
                    completion(nil, error)
                }
            }
            
            // Create Video Composition and pass Layer Instructions to it.
            let videoComposition = AVMutableVideoComposition()
            videoComposition.instructions = instructions
            // Do not forget to set frame duration and render size. It will crash if you dont.
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComposition.renderSize = renderSize
            
            guard let exporter = AVAssetExportSession(asset: self, presetName: AVAssetExportPreset1280x720) else {
                completion(nil, nil)
                return
            }
            exporter.outputURL = outputURL
            exporter.outputFileType = .mp4
            // Pass Video Composition to the Exporter.
            exporter.videoComposition = videoComposition
            
            exporter.exportAsynchronously {
                DispatchQueue.main.async {
                    completion(exporter.outputURL, nil)
                }
            }
        }
        
        static func instruction(_ assetTrack: AVAssetTrack, asset: AVAsset, time: CMTime, duration: CMTime, maxRenderSize: CGSize)
            -> (videoCompositionInstruction: AVMutableVideoCompositionInstruction, isPortrait: Bool) {
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: assetTrack)
                
                // Find out orientation from preffered transform.
                let assetInfo = orientationFromTransform(assetTrack.preferredTransform)
                
                // Calculate scale ratio according orientation.
                var scaleRatio = maxRenderSize.width / assetTrack.naturalSize.width
                if assetInfo.isPortrait {
                    scaleRatio = maxRenderSize.height / assetTrack.naturalSize.height
                }
                
                // Set correct transform.
                var transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
                transform = assetTrack.preferredTransform.concatenating(transform)
                layerInstruction.setTransform(transform, at: .zero)
                
                // Create Composition Instruction and pass Layer Instruction to it.
                let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
                videoCompositionInstruction.timeRange = CMTimeRangeMake(start: time, duration: duration)
                videoCompositionInstruction.layerInstructions = [layerInstruction]
                
                return (videoCompositionInstruction, assetInfo.isPortrait)
        }
        
        static func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
            var assetOrientation = UIImage.Orientation.up
            var isPortrait = false
            
            switch [transform.a, transform.b, transform.c, transform.d] {
            case [0.0, 1.0, -1.0, 0.0]:
                assetOrientation = .right
                isPortrait = true
                
            case [0.0, -1.0, 1.0, 0.0]:
                assetOrientation = .left
                isPortrait = true
                
            case [1.0, 0.0, 0.0, 1.0]:
                assetOrientation = .up
                
            case [-1.0, 0.0, 0.0, -1.0]:
                assetOrientation = .down
                
            default:
                break
            }
            
            return (assetOrientation, isPortrait)
        }
        
}
