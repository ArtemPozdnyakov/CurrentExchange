//
//  ExchangeView.swift
//  ExchangeRates
//
//  Created by admin on 6/12/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//
import PinLayout
import UIKit
import Lottie

protocol ExchangeView: UIView {
    var numberValueUser: UITextField { get }
    var picker: UIPickerView { get }
    func pickerSelected(flag: Bool)
    func bind(model: VisualModel)
    var go2VCButton: UIButton { get }
}

struct VisualModel {
    let valueName: String
    let fullName: String
    let exchangeValue: String
}



final class ExchangeViewImpl: UIView, ExchangeView {
    
    
    // MARK: - header
    
    private let header: UIView = {
        return $0
    }(UIView())
    
    private let topNameValeu: UILabel = {
        $0.textColor = .idealYellow()
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let numberValueUser: UITextField = {
        $0.backgroundColor = .idealGrey()
        $0.textColor = .turquoise()
        $0.keyboardType = .numberPad
        $0.attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.idealGrey()])
        $0.placeholder = "Enter sum..."
        $0.layer.cornerRadius = 10
        return $0
    }(UITextField())
    
    private let russianTopName: UILabel = {
        $0.textColor = .idealGrey()
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let exchangeValue: UILabel = {
        $0.textColor = .turquoise()
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
     private let welcomLable: UILabel = {
        $0.textColor = .turquoise()
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
    // MARK: - PickerView
    
    let picker: UIPickerView = {
        return $0
    }(UIPickerView())
    
    
    let go2VCButton: UIButton = {
        $0.backgroundColor = .turquoise()
        $0.setTitleColor(.idealBlack(), for: .normal)
        $0.setTitle("Currency exchange", for: .normal)
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton())
    
    
    private let animationLoading = AnimationView()
    private let animationWelcom = AnimationView()
    private var flag = false
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if flag == false {
            setupWelcomAnimation()
        } else {
            if welcomLable.isHidden {
                pickerSelected(flag: flag)
            }
        }
    }
    
    private func initViews() {
        backgroundColor = .idealBlack()
        let safe = pin.safeArea
        
        header.pin(to: self).top(safe + 100).horizontally(safe + 15)
        if welcomLable.isHidden {
            topNameValeu.pin(to: header).top().horizontally().sizeToFit(.width)
            numberValueUser.pin(to: header).below(of: topNameValeu).marginTop(10).horizontally(5).height(35) 
            russianTopName.pin(to: header).below(of: numberValueUser).marginTop(10).horizontally().sizeToFit(.width)
            exchangeValue.pin(to: header).below(of: russianTopName).marginTop(10).horizontally().sizeToFit(.width)
            flag = true
        } else {
            welcomLable.pin(to: header).top().horizontally().sizeToFit(.width)
        }
        header.pin.wrapContent(.vertically)
        
        picker.pin(to: self).below(of: header).marginTop(100).hCenter().height(200).width(frame.width)
        go2VCButton.pin(to: self).below(of: picker).marginTop(65).hCenter().height(30).width(230)
    }
    
    func pickerSelected(flag: Bool) {
         welcomLable.text = "Выберете валюту"
        welcomLable.isHidden = flag
        topNameValeu.isHidden = !flag
        numberValueUser.isHidden = !flag
        russianTopName.isHidden = !flag
        exchangeValue.isHidden = !flag
        go2VCButton.isHidden = !flag
        
        initViews()
    }
    
    func bind(model: VisualModel) {
        topNameValeu.text = model.valueName
        russianTopName.text = model.fullName
        exchangeValue.text = model.exchangeValue + " рублей"
    }
    
    private func setupWelcomAnimation() {
        animationWelcom.animation = Animation.named("convertManey")
        animationWelcom.frame = self.bounds
        animationWelcom.backgroundColor = .idealBlack()
        animationWelcom.contentMode = .scaleAspectFit
        animationWelcom.play {_ in
            self.animationWelcom.isHidden = true
            self.pickerSelected(flag: false)
            self.flag = true
        }
        self.addSubview(animationWelcom)
    }


    private func setupAnimation () {
        animationLoading.animation = Animation.named("loading")
        animationLoading.frame = bounds
        animationLoading.backgroundColor = .idealBlack()
        animationLoading.contentMode = .scaleAspectFit
        animationLoading.loopMode = .loop
        animationLoading.play()
        self.addSubview(animationLoading)
    }
    
}
