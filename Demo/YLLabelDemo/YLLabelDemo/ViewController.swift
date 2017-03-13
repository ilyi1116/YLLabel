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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Label #hhahha#"
        //label.text = "adfadfadfadfadfa#adfadfadfadf#adfadfadfadfadfadfadfadfa#adfadfaddghdghjd#\n@adfadfadf adfadfadf @adfgadfagsfgshdfghfhjf"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor  = UIColor.red
        label.textAlignment = .center
//        label.lineSpacing = 8
//        label.paragraphSpacing = 18
//        label.numberOfLines = 100
        
        label.mentionColor = UIColor.brown
        label.hashtagColor = UIColor.blue.withAlphaComponent(0.7)
        
        
        
        
        label.handleHashtagTap { (string) in
            self.alert("标签", message: string)
        }
        
        label.handleMentionTap { (string) in
            self.alert("提醒", message: string)
        }
        

    }


    @IBAction func showButtonClick(_ sender: UIButton) {
        
        
        label.text = textView.text        
    }

    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
}





