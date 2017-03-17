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
            let range = NSRange(location: match.range.location+type.startIndex, length: match.range.length + type.tenderLength)
            let word = nsstring.substring(with: range)
            guard word.utf16.count > 0 else {continue}
            elementTupleArr.append((match.range,YLElements.creat(with: type, text: word),type))
        }
        return elementTupleArr
    }
}
