//
//  PostTableViewCell.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 20.02.2024.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didTapShareButton(with url:URL?)
    func didTapSavePostButton(with post:Child?)
    func didTapCommentButton(with post:Child?)
    func didDoubleTap(with post:Child?)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate: PostTableViewCellDelegate?
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var savedIconAnimationView: UIView!
    
    private var shareURL:String = ""
    private var selectedPost:Child?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.savedIconAnimationView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)

    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            if let post = self.selectedPost {
                if PostSaveService.shared.isSaved(post: post) {
                    return
                }
            }
            
            delegate?.didDoubleTap(with: selectedPost)
            self.savedIconAnimationView.isHidden = false
            let radius: CGFloat = 70
            let midX = self.savedIconAnimationView.bounds.midX
            let midY = self.savedIconAnimationView.bounds.midY - radius/2
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: midX - radius/2,
                                      y: midY))
            path.addLine(to: CGPoint(x: midX + radius/2,
                                         y: midY))
            path.addLine(to: CGPoint(x: midX + radius/2,
                                         y: midY + radius*1.5))
            path.addLine(to: CGPoint(x: midX,
                                         y: midY + radius))
            path.addLine(to: CGPoint(x: midX - radius/2,
                                         y: midY + radius*1.5))
            path.close()
                
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 5
            self.savedIconAnimationView.layer.addSublayer(shapeLayer)
                
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.3
            scaleAnimation.toValue = 1
            scaleAnimation.duration = 0.2
            self.savedIconAnimationView.layer.add(scaleAnimation, forKey: "scaleAnimation")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + scaleAnimation.duration) {
                let positionAnimation = CABasicAnimation(keyPath: "position")
                positionAnimation.fromValue = self.savedIconAnimationView.layer.position
                positionAnimation.toValue = CGPoint(x:self.savedBtn.frame.maxX,
                                                    y: self.savedBtn.frame.minY)
                positionAnimation.duration = 0.5
                positionAnimation.delegate = LayerRemover(for: shapeLayer, with: self.savedIconAnimationView);
                
                let scaleToSmallAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleToSmallAnimation.fromValue = 1
                scaleToSmallAnimation.toValue = 0.1
                scaleToSmallAnimation.duration = 0.5
                
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = 1
                opacityAnimation.toValue = 0.2
                opacityAnimation.duration = 0.5


                self.savedIconAnimationView.layer.add(opacityAnimation, forKey: "opacityAnimation")
                self.savedIconAnimationView.layer.add(scaleToSmallAnimation, forKey: "scaleToSmallAnimation")
                self.savedIconAnimationView.layer.add(positionAnimation, forKey: "positionAnimation")
                self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }
    

    
    @IBAction func shareAction(_ sender: Any) {
        delegate?.didTapShareButton(with: URL(string: "https://www.reddit.com" + self.shareURL))
    }
    
    @IBAction func savePostAction(_ sender: Any) {
        if let img = self.savedBtn.currentImage {
            if img.isEqual(UIImage(systemName: "bookmark.fill")) {
                self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            } else {
                self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
        delegate?.didTapSavePostButton(with: self.selectedPost)
        
    }
    
    @IBAction func commentAction(_ sender: Any) {
        print("here")
        delegate?.didTapCommentButton(with: self.selectedPost)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.authorName.text = ""
        self.timePassed.text = ""
        self.domain.text = ""
        self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.postTitle.text = ""
        self.commentsBtn.setTitle("", for: .normal)
        self.ratingBtn.setTitle("", for: .normal)
        self.img?.image = nil
    }
    func configure(redditPost:Child) {
        let myPost = MyPost(redditPost: redditPost)
        
        self.shareURL = myPost.url
        self.selectedPost = redditPost
        
        DispatchQueue.main.async {
            self.authorName.text = myPost.author
            self.timePassed.text = myPost.timePassed
            self.postTitle.text = myPost.title
            self.domain.text = myPost.domain
            if PostSaveService.shared.isSaved(post: redditPost){
                self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            if let image = myPost.image {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: image) {
                        DispatchQueue.main.async {
                            self?.img?.image = UIImage(data: data)
                        }
                    }
                }
            }
            self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
            self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
        }
    }

}

struct MyPost {
    let author: String
    let timePassed: String
    let domain: String
    let title: String
    let saved: Bool
    let image: URL?
    let rating: Int
    let comments: Int
    let url: String
    
    init(redditPost:Child) {
        if let author = redditPost.data.authorFullname {
            self.author = author
        } else {
            self.author = "No author"
        }
        // temporary
        self.timePassed = "10h"
        if let domain = redditPost.data.domain {
            self.domain = domain
        } else {
            self.domain = "No domain"
        }
        if let title = redditPost.data.title {
            self.title = title
        } else {
            self.title = "No title"
        }
        if let comments = redditPost.data.numComments {
            self.comments = comments
        } else {
            self.comments = 0
        }
        if let ups = redditPost.data.ups {
            if let downs = redditPost.data.downs {
                self.rating = ups + downs
            } else {
                self.rating = ups
            }
        } else if let downs = redditPost.data.downs {
            self.rating = downs
        } else {
            self.rating = 0
        }
        
        if let imgPreview = redditPost.data.url {
            self.image = URL(string: imgPreview.replacingOccurrences(of: "&amp", with: "&"))!
        } else {
            self.image = nil
        }
        
        self.saved = PostSaveService.shared.isSaved(post: redditPost)
      
        if let link = redditPost.data.permalink {
            //  "https://www.reddit.com" + link
            self.url = link
        } else {
            self.url = "Unable to get link"
        }
    }
}
