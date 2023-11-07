//
//  Comment.swift
//  MySDK
//
//  Created by liyuan chang on 2023/11/5.
//

import Foundation
public class Comment: Codable, Hashable {
    public let postID, id: Int
    public let name, email , body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email , body
    }

    init(postID: Int? = -1, id: Int? = -1, name: String? = "", email: String? = "", body: String? = "") {
        self.postID = postID ?? -1
        self.id = id ?? -1
        self.name = name ?? ""
        self.email = email ?? ""
        self.body = body ?? ""
    }
    
    public static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher){
        
    }
}
