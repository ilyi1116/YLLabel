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
    
    open var enabledTypes: [YLLabelType] = [.hashtag]

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
    fileprivate var drawBeginY : CGFloat = 0
    
    // 重要属性
    lazy var elementDict = [YLLabelType: [ElementTuple]]()
    
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
        isUserInteractionEnabled = true
    }
    
    fileprivate func updateTextStorage(updateString: Bool = true) {
        
        guard let text = text else {
            fatalError()
        }
        
        let mutAttrString = NSMutableAttributedString(string: text)
        
        if updateString {
            print(mutAttrString.string)
            
            //var attributes = [String:Any]()
            //attributes[NSForegroundColorAttributeName] = UIColor.red
            //mutAttrString.setAttributes(attributes, range: NSRange(location: 2, length: 2))
            
            getAttributesAndElements(mutAttrString)
        }
        
        addPatternAttributes(mutAttrString)
        
        textStorage.setAttributedString(mutAttrString)
        
        setNeedsDisplay()
        
    }
    /// 核心方法,配置elementDict
    fileprivate func getAttributesAndElements(_ mutAttrString :NSMutableAttributedString){
        
        let text = mutAttrString.string
        let range = NSRange(location: 0, length: text.characters.count)
        let nsstring = text as NSString
        var elementTupleArr = [ElementTuple]()
        
        for type in enabledTypes {
            
            // 1.创建规则
            let pattern = type.pattern
            // 2.利用规则创建一个正则表达式对象
            let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            // 从指定字符串中取出所有匹配规则的字符串的结果集
            let matches = regex.matches(in: text, options: [], range: range)
            
            for match in matches {
                let range = NSRange(location: match.range.location+1, length: match.range.length-2)
                let word = nsstring.substring(with: range)
                print(word)
                elementTupleArr.append((match.range,YLElements.creat(with: type, text: word)))
            }
            
            elementDict[type] = elementTupleArr
        }
    }
    /// 给目标字符串添加文字属性
    fileprivate func addPatternAttributes(_ mutAttrString :NSMutableAttributedString){
        
        var range = NSRange(location: 0, length: 0)
        //给指定索引的字符返回属性
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)
        
        for (type,elements) in elementDict {
            switch type {
            case .hashtag: attributes[NSForegroundColorAttributeName] = hashtagColor
            }
            
            for element in elements {
                mutAttrString.setAttributes(attributes, range: element.range)
            }
        }
        
    }
    
    // MARK: - drawText
    override func drawText(in rect: CGRect) {
        
        let range = NSRange(location: 0, length: textStorage.length)
        
        let newRect = layoutManager.usedRect(for: textContainer)
        
        drawBeginY = (rect.size.height - newRect.size.height) / 2
        
        let newOrigin = CGPoint(x: rect.origin.x, y: drawBeginY)
        
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
    // MARK: - touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touch = touches.first else {
            return
        }
        
        var location = touch.location(in: self)
        location.y -= drawBeginY
        
        print(location as Any)
        
        let textRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        
        print(textRect as Any)
        
        guard textRect.contains(location) else {
            return
        }
        print("点击到了文字")
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        print("index = \(index)")
        
        //elementDict = ["key":[elementTuple]] $0.1 = [elementTuple]
        for elementTuples in elementDict.map({ $0.1 }){
            
            for elementTuple in elementTuples {
                
                if index > elementTuple.range.location &&
                    index < elementTuple.range.location + elementTuple.range.length{
                    
                    print("点击到了我想要的文字")
                }
            }
        }
    }
}


