//
//  CreatePostCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit

protocol CreatePostDelegate:class {
    func createPostFinished(coordinator: Coordinator)
}
class CreatePostCoordinator: Coordinator {
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var tabBarController: UITabBarController!
    
    weak var delegate: CreatePostDelegate? = nil
    
    init(stateController: StateController, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.stateManeger = stateController
    }
    
    
    func start() -> UIViewController{
        let vc = CreatePostViewController(nibName: "CreatePostViewController", bundle: nil)
        let postPresente = CreatePostPresenter()
        let postInterator = CreatePostInterator(stateController: stateManeger)
        postPresente.interator = postInterator
        postPresente.view = vc
        postPresente.router = self
        vc.presenter = postPresente
        postInterator.presenter = postPresente
       return vc
                                                            //modo de apresentação
//         vc.modalPresentationStyle = .overCurrentContext
//        if let oldVc = tabBarController.viewControllers?.first as? UINavigationController{
//            oldVc.definesPresentationContext = true
//            oldVc.title = "Create Post"
//            oldVc.pushViewController(vc, animated: true)
//        }
//        guard let topViewController = navigationController.topViewController else {
//            return navigationController.setViewControllers([vc], animated: false)
//        }
//
//        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
//            self.navigationController.setViewControllers([vc], animated: false)
//
//        }
        
    }
    
    
    
}

extension CreatePostCoordinator: CreatePostPresenterToRouter{
    func createPostFinished() {
        delegate?.createPostFinished(coordinator: self)
    }
}
