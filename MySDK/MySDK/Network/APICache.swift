//
//  APICache.swift
//  MySDK
//
//  Created by liyuan chang on 2023/11/6.
//

import Foundation

final class APICache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    
    init(entryLifetime: TimeInterval = 12 * 60 * 60,
         dateProvider: @escaping () -> Date = Date.init) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
    }
    
    func insert(_ value: Value, forKey key:Key){
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        
        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    subscript(key: Key) -> Value?{
        get{ return value(forKey: key) }
        set{
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

private extension APICache{
    final class WrappedKey : NSObject{
        let key : Key
        
        init(_ key:Key) {
            self.key = key
        }
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else{ return false }
            return value.key == key
        }
    }
    
    final class Entry{
        let value : Value
        let expirationDate: Date
        
        init(value: Value, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}