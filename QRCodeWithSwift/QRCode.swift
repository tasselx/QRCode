//
//  QRCode.swift
//  QRCodeWithIcon
//
//  Created by Tassel on 15/9/23.
//  Copyright © 2015年 Tassel. All rights reserved.
//

import UIKit


public struct QRCode {
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
    }
    
    /// CIQRCodeGenerator generates 27x27px images per default
    private let DefaultQRCodeSize = CGSize(width: 27, height: 27)
    
    /// Data contained in the generated QRCode
    public let data: NSData
    
    /// Foreground color of the output
    /// Defaults to black
    public var color = CIColor(red: 0.1, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.Low
    
    /// Center icon image
    public var iconImage:UIImage?
    
    ///Center icon radius
    public var iconRadius:CGFloat = 0
    
    ///Center icon border color
    
    public var iconBorderColor = UIColor.white
    
    ///Center icon border width
    public var iconBorderWidth:CGFloat = 0
    
    
    // MARK: Init
    
    public init(_ data: NSData) {
        self.data = data
    }
    
    public init?(_ string: String) {
        
        if let data = string.data(using: .utf8) {
            self.data = data as NSData
        }else {
            return nil
        }
     
    }
    
    public init?(_ url: NSURL) {
        
        if let data = url.absoluteString?.data(using: .utf8) {
            self.data = data as NSData
        }else {
            return nil
        }
      
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage {
        
        let qrcodeImage = UIImage(ciImage: ciImage)
        
        if let icon = iconImage {
            
            UIGraphicsBeginImageContextWithOptions(qrcodeImage.size, false, qrcodeImage.scale)
            qrcodeImage.draw(in: CGRect(x: 0, y: 0, width: qrcodeImage.size.width, height: qrcodeImage.size.height))
            let roumdImage = icon.makeRoundCornersWithRadius(radius: iconRadius, borderColor: iconBorderColor, borderWidth: iconBorderWidth)
            
            roumdImage.draw(in: CGRect(x: (qrcodeImage.size.width-icon.size.width)*0.5, y: (qrcodeImage.size.height-icon.size.height)*0.5, width: icon.size.width, height: icon.size.height))
         
            let resultImage      = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage.init()
            
            UIGraphicsEndImageContext()
            return resultImage;
        }
        
        return qrcodeImage
    }
    
    /// The QRCode's CIImage representation
    public var ciImage: CIImage {
        // Generate QRCode
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(qrFilter?.outputImage, forKey: "inputImage")
        colorFilter?.setValue(color, forKey: "inputColor0")
        colorFilter?.setValue(backgroundColor, forKey: "inputColor1")
        
        // Size
        let sizeRatioX = size.width / DefaultQRCodeSize.width
        let sizeRatioY = size.height / DefaultQRCodeSize.height
        let transform = CGAffineTransform(scaleX: sizeRatioX, y: sizeRatioY)
        let transformedImage = colorFilter?.outputImage!.transformed(by: transform)
        
        return transformedImage!
    }
    
}

public extension CIColor {
    
    /// Creates a CIColor from an rgba string
    ///
    /// E.g.
    ///     `aaa`
    ///     `ff00`
    ///     `bb00ff`
    ///     `aabbccff`
    ///
    /// - parameter rgba:    The hex string to parse in rgba format
    convenience init(rgba: String) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let scanner = Scanner(string: rgba)
        var hexValue: CUnsignedLongLong = 0
        
    
        if scanner.scanHexInt64(&hexValue) {
            
            let length = rgba.count
            
            switch (length) {
            case 3:
                r = CGFloat((hexValue & 0xF00) >> 8)    / 15.0
                g = CGFloat((hexValue & 0x0F0) >> 4)    / 15.0
                b = CGFloat(hexValue & 0x00F)           / 15.0
            case 4:
                r = CGFloat((hexValue & 0xF000) >> 12)  / 15.0
                g = CGFloat((hexValue & 0x0F00) >> 8)   / 15.0
                b  = CGFloat((hexValue & 0x00F0) >> 4)  / 15.0
                a = CGFloat(hexValue & 0x000F)          / 15.0
            case 6:
                r = CGFloat((hexValue & 0xFF0000) >> 16)    / 255.0
                g = CGFloat((hexValue & 0x00FF00) >> 8)     / 255.0
                b  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                r = CGFloat((hexValue & 0xFF000000) >> 24)  / 255.0
                g = CGFloat((hexValue & 0x00FF0000) >> 16)  / 255.0
                b = CGFloat((hexValue & 0x0000FF00) >> 8)   / 255.0
                a = CGFloat(hexValue & 0x000000FF)          / 255.0
            default:
                print("Invalid number of values (\(length)) in HEX string. Make sure to enter 3, 4, 6 or 8 values. E.g. `aabbccff`")
            }
            
        } else {
            print("Invalid HEX value: \(rgba)")
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}

public extension UIImage {
    
    func makeRoundCornersWithRadius(radius:CGFloat,borderColor color:UIColor?,borderWidth width:CGFloat?)->UIImage {
        
        let image = self
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let path = UIBezierPath(roundedRect:rect, cornerRadius:radius)
        let context = UIGraphicsGetCurrentContext()
        
        // Clip the drawing area to the path
        path.addClip()
        
        context!.saveGState()
        // Draw the image into the context
        image.draw(in: rect)
        context!.restoreGState()
        
        // Configure the stroke
        color!.setStroke()
        path.lineWidth = width!
        // Stroke the border
        path.stroke()
        
        //        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        //        image.drawInRect(rect)
        
        //imageView.image
        guard let imageNew = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage.init() };
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        return imageNew
        
    }
    
}


//func randomCIColor()->CIColor {
//
//    return CIColor(red: CGFloat(arc4random() % 256) / 256.0, green: CGFloat(arc4random() % 256) / 256.0, blue: CGFloat(arc4random() % 256) / 256.0, alpha: 1)
//
//}

//class QRCode {
//
//    class func Generate(qrstring:String,icon:UIImage)->UIImage {
//
//        let stringData       = qrstring.dataUsingEncoding(NSUTF8StringEncoding)
//        let  qrFilter        = CIFilter(name:"CIQRCodeGenerator")
//        qrFilter?.setValue(stringData, forKey: "inputMessage")
//        qrFilter?.setValue("Q", forKey: "inputCorrectionLevel")
//
//        let qrImage:UIImage! = UIImage(CIImage: (qrFilter?.outputImage)!)
//        let scale            = 300.0 / qrImage.size.width
//        let scaleQRImage     = qrFilter?.outputImage?.imageByApplyingTransform(CGAffineTransformMakeScale(scale, scale))
//        let finalImage       = UIImage(CIImage: scaleQRImage!)
//
//        UIGraphicsBeginImageContextWithOptions(finalImage.size, false, finalImage.scale)
//        finalImage.drawInRect(CGRectMake(0, 0, finalImage.size.width, finalImage.size.height))
//        icon.drawInRect(CGRectMake((finalImage.size.width - icon.size.width) * 0.5, (finalImage.size.height - icon.size.height)*0.5, icon.size.width, icon.size.height))
//
//        let resultImage      = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return resultImage
//    }
//
//}

