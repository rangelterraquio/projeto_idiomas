//
//  FeedViewController.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 14/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

public enum SectionSelected{
    case teachingSection
    case learningSection
}


public enum VoteType{
    case upVote
    case downVote
}


class FeedViewController: UIViewController {


    var presenter: FeedViewToPresenter? = nil
    
    var posts: [Post] = [Post]()
    
    var newPosts: [Post] = [Post]()
    
    var section: SectionSelected = .learningSection
    
    var updateVotesView: (VoteType, Int32) -> () = {_, _ in}
    var profileButton: UIBarButtonItem!
    
    var user: User!
    
    var languagesTeaching:[Languages]!
    var languagesLearning:[Languages]!
    
    
    var fetchedAll = false
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var newPostsButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var feedLoadingIndicator: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        feedTableView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Feed"
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        ///setup tableView
        let cellXib = UINib.init(nibName: "FeedCell", bundle: nil)
        let filterCellXib = UINib.init(nibName: "FilterCell", bundle: nil)
        feedTableView.register(filterCellXib, forCellReuseIdentifier: "filterCell")
        feedTableView.register(cellXib, forCellReuseIdentifier: "feedCell")
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedTableView.separatorColor = .clear
        feedTableView.separatorStyle = .none
        feedTableView.allowsSelection = false
        newPostsButton.isHidden = true
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(self.retriveData), for: .valueChanged)
//        myTableView.refreshControl = refresh
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector((reloadFeed)), for: .valueChanged)
        feedTableView.refreshControl = refresh
        
        
        
        profileButton = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(goToProfile))
        self.navigationItem.setRightBarButton(profileButton, animated: true)
        profileButton.isEnabled = true
        profileButton.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
        
        
        
        

                   
        languagesTeaching = user.fluentLanguage.map { (lang) -> Languages in
            return Languages(rawValue: lang)!
        }
        
        languagesLearning = user.learningLanguage!.map { (lang) -> Languages in
            return Languages(rawValue: lang)!
        }
        
        presenter?.updateFeed(in: languagesLearning, from: Date())
        
        newPostsButton.isHidden = true
    }
    
    @objc func goToProfile(){
        presenter?.goToProfile()
    }
    
    @objc func reloadFeed(){
        posts.removeAll()
        if section == .teachingSection{
           
            presenter?.updateFeed(in: languagesTeaching, from: Date())
        }else{
         
            
            presenter?.updateFeed(in: languagesLearning, from: Date())
        }
    }

    @IBAction func newPostAdded(_ sender: Any) {
        
        newPosts.append(contentsOf: posts)
        posts = newPosts
            
       var tempVet = [Post]()
        for i in 0..<posts.count {
            if !tempVet.contains(posts[i]){
                tempVet.append(posts[i])
            }
        }
        posts = tempVet
        
        newPosts.removeAll()
        let indexPath = NSIndexPath(row: 0, section: 0)
        feedTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        feedTableView.reloadData()
        newPostsButton.isHidden = true
        
    
    }
    
   
}


extension FeedViewController: FeedPresenterToView{
    func updateViewWith(posts: [Post]) {
        var languages: [Languages]!
        if section == .teachingSection{
            languages = languagesTeaching
        }else{
            languages = languagesLearning
        }
        
        if languages == nil {return}
        posts.forEach { (post) in
            
            languages.forEach { (lang) in
                if lang.rawValue == post.language{
                        newPosts.append(post)
                    }
                }
        }
        
        if !newPosts.isEmpty{
            newPostsButton.isHidden = false
        }
        
    }
    
    func showPosts(posts: [Post]) {
        if !posts.isEmpty{
            self.feedLoadingIndicator.stopAnimating()
            self.feedLoadingIndicator.isHidden = true
            self.feedTableView.refreshControl?.endRefreshing()
            
            
            
            
            
            
            self.posts.append(contentsOf: posts)
            self.feedTableView.reloadData()
            
        }
        
       feedLoadingIndicator.isHidden = true
        errorLabel.isHidden = !posts.isEmpty
    }
    
    func showError(fetchedAll: Bool) {
        self.fetchedAll = fetchedAll
        print("Não deve buscar mais posts")
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterCell{
                cell.teachingSelect = {
                    self.section = .teachingSection
                    self.posts.removeAll()
                    self.feedTableView.reloadData()
                    self.feedLoadingIndicator.startAnimating()
                    self.presenter?.updateFeed(in: self.languagesTeaching, from: Date())
                }
                cell.learningSelect = {
                    self.section = .learningSection
                    self.posts.removeAll()
                    self.feedTableView.reloadData()
                    self.feedLoadingIndicator.startAnimating()
                    self.presenter?.updateFeed(in: self.languagesLearning, from: Date())
                }
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell{
            if indexPath.row == 0 || indexPath.row > posts.count {return UITableViewCell()}
            let post = posts[indexPath.row-1] ///subtraio 1 por causa da celula statica
            print(post.publicationDate)
            cell.populate(post: post, section: section)
            
            let uuid = presenter?.requestProfileImage(from: post.author.photoURL, completion: { (result) in
                do{
                    let image = try result.get()
                    cell.populateImage(image: image)
                }catch{
                    print(error as Any)
                    cell.populateImage(image: UIImage(named: "blankProfile")!)
                }
            })
            cell.onReuse = {
                if let uuid = uuid{
                    self.presenter?.cancelImageRequest(uuid: uuid)
                }
            }
            
            
            cell.upvoted = { self.presenter?.updateVotes(from: "upvote", inDocument: post, with: nil)}
            cell.downVoted = {self.presenter?.updateVotes(from: "downvote", inDocument: post, with: nil)}
            cell.readMoreClicked = {self.didReadMoreAction(cell: cell, index: indexPath.row)}
            return cell
        }
        
        fatalError("deu ruim com a cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell =  tableView.cellForRow(at: indexPath) as?  FeedCell else {return}
//        var post = posts[indexPath.row-1]
//        post.downvote = Int32(cell.downVoteLabel.text!)!
//        post.upvote = Int32(cell.upVoteLabel.text!)!
//
//        updateVotesView = {voteType, num in
//            if voteType == .upVote{
//                post.upvote = num
//                cell.upVoteLabel.text = "\(num)"
//            }else{
//                post.downvote = num
//                cell.downVoteLabel.text = "\(num)"
//            }
//            tableView.reloadData()
//        }
//        presenter?.goToViewPostDetails(post: post, imageProfile: cell.userPictureView.image, vc: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }else{
            return 300
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let lastVisibleIndexPath = tableView.numberOfRows(inSection: 0)
            print(lastVisibleIndexPath)
        
        ///aqui eu faço a requisição de mais posts, tenho que testar dps
        if indexPath.row == lastVisibleIndexPath-1, !posts.isEmpty {
            print("Entrou na func rangel")
            if !fetchedAll{
                if section == .teachingSection{
                    presenter?.updateFeed(in: languagesTeaching, from: posts.last!.publicationDate)
                }else{
                    presenter?.updateFeed(in: languagesLearning, from: posts.last!.publicationDate)
                }
            }
           
        }
        
    }
    
    func didReadMoreAction(cell: FeedCell, index: Int){
     //   guard let cell =  tableView.cellForRow(at: indexPath) as?  FeedCell else {return}
        var post = posts[index-1]
        post.downvote = Int32(cell.downVoteLabel.text!)!
        post.upvote = Int32(cell.upVoteLabel.text!)!
        
        updateVotesView = {voteType, num in
            if voteType == .upVote{
                post.upvote = num
                cell.upVoteLabel.text = "\(num)"
            }else{
                post.downvote = num
                cell.downVoteLabel.text = "\(num)"
            }
            self.feedTableView.reloadData()
        }
        presenter?.goToViewPostDetails(post: post, imageProfile: cell.userPictureView.image, vc: self)
    }
    
    
    
}


extension FeedViewController: UITabBarDelegate{
     
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            presenter?.goToAddPostView()
        }
    }
}
