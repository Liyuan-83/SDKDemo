//
//  ContentView.swift
//  MySDKDemo
//
//  Created by liyuan chang on 2023/11/3.
//

import SwiftUI
import MySDK

struct ContentView: View {
    @State private var items: [Post] = []
    @State private var comments:[Int:[Comment]] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(items.enumerated()), id: \.1.self) { index, item in
                    VStack(alignment: .leading){
                        Text("\(index+1)." + item.title)
                            .font(.system(.title))
                            .lineLimit(1)
                        Text(item.body)
                            .font(.system(size: 12))
                        if let comments = comments[item.id]{
                            Text("comments : \(comments.count)")
                                .font(.system(size: 12))
                        }
                    }
                    
                        .onAppear {
                            if item == self.items.last {
                                self.loadMoreData()
                            }
                        }
                }
            }
            .navigationTitle("Infinite Scroll List")
            .onAppear {
                self.loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        let newItemIndexs = (items.count + 1...items.count + 10).map { $0 % 100 }
        Task {
            let newItems =  await MySDKManager.getPostByIds(ids:  newItemIndexs)
            DispatchQueue.main.async {
                self.items.append(contentsOf: newItems)
            }
            let newComment = await MySDKManager.getPostWithCommentByIds(ids: newItems.map({ $0.id }))
            DispatchQueue.main.async {
                self.comments.merge(newComment){ (_, new) in new }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
