//
//  UIImageView+FaceDetect.swift
//  ABCLaboratory
//
//  Created by HanSJin on 03/06/2019.
//  Copyright © 2019 ABC Studio. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - Extension UIImageView for the FaceCrop

public enum FaceDetectError: Error {
    case wrongUrl
    case imageNotFound
    case detectorInitialFail
    case noFace
}

public extension UIImageView {
    
    private var FaceCropLayerName: String {
        return "FaceCropLayer"
    }
    
    private var GOLDEN_RATIO: CGFloat {
        return 0.618
    }
    
    private var imageLayer: CALayer {
        if let sublayers = self.layer.sublayers {
            for layer: CALayer in sublayers {
                if layer.name == FaceCropLayerName {
                    return layer
                }
            }
        }
        
        let layer = CALayer()
        layer.name = FaceCropLayerName
        layer.actions = [
            "contents": NSNull(),
            "bounds": NSNull(),
            "position": NSNull()
        ]
        self.layer.addSublayer(layer)
        return layer
    }
    
    func setFaceImage(with url: URL?, fast: Bool = true, completion: ((Result<[AnyObject], FaceDetectError>) -> Void)? = nil) {
        guard let url = url else {
            completion?(.failure(.wrongUrl))
            return
        }
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { [weak self] image, error, _, _ in
            self?.setFaceImage(image, fast: fast, completion: completion)
        }
    }
    
    func setFaceImage(_ image: UIImage?, fast: Bool = true, completion: ((Result<[AnyObject], FaceDetectError>) -> Void)? = nil) {
        guard let image = image else {
            completion?(.failure(.imageNotFound))
            return
        }
        let resourceImage: CIImage
        if let ciImage = image.ciImage {
            resourceImage = ciImage
        } else if let cgImage = image.cgImage {
            resourceImage = CIImage(cgImage: cgImage)
        } else {
            completion?(.failure(.imageNotFound))
            return
        }
        guard let detector = makeDetector(fast: fast) else {
            completion?(.failure(.detectorInitialFail))
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let features: [AnyObject] = detector.features(in: resourceImage)
            
            if features.count > 0 {
                let imgSize = CGSize(width: image.size.width, height: image.size.height)
                DispatchQueue.main.async { [weak self] in
                    self?.markAfterFaceDetect(features: features, image: image, size: imgSize)
                }
                completion?(.success(features))
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.imageLayer.removeFromSuperlayer()
                    self?.image = image
                }
                completion?(.failure(.noFace))
            }
        }
    }
    
    private func makeDetector(fast: Bool) -> CIDetector? {
        let opts = [(fast ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh): CIDetectorAccuracy]
        return CIDetector(ofType: CIDetectorTypeFace, context: nil, options: opts)
    }
    
    private func markAfterFaceDetect(features: [AnyObject], image: UIImage?, size: CGSize) {
        var fixedRect = CGRect(x: Double(MAXFLOAT), y: Double(MAXFLOAT), width: 0, height: 0)
        var rightBorder:Double = 0, bottomBorder: Double = 0
        for f: AnyObject in features {
            var oneRect = CGRect(x: f.bounds.origin.x, y: f.bounds.origin.y, width: f.bounds.size.width, height: f.bounds.size.height)
            oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height
            
            fixedRect.origin.x = min(oneRect.origin.x, fixedRect.origin.x)
            fixedRect.origin.y = min(oneRect.origin.y, fixedRect.origin.y)
            
            rightBorder = max(Double(oneRect.origin.x) + Double(oneRect.size.width), rightBorder)
            bottomBorder = max(Double(oneRect.origin.y) + Double(oneRect.size.height), bottomBorder)
        }
        
        fixedRect.size.width = CGFloat(Int(rightBorder) - Int(fixedRect.origin.x))
        fixedRect.size.height = CGFloat(Int(bottomBorder) - Int(fixedRect.origin.y))
        
        var fixedCenter: CGPoint = CGPoint(x: fixedRect.origin.x + fixedRect.size.width / 2.0,
                                           y: fixedRect.origin.y + fixedRect.size.height / 2.0)
        var offset: CGPoint = CGPoint.zero
        var finalSize: CGSize = size
        
        if size.width / size.height > self.bounds.size.width / self.bounds.size.height {
            //move horizonal
            finalSize.height = self.bounds.size.height
            finalSize.width = size.width/size.height * finalSize.height
            fixedCenter.x = finalSize.width / size.width * fixedCenter.x
            fixedCenter.y = finalSize.width / size.width * fixedCenter.y
            
            offset.x = fixedCenter.x - self.bounds.size.width * 0.5
            if (offset.x < 0) {
                offset.x = 0
            } else if (offset.x + self.bounds.size.width > finalSize.width) {
                offset.x = finalSize.width - self.bounds.size.width
            }
            offset.x = -offset.x
        } else {
            //move vertical
            finalSize.width = self.bounds.size.width
            finalSize.height = size.height/size.width * finalSize.width
            fixedCenter.x = finalSize.width / size.width * fixedCenter.x
            fixedCenter.y = finalSize.width / size.width * fixedCenter.y
            
            offset.y = CGFloat(fixedCenter.y - self.bounds.size.height * CGFloat(1 - GOLDEN_RATIO))
            if (offset.y < 0) {
                offset.y = 0
            } else if (offset.y + self.bounds.size.height > finalSize.height) {
                offset.y = finalSize.height - self.bounds.size.height
            }
            offset.y = -offset.y
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.imageLayer.frame = CGRect(x: offset.x, y: offset.y, width: finalSize.width, height: finalSize.height)
            self?.imageLayer.contents = image?.cgImage
        }
    }
}
