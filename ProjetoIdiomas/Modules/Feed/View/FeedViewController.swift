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
    
    var section: SectionSelected = .teachingSection
    
    var updateVotesView: (VoteType, Int32) -> () = {_, _ in}
    var profileButton: UIBarButtonItem!
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        feedTableView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
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

        presenter?.updateFeed(in: [.english], from: Date())
        
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(self.retriveData), for: .valueChanged)
//        myTableView.refreshControl = refresh
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector((reloadFeed)), for: .valueChanged)
        feedTableView.refreshControl = refresh
        
        
        
        profileButton = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(goToProfile))//UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goToProfile))
        self.navigationItem.setRightBarButton(profileButton, animated: true)
        profileButton.isEnabled = true
        profileButton.tintColor = UIColor(red: 29/255, green: 37/255, blue: 100/255, alpha: 1.0)
    }
    
    @objc func goToProfile(){
        presenter?.goToProfile()
    }
    
    @objc func reloadFeed(){
        posts.removeAll()
        if section == .teachingSection{
            presenter?.updateFeed(in: [.english], from: Date())
        }else{
            presenter?.updateFeed(in: [.french], from: Date())
        }
    }

   
   
}


extension FeedViewController: FeedPresenterToView{
    func showPosts(posts: [Post]) {
        self.feedTableView.refreshControl?.endRefreshing()
        self.posts = posts
        self.feedTableView.reloadData()
    }
    
    func showError() {
        print("errooou")
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
                    self.presenter?.updateFeed(in: [.english], from: Date())
                }
                cell.learningSelect = {
                    self.section = .learningSection
                    self.posts.removeAll()
                    self.presenter?.updateFeed(in: [.french], from: Date())
                }
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell{
            if indexPath.row == 0 || indexPath.row > posts.count {return UITableViewCell()}
            let post = posts[indexPath.row-1] ///subtraio 1 por causa da celula statica
            print(post.publicationDate)
            cell.populate(post: post)
            
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
            return cell
        }
        
        fatalError("deu ruim com a cell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell =  tableView.cellForRow(at: indexPath) as?  FeedCell else {return}
        var post = posts[indexPath.row-1]
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
            tableView.reloadData()
        }
        presenter?.goToViewPostDetails(post: post, imageProfile: cell.userPictureView.image, vc: self)
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
            presenter?.updateFeed(in: [.english], from: posts.last!.publicationDate)
        }
        
    }
    
    
}


extension FeedViewController: UITabBarDelegate{
     
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            presenter?.goToAddPostView()
        }
    }
}
