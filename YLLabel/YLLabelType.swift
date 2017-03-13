//
//  YLLabelType.swift
//  YLLabelDemo
//
//  Created by yinlong on 2017/2/20.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

enum  YLLabelType {
    // #话题#
    case hashtag
    // @用户名
    case mention
    
     var pattern : String {
        switch self {
        case .hashtag: return YLLabelRegex.hashtagPattern
        case .mention: return YLLabelRegex.mentionPattern
        }
    }
    
}
/* 枚举关联值 */
enum YLElements{
    
    case hashtag(String)
    case mention(String)
    
    static func creat(with type : YLLabelType, text : String) -> YLElements {
        switch type {  
        case .hashtag:return hashtag(text)
        case .mention:return mention(text)
        }
    }
    
    
    
}


extension YLLabelType : Hashable {
    public var hashValue : Int {
        switch self {
        case .hashtag : return -2
        case .mention : return -1
        }
    }
}
