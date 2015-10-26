//
//  FirstViewController.swift
//  LinkTextView
//
//  Created by shoji on 2015/10/23.
//  Copyright © 2015年 vasily.jp. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet private var textViews: [UITextView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }

    private func setupTextView() {

        let linkKeywords = ["#ロゴ", "#ロゴニット", "#チュールスカート", "#ダッフルコート", "#スニーカー", "#コーデュロイ", "#ファーバッグ", "#クラッチバッグ", "#時計", "#アースカラー"]

        let url = NSURL(string: "http://google.co.jp")!
        for textView in textViews {
            let string = textView.attributedText.string
            let mutableAttributedString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
            for keyword in linkKeywords {
                let range = (string as NSString).rangeOfString(keyword)
                mutableAttributedString.addAttribute(NSLinkAttributeName, value: url, range: range)
            }
            textView.attributedText = mutableAttributedString
        }
    }
}
