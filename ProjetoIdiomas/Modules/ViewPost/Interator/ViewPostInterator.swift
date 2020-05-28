//
//  ViewPostInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 27/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
class ViewPostInterator: ViewPostPresenterToInterator {
   
    var stateController: StateController!
    var presenter: ViewPostInteratorToPresenter? = nil
    init(stateController: StateController) {
        self.stateController = stateController
        
        
    }
    
    
    func createComent(comment: String) {
        
    }
    
    
    public func requestImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        stateController.imageLoader.loadImgage(url: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        stateController.imageLoader.cancelLoadRequest(uuid: token)
    }
    
    
    public func requestUpdateVotes<T : DocumentSerializable >(from: String, inDocument: T) {
        stateController.updateVotes(from: from, inDocument: inDocument)
    }
    
    func validadeComment(text: String?) {
        presenter?.commentValidated(isValid: !text.isEmpty)
    }
    
}
