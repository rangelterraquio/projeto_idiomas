//
//  ViewPostCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit

protocol ViewPostDelegate:class {
    func viewPostFinished(coordinator: Coordinator)
}
class ViewPostCoordinator: Coordinator {
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var tabBarController: UITabBarController!
    
    weak var delegate: ViewPostDelegate? = nil
    
    init(stateController: StateController, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.stateManeger = stateController
    }
    
    
    func start(post: Post,imageProfile: UIImage?,feedVC: UIViewController?){
        let vc = ViewPostViewController(nibName: "ViewPostViewController", bundle: nil)
        let interator = ViewPostInterator(stateController: stateManeger)
        let presenter = ViewPostPresenter()
        vc.post = post
        presenter.interator = interator
        presenter.view = vc
        interator.presenter = presenter
        presenter.router = self
        vc.presenter = presenter
        vc.imageAuthor = imageProfile
        vc.modalPresentationStyle = .overCurrentContext
       
        
        
        if let feedView = feedVC as? FeedViewController{
             vc.feedVC = feedView
           
            if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
                oldVc.definesPresentationContext = true
                oldVc.title = "Post"
                oldVc.pushViewController(vc, animated: true)
            }
        }else{
            feedVC?.definesPresentationContext = true
            feedVC?.title = "Post"
            feedVC?.navigationController?.pushViewController(vc, animated: true)
        }
        
       
//        guard let topViewController = tabBarController.topViewController else {
//            return tabBarController.setViewControllers([vc], animated: false)
//        }
//        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
//            self.tabBarController.definesPresentationContext = true
//
//
//        }
        
    }
//    
//      func start(post: Post,imageProfile: UIImage?,currentView: UIViewController){
//            let vc = ViewPostViewController(nibName: "ViewPostViewController", bundle: nil)
//            let interator = ViewPostInterator(stateController: StateController(storage: StoregeAPI()))
//            let presenter = ViewPostPresenter()
//            vc.post = post
//            presenter.interator = interator
//            presenter.view = vc
//            interator.presenter = presenter
//            presenter.router = nil
//            vc.presenter = presenter
//            vc.imageAuthor = imageProfile
//            
//           
////            vc.modalPresentationStyle = .overCurrentContext
////        self.tabBarController.definesPresentationContext = true
////        self.tabBarController.pushViewController(vc, animated: true)
////        currentView.navigationController?.definesPresentationContext = true
////        currentView.navigationController?.pushViewController(vc, animated: true)
//    //        vc.definesPresentationContext = true//modo de apresentação
//            
////            guard let topViewController = navigationController.topViewController else {
////                return navigationController.setViewControllers([vc], animated: false)
////            }
////    // self.definesPresentationContext = true
////            UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
////    //            self.navigationController.setViewControllers([vc], animated: false)
////                self.navigationController.definesPresentationContext = true
////                let tab = self.navigationController.viewControllers.first! as! UITabBarController
////    //            let newVc = tab.viewControllers?.first
////    //            newVc!.definesPresentationContext = true
////    //            newVc?.present(vc, animated: true, completion: nil)
////                tab.definesPresentationContext = true
////                tab.hidesBottomBarWhenPushed = false
////                vc.hidesBottomBarWhenPushed = false
////            
////                tab.present(vc, animated: true, completion: nil)
////    //            self.navigationController.present(vc, animated: true, completion: nil)
////    //            self.navigationController.pushViewController(vc, animated: true)
////               
////            }
//            
//        }
    func start(postID: String,completio:  @escaping (UIViewController)-> ()){
        let vc = ViewPostViewController(nibName: "ViewPostViewController", bundle: nil)
        let interator = ViewPostInterator(stateController: stateManeger)
        let presenter = ViewPostPresenter()
        
        stateManeger.fetchPostBy(id: postID) { (document) in
            if let doc = document{
                if let post = Post(dictionary: doc){
                    vc.post = post
                    self.stateManeger.imageLoader.loadImgage(url: post.author.photoURL) { (result) in
                        do{
                            let image = try result.get()
                            vc.imageAuthor = image
                        }catch{
                             UIImage(named: "blankProfile")!
                        }
                    }
                    
                    
                    presenter.interator = interator
                    presenter.view = vc
                    interator.presenter = presenter
                    presenter.router = self
                    vc.presenter = presenter
                    
                    completio(vc)
//                    vc.modalPresentationStyle = .overCurrentContext
//                    if let oldVc = self.tabBarController.selectedViewController{
//                        oldVc.navigationController?.pushViewController(vc, animated: true)
//                    }
                    
//                    if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
//                        oldVc.definesPresentationContext = true
//
//                        oldVc.pushViewController(vc, animated: true)
//                    }

                }
            }
        }
        
        
    }
    
    
    func start(postID: String){
            let vc = ViewPostViewController(nibName: "ViewPostViewController", bundle: nil)
            let interator = ViewPostInterator(stateController: stateManeger)
            let presenter = ViewPostPresenter()
            
            stateManeger.fetchPostBy(id: postID) { (document) in
                if let doc = document{
                    if let post = Post(dictionary: doc){
                        vc.post = post
                        self.stateManeger.imageLoader.loadImgage(url: post.author.photoURL) { (result) in
                            do{
                                let image = try result.get()
                                vc.imageAuthor = image
                            }catch{
                                 UIImage(named: "blankProfile")!
                            }
                        }
              
                    }

                    presenter.interator = interator
                    presenter.view = vc
                    interator.presenter = presenter
                    presenter.router = self
                    vc.presenter = presenter
                    
                    if let oldVc = self.tabBarController.selectedViewController as? UINavigationController{
                        oldVc.definesPresentationContext = true
                        
                        oldVc.pushViewController(vc, animated: true)
                    }
                }
            }
            
            
        }
    
    
}

extension ViewPostCoordinator: ViewPostPresenterToRouter{
    func finishedViewPostOperation() {
        delegate?.viewPostFinished(coordinator: self)
    }
}
