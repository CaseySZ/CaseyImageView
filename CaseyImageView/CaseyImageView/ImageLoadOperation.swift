//
//  ImageOperation.swift
//  CaseyImageView
//
//  Created by Casey on 20/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit

fileprivate typealias CancelOperation = () -> Bool

class ImageLoadOperation: Operation {
    
    fileprivate static var __operationTaskInfoDict = [String:[UIImageView]]()
    fileprivate static let __taskLock = NSLock()
    fileprivate static var __imageCache:NSCache<AnyObject, AnyObject> = {
       
        let cache = NSCache<AnyObject, AnyObject>()
        
        createCacheDocument()
        
        return cache
    }()
    
    fileprivate static var cacheDoument:String = {
        
        let rootDocument = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! as NSString
        let cacheDoument = rootDocument.appendingPathComponent("CaseyCacheDocument")
        return cacheDoument
    }()
    
    
    var imageView:UIImageView?
    var urlStr:String?
    
    
    fileprivate static func createCacheDocument(){
        
        
        let newBoolPtr = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        if  FileManager.default.fileExists(atPath: ImageLoadOperation.cacheDoument, isDirectory: newBoolPtr) {
            
            if newBoolPtr.pointee.boolValue {
                
                return
               
            }else {
                
                do{
                    try FileManager.default.removeItem(atPath: ImageLoadOperation.cacheDoument)
                }catch{
                    print("Remove CacheDocument error: \(error)")
                }
                
            }
        }
        
        
            
        do{
            try FileManager.default.createDirectory(atPath: ImageLoadOperation.cacheDoument, withIntermediateDirectories: true, attributes: nil)
            let url = NSURL.init(fileURLWithPath: ImageLoadOperation.cacheDoument)
            try url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            
        }catch {
            
            print("CacheDocument error: \(error)")
        }
        
            
        
        
    }
    
    override func main() {
        
        
        
        if let imageData = getImageDataFromCache() {
            
            loadImageInMain(UIImage.init(data: imageData), self.imageView)
            return
        }
        
        
        let cancelBlock:CancelOperation = {
            
            
            var cancel = false
            if !(self.urlStr!.elementsEqual(self.imageView?.imageURLString ?? "")) {
                cancel = true
            }
            
            return cancel
        }
        
        
        //////
        
        ImageLoadOperation.__taskLock.lock()
        if var taskExist =  ImageLoadOperation.__operationTaskInfoDict[urlStr!] {
            
            taskExist.append(self.imageView!)
            ImageLoadOperation.__operationTaskInfoDict[urlStr!] = taskExist
            ImageLoadOperation.__taskLock.unlock()
            return
            
        }else {
            
            ImageLoadOperation.__operationTaskInfoDict[urlStr!] = [self.imageView!]
        }
        ImageLoadOperation.__taskLock.unlock()
        
        
        if let imageData = loadImageViewSynNet() {
        
            if  let bitmapImage = imageData.bitmapImageDataFormat() {
                
                saveImageDataToCache(image: bitmapImage)
                
                if !cancelBlock() {
                    
                    loadImageInMain(bitmapImage, self.imageView)
                }
                
                
                ImageLoadOperation.__taskLock.lock()
                let sameTask = ImageLoadOperation.__operationTaskInfoDict[urlStr!]
                
                DispatchQueue.main.async {
                    for sameTaskImageView in sameTask! {
                        if sameTaskImageView != self.imageView {
                            if self.urlStr!.elementsEqual(sameTaskImageView.imageURLString ?? "") {
                                sameTaskImageView.image = bitmapImage
                                sameTaskImageView.setNeedsDisplay()
                            }
                        }
                    }
                }
                ImageLoadOperation.__taskLock.unlock()
                
            }
        }
        
        ImageLoadOperation.__taskLock.lock()
        ImageLoadOperation.__operationTaskInfoDict[urlStr!] = nil
        ImageLoadOperation.__taskLock.unlock()
        
        
    }
    
    
    fileprivate func loadImageViewSynNet() -> Data? {
        
        let  url = URL.init(string: self.urlStr!)
        let session = URLSession.init(configuration: URLSessionConfiguration.ephemeral)
        let sem = DispatchSemaphore.init(value: 0)
        var imageData:Data?
        let task =  session.dataTask(with: URLRequest.init(url: url!)) { (data, response, error) in
            
            if let netError = error {
                
                print("imageView network: \(netError)")
                
            }else {
                
                imageData = data
            }
            
            sem.signal()
        }
        


        task.resume()
        
        sem.wait()
        
        return imageData
    }
    
    
    fileprivate func saveImageDataToCache(image:UIImage)  {
        
        let imageKey = urlStr!.encodeUrlKey()
        let cacheDoument = ImageLoadOperation.cacheDoument as NSString
        let filePath = cacheDoument.appendingPathComponent(imageKey)
        
        do{
            
            try image.pngData()?.write(to: URL.init(fileURLWithPath: filePath))
            
        }catch{
            
            print("image save cache error: \(error)")
        }
    }
    
    
    
    fileprivate func getImageDataFromCache() -> Data? {
        
        let imageKey = urlStr!.encodeUrlKey()
        
        
        if let imageData = ImageLoadOperation.__imageCache.object(forKey: imageKey as AnyObject) {
            
            return imageData as? Data
            
        }else {
            
            let cacheDoument = ImageLoadOperation.cacheDoument as NSString
            let filePath = cacheDoument.appendingPathComponent(imageKey)
            let fileData = NSData.init(contentsOfFile: filePath) as Data?
            
            
            return fileData
        }
    }
    
    
    fileprivate func loadImageInMain(_ image:UIImage?, _ imgView:UIImageView?)  {
        
        DispatchQueue.main.async {
            imgView?.image = image
        }
    }
    

}

extension String {
    
    
    func encodeUrlKey() -> String {
        
        var targetStr = self.replacingOccurrences(of: "http://", with: "")
        targetStr = targetStr.replacingOccurrences(of: "https://", with: "")
        targetStr = targetStr.replacingOccurrences(of: "/", with: "")
        if targetStr.count > 10 {
            
        }
        return targetStr
    }
    
}
