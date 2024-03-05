//
//  PostNetworkService.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 13.02.2024.
//

import Foundation

class PostNetworkService {
    static let shared = PostNetworkService()
    private init() {}
    
    private let urlStart = "https://www.reddit.com/r/"
    private let urlEnd = "/top.json"
    
    private func buildURL(_ subreddit:String = "ios", _ limit:Int = 1, _ after:String = "") -> URL {
        return URL(string: urlStart + subreddit + urlEnd)!
            .appending(queryItems: [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "after", value: after),
                //URLQueryItem(name: "raw_json", value: String(1))
            ])
    }
    func fetchRedditAPIWithDataTask(subreddit:String = "ios", limit:Int = 1, after:String = "", completion: @escaping (Post?) -> Void) {
      
        let reqUrl = buildURL(subreddit, limit, after)
        print(reqUrl)
        
        let task = URLSession.shared.dataTask(with: reqUrl) {data,_,error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else {
                print("Data is not available")
                return
            }
//            let posts = try? JSONDecoder().decode(Posts.self, from: data)
//            print(posts)
//            completion(posts)
            do {
                let posts = try JSONDecoder().decode(Post.self, from: data)
                completion(posts)
            } catch {
                print("JSON decoding error: \(error)")
                print("JSON decoding error")
                completion(nil)
            }
        }
        task.resume()
    }
}

// MARK: - Post
struct Post: Codable {
    let kind: String
    let data: PostData
}

// MARK: - PostData
struct PostData: Codable {
    let after: String
    let dist: Int
    let modhash, geoFilter: String
    let children: [Child]
    let before: String?

    enum CodingKeys: String, CodingKey {
        case after, dist, modhash
        case geoFilter = "geo_filter"
        case children, before
    }
}

// MARK: - Child
struct Child: Codable {
    let kind: String
    let data: ChildData
}

// MARK: - ChildData
struct ChildData: Codable {
    let approvedAtUTC: String?
    let subreddit, authorFullname: String?
    let saved: Bool?
    let title: String?
    let domain: String?
    let downs: Int?
    let name: String?
    let ups: Int?
    let preview: Preview?
    let author: String?
    let numComments: Int?
    let permalink: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case approvedAtUTC = "approved_at_utc"
        case subreddit
        case authorFullname = "author_fullname"
        case saved
        case title
        case domain
        case downs
        case name
        case ups
        case preview
        case author
        case numComments = "num_comments"
        case permalink
        case url
    }
}

// MARK: - Gildings
struct Gildings: Codable {
}

// MARK: - Preview
struct Preview: Codable {
    let images: [Image]
    let enabled: Bool
}

// MARK: - Image
struct Image: Codable {
    let source: Source
    let resolutions: [Source]
    let variants: Gildings
    let id: String
}

// MARK: - Source
struct Source: Codable {
    let url: String
    let width, height: Int
}
