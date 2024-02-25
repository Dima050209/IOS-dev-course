//
//  PostListViewController.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 25.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    var posts = [Child]()
    override func viewDidLoad() {
        super.viewDidLoad()
        PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: 10) { res in
            if let res = res {
                self.posts.append(contentsOf: res.data.children)
            }
        }
    }

}
extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
//        PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: 10) { res in
//            if let res = res {
//                cell.configure(redditPost: res.data.children[indexPath.row])
//            }
//        }
        cell.configure(redditPost: self.posts[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 1...posts.count {
            if let lastPostAuthorName = posts[posts.count-1].data.authorFullname {
                PostNetworkService.shared.fetchRedditAPIWithDataTask(limit: 10, after:lastPostAuthorName) { res in
                    if let res = res {
                        self.posts.append(contentsOf: res.data.children)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("No posts were returned with after parameter \(lastPostAuthorName)")
                    }
                }
            }
        }
       
    }
}
