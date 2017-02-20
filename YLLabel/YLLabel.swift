//
//  YLLabel.swift
//  YLLabelDemo
//
//  Created by 张银龙 on 2017/2/18.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

typealias ElementTuple = (range: NSRange, element: YLElements)

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
    // MARK: - public 属性
    open var hashtagColor : UIColor = .blue{
        didSet {
            
        }
    }
    
    // MARK: - override 属性
    
    /*
     1.显示高亮主要是正则表达式的运用
     2.点击方法为touchBegan
     3.点击判定为coreText的运用。
     */
    override open var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    // MARK: - 私有属性
    /*
     NSTextStorage保存并管理UITextView要展示的文字内容，该类是NSMutableAttributedString的子类，由于可以灵活地往文字添加或修改属性，所以非常适用于保存并修改文字属性。
     NSLayoutManager用于管理NSTextStorage其中的文字内容的排版布局。
     NSTextContainer则定义了一个矩形区域用于存放已经进行了排版并设置好属性的文字。
     以上三者是相互包含相互作用的层次关系。
     NSTextStorage -> NSLayoutManager -> NSTextContainer
     */
    
    fileprivate var textStorage : NSTextStorage =  NSTextStorage()
    fileprivate var layoutManager : NSLayoutManager =  NSLayoutManager()
    fileprivate var textContainer : NSTextContainer =  NSTextContainer()
    
    lazy var YLElements = [YLLabelType: [ElementTuple]]()
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    // MARK: - 私有方法
    
    fileprivate func setupLabel()  {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
    }
    
    fileprivate func updateTextStorage(resetText: Bool = true) {
        
        guard let text = text else {
            fatalError()
        }
        
        let mutAttrString = NSMutableAttributedString(string: text)
        
        if resetText {
            print(mutAttrString.string)
            
            
        }
    }
}
