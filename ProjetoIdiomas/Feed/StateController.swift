//
//  StateController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore

public class StateController{
    
    var storage: StoregeAPI!
    let imageLoader = ImageLoader()
    init(storage: StoregeAPI) {
        self.storage = storage
    }
    
    
    func fecthPosts(in languages: [Languages], completion: @escaping ([QueryDocumentSnapshot]?) -> ()){
        storage.fechPosts(in: languages, completion: completion)
    }
}
