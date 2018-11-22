//
//  UIImageView+loadURL.swift
//  CaseyImageView
//
//  Created by Casey on 20/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit

extension UIImageView {
    
    
    fileprivate static let __operationQueue:OperationQueue  = {
        
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 5
        return queue
        
    }()
    
    
    
    func imageWithUrl(_ urlStr:String, _ placeholder:UIImage? = nil)  {
        
        if let defalutImage = placeholder {
            self.image = defalutImage
        }
        
        self.imageURLString = urlStr
        
        let operation = ImageLoadOperation()
        operation.urlStr = urlStr
        operation.imageView = self
        UIImageView.__operationQueue.addOperation(operation)
        
        
    }
    
    
    
    var imageURLString:String? {
        
        get{
            
            let key = UnsafeRawPointer.init(bitPattern: "_simageURLString".hashValue)!
            return objc_getAssociatedObject(self, key) as? String
            
            
        }set{
            
            let key = UnsafeRawPointer.init(bitPattern: "_simageURLString".hashValue)!
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        
    }
    
}



