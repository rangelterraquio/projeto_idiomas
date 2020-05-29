//
//  AppCoordinator.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 28/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation
import UIKit
public class Coordinator {}

final class AppCoordinator: Coordinator{
    
    fileprivate let navigationController: UINavigationController!
    fileprivate var childCoordinators = [Coordinator]()
    fileprivate let storage = StoregeAPI()
    fileprivate var stateManeger: StateController!
    fileprivate let signUpAPI = SignUpAPI()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        signUpAPI.signOut()
        stateManeger = StateController(storage:storage)
    }
    
    
    func start(){
        if signUpAPI.userHasAValidSession(){
            storage.fetchUser { 
                self.showFeed()
            }
           
        }else{
            showAuthentication()
        }
    }
    
    
    
    func showFeed(){
        let coordinator = FeedCoordinator(stateController: stateManeger, navitagtion: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        let newArray = childCoordinators.filter {!($0 is SignUpCoordinator)}
        childCoordinators = newArray
    }
    
    func showAuthentication(){
        let signUpCoordinator = SignUpCoordinator(signUpAPI: signUpAPI, navitagtion: navigationController)
        signUpCoordinator.delegate = self
        signUpCoordinator.start()
        childCoordinators.append(signUpCoordinator)//adiciono no childrem para o appcoordinator nao ser desalocado
        
        
    }
    
    func showSelectLanguage(with user: User){
        let coordinator = SelectLanguagesCoordinator(user: user, navigation: navigationController)
        coordinator.delegate = self
        coordinator.stat(user: user)
        childCoordinators.append(coordinator)
    }
    
    func showCreatePost(){
        let coordinator = CreatePostCoordinator(stateController: stateManeger, navitagtion: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func showViewPostInDetails(post: Post){
        
    }
}


//MARK: -> Authetication Delegate
extension AppCoordinator: AuthenticationCoordinatorDelegate{
    
    
    func coordinatorDidAuthenticate(coordinator: SignUpCoordinator,user: User) {
        //chamar selecte language
//        removeCoordinator(coordinator: coordinator)
        showSelectLanguage(with: user)
    }
    
    
    fileprivate func removeCoordinator(coordinator:Coordinator) {
        let newArray = childCoordinators.filter {$0 !== coordinator}
        childCoordinators = newArray
    }
    
}
//MARK: -> Select Language Delegate
extension AppCoordinator: SelectLanguagesCoordinatorDelegate{
  
    
    func coordinatorDidCreate(coordinator: Coordinator, user: User) {
        removeCoordinator(coordinator: coordinator)
        stateManeger.createUser(user: user) { (result) in
            switch result{
            case .success(_):
                self.stateManeger.user = user
                self.showFeed()
            case .failure(_):
                fatalError("Deu mt ruim cusão")
            }
        }
    }
    
    func coordinatorDidCancel(coordinator: Coordinator) {
        signUpAPI.deleteCurrentUser()
        removeCoordinator(coordinator: coordinator)
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? SignUpCoordinator{
                    coo.start()
                }
            }
        }
    }
    
    
}


//MARK: -> Create Post Delegate
extension AppCoordinator: CreatePostDelegate{
    func createPostFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
//        navigationController.popViewController(animated: true)
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? FeedCoordinator{
                    coo.start()
                }
            }
        }
    }
}

//MARK: -> Create Post Delegate
extension AppCoordinator: FeedCoordinatorDelegate{
    func chooseCreatePostView() {
        showCreatePost()
    }
    
    func chooseViewPostDetails(post: Post) {
        showViewPostInDetails(post: post)
    }
    
    
}

//MARK: -> Create Post Delegate
extension AppCoordinator: ViewPostDelegate{
    
    func viewPostFinished(coordinator: Coordinator) {
        removeCoordinator(coordinator: coordinator)
//        navigationController.popViewController(animated: true)
        childCoordinators.forEach { (coordinator) in
            DispatchQueue.main.async {
                if let coo = coordinator as? FeedCoordinator{
                    coo.start()
                }
            }
        }
    }
}
