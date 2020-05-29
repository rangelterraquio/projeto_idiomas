//
//  ViewPostProtocols.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 11/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//


import Foundation
import UIKit
//  var presenter: FeedInteratorToPresenter
public protocol ViewPostInteratorToPresenter: class{
    
    func createCommentSuccessefull(comment: Comment)-> Void
    func createCommentFailed(error msg: String) -> Void
    func fetchCommentSuccessefull(comments: [Comment])-> Void
    func fetcheCommentFailed(error msg: String) -> Void
    func commentValidated(isValid: Bool)-> Void
}

public protocol ViewPostPresenterToView: class{
    
    func commentCreated(comment: Comment) -> Void
    func commentValidated(isValid: Bool)-> Void
    func showAlertError(error msg: String) -> Void
    func showComments(comments: [Comment])-> Void 
}
public protocol ViewPostPresenterToInterator: class{
   func requestImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID?
   func cancelImageRequest(uuid token: UUID)
   func requestUpdateVotes<T: DocumentSerializable>(from: String, inDocument: T,  with comment: Comment?)
   func createComent(comment: String, postID: String) -> Void
   func validadeComment(text: String?) ->Void
   func fetchCommments(in post: Post, startingBy num: Int32)
}

public protocol ViewPostViewToPresenter: class {
    func createComent(comment: String, postID: String) -> Void
    func requestProfileImage(from url: String?, completion:  @escaping  (Result<UIImage, CustomError>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func validadeComment(text: String?) ->Void
    func updateVotes<T: DocumentSerializable>(from: String, inDocument: T, with comment: Comment?)
    func finishViewPostSession()
    func updateFeed(from post: Post, startingBy votesNum: Int32)
}


public protocol ViewPostPresenterToRouter{
    func finishedViewPostOperation()
    //func showErrorAlert(error: String)
}
