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
    func chooseViewPostDetails(post: Post,imageProfile: UIImage?,vc: UIViewController)
}

class FeedCoordinator: Coordinator {
    
    
    fileprivate var stateManeger: StateController!
    fileprivate var tabBarController: UITabBarController!
    
    weak var delegate: FeedCoordinatorDelegate? = nil
    
    init(stateController: StateController, tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.stateManeger = stateController
    }
    
    
    func start() -> UIViewController{
        let interator = FeedInterator(stateController: stateManeger)
        let presenter = FeedPresenter()
        presenter.interator = interator
        interator.presenter = presenter
        let vc = FeedViewController(nibName: "FeedViewController", bundle: nil)
        vc.presenter = presenter
        vc.modalPresentationStyle = .fullScreen
        presenter.view = vc
        presenter.router = self
        
        return vc
        
    }
    
    
    
}


extension FeedCoordinator: FeedPresenterToRouter{
    
    
    func addPostView() {
        //criar o coordinator do view post
        delegate?.chooseCreatePostView()
    }
    
    func viewPostWithDetails(post: Post,imageProfile: UIImage?,vc: UIViewController) {
        // criar o coordinator do
        delegate?.chooseViewPostDetails(post: post, imageProfile: imageProfile, vc: vc)
    }
    
    
}



extension FeedCoordinator: UITabBarDelegate{
   
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            delegate?.chooseCreatePostView()
        }
    }
    
}
