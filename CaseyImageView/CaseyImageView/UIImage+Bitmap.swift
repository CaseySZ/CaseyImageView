//
//  UIImage+Bitmap.swift
//  CaseyImageView
//
//  Created by Casey on 22/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//


import UIKit
import CoreGraphics
import CoreFoundation
import CommonCrypto

public extension Data {
    
    public func bitmapImageDataFormat() -> UIImage? {
        
        
        if let image = UIImage.init(data: self){
            
            return image.bitmapFormat()
        }
        
        return nil
    }
}





public extension UIImage {
    
    
    public func bitmapFormat() -> UIImage? {
        
      
        if let cgImage = self.cgImage{
            
            let colorSpace = cgImage.colorSpaceBitmap()
            let context =  CGContext.init(data: nil, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGImageByteOrderInfo.orderDefault.rawValue)
            
            context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
            if let bitmapOfCGImage =  context?.makeImage(){
                
                return UIImage.init(cgImage: bitmapOfCGImage)
                
            }else {
                print("CaseyImageView 解码失败, 请检查图片底层格式")
            }
        }
        return self
    }
    
    func shouldDecodeImage() -> Bool {
        
        if self.images != nil {
            return false
        }
        
        if let imageRef = self.cgImage{
            
            let alpha = imageRef.alphaInfo
            let anyAlpha =  (alpha == CGImageAlphaInfo.first || alpha == CGImageAlphaInfo.last || alpha == CGImageAlphaInfo.premultipliedFirst || alpha == CGImageAlphaInfo.premultipliedLast)
            if anyAlpha {
                return false
            }
        }
        return true
    }
    
}

extension CGImage {
    
    func colorSpaceBitmap() -> CGColorSpace {
        
        
        if let imageColorSpaceModel =  self.colorSpace?.model {
            
          let unsupportedColorSpace =   ( imageColorSpaceModel == .unknown ||
                imageColorSpaceModel == .monochrome ||
                imageColorSpaceModel == .cmyk ||
                imageColorSpaceModel == .indexed )
                
            if unsupportedColorSpace {
                
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                
                return colorSpace
            }
            
        }
        
        if let colorSpace = self.colorSpace {
    
            return colorSpace
            
        }else{
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            return colorSpace
        }
        
        
        
       
    }
    
    
}


