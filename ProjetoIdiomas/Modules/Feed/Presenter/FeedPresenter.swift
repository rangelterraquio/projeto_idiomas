//
//  FeedPresenter.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

public class FeedPresenter : FeedViewToPresenter{
   

    
    
    var view: FeedPresenterToView? = nil
    var router: FeedPresenterToRouter? = nil
    ///se eu coloco weak aqui ele morre
    var interator: FeedPresenterToInterator? = nil
    
    
 
    
    public func updateFeed(in languages: [Languages], from date: Date){
        interator?.fechePosts(in: languages, from: date)
    }
    
    
    
    public func requestProfileImage(from url: String?, completion: @escaping (Result<UIImage, CustomError>) -> Void) -> UUID? {
        interator?.requestImage(from: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    public func updateVotes<T: DocumentSerializable>(from: String, inDocument: T, with comment: Comment?) {
        interator?.requestUpdateVotes(from: from,inDocument: inDocument, with: comment)
    }
    
    public func goToAddPostView() {
        router?.addPostView()
    }
    
    func goToViewPostDetails(post: Post,imageProfile: UIImage?,vc: FeedViewController?) {
        router?.viewPostWithDetails(post: post, imageProfile: imageProfile, vc: vc)
    }
    
    func goToProfile() {
        router?.goToProfile()
    }
    
    func reportPost(post: Post) {
        interator?.reportPost(post: post)
    }
       
       

             
}


extension FeedPresenter: FeedInteratorToPresenter{
    
    
    public func fetchedImageProfile(image: UIImage) {
        print("")
    }
    
    public func fechedPosts(posts: [Post],languages: [Languages]) {
        //aqui eu devo configurar o dado (exemplo: ordenar) para mandar a view apresentar
        var newPosts = [Post]()
        posts.forEach { (post) in
            
            languages.forEach { (lang) in
                if lang.rawValue == post.language{
                    newPosts.append(post)
                }
            }
        }
        view?.showPosts(posts: newPosts)
    }
    
    public func newPostAdded(posts: [Post]) {
        view?.updateViewWith(posts: posts)
    }
    
    public func fecthPostsFailed(fetchedAll: Bool) {
        //aqui eu falo pra view que deu error em carregar os dados e mostrar uma msg de erroo
        view?.showError(fetchedAll: fetchedAll)
    }
    
   
       
    
    
    
    
    
    
}
