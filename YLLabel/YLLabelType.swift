//
//  YLLabelType.swift
//  YLLabelDemo
//
//  Created by yinlong on 2017/2/20.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

enum  YLLabelType {
    case hashtag
    
    var Regex : String {
        switch self {
        case .hashtag:
            
            return YLLabelRegex.hashtagRegex
            
        }
    }
    
}
/* 枚举关联值 */
enum YLElements{
    
    case hashtag(String)
    
    static func creat(with type : YLLabelType, text : String) -> YLElements {
        switch type {
        case .hashtag:
            return hashtag(text)
        }
    }
    
    
    
}


