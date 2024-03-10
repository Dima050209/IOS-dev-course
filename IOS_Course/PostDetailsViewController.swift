//
//  PostDetailsViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 25.02.2024.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var timePeriod: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var savedBtn: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var savedIconAnimationView: UIView!
    
    private var currentPost:Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.savedIconAnimationView.isHidden = true
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.savedIconAnimationView.addGestureRecognizer(doubleTapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        print("here")
        if gesture.state == .ended {
            if let post = self.currentPost {
                if PostSaveService.shared.isSaved(post: post) {
                    return
                } else {
                    // add post to db
                    self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    PostSaveService.shared.addPost(post: post)
                }
            }
            
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
    
    @IBAction func savedAction(_ sender: Any) {
        if let post = self.currentPost {
            if PostSaveService.shared.isSaved(post: post) {
                // remove post from db
                self.savedBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                PostSaveService.shared.removePost(post: post)
            } else {
                // add post to db
                self.savedBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                PostSaveService.shared.addPost(post: post)
            }
        }
        
    }
    @IBAction func shareAction(_ sender: Any) {
        if let url = self.currentPost?.data.permalink {
            let avc = UIActivityViewController(activityItems: ["https://www.reddit.com" + url], applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
        }
    }
    func config(with post:Child) {
        let myPost = MyPost(redditPost: post)
        self.currentPost = post
        DispatchQueue.main.async {
            guard self.authorName != nil else { return }
            self.authorName.text = myPost.author
                   
            guard self.timePeriod != nil else { return }
            self.timePeriod.text = myPost.timePassed
                   
            guard self.postTitle != nil else { return }
            self.postTitle.text = myPost.title
                   
            guard self.domain != nil else { return }
            self.domain.text = myPost.domain
    
            guard self.savedBtn != nil else { return }
            if myPost.saved {
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
            guard self.commentsBtn != nil else { return }
            self.commentsBtn.setTitle(String(myPost.rating), for: .normal)
                   
            guard self.ratingBtn != nil else { return }
            self.ratingBtn.setTitle(String(myPost.comments), for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
