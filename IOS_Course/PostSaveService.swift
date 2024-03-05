//
//  PostSaveService.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 05.03.2024.
//

import Foundation

class PostSaveService {
    static let shared = PostSaveService()

    let postsURL = URL.documentsDirectory.appending(path: "savedPosts.txt")
    
    private init() {}
    
    func savePosts(posts: [Child]) {
        let jsonData = try? JSONEncoder().encode(posts)
           
        do {
            try jsonData?.write(to: self.postsURL, options: [.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadPosts() -> [Child]? {
        do {
            let jsonData = try Data(contentsOf: self.postsURL)
            let posts = try JSONDecoder().decode([Child].self, from: jsonData)
            return posts
        } catch {
            print("Posts load error: \(error.localizedDescription)")
            return nil
        }
    }
    func isSaved(post:Child) -> Bool {
        if let postURL = post.data.permalink {
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
                return containsPost
            }
        }
        return false
    }
    func removePost(post:Child) {
        if let postURL = post.data.permalink {
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
                }
            }
        }
    }
    func addPost(post:Child) {
        if let postURL = post.data.permalink {
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
                if !containsPost  {
                    // add post to db
                    var newPosts:[Child] = savedPosts
                    newPosts.append(post)
                    PostSaveService.shared.savePosts(posts: newPosts)
                }
            }
        }
    }
}
