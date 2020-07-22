//
//  CreatePostInterator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

class CreatePostInterator: CreatePostPresenterToInterator{
   
    
    
    var stateController: StateController!
    var presenter: CreatePostInteratorToPresenter!
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    func postIsValid(title: String, text: String, language: Languages?) -> Bool {
        if title.isEmpty || text == "What are you thinking?" || text == "" || language == nil {
            return false
        }
        return true
    }
    
    
    func createPost(title: String, text: String, language: Languages?) {
        stateController.createPost(title: title, text: text, language: language!) {[weak self] (result) in
            switch result {
            case .failure(let error):
                switch error {
                case .internetError:
                    self?.presenter.createPostFailed(error: "The phone has no Internet connection")
                case .operationFailed:
                    self?.presenter.createPostFailed(error: "Sorry, an error occurred.")
                }
            case .success(_):
                self?.presenter.createPostSuccessefull()
            }
        }
    }
    
}
