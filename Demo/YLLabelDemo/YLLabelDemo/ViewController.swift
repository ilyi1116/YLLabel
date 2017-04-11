//
//  ViewController.swift
//  YLLabelDemo
//
//  Created by 张银龙 on 2017/2/18.
//  Copyright © 2017年 张银龙. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: YLLabel!
    @IBOutlet weak var numOfLine: UITextField!
    @IBOutlet weak var lineSpacing: UITextField!
    @IBOutlet weak var fone: UITextField!
    @IBOutlet weak var custom: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customType = YLLabelType.custom(pattern: "用于匹")
        label.enabledTypes.append(customType)
    
        
        
        label.font = UIFont.systemFont(ofSize: CGFloat((fone.text! as NSString).doubleValue))
        label.textAlignment = .left
        label.lineSpacing = CGFloat((lineSpacing.text! as NSString).doubleValue)
        label.numberOfLines = (numOfLine.text! as NSString).integerValue
        
        label.textColor = UIColor.black
        label.hashtagColor = UIColor.blue
        label.hashtagSelectColor = UIColor.blue.withAlphaComponent(0.5)
        label.mentionColor = UIColor.brown
        label.mentionSelectColor = UIColor.brown.withAlphaComponent(0.5)
        label.URLColor = UIColor.cyan
        label.URLSelectColor = UIColor.cyan.withAlphaComponent(0.5)
        label.customColor[customType] = UIColor.red
        //label.customSelectColor[customType] = UIColor.red.withAlphaComponent(0.5)
        
        // label.paragraphSpacing = 18
        
        label.text = "#YLLabel# 用于匹配字符串中的相关内容,地址: https://github.com/CoderYLZhang/YLLabel 作者@CoderYLZhang"
        
        
        // 标签(##) 点击事件
        label.handleHashtagTap { (string) in
            self.alert("标签", message: string)
        }
//        label.hashtagTapHandler = {(string) in
//            self.alert("标签", message: string)
//        }
        
        // 提醒(@) 点击事件
        label.handleMentionTap { (string) in
            self.alert("提醒", message: string)
        }
//        label.mentionTapHandler = {(string) in
//            self.alert("提醒", message: string)
//        }
        
        // URL 点击事件
        label.handleURLTap { (string) in
            self.alert("URL", message: string)
        }
//        label.URLTapHandler = {(string) in
//            self.alert("URL", message: string)
//        }
        
        // 自定义 点击事件
        label.handleCustomTap(customType, handler: { (string) in
            self.alert("customType", message: string)
        })
    }


    @IBAction func showButtonClick(_ sender: UIButton) {
        let customType = YLLabelType.custom(pattern: custom.text!)
        label.enabledTypes.remove(at: label.enabledTypes.count-1)
        label.enabledTypes.append(customType)
        label.customColor[customType] = UIColor.red
        label.font = UIFont.systemFont(ofSize: CGFloat((fone.text! as NSString).doubleValue))
        label.lineSpacing = CGFloat((lineSpacing.text! as NSString).doubleValue)
        label.numberOfLines = (numOfLine.text! as NSString).integerValue
        label.text = textView.text
        label.handleCustomTap(customType, handler: { (string) in
            self.alert("customType", message: string)
        })
    }

    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
}





