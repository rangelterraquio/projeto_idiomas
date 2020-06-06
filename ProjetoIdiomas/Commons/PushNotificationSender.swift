//
//  PushNotificationSender.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 30/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

class PushNotificationSender {
    
    let authorizationToken: String = "key=AAAA2h27LAU:APA91bHSrkEtNe9QsqLtqQ9yeNQezUmYSXgdhn6g4qwOZIfihiuGp3UBGdNxkejWT8wjbbvdZjDzxOhAa5_L_ZiLNpMnCXCfLOD0Okk2PW206c5GsNvNcdeVlgdXkpmnpsdTw4yvb61m"
    func sendPushNotification(to post: Post, title: String, body: String, complition: @escaping (Bool) -> ()){
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = URL(string: urlString)!
        
        let paramString: [String : Any] = ["to" : post.author.fcmToken, "priority" : "high","notification" : ["title" : title, "body" : body, "click_action" : post.id]]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            if error != nil{
                complition(false)
            }
            complition(true)
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        print("Received data:\n\(jsonDataDict))")
                    }
                   
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
}
