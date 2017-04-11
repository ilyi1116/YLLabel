//
//  YLLabel.swift
//  YLLabelDemo
//
//  Created by 张银龙 on 2017/2/18.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

typealias ElementTuple = (range: NSRange, element: YLElements,type: YLLabelType)

class YLLabel: UILabel {
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        updateTextStorage()
    }
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
    // MARK: -  属性
    
    // MARK: 公用
    
    open var enabledTypes: [YLLabelType] = [.URL,.hashtag,.mention]
    
    open var hashtagColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var hashtagSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5) {
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var mentionColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var mentionSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5){
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var URLColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var URLSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5){
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var customColor : [YLLabelType : UIColor] = [:] {
        didSet {updateTextStorage(updateString: false)}
    }
    open var customSelectColor : [YLLabelType : UIColor] = [:] {
        didSet {updateTextStorage(updateString: false)}
    }
    
    // 标签点击事件
    internal var hashtagTapHandler: ((String) -> ())?
    // 提醒点击事件
    internal var mentionTapHandler: ((String) -> ())?
    // URL 点击事件
    internal var URLTapHandler: ((String) -> ())?
    // 自定义 点击事件
    internal var customHandler: [YLLabelType : ((String) -> ())] = [:]

    // MARK: 重写
    
    /*
     1.显示高亮主要是正则表达式的运用
     2.点击方法为touchBegan
     3.点击判定为coreText的运用。
     */
    override open var text: String? {
        didSet {updateTextStorage()}
    }
    override open var attributedText: NSAttributedString?{
        didSet {updateTextStorage()}
    }
    override open var font: UIFont! {
         didSet {updateTextStorage(updateString: false)}
    }
    override open var textColor: UIColor! {
        didSet {updateTextStorage(updateString: false)}
    }
    override open var textAlignment: NSTextAlignment {
        didSet {updateTextStorage(updateString: false)}
    }
    open override var numberOfLines: Int {
        didSet { textContainer.maximumNumberOfLines = numberOfLines }
    }
    public var lineSpacing : CGFloat = 0 { // 行间距
        didSet {updateTextStorage(updateString: false)}
    }
    public var paragraphSpacing : CGFloat = 0 { // 段间距
        didSet {updateTextStorage(updateString: false)}
    }
    // MARK: 私有属性
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
    // key   : 高亮类型 -- 话题(##) 提到(@) URL 未来可能支持自定义
    // value : 元组数组 -- 高亮文字的文字及内容
    fileprivate lazy var elementDict = [YLLabelType: [ElementTuple]]()
    
    fileprivate var selectedElementTuple : ElementTuple?
    // MARK: - 方法
    
    // MARK: 公用
    
    open func handleHashtagTap(_ handler: @escaping (String) -> ()) {
        hashtagTapHandler = handler
    }
    
    open func handleMentionTap(_ handler: @escaping (String) -> ()) {
        mentionTapHandler = handler
    }
    
    open func handleURLTap(_ handler: @escaping (String) -> ()) {
        URLTapHandler = handler
    }
    open func handleCustomTap(_ type: YLLabelType, handler: @escaping (String) -> ()) {
        customHandler[type] = handler
    }
    
    // MARK: 私有
    
    fileprivate func setupLabel()  {
        numberOfLines = 1
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        isUserInteractionEnabled = true
    }
    
    fileprivate func updateTextStorage(updateString: Bool = true) {
        
        guard let attributedText = attributedText else {return}
        
        let mutAttrString = addOrdinarilyAttributes(attributedText)
        
        if updateString {
            clearElementTupleDict()
            getElementTupleDict(mutAttrString)
        }
        
        addPatternAttributes(mutAttrString)
        textStorage.setAttributedString(mutAttrString)
        
        setNeedsDisplay()
    }
    
    fileprivate func clearElementTupleDict() {
        for (type, _) in elementDict {
            elementDict[type]?.removeAll()
        }
    }
    // 给所有字符串添加文字属性
    fileprivate func addOrdinarilyAttributes(_ attrString :NSAttributedString) -> NSMutableAttributedString {
        
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)
        
        var range = NSRange(location: 0, length: 0)
        //给指定索引的字符返回属性
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)
        attributes[NSFontAttributeName] = font
        attributes[NSForegroundColorAttributeName] = textColor
        
        let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        mutAttrString.setAttributes(attributes, range: range)
        
        return mutAttrString
    }
    /// 核心方法,配置elementDict
    fileprivate func getElementTupleDict(_ mutAttrString :NSMutableAttributedString){
        
        let textString = mutAttrString.string
        let range = NSRange(location: 0, length: textString.characters.count)
        
        for type in enabledTypes {
        
            elementDict[type] = YLLabelBuilder.creatElementTupleArr(type: type, from: textString, range: range)
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
            case .mention: attributes[NSForegroundColorAttributeName] = mentionColor
            case .URL    : attributes[NSForegroundColorAttributeName] = URLColor
            case .custom : attributes[NSForegroundColorAttributeName] = customColor[type] ?? textColor
            }
            
            for element in elements {
                mutAttrString.setAttributes(attributes, range: element.range)
            }
        }
    }
    
    fileprivate func updateWhenSelected(_ isSelected :Bool){
        guard let elementTuple = selectedElementTuple else {return}
        
        //给指定索引的字符返回属性
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        
        if isSelected {
            
            switch elementTuple.type {
                
            case .hashtag: attributes[NSForegroundColorAttributeName] = hashtagSelectColor
            case .mention: attributes[NSForegroundColorAttributeName] = mentionSelectColor
            case .URL    : attributes[NSForegroundColorAttributeName] = URLSelectColor
            case .custom :
                var color = self.customSelectColor[elementTuple.type] ?? self.customColor[elementTuple.type]
                color = color ?? textColor
                attributes[NSForegroundColorAttributeName] = color
                
            }
        }
        else{
            switch elementTuple.type {
                
            case .hashtag: attributes[NSForegroundColorAttributeName] = hashtagColor
            case .mention: attributes[NSForegroundColorAttributeName] = mentionColor
            case .URL    : attributes[NSForegroundColorAttributeName] = URLColor
            case .custom : attributes[NSForegroundColorAttributeName] = customColor[elementTuple.type] ?? textColor
            }
        }
        
        textStorage.addAttributes(attributes, range: elementTuple.range)
        setNeedsDisplay()
    }
    
    fileprivate func getSelectElementTuple(_ index: Int) -> ElementTuple? {
        
        //elementDict = ["key":[elementTuple]] $0.1 = [elementTuple]
        for elementTuples in elementDict.map({ $0.1 }){
            
            for elementTuple in elementTuples {
                
                guard index >= elementTuple.range.location else {continue}
                guard index < elementTuple.range.location + elementTuple.range.length else {continue}
                
                return elementTuple
            }
        }
        return  nil
    }
    // MARK: - drawText
    override func drawText(in rect: CGRect) {
        
        let range = NSRange(location: 0, length: textStorage.length)
        textContainer.size = rect.size// 这样得到的 newRect才是正确是尺寸
        let newRect = layoutManager.usedRect(for: textContainer)
        drawBeginY = (rect.size.height - newRect.size.height) / 2
        let newOrigin = CGPoint(x: rect.origin.x, y: drawBeginY)

        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
    // MARK: - touch
    
    fileprivate func onTouch(_ touch : UITouch) {
        
        var location = touch.location(in: self)
        location.y -= drawBeginY
        
        let textRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        
        guard textRect.contains(location) else {return}
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        let elementTuple = getSelectElementTuple(index)
        
        switch touch.phase {
        case .began,.moved:
            
            if elementTuple?.range.location != selectedElementTuple?.range.location {
                updateWhenSelected(false)
                selectedElementTuple = elementTuple
                updateWhenSelected(true)
            }
        case .ended:
            
            guard let elementTuple = elementTuple else {return}
            updateWhenSelected(false)
            switch elementTuple.element {
            case .hashtag(let hashtag)  : didTapHashtag(hashtag)
            case .mention(let mention)  : didTapMention(mention)
            case .URL(let URL)          : didTapURL(URL)
            case .custom(let custom)    : didTapCustom(elementTuple.type, custom: custom)
            }
        default: break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }
    
    /// 点击的是标签
    fileprivate func didTapHashtag(_ hashtagString : String) -> Void {
        
        guard let tapHandler = hashtagTapHandler else {return}
        tapHandler(hashtagString)
    }
    
    /// 点击的是提醒
    fileprivate func didTapMention(_ mentionString : String) -> Void {
        
        guard let tapHandler = mentionTapHandler else {return}
        tapHandler(mentionString)
    }
    /// 点击的是URL
    fileprivate func didTapURL(_ URLString : String) -> Void {
        
        guard let URLHandler = URLTapHandler else {return}
        URLHandler(URLString)
    }
    /// 点击的是自定义
    fileprivate func didTapCustom(_ type : YLLabelType,custom : String) -> Void {
        
        guard let customHandler = customHandler[type] else {return}
        customHandler(custom)
    }
}


