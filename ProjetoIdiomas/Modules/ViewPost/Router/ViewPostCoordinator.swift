//
//  ViewPostCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

import UIKit

protocol ViewPostDelegate:class {
    func viewPostFinished(coordinator: Coordinator)
}
class ViewPostCoordinator: Coordinator {
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var navigationController: UINavigationController!
    
    weak var delegate: ViewPostDelegate? = nil
    
    init(stateController: StateController, navitagtion: UINavigationController) {
        self.navigationController = navitagtion
        self.stateManeger = stateController
    }
    
    
    func start(post: Post){
        let vc = ViewPostViewController(nibName: "ViewPostViewController", bundle: nil)
        let interator = ViewPostInterator(stateController: stateManeger)
        let presenter = ViewPostPresenter()
        vc.post = post
        presenter.interator = interator
        presenter.view = vc
        interator.presenter = presenter
        presenter.router = self
        vc.presenter = presenter
        
       
        vc.modalPresentationStyle = .fullScreen //modo de apresentação
        
        guard let topViewController = navigationController.topViewController else {
            return navigationController.setViewControllers([vc], animated: false)
        }
        
        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
            self.navigationController.setViewControllers([vc], animated: false)
           
        }
        
    }
    
    
    
}

extension ViewPostCoordinator: ViewPostPresenterToRouter{
    func finishedViewPostOperation() {
        delegate?.viewPostFinished(coordinator: self)
    }
}
