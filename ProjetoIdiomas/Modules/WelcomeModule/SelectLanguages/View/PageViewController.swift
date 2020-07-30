//
//  PageViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 18/07/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

public enum PageOnBoarding{

    case learningOnBoard
    case selectLanguageLearning
    case teachingOnBoard
    case selectLanguageTeaching
    case onBoard01
    case onBoard02
    

    var vc: UIViewController {
        switch self {
        case .learningOnBoard:
            return LearningOnBoardViewController(nibName: "LearningOnBoardViewController", bundle: nil)
        case .selectLanguageLearning:
            return SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
        case .teachingOnBoard:
            return TeachingOnBoardViewController(nibName: "TeachingOnBoardViewController", bundle: nil)
        case .selectLanguageTeaching:
            return SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
        case .onBoard01:
            return OnBoardViewController(nibName: "OnBoardViewController", bundle: nil)
        case .onBoard02:
            return OnBoardViewController(nibName: "OnBoardViewController", bundle: nil)
        }
    }

    var index: Int {
          switch self {
          case .onBoard01:
              return 0
          case .onBoard02:
            return 1
          case .learningOnBoard:
              return 2
          case .selectLanguageLearning:
              return 3
          case .teachingOnBoard:
              return 4
          case .selectLanguageTeaching:
              return 5
          
        }
      }
}
//
//
//
//    public enum PageOnBoardindg{
//
//        case learningOnBoard
//        case selectLanguageLearning
//        case teachingOnBoard
//        case selectLanguageTeaching
//
//        var vc: UIViewController {
//            switch self {
//            case .learningOnBoard:
//                return
//            case .selectLanguageLearning:
//                return SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
//            case .teachingOnBoard:
//                return TeachingOnBoardViewController(nibName: "TeachingOnBoardViewController", bundle: nil)
//            case .selectLanguageTeaching:
//                return SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
//            }
//        }
//
//
//        var page: PageOnBoardindg{
//
//        }
//
//        var index: Int {
//              switch self {
//              case .learningOnBoard:
//                  return 0
//              case .selectLanguageLearning:
//                  return 1
//              case .teachingOnBoard:
//                  return 2
//              case .selectLanguageTeaching:
//                  return 3
//              }
//          }
//
//    }

    struct PageOnBoardingModel {
        
        private var user: User!
        private var learningOnBoard: LearningOnBoardViewController!
        private var selectLanguageLearning: SelectLanguageViewController!
        private var teachingOnBoard: TeachingOnBoardViewController!
        private var selectLanguageTeaching: SelectLanguageViewController!
        private var onBoard01: OnBoardViewController!
        private var onBoard02: OnBoardViewController!
        
        init(user: User, learningOnBoard: LearningOnBoardViewController,selectLanguageVC: SelectLanguageViewController,teachingOnBoard: TeachingOnBoardViewController, onBoard: OnBoardViewController) {
            self.user = user
            self.learningOnBoard = learningOnBoard
            self.selectLanguageLearning = selectLanguageVC
            self.selectLanguageTeaching = selectLanguageVC
            self.teachingOnBoard = teachingOnBoard
            self.onBoard01 = onBoard
            let onBoard02 = OnBoardViewController(nibName: "OnBoardViewController", bundle: nil)
            onBoard02.pageDelegate = onBoard.pageDelegate
            self.onBoard02 = onBoard02
        }
        
        
        func getVC(by page: PageOnBoarding) -> OnBoardingPage{
            switch page {
            case .learningOnBoard:
                return learningOnBoard
            case .selectLanguageLearning:
                selectLanguageLearning.viewState = .learningLanguagesSection
                return selectLanguageLearning
            case .teachingOnBoard:
                return teachingOnBoard
            case .selectLanguageTeaching:
                selectLanguageTeaching.viewState = .fluentlyLanguagesSection
                return selectLanguageTeaching
            case .onBoard01:
                onBoard01.onBoardStep = .onBoard01
                return onBoard01
            case .onBoard02:
                onBoard02.onBoardStep = .onBoard02
                return onBoard02
            }
        }
        
    }

    




class PageViewController: UIViewController {

    var pageView: UIPageViewController!
    var pageModel: PageOnBoardingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageView = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        
        //pageView.dataSource = self
        pageView.delegate = self
        pageView.view.backgroundColor = .clear
        pageView.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(pageView)
        self.view.addSubview(pageView.view)
        pageView.didMove(toParent: self)
        pageView.setViewControllers([pageModel.getVC(by: .onBoard01) as UIViewController], direction: .forward, animated: true, completion: nil)
    
    }
    

    

}

extension PageViewController: UIPageViewControllerDelegate, WalkThroughOnBoardDelegate{
    
    func goNextPage(fowardTo page: PageOnBoarding) {
        let viewController = pageModel.getVC(by: page)
        viewController.pageDelegate = self
        pageView.setViewControllers([viewController], direction:
                 UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    func goBeforePage(reverseTo page: PageOnBoarding) {
        let viewController = pageModel.getVC(by: page)
        viewController.pageDelegate = self
        pageView.setViewControllers([viewController], direction:
            UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
    }

//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//         return 3
//     }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}


