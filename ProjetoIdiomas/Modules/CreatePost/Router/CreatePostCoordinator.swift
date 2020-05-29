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
    fileprivate var navigationController: UINavigationController!
    
    weak var delegate: CreatePostDelegate? = nil
    
    init(stateController: StateController, navitagtion: UINavigationController) {
        self.navigationController = navitagtion
        self.stateManeger = stateController
    }
    
    
    func start(){
        let vc = CreatePostViewController(nibName: "CreatePostViewController", bundle: nil)
        let postPresente = CreatePostPresenter()
        let postInterator = CreatePostInterator(stateController: stateManeger)
        postPresente.interator = postInterator
        postPresente.view = vc
        postPresente.router = self
        vc.presenter = postPresente
        postInterator.presenter = postPresente
       
        vc.modalPresentationStyle = .fullScreen //modo de apresentação
        
        guard let topViewController = navigationController.topViewController else {
            return navigationController.setViewControllers([vc], animated: false)
        }
        
        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
            self.navigationController.setViewControllers([vc], animated: false)
           
        }
        
    }
    
    
    
}

extension CreatePostCoordinator: CreatePostPresenterToRouter{
    func createPostFinished() {
        delegate?.createPostFinished(coordinator: self)
    }
}
