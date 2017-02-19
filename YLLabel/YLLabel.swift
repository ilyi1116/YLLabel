//
//  YLLabel.swift
//  YLLabelDemo
//
//  Created by 张银龙 on 2017/2/18.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

class YLLabel: UILabel {

    /*
     访问控制
     1，private      访问级别所修饰的属性或者方法只能在当前类里访问。
     2，fileprivate  访问级别所修饰的属性或者方法在当前的Swift源文件里可以访问
     3，internal     (默认访问级别，internal修饰符可写可不写),internal访问级别所修饰的属性或方法在源代码所在的整个模块都可以访问。如果是框架或者库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可以访问。如果是App代码，也是在整个App代码，也是在整个App内部可以访问。
     4，public       可以被任何人访问。但其他module中不可以被override和继承，而在module内可以被override和继承。
     5，open         可以被任何人使用，包括override和继承。
     从高到低排序如下：
     open > public > interal > fileprivate > private
     */
    
    
    // MARK: - 属性
    
    /*
     1.显示高亮主要是正则表达式的运用
     2.点击方法为touchBegan
     3.点击判定为coreText的运用。
     */
    override open var text: String? {
        didSet {
            
        }
    }
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

}
