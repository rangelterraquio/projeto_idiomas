//
//  FeedCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
public protocol FeedCoordinatorDelegate: class{
    func chooseCreatePostView()
    func chooseViewPostDetails(post: Post,imageProfile: UIImage?)
}

class FeedCoordinator: Coordinator {
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var navigationController: UINavigationController!
    
    weak var delegate: FeedCoordinatorDelegate? = nil
    
    init(stateController: StateController, navitagtion: UINavigationController) {
        self.navigationController = navitagtion
        self.stateManeger = stateController
    }
    
    
    func start(){
        let interator = FeedInterator(stateController: stateManeger)
        let presenter = FeedPresenter()
        presenter.interator = interator
        interator.presenter = presenter
        let vc = FeedViewController(nibName: "FeedViewController", bundle: nil)
        vc.presenter = presenter
        vc.modalPresentationStyle = .fullScreen
        presenter.view = vc
        presenter.router = self
        
        guard let topViewController = navigationController.topViewController else {
            return navigationController.setViewControllers([vc], animated: false)
        }
        
        UIView.transition(from:topViewController.view, to: vc.view, duration: 0.50, options: .transitionCrossDissolve) {[unowned self] (_) in
            self.navigationController.setViewControllers([vc], animated: false)
           
        }
        
    }
    
    
    
}


extension FeedCoordinator: FeedPresenterToRouter{
    
    
    func addPostView() {
        //criar o coordinator do view post
        delegate?.chooseCreatePostView()
    }
    
    func viewPostWithDetails(post: Post,imageProfile: UIImage?) {
        // criar o coordinator do
        delegate?.chooseViewPostDetails(post: post, imageProfile: imageProfile)
    }
    
    
}



