//
//  FeedCell.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 15/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var userPictureView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var reactionButton: UIButton!
    
    @IBOutlet weak var upVoteLabel: UILabel!
    @IBOutlet weak var downVoteLabel: UILabel!
    @IBOutlet weak var feedIndicator: UIActivityIndicatorView!
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var profilePicIndicator: UIActivityIndicatorView!
    
    var onReuse: () -> () = {}
    var upvoted: () -> () = {}
    var downVoted: () -> () = {}

    
//    override func viewWillLayoutSubviews() {
//          sampleLabel.sizeToFit()
//      }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicIndicator.startAnimating()
        feedIndicator.startAnimating()
        feedIndicator.hidesWhenStopped = true
        profilePicIndicator.hidesWhenStopped = true
        
        
        ///setup profile image view
        userPictureView.translatesAutoresizingMaskIntoConstraints = false
        userPictureView.layer.cornerRadius = 24
        userPictureView.layer.masksToBounds = true
        userPictureView.contentMode = .scaleAspectFill
        
        postText.sizeToFit()
        
    }
    @IBAction func upVoteButton(_ sender: Any) {
        upvoted()
        ///atualizo label dos numeros
        if let tex = upVoteLabel.text, let num = Int16(tex){
            upVoteLabel.text = "\(num + 1)"
        }
        
    }
    
    @IBAction func downVoteButton(_ sender: Any) {
        downVoted()
        ///atualizo label dos numeros
        if let tex = downVoteLabel.text, let num = Int16(tex){
            downVoteLabel.text = "\(num + 1)"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    func populate(post: Post){
        self.postText.text = post.message
        self.userNameLabel.text = post.author.name
        self.postTitleLabel.text = post.title
        self.downVoteLabel.text = "\(post.downvote)"
        self.upVoteLabel.text = "\(post.upvote)"
        self.feedIndicator.stopAnimating()
        if let imageName =  Languages.init(rawValue: post.language)?.name{
            self.languageImage.image = UIImage(named: imageName)
        }
        
        
//        if let photoURL = post.author.photoURL{
//            self.userPictureView.loadImagefromURL(from: photoURL) {
//                self.profilePicIndicator.stopAnimating()
//            }
//        }
    }
    
    func populateImage(image: UIImage){
        DispatchQueue.main.async {
            self.userPictureView.image = image
            self.profilePicIndicator.stopAnimating()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userPictureView.image = nil
        onReuse()
    }
}
