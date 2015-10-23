//
//  LinkTextView.swift
//  LinkTextView
//
//  Created by shoji on 2015/10/23.
//  Copyright © 2015年 vasily.jp. All rights reserved.
//

import UIKit

class LinkTextView: UITextView {

    static let LinkKey = "LinkKey"
    var linkClickedBlock: ((string: String) -> Void)?
    private var selectedStringRange: NSRange?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        editable = false
        selectable = false
        scrollEnabled = false

        let recognizer = TouchUpDownGestureRecognizer(target: self, action: "handleTouchUpDownGesture:")
        addGestureRecognizer(recognizer)
    }
}


// MARK: - public

extension LinkTextView {

    func handleTouchUpDownGesture(recognizer: TouchUpDownGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            touchDownWithRecognizer(recognizer)
        case .Changed:
            break
        case .Ended:
            touchUpWithRecognizer(recognizer)
        default:
            touchCancelWithRecognizer(recognizer)
        }
    }
}


// MARK: - private

extension LinkTextView {

    private func touchDownWithRecognizer(recognizer: TouchUpDownGestureRecognizer) {
        if let range = selectedLinkRangeWithRecognizer(recognizer) {
            selectedStringRange = range
            // リンクをタップした場合はハイライトさせる
            attributedText = attributedText(range: range, highlighted: true)
            setNeedsDisplay()
        }
    }

    private func touchUpWithRecognizer(recognizer: TouchUpDownGestureRecognizer) {
        if let selectedStringRange = selectedStringRange, linkClickedBlock = linkClickedBlock {
            let string = (attributedText.string as NSString).substringWithRange(selectedStringRange)
            linkClickedBlock(string: string)
        }

        if let range = selectedStringRange {
            // ハイライトした文字列を戻す
            attributedText = attributedText(range: range, highlighted: false)
            setNeedsDisplay()
        }
        selectedStringRange = nil
    }

    private func touchCancelWithRecognizer(recognizer: TouchUpDownGestureRecognizer) {
        if let range = selectedStringRange {
            // ハイライトした文字列を戻す
            attributedText = attributedText(range: range, highlighted: false)
            setNeedsDisplay()
        }
        selectedStringRange = nil
    }

    /**
     選択したリンク文字列のrangeを返す

     - parameter recognizer: ジェスチャーレコグナイザ

     - returns: タップしたリンク文字列のNSRange。リンク出ない場合はnil
     */
    private func selectedLinkRangeWithRecognizer(recognizer: TouchUpDownGestureRecognizer) -> NSRange? {
        var location = recognizer.locationInView(self)
        location.y -= textContainerInset.top    // タッチ位置がtextContainerInsetの分だけズレるので調整
        location.x -= textContainerInset.left

        let characterIndex = layoutManager.characterIndexForPoint(  // タッチした位置の文字列のindex
            location,
            inTextContainer: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)

        // 指定した位置と属性に該当するリンク文字列のNSRangeをrangeに格納する
        var range = NSMakeRange(0, 0)
        let object = attributedText.attribute(
            LinkTextView.LinkKey,
            atIndex: characterIndex,
            effectiveRange: &range)

        return (object == nil) ? nil : range
    }

    private func attributedText(range range: NSRange, highlighted: Bool) -> NSAttributedString {
        var attributes = attributedText.attributesAtIndex(range.location, effectiveRange: nil)
        let mutableAttributedString = attributedText.mutableCopy() as! NSMutableAttributedString
        let color = highlighted ? UIColor.redColor() : UIColor.blueColor()
        attributes[NSForegroundColorAttributeName] = color
        mutableAttributedString.setAttributes(attributes, range: range)
        return mutableAttributedString
    }
}
