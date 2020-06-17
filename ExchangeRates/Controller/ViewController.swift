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
    
    private let controller: ExchangeVM
    private let mainView: ExchangeView
    var exView = ExchangeViewImpl()
    
    let animationWelcom = AnimationView()
    let animationLoading = AnimationView()
    

    
    init(mainView: ExchangeView, controller: ExchangeVM) {
        self.mainView = mainView
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        mainView.picker.delegate = self
        mainView.picker.dataSource = self
        mainView.numberValueUser.addTarget(self, action: #selector(text(textField:)), for: .editingChanged)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideAction(sender:)))
        mainView.addGestureRecognizer(gesture)
        
        controller.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.mainView.picker.reloadAllComponents()
            }
        }
        
        controller.updateValues = mainView.bind
        
        mainView.go2VCButton.addTarget(self, action: #selector(fagas), for: .touchUpInside)
     
    }
    
    @objc func fagas() {
     let vc = SearchViewController(nibName: nil, bundle: nil)
     self.navigationController?.pushViewController(vc, animated: true)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    


    @objc func hideAction(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func text(textField: UITextField) {
        controller.set(value: textField.text)
    }
}





extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return controller.courseName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return controller.courseName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        controller.set(type: controller.courseName[row])
        mainView.pickerSelected(flag: true)
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

        pickerViewLavle.text = controller.courseName[row]
        return pickerViewLavle
    }
}







