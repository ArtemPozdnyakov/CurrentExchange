//
//  UIViewExt.swift
//  ExchangeRates
//
//  Created by admin on 6/12/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import UIKit
import PinLayout
//
extension UIView {
    func pin(to addView: UIView) -> PinLayout<UIView> {
        if !addView.subviews.contains(self) {
            addView.addSubview(self)
        }
        return self.pin
    }
}
