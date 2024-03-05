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
    
    private var shareURL:String = ""
    private var selectedPost:Child?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.authorName.text = ""
        self.timePassed.text = ""
        self.domain.text = ""
        self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.postTitle.text = ""
        self.commentsBtn.setTitle("", for: .normal)
        self.ratingBtn.setTitle("", for: .normal)
        self.img?.image = UIImage(systemName: "zzz")
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
        // temporary
        self.saved = false
        
        if let link = redditPost.data.permalink {
            //  "https://www.reddit.com" + link
            self.url = link
        } else {
            self.url = "Unable to get link"
        }
    }
}
