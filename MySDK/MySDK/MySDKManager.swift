//
//  MySDKManager.swift
//  MySDK
//
//  Created by liyuan chang on 2023/11/5.
//

import Foundation

public class MySDKManager{
    public static func getAllPosts() async -> [Post]{
        return await HttpManager().getAllPost()
    }
    
    public static func getPostByIds(ids: [Int]) async -> [Post]{
        var res : [Int:Post] = [:]
        await withTaskGroup(of: (Int, Post).self) { group in
            for id in ids {
                group.addTask {
                    return (id, await HttpManager().getPostByID(id))
                }
            }
            
            for await back in group {
                res[back.0] = back.1
            }
        }
        //確保順序對
        var posts : [Post] = []
        for id in ids{
            posts.append(res[id]!)
        }
        return posts
    }
    
    public static func getPostWithCommentByIds(ids: [Int]) async -> [Int:[Comment]]{
        var res : [Int:[Comment]] = [:];
        await withTaskGroup(of: (Int, [Comment]).self) { group in
            for id in ids {
                group.addTask {
                    return (id, await HttpManager().getPostWithCommentById(id))
                }
            }
            
            for await back in group {
                res[back.0] = back.1
            }
        }
        return res
    }
}
