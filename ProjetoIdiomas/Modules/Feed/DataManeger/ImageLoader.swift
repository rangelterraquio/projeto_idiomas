//
//  ImageLoader.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 18/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

//let imageCache = NSCache<NSString, AnyObject>()


//extension UIImageView{
//    
//    func loadImagefromURL(from url: String, handler: @escaping () -> ()){
//        
//        self.image = nil
//        
//        if let cachedImage = imageCache.object(forKey: url as NSString) as? UIImage {
//            self.image = cachedImage
//            return
//        }
//        
//        
//        let urlPath = URL(string: url)
//        
//        URLSession.shared.dataTask(with: urlPath!) { (dataImage, response, error) in
//            if error != nil {
//                print(error as Any)
//                DispatchQueue.main.async {
//                        handler()
//                        self.image = UIImage(named: "blankProfile")
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                if let imageDownloaded = UIImage(data: dataImage!){
//                    handler()
//                    self.image = imageDownloaded
//                    imageCache.setObject(imageDownloaded, forKey: url as NSString)
//                }
//            }
//            
//            
//            
//        }.resume()
//        
//    }
//    
//}



class ImageLoader{
    private let imageCache = NSCache<NSString, AnyObject>()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    
    func loadImgage(url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID?{
       
        guard let newURL = url else {
            completion(.failure(.operationFailed))
            return nil
        }
        
        
        if let imageCache = imageCache.object(forKey: newURL as NSString) as? UIImage {
            completion(.success(imageCache))
            return nil
        }
        
        let uuid = UUID()
        
        let urlPath = URL(string: newURL)
        
        let taks = URLSession.shared.dataTask(with: urlPath!) { data, response, error in
            //aqui eu garanto que vou remover a task do meu array antes dela terminar
            defer {self.runningRequests.removeValue(forKey: uuid)}
            
            if error != nil {
                completion(.failure(.internetError))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.operationFailed))
                return
            }
            self.imageCache.setObject(image, forKey: newURL as NSString)
            completion(.success(image))
            
        }
        taks.resume()
        ///add a taks no meu array de tasks rodando
        runningRequests[uuid] = taks
        return uuid
        
    }
    
   
    
    func removeImagefromCache(url: String){
        print("A url do parametro : \(url)")
        
        
        
        imageCache.removeAllObjects()
    }
    
    func cancelLoadRequest(uuid: UUID){
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
