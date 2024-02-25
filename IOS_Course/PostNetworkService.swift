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
                URLQueryItem(name: "raw_json", value: String(1))
            ])
    }
    func fetchRedditAPIWithDataTask(subreddit:String = "ios", limit:Int = 1, after:String = "", completion: @escaping (Post?) -> Void) {
      
        let reqUrl = buildURL(subreddit, limit, after)
        //print(reqUrl)
        
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
                //print("JSON decoding error: \(error)")
                //print("JSON decoding error")
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
    let subreddit, selftext, authorFullname: String?
    let saved: Bool?
    let modReasonTitle: String?
    let gilded: Int?
    let clicked: Bool?
    let title: String?
    let linkFlairRichtext: [String?]
    let subredditNamePrefixed: String?
    let hidden: Bool?
    let pwls: Int?
    let linkFlairCSSClass: String?
    let downs, thumbnailHeight: Int?
    let topAwardedType: String?
    let hideScore: Bool?
    let name: String?
    let quarantine: Bool?
    let linkFlairTextColor: String?
    let upvoteRatio: Double?
    let authorFlairBackgroundColor: String?
    let ups, totalAwardsReceived: Int?
    let mediaEmbed: Gildings?
    let thumbnailWidth: Int?
    let authorFlairTemplateID: String?
    let isOriginalContent: Bool?
    let userReports: [String?]
    let secureMedia: String?
    let isRedditMediaDomain, isMeta: Bool?
    let category: String?
    let secureMediaEmbed: Gildings?
    let linkFlairText: String?
    let canModPost: Bool?
    let score: Int?
    let approvedBy: String?
    let isCreatedFromAdsUI, authorPremium: Bool?
    let thumbnail: String?
    let edited: Bool?
    let authorFlairCSSClass: String?
    let authorFlairRichtext: [String]?
    let gildings: Gildings?
    let postHint: String?
    let contentCategories: String?
    let isSelf: Bool?
    let subredditType: String?
    let created: Int?
    let linkFlairType: String?
    let wls: Int?
    let removedByCategory, bannedBy: String?
    let authorFlairType, domain: String?
    let allowLiveComments: Bool?
    let selftextHTML, likes, suggestedSort, bannedAtUTC: String?
    let urlOverriddenByDest: String?
    let viewCount: String?
    let archived, noFollow, isCrosspostable, pinned: Bool?
    let over18: Bool?
    let preview: Preview?
    let allAwardings, awarders: [String?]
    let mediaOnly: Bool?
    let linkFlairTemplateID: String?
    let canGild, spoiler, locked: Bool?
    let authorFlairText: String?
    let treatmentTags: [String?]
    let visited: Bool?
    let removedBy, modNote, distinguished: String?
    let subredditID: String?
    let authorIsBlocked: Bool?
    let modReasonBy, numReports, removalReason: String?
    let linkFlairBackgroundColor, id: String?
    let isRobotIndexable: Bool?
    let reportReasons: String?
    let author: String?
    let discussionType: String?
    let numComments: Int?
    let sendReplies: Bool?
    let whitelistStatus: String?
    let contestMode: Bool?
    let modReports: [String?]
    let authorPatreonFlair: Bool?
    let authorFlairTextColor: String?
    let permalink, parentWhitelistStatus: String?
    let stickied: Bool?
    let url: String?
    let subredditSubscribers, createdUTC, numCrossposts: Int?
    let media: String?
    let isVideo: Bool?

    enum CodingKeys: String, CodingKey {
        case approvedAtUTC = "approved_at_utc"
        case subreddit, selftext
        case authorFullname = "author_fullname"
        case saved
        case modReasonTitle = "mod_reason_title"
        case gilded, clicked, title
        case linkFlairRichtext = "link_flair_richtext"
        case subredditNamePrefixed = "subreddit_name_prefixed"
        case hidden, pwls
        case linkFlairCSSClass = "link_flair_css_class"
        case downs
        case thumbnailHeight = "thumbnail_height"
        case topAwardedType = "top_awarded_type"
        case hideScore = "hide_score"
        case name, quarantine
        case linkFlairTextColor = "link_flair_text_color"
        case upvoteRatio = "upvote_ratio"
        case authorFlairBackgroundColor = "author_flair_background_color"
        case ups
        case totalAwardsReceived = "total_awards_received"
        case mediaEmbed = "media_embed"
        case thumbnailWidth = "thumbnail_width"
        case authorFlairTemplateID = "author_flair_template_id"
        case isOriginalContent = "is_original_content"
        case userReports = "user_reports"
        case secureMedia = "secure_media"
        case isRedditMediaDomain = "is_reddit_media_domain"
        case isMeta = "is_meta"
        case category
        case secureMediaEmbed = "secure_media_embed"
        case linkFlairText = "link_flair_text"
        case canModPost = "can_mod_post"
        case score
        case approvedBy = "approved_by"
        case isCreatedFromAdsUI = "is_created_from_ads_ui"
        case authorPremium = "author_premium"
        case thumbnail, edited
        case authorFlairCSSClass = "author_flair_css_class"
        case authorFlairRichtext = "author_flair_richtext"
        case gildings
        case postHint = "post_hint"
        case contentCategories = "content_categories"
        case isSelf = "is_self"
        case subredditType = "subreddit_type"
        case created
        case linkFlairType = "link_flair_type"
        case wls
        case removedByCategory = "removed_by_category"
        case bannedBy = "banned_by"
        case authorFlairType = "author_flair_type"
        case domain
        case allowLiveComments = "allow_live_comments"
        case selftextHTML = "selftext_html"
        case likes
        case suggestedSort = "suggested_sort"
        case bannedAtUTC = "banned_at_utc"
        case urlOverriddenByDest = "url_overridden_by_dest"
        case viewCount = "view_count"
        case archived
        case noFollow = "no_follow"
        case isCrosspostable = "is_crosspostable"
        case pinned
        case over18 = "over_18"
        case preview
        case allAwardings = "all_awardings"
        case awarders
        case mediaOnly = "media_only"
        case linkFlairTemplateID = "link_flair_template_id"
        case canGild = "can_gild"
        case spoiler, locked
        case authorFlairText = "author_flair_text"
        case treatmentTags = "treatment_tags"
        case visited
        case removedBy = "removed_by"
        case modNote = "mod_note"
        case distinguished
        case subredditID = "subreddit_id"
        case authorIsBlocked = "author_is_blocked"
        case modReasonBy = "mod_reason_by"
        case numReports = "num_reports"
        case removalReason = "removal_reason"
        case linkFlairBackgroundColor = "link_flair_background_color"
        case id
        case isRobotIndexable = "is_robot_indexable"
        case reportReasons = "report_reasons"
        case author
        case discussionType = "discussion_type"
        case numComments = "num_comments"
        case sendReplies = "send_replies"
        case whitelistStatus = "whitelist_status"
        case contestMode = "contest_mode"
        case modReports = "mod_reports"
        case authorPatreonFlair = "author_patreon_flair"
        case authorFlairTextColor = "author_flair_text_color"
        case permalink
        case parentWhitelistStatus = "parent_whitelist_status"
        case stickied, url
        case subredditSubscribers = "subreddit_subscribers"
        case createdUTC = "created_utc"
        case numCrossposts = "num_crossposts"
        case media
        case isVideo = "is_video"
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
