//
//  PostListViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 25.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    struct Const {
           static let postReuseIdentifier = "post"
           static let goToPostDetailsSegueID = "go_to_post_details"
       }
    private var posts = [Child]()
    private var postsCopy = [Child]()
    private var lastSelectedPost: Child?
    private var subreddit:String = "ios"
    private var savedFilterOn = false
    
    @IBOutlet weak var savedFilterBtn: UIButton!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    @IBOutlet weak var savedFilterByTitleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedFilterByTitleTextField.isUserInteractionEnabled = false
        self.savedFilterByTitleTextField.alpha = 0
        self.savedFilterByTitleTextField.delegate = self
        self.savedFilterBtn.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        self.subredditLabel.text = "/r/" + subreddit
        PostNetworkService.shared.fetchRedditAPIWithDataTask(subreddit: subreddit, limit: 10) { res in
            if let res = res {
                self.posts.append(contentsOf: res.data.children)
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func savedFilterAction(_ sender: Any) {
        if let img = self.savedFilterBtn.currentImage {
            if img.isEqual(UIImage(systemName: "bookmark.circle.fill")) {
                self.savedFilterBtn.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
                self.savedFilterOn = false
                self.posts = postsCopy
                self.postsTableView.reloadData()
                self.savedFilterByTitleTextField.isUserInteractionEnabled = false
                self.savedFilterByTitleTextField.alpha = 0
            } else {
                self.savedFilterBtn.setImage(UIImage(systemName: "bookmark.circle.fill"), for: .normal)
                self.savedFilterOn = true
                if let filteredPosts = PostSaveService.shared.loadPosts() {
                    self.postsCopy = posts
                    self.posts = filteredPosts
                    self.postsTableView.reloadData()
                    self.savedFilterByTitleTextField.isUserInteractionEnabled = true
                    self.savedFilterByTitleTextField.alpha = 1
                }
            }
        }
      
    }
    override func prepare(
           for segue: UIStoryboardSegue,
           sender: Any?
       ) {
           switch segue.identifier {
           case Const.goToPostDetailsSegueID:
               let nextVc = segue.destination as! PostDetailsViewController
               DispatchQueue.main.async {
                  
                   //print(self.lastSelectedPost!)
                   if let post = self.lastSelectedPost {
                       nextVc.config(with: post)
                   }
               }

           default: break
           }
       }

}
extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.postReuseIdentifier, for: indexPath) as! PostTableViewCell
        cell.configure(redditPost: self.posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // print("didselect")
          self.lastSelectedPost = self.posts[indexPath.row]
          self.performSegue(
              withIdentifier: Const.goToPostDetailsSegueID,
              sender: nil
          )
      }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.savedFilterOn {
            return
        }
        let lastVisibleIndexPath = IndexPath(row: posts.count - 1, section: 0)
        if self.postsTableView.indexPathsForVisibleRows?.contains(lastVisibleIndexPath) == true {
            // try to find some posts with given after. Try this for every post until something is found
            for i in 1...posts.count {
                if let lastPostAuthorName = posts[posts.count-i].data.authorFullname {
                    PostNetworkService.shared.fetchRedditAPIWithDataTask(subreddit: subreddit, limit: 10, after:lastPostAuthorName) { res in
                        if let res = res {
                            self.posts.append(contentsOf: res.data.children)
                            DispatchQueue.main.async {
                                self.postsTableView.reloadData()
                            }
                        } else {
                            print("No posts were returned with after parameter \(lastPostAuthorName)")
                        }
                    }
                }
            }
            // if haven't been found any posts with any after parameters, just load 10 more posts without after
            PostNetworkService.shared.fetchRedditAPIWithDataTask(subreddit: subreddit, limit: posts.count + 10) { res in
                if let lastTenPosts = res?.data.children.suffix(10) {
                    self.posts.append(contentsOf: lastTenPosts)
                    DispatchQueue.main.async {
                        self.postsTableView.reloadData()
                    }
                } else {
                    print(self.posts.count)
                    print("No posts were returned")
                }
            }
        }
       
    }
}
extension PostListViewController : PostTableViewCellDelegate {
    func didTapShareButton(with url: URL?) {
        if let imgUrl = url {
            let avc = UIActivityViewController(activityItems: [imgUrl], applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
        }
    }
    func didTapSavePostButton(with post: Child?) {
        if let selectedPost = post {
            if let postURL = post?.data.permalink {
                if let savedPosts = PostSaveService.shared.loadPosts() {
                    // check if posts db contains post, using permalink as identifier
                    var containsPost = false
                    for post in savedPosts {
                        if let link = post.data.permalink {
                            if link.elementsEqual(postURL) {
                                containsPost = true
                            }
                        }
                    }
                    if containsPost {
                        // erase post from db
                        var newPosts:[Child] = []
                        for post in savedPosts {
                            if let link = post.data.permalink {
                                if !link.elementsEqual(postURL) {
                                    newPosts.append(post)
                                }
                            }
                        }
                        PostSaveService.shared.savePosts(posts: newPosts)
                    } else {
                        // add post to db
                        var newPosts:[Child] = savedPosts
                        newPosts.append(selectedPost)
                        PostSaveService.shared.savePosts(posts: newPosts)
                    }
                }
            }
        }
    }
}

extension PostListViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var filteredPosts = [Child]()
        if let currentText = textField.text {
            if let posts = PostSaveService.shared.loadPosts() {
                for post in posts {
                    if let title = post.data.title {
                        if title.contains(currentText) {
                            filteredPosts.append(post)
                        }
                    }
                }
            }
        }
        self.posts = filteredPosts
        self.postsTableView.reloadData()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

}
