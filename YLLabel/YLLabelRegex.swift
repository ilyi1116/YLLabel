//
//  YLRegex.swift
//  YLLabelDemo
//
//  Created by yinlong on 2017/2/20.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import Foundation

struct YLLabelRegex {
    
    static let hashtagPattern = "#[^#]+#"
    static let mentionPattern = "@[\\p{L}0-9_]*"
    
    
    static func getMatches(type: YLLabelType, frome textString:String,range: NSRange)-> [NSTextCheckingResult]{
        
        // 1.创建规则
        let pattern = type.pattern
        // 2.利用规则创建一个正则表达式对象
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        // 从指定字符串中取出所有匹配规则的字符串的结果集
        let matches = regex.matches(in: textString, options: [], range: range)
        
        return matches
    }
    
    
    
    
    
}
