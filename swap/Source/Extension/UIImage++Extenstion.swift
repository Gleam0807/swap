//
//  UIImage++Extenstion.swift
//  swap
//
//  Created by SUNG on 3/5/24.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 1)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        draw(in: newRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
}
