# YLLabel
UILabe 子类 -- 支持 Hashtags (#), Mentions (@) 和 URLs (http://) written in Swift3



# 使用效果



![使用效果](https://github.com/CoderYLZhang/YLLabel/blob/master/Demo/img/%E4%BD%BF%E7%94%A8%E6%95%88%E6%9E%9C.gif)



# Demo 代码

现在支持下面这些属性,会拓展其他的实用属性

```swift
label.text = "#YLLabel# 用于匹配字符串中的相关内容,地址: https://github.com/CoderYLZhang/YLLabel 作者@CoderYLZhang"
        
label.font = UIFont.systemFont(ofSize: CGFloat((fone.text! as NSString).doubleValue))
label.textAlignment = .left
label.lineSpacing = CGFloat((lineSpacing.text! as NSString).doubleValue)
label.numberOfLines = (numOfLine.text! as NSString).integerValue
        
label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
label.URLColor = UIColor.blue

// 标签(##) 点击事件
label.handleHashtagTap { (string) in
	self.alert("标签", message: string)
}
//label.hashtagTapHandler = {(string) in
//	self.alert("标签", message: string)
//}
// 提醒(@) 点击事件
label.handleMentionTap { (string) in
	self.alert("提醒", message: string)
}
//label.mentionTapHandler = {(string) in
//	self.alert("提醒", message: string)
//}
// URL 点击事件
label.handleURLTap { (string) in
	self.alert("URL", message: string)
}
//label.URLTapHandler = {(string) in
//	self.alert("URL", message: string)
//}



```



### 属性解释

| 属性                | 类型                 | 作用                     |
| :---------------- | :----------------- | ---------------------- |
| enabledTypes      | [YLLabelType]      | 用户可定义,需要高亮的类型          |
| hashtagColor      | UIColor            | 标签(##)  显示的颜色 :默认 blue |
| mentionColor      | UIColor            | 提醒(@)  显示的颜色:默认 blue   |
| URLColor          | UIColor            | URL  显示的颜色:默认 blue     |
| text              | String             | 需要显示的文本                |
| attributedText    | NSAttributedString | 需要显示的富文本               |
| font              | UIFont             | 所有文本的字体                |
| textColor         | UIColor            | 普通文本的颜色                |
| textAlignment     | NSTextAlignment    | 对齐方式:默认左               |
| numberOfLines     | Int                | 行数:默认1                 |
| lineSpacing       | paragraphSpacing   | 行高:默认0                 |
| hashtagTapHandler | ((String) -> ())?  | 标签(##)  点击事件           |
| mentionTapHandler | ((String) -> ())?  | 提醒(@)  点击事件            |
| URLTapHandler     | ((String) -> ())?  | URL  点击事件              |
|                   |                    |                        |
|                   |                    |                        |
|                   |                    |                        |
|                   |                    |                        |
|                   |                    |                        |



# 即将登场

-[ ] 自定义类型


-[ ] 选中状态颜色



## 感谢您的使用,欢迎 提供宝贵意见

## 欢迎  star issue fork

















