//
//  MySDKTests.swift
//  MySDKTests
//
//  Created by liyuan chang on 2023/11/3.
//

import XCTest
@testable import MySDK

final class MySDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllPosts() async throws {
        let posts = await MySDKManager.getAllPosts()
        XCTAssertNotNil(posts)
        guard let posts = posts else { return }
        XCTAssertNotEqual(posts.count, 0)
        for post in posts{
            XCTAssertNotEqual(post.title, "")
            XCTAssertNotEqual(post.body, "")
            XCTAssertNotEqual(post.id, -1)
            XCTAssertNotEqual(post.userID, -1)
        }
    }
    
    func testGetPostByIds() async throws {
        let ids = generateRandomNumbers(10, 1...100)
        let posts = await MySDKManager.getPostByIds(ids: ids)
        XCTAssertEqual(posts.count, 10)
        for post in posts{
            XCTAssertNotEqual(post.title, "")
            XCTAssertNotEqual(post.body, "")
            XCTAssertNotEqual(post.id, -1)
            XCTAssertNotEqual(post.userID, -1)
        }
    }
    
    func testGetPostWithCommentByIds() async throws {
        let ids = generateRandomNumbers(10, 1...100)
        let commentlists = await MySDKManager.getPostWithCommentByIds(ids: ids)
        XCTAssertEqual(commentlists.count, 10)
        for id in ids{
            XCTAssertNotNil(commentlists[id])
            guard let comments = commentlists[id] else { return }
            for comment in comments{
                XCTAssertNotEqual(comment.name, "")
                XCTAssertNotEqual(comment.email, "")
                XCTAssertNotEqual(comment.body, "")
                XCTAssertNotEqual(comment.id, -1)
                XCTAssertNotEqual(comment.postID, -1)
            }
        }
    }
    
    func generateRandomNumbers(_ count: Int,_ range: ClosedRange<Int>) -> [Int] {
        var uniqueNumbers = Set<Int>()
        
        while uniqueNumbers.count < count {
            let randomValue = Int.random(in: range)
            uniqueNumbers.insert(randomValue)
        }
        
        return Array(uniqueNumbers)
    }
}
