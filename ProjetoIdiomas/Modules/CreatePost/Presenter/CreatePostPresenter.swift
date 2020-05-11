//
//  CreatePostPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 10/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

class CreatePostPresenter: CreatePostViewToPresenter {
   
    
   
    
    var interator: CreatePostPresenterToInterator!
    var view: CreatePostPresenterToView!
    
    func createPost(title: String, text: String, language: Languages?) {
        interator.createPost(title: title, text: text, language: language!)
    }
       
    func validatePost(title: String, text: String, language: Languages?) {
        if interator.postIsValid(title: title, text: text, language: language){
            view.updateDoneStatus()
        }
   }
       
}


extension CreatePostPresenter: CreatePostInteratorToPresenter{
   
    func createPostSuccessefull() {
        //Chamar o router
        print("Deu bom")
    }
    
    func createPostFailed(error msg: String) {
        view.showAlertError(error: msg)
    }
    
    
}
