//
//  EncodedImageGenerator.swift
//  SwyftSdk
//
//  Created by Tom Manuel on 7/9/19.
//  Copyright © 2019 Swyft. All rights reserved.
//

import Foundation
import CoreImage


class SwyftImageGenerator {
    
    private static let qrCodeGen =  "CIQRCodeGenerator"
    private static let barCodeGen =  "CICode128BarcodeGenerator"
    
    static func buildQRImage(string: String, color: UIColor = UIColor.black) -> UIImage? {
        if let ciImage = buildImage(string, qrCodeGen, color){
            return UIImage(ciImage: ciImage)
        }
        return nil
    }
    
    static func buildBarcodeImage(string: String, color: UIColor = UIColor.black) -> UIImage? {
        if let ciImage = buildImage(string, barCodeGen, color) {
            return UIImage(ciImage: ciImage)
        }
        return nil
    }
    
    private static func buildImage(_ value: String, _ type: String, _ color: UIColor) -> CIImage? {
        guard let imgFilter = CIFilter(name: type) else { return nil }
        let imgData = value.data(using: String.Encoding.ascii)
        imgFilter.setValue(imgData, forKey: "inputMessage")
        
        let imgTransform = CGAffineTransform(scaleX: 24, y: 24)
        let imgImage = imgFilter.outputImage?.transformed(by: imgTransform)
        
        return imgImage?.tinted(using: color)
    }
    
}
