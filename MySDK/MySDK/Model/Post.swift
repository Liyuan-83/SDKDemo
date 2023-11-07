//
//  Post.swift
//  MySDK
//
//  Created by liyuan chang on 2023/11/5.
//

import Foundation
public class Post: Codable, Hashable {
    public let userID, id: Int
    public let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init(userID: Int? = -1, id: Int? = -1, title: String? = "", body: String? = "") {
        self.userID = userID ?? -1
        self.id = id ?? -1
        self.title = title ?? ""
        self.body = body ?? ""
    }
    
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher){
        
    }
}
