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
    private var lastSelectedPost: Child?
    
    @IBOutlet weak var postsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: 10) { res in
            if let res = res {
                self.posts.append(contentsOf: res.data.children)
                //print(self.posts)
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
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
                   print("seg")
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("didselect")
          self.lastSelectedPost = self.posts[indexPath.row]
          self.performSegue(
              withIdentifier: Const.goToPostDetailsSegueID,
              sender: nil
          )
      }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let lastVisibleIndexPath = IndexPath(row: posts.count - 1, section: 0)
        if self.postsTableView.indexPathsForVisibleRows?.contains(lastVisibleIndexPath) == true {
            for i in 1...posts.count {
                if let lastPostAuthorName = posts[posts.count-i].data.authorFullname {
                    PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: 10, after:lastPostAuthorName) { res in
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
            PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: posts.count + 10) { res in
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
