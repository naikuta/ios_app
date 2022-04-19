//
//  Gesture.swift
//  TimerAndStats
//
//  Created by iku on 2022/03/21.
//

import UIKit

class Gesture: UIImageView, UIGestureRecognizerDelegate {


    // MARK: ------------------------------ UIGestureRecognizer
    ///
    /// コールバック関数
    ///
    private var _singleTapAction: ((_ g: UITapGestureRecognizer) -> Void)?
    ///
    /// シングルタップ設定
    ///
    func singleTap(_ action: ((_ g: UITapGestureRecognizer) -> Void)?) {
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(Gesture._singleTapSelector(_:))
        )
        singleTapGesture.delegate = self
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(singleTapGesture)
        self._singleTapAction = action
    }
    ///
    /// selector用
    ///
    @objc private func _singleTapSelector(_ g: UITapGestureRecognizer) {
        self._singleTapAction?(g)
    }

}
