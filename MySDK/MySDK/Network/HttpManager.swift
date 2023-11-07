//
//  HttpManager.swift
//  MySDK
//
//  Created by liyuan chang on 2023/11/5.
//

import Foundation

class HttpManager{
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    internal var postCache = APICache<Int, Post>(entryLifetime: 5*60)
    internal var commentCache = APICache<Int, [Comment]>(entryLifetime: 5*60)
    func getAllPost() async -> [Post]{
        guard let url = URL(string: baseUrl + "posts"),
              let data = try? await sendRequest(url) else { return [] }
        let decoder = JSONDecoder()
        guard let res = try? decoder.decode([Post].self, from: data) else { return [] }
        return res
    }
    
    func getPostByID(_ id:Int) async -> Post{
        guard postCache[id] == nil else { return postCache[id] ?? Post() }
        guard let url = URL(string: baseUrl + "posts/\(id)"),
              let data = try? await sendRequest(url) else { return Post() }
        let decoder = JSONDecoder()
        guard let res = try? decoder.decode(Post.self, from: data) else { return Post() }
        postCache[id] = res
        return res
    }
    
    func getPostWithCommentById(_ id:Int) async -> [Comment]{
        guard commentCache[id] == nil else { return commentCache[id] ?? [] }
        guard let url = URL(string: baseUrl + "posts/\(id)/comments"),
              let data = try? await sendRequest(url) else { return [] }
        let decoder = JSONDecoder()
        guard let res = try? decoder.decode([Comment].self, from: data) else { return [] }
        commentCache[id] = res
        return res
    }
}

extension HttpManager{
    internal func sendRequest(_ url: URL) async throws -> Data{
        var data : Data
        if #available(iOS 15.0, *) {
            let (d, _) = try await URLSession.shared.data(from: url)
            data = d
        } else {
            data = try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data {
                        continuation.resume(returning: data)
                    }
                }
                task.resume()
            }
        }
        return data
    }
}
