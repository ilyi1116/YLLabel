//
//  YLLabelBuilder.swift
//  YLLabelDemo
//
//  Created by yinlong on 2017/2/21.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

class YLLabelBuilder: NSObject {

    
    static func creatElementTupleArr(type: YLLabelType,from textString: String, range: NSRange) ->[ElementTuple] {
        
        var elementTupleArr = [ElementTuple]()
        let nsstring = textString as NSString
        
        let matches = YLLabelRegex.getMatches(type: type, frome: textString, range: range)
        
        for match in matches {
            let range = NSRange(location: match.range.location+1, length: match.range.length-2)
            let word = nsstring.substring(with: range)
            print(word)
            elementTupleArr.append((match.range,YLElements.creat(with: type, text: word)))
        }
        return elementTupleArr
    }
}
