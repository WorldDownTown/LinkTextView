//
//  TouchUpDownGestureRecognizer.swift
//  LinkTextView
//
//  Created by shoji on 2015/10/23.
//  Copyright © 2015年 vasily.jp. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TouchUpDownGestureRecognizer: UIGestureRecognizer {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)

        state = .Began
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)

        if let touch = touches.first {
            let beforePoint = touch.previousLocationInView(view)
            let afterPoint = touch.locationInView(view)
            if !CGPointEqualToPoint(beforePoint, afterPoint) {
                // タッチした指が動いたらキャンセル
                // 3D Touch 対応端末では touch.force の変化でも touchesMoved:withEvent: が呼ばれてしまうので、厳密にtouchの位置の変化を監視する
                state = .Cancelled
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        state = .Ended
    }

    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)

        state = .Cancelled
    }

    override func canPreventGestureRecognizer(preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = preventedGestureRecognizer.view as? UIScrollView {
            return false
        }
        return true
    }
}
