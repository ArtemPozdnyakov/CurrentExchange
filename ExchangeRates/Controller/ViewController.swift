//
//  ViewController.swift
//  Exchange Rates
//
//  Created by admin on 6/3/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie

class ViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pickerLeft: UIPickerView!
    @IBOutlet weak var lableLeft: UILabel!
    @IBOutlet weak var lableRaith: UILabel!
    @IBOutlet weak var leftTextField: UITextField!

    @IBOutlet weak var leftName: UILabel!
    @IBOutlet weak var welcomLable: UILabel!
    
    let animationLoading = AnimationView()
    let animationWelcom = AnimationView()
    
    
    
    @IBOutlet weak var go2VCButton: UIButton!
    @IBAction func goTwoVC(_ sender: UIButton) {
        
    }
    
    
    
    
    
    let net = NetworkRequest()
    var item: Double = 0
    var item2: Double = 0
    
    var arrValue: [String: Double] = [:]
    var fullName: [String: String] = [:]
    
    var arr1: [String] = []
    var arr2: [Double] = []
    var const = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomAnimation()
        animationWelcom.play() { finished in
            self.animationWelcom.isHidden = true
            self.setupAnimation ()
            self.first()
            self.net.getCourse()
            self.net.delegate = self
            self.leftTextField.addTarget(self, action: #selector(self.text(textField:)), for: .editingChanged)
            let hideKeyBoard = UITapGestureRecognizer(target: self, action: #selector(self.hideAction))
            self.view.addGestureRecognizer(hideKeyBoard)
        }
        
    }
    
    private func setupWelcomAnimation() {
        animationWelcom.animation = Animation.named("convertManey")
        animationWelcom.frame = view.bounds
        animationWelcom.backgroundColor = .idealBlack()
        animationWelcom.contentMode = .scaleAspectFit
        view.addSubview(animationWelcom)
    }
    
    
    private func setupAnimation () {
        animationLoading.animation = Animation.named("loading")
        animationLoading.frame = view.bounds
        animationLoading.backgroundColor = .idealBlack()
        animationLoading.contentMode = .scaleAspectFit
        animationLoading.loopMode = .loop
        animationLoading.play()
        view.addSubview(animationLoading)
    }

    
    
    @objc func hideAction(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func first() {
        welcomLable.text = "Выберете валюту"
        leftTextField.isHidden = true
        lableLeft.isHidden = true
        lableRaith.isHidden = true
        leftName.isHidden = true
        pickerLeft.delegate = self
        pickerLeft.dataSource = self
        buttonSetting()
        
    }
    
    func buttonSetting() {
        go2VCButton.isHidden = true
        go2VCButton.layer.cornerRadius = CGFloat(8)
        go2VCButton.backgroundColor = .turquoise()
        go2VCButton.tintColor = .idealGrey()
        go2VCButton.setTitle("Currency exchange", for: .normal)
    }
    
    
    @objc func text(textField: UITextField) {
        if leftTextField.text != "" {
        var value = leftTextField.text
        guard let number = Double(value!) else { return }
            item2 = number
            const = "\((number * item).rounded()) рублей"
            lableRaith.text = const
        } else {
            lableRaith.text = "\(item.rounded()) рублей"
        }
    }
    
    func asdc(array: [String: Double]) {
        for (_, j) in arrValue.enumerated() {
            arr1.append(j.key)
        }
    }
    
    func asdc2(array: [String: Double]) {
        for (_, j) in arrValue.enumerated() {
            arr2.append(j.value)
        }
    }
}











extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return arr1.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return arr1[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        leftTextField.isHidden = false
        lableLeft.isHidden = false
        lableRaith.isHidden = false
        leftName.isHidden = false
        welcomLable.isHidden = true
        go2VCButton.isHidden = false
        
        lableLeft.text = "\(arr1[row])"
        if leftTextField.text == "" {
        lableRaith.text = "\((arr2[row]).rounded()) рублей"
        } else {
            lableRaith.text = "\((item2 * arr2[row]).rounded()) рублей"
        }
        leftName.text = fullName[arr1[row]]
        item = arr2[row]
        
        
      
    }



    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerViewLavle = UILabel()

        if let currentLable = view as? UILabel {
            pickerViewLavle = currentLable
        } else {
            pickerViewLavle = UILabel()
        }


        pickerViewLavle.textColor = #colorLiteral(red: 0.968627451, green: 0.631372549, blue: 0, alpha: 1)
        pickerViewLavle.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30)
        pickerViewLavle.textAlignment = .center

        pickerViewLavle.text = arr1[row]
        return pickerViewLavle
    }
}

extension ViewController: NetworkWetherDelegate {
    func updateInterface(_: NetworkRequest, with currentWeather: CourseModel) {
        animationLoading.stop()
        animationLoading.isHidden = true
        arrValue = currentWeather.valute
        fullName = currentWeather.fullName
        asdc(array: arrValue)
        asdc2(array: arrValue)
        pickerLeft.reloadAllComponents()
    }
}





