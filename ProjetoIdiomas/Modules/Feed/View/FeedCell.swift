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
    @IBOutlet weak var feedIndicator: UIActivityIndicatorView!
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var profilePicIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var backgroundCell: UIView!
    var onReuse: () -> () = {}
    var upvoted: () -> () = {}
    var downVoted: () -> () = {}
    var readMoreClicked: () -> () = {}
    var reportClicked: () -> () = {}
    var isLiked = false
    
//    override func viewWillLayoutSubviews() {
//          sampleLabel.sizeToFit()
//      }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reactionButton.setImage(UIImage(named: "likedIcon"), for: .disabled)
        reactionButton.setImage(UIImage(named: "Icon awesome-arrow-alt-circle-up-1"), for: .normal)
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
        
     
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        upvoted()
        ///atualizo label dos numeros
        if let tex = upVoteLabel.text, let num = Int16(tex){
            upVoteLabel.text = "\(num + 1)"
        }
        reactionButton.isEnabled = false
        
    }
    
//    @IBAction func downVoteButton(_ sender: Any) {
//        downVoted()
//        ///atualizo label dos numeros
//        if let tex = downVoteLabel.text, let num = Int16(tex){
//            downVoteLabel.text = "\(num + 1)"
//        }
//    }
    @IBAction func didTapReadMore(_ sender: Any) {
        readMoreClicked()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    @IBAction func reportButtonDidTap(_ sender: Any) {
        reportClicked()
    }
    
    func populate(post: Post){
        self.postText.text = post.message
        self.userNameLabel.text = post.author.name
        self.postTitleLabel.text = post.title
//        self.downVoteLabel.text = "\(post.downvote)"
        self.upVoteLabel.text = "\(post.upvote)"
        self.feedIndicator.stopAnimating()
        if let imageName =  Languages.init(rawValue: post.language)?.name{
            self.languageImage.image = UIImage(named: imageName)
        }
        
        reportButton.isHidden = post.isReported
        reactionButton.isEnabled = !post.isLiked
        
    }
    
    func populate(post: Post, section: SectionSelected){
            self.postText.text = post.message
            self.userNameLabel.text = post.author.name
            self.postTitleLabel.text = post.title
//            self.downVoteLabel.text = "\(post.downvote)"
            self.upVoteLabel.text = "\(post.upvote)"
            self.feedIndicator.stopAnimating()
            if let imageName =  Languages.init(rawValue: post.language)?.name{
                self.languageImage.image = UIImage(named: imageName)
            }
            
            reactionButton.isEnabled = !post.isLiked
            reportButton.isHidden = post.isReported
            
        if section == .learningSection{
                backgroundCell.backgroundColor = SectionColor.learning.color
            }else {
                backgroundCell.backgroundColor = SectionColor.teaching.color
            }
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
