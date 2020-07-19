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
        }
    }

    var index: Int {
          switch self {
          case .learningOnBoard:
              return 0
          case .selectLanguageLearning:
              return 1
          case .teachingOnBoard:
              return 2
          case .selectLanguageTeaching:
              return 3
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
        
        init(user: User, learningOnBoard: LearningOnBoardViewController,selectLanguageVC: SelectLanguageViewController,teachingOnBoard: TeachingOnBoardViewController) {
            self.user = user
            self.learningOnBoard = learningOnBoard
            self.selectLanguageLearning = selectLanguageVC
            self.selectLanguageTeaching = selectLanguageVC
            self.teachingOnBoard = teachingOnBoard
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
        pageView.setViewControllers([pageModel.getVC(by: .learningOnBoard) as UIViewController], direction: .forward, animated: true, completion: nil)
    
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


