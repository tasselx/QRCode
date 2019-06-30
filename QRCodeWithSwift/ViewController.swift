//
//  ViewController.swift
//  QRCodeWithSwift
//
//  Created by tassel on 2019/6/30.
//  Copyright © 2019 rc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView:UIImageView?
    
    @objc func changeImageViewScale(sender:UISlider){
        
        imageView?.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 300, height: 300))
        
        imageView!.image = {
            var qrCode = QRCode("http://www.baidu.com")!
            qrCode.errorCorrection = .High
            qrCode.size = (imageView?.frame.size)!
            qrCode.color = CIColor(rgba: "f1466a")
            qrCode.backgroundColor = CIColor(rgba: "ffffff")
            qrCode.iconImage = UIImage(named: "avatar")
            qrCode.iconBorderWidth = 8
            qrCode.iconBorderColor = UIColor.white
            qrCode.iconRadius = 10
            
            return qrCode.image
        }()
        
        self.view.addSubview(imageView!)
        
        let slider = UISlider(frame: CGRect(x: 20, y: 420, width: self.view.bounds.size.width-20*2, height: 20))
        slider.value = 1
        slider.addTarget(self, action: #selector(changeImageViewScale(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        
    }
  
    
    
}

