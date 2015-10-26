//
//  SecondViewController.swift
//  LinkTextView
//
//  Created by shoji on 2015/10/23.
//  Copyright © 2015年 vasily.jp. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet private var textViews: [LinkTextView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }

    private func setupTextView() {

        let linkKeywords = ["#ロゴ", "#ロゴニット", "#チュールスカート", "#ダッフルコート", "#スニーカー", "#コーデュロイ", "#ファーバッグ", "#クラッチバッグ", "#時計", "#アースカラー"]

        let attributes = [
            NSForegroundColorAttributeName: UIColor.blueColor(),
            LinkTextView.LinkKey: "linked",
        ]


        for textView in textViews {

            // TextViewにリンクを設定
            let string = textView.attributedText.string
            let mutableAttributedString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
            for keyword in linkKeywords {
                let range = (string as NSString).rangeOfString(keyword)
                mutableAttributedString.addAttributes(attributes, range: range)
            }
            textView.attributedText = mutableAttributedString

            textView.linkClickedBlock = { [weak self] (string: String) in
                // タップした文字列をアラート表示
                let alertController = UIAlertController(title: string, message: nil, preferredStyle: .Alert)
                let action = UIAlertAction(title: "close", style: .Cancel, handler: nil)
                alertController.addAction(action)
                self?.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
