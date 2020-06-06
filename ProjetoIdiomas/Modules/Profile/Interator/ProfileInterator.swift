//
//  ProfileInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 05/06/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit


public class ProfileInterator: ProfilePresenterToInterator{
    
    
    
   
    
    var stateController: StateController!
    var presenter: ViewActivitiesInteratorToPresenter? = nil

    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    public func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        stateController.imageLoader.loadImgage(url: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        stateController.imageLoader.cancelLoadRequest(uuid: token)
    }
    
   
    
    
    
    
    
}
