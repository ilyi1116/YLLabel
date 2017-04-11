//
//  YLLabelType.swift
//  YLLabelDemo
//
//  Created by yinlong on 2017/2/20.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

public enum  YLLabelType {
    // #话题#
    case hashtag
    // @用户名
    case mention
    // URL
    case URL
    
    case custom(pattern:String)
    
    var pattern : String {
        switch self {
        case .hashtag   : return YLLabelRegex.hashtagPattern
        case .mention   : return YLLabelRegex.mentionPattern
        case .URL       : return YLLabelRegex.URLPattern
        case .custom(let pattern) : return pattern
        }
    }
    var tenderLength: Int {
        switch self {
        case .hashtag   : return -2
        case .mention   : return -1
        case .URL       : return 0
        case .custom    : return 0
        }
    }
    
    var startIndex: Int {
        switch self {
        case .URL,.custom:
            return 0
        case .mention,.hashtag:
            return 1
        }
    }
    
}
/* 枚举关联值 */
enum YLElements{
    
    case hashtag(String)
    case mention(String)
    case URL(String)
    case custom(String)
    
    static func creat(with type : YLLabelType, text : String) -> YLElements {
        switch type {
        case .hashtag   :return hashtag(text)
        case .mention   :return mention(text)
        case .URL       :return URL(text)
        case .custom    :return custom(text)
        }
    }
}

/*
 Swift的所有基本类型（形如String，Int，Double，Bool）默认是可哈希化的，可以作为集合的值的类型或者字典的键的类型。
 没有关联值的枚举成员值默认也是可哈希化的。
 http://www.jianshu.com/p/5eb7c02f82d3
 */
extension YLLabelType : Hashable, Equatable{
    public var hashValue : Int {
        switch self {
        case .hashtag   : return -3
        case .mention   : return -2
        case .URL       : return -1
        case .custom(let pattern) : return pattern.hashValue
        }
    }
}
/*
 对于 == 的实现我们并没有像实现其他一些协议一样将其放在对应的 extension里,
 而是放在了全局,因为你应该需要在全局范围内都能使用 ==
 (上面这段话来自 Swift 开发必备100个tips)
 */
public func == (lhs: YLLabelType, rhs: YLLabelType) -> Bool {
    
    switch (lhs, rhs) {
    case (.mention, .mention): return true
    case (.hashtag, .hashtag): return true
    case (.URL, .URL): return true
    case (.custom(let pattern1), .custom(let pattern2)): return pattern1 == pattern2
    default: return false
    }
}


