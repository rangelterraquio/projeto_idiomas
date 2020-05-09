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
    
    ///se eu coloco weak aqui ele morre
    var interator: FeedPresenterToInterator? = nil
    
    
 
    
    public func updateFeed(in languages: [Languages], from date: Date){
        interator?.fechePosts(in: languages, from: date)
    }
    
    
    
    public func requestProfileImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        interator?.requestImage(from: url, completion: completion)
    }
    
    public func cancelImageRequest(uuid token: UUID) {
        interator?.cancelImageRequest(uuid: token)
    }
    
    public func updateVotes(from: String, inPost: Post) {
        interator?.requestUpdateVotes(from: from,inPost: inPost)
    }
    
    
}


extension FeedPresenter: FeedInteratorToPresenter{
    public func fetchedImageProfile(image: UIImage) {
        print("")
    }
    
    public func fechedPosts(posts: [Post]) {
        //aqui eu devo configurar o dado (exemplo: ordenar) para mandar a view apresentar
        
        view?.showPosts(posts: posts)
    }
    
    public func fecthPostsFailed() {
        //aqui eu falo pra view que deu error em carregar os dados e mostrar uma msg de erroo
        view?.showError()
    }
    
    
    
    
    
    
    
    
}
