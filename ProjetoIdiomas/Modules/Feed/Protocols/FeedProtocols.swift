//
//  Protocos.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

public protocol FeedInteratorToPresenter: class {
    func fechedPosts(posts: [Post])
    func fecthPostsFailed()
    func fetchedImageProfile(image: UIImage)
}
public protocol FeedPresenterToInterator: class {
    func fechePosts(in languages: [Languages], from date: Date)
    func requestImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func requestUpdateVotes<T: DocumentSerializable>(from: String, inDocument: T)

}
public protocol FeedPresenterToView: class{
    func showPosts(posts: [Post])
    func showError()
}

public protocol FeedViewToPresenter: class{
    func updateFeed(in languages: [Languages], from date: Date)
    func requestProfileImage(from url: String, completion:  @escaping  (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelImageRequest(uuid token: UUID)
    func updateVotes<T: DocumentSerializable>(from: String, inDocument: T)
}

extension FeedPresenterToInterator{
    func fechePosts(in languages: [Languages], from date: Date){}
}
/*

 protocol PresenterToViewProtocol: class {
     func showNews(news: LiveNewsModel)
     func showError()
 }

 protocol InteractorToPresenterProtocol: class {
     func liveNewsFetched(news: LiveNewsModel)
     func liveNewsFetchedFailed()
 }

 protocol PresentorToInteractorProtocol: class {
     var presenter: InteractorToPresenterProtocol? {get set}
     func fetchLiveNews()
 }

 protocol ViewToPresenterProtocol: class {
     var view: PresenterToViewProtocol? {get set}
     var interactor: PresentorToInteractorProtocol? {get set}
     var router: PresenterToRouterProtocol? {get set}
     func updateView()
 }

 protocol PresenterToRouterProtocol: class {
     static func createModule() -> UIViewController
 }

 */
