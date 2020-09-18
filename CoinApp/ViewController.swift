//
//  ViewController.swift
//  CoinApp
//
//  Created by たっくん on 2020/09/13.
//  Copyright © 2020 tatsuya.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerDelegete {
    
    func didUpdatePrice(price: String, currency: String,secondCurrency: String) {
        DispatchQueue.main.async {
            self.coinLabel.text = price
            self.currencyLabel.text = currency
            self.secondCurrencyLabel.text = secondCurrency
        }
    }
    
    func didFailWhithError(error: Error) {
        print(error)
    }
    
    
    //数を決まる
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    //構造体CoinManagerにアクセス
    var coinManager = CoinManager()
    
    //PickerViewのセルの数を決める
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //構造体の中のcurrencyArrayの数を数える
        switch component {
        case 0:
            return coinManager.currencyArray.count
        default:
            return coinManager.secondlCurrencyArray.count
        }
    }
    //セルに表示するラベルを決める
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return coinManager.currencyArray[row]
            default:
                return coinManager.secondlCurrencyArray[row]
            }
        }

    //選択されたPickerの値を取得できる
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //ifの中にswitchぶん
        print(component,row,coinManager.currencyArray[row],coinManager.secondlCurrencyArray[row])
//        switch component {
//        case 0:
            let selectedCurrency = coinManager.currencyArray[pickerView.selectedRow(inComponent: 0)]
            let secondSelectedCurrency = coinManager.secondlCurrencyArray[pickerView.selectedRow(inComponent: 1)]
            coinManager.getCoinPrice(for: selectedCurrency, secondCurrency: secondSelectedCurrency)

//        default:
//            let secondSelectedCurrency = coinManager.secondlCurrencyArray[row]
//            coinManager.getCoinPrice(for: selectedCurrency, secondCurrency: secondSelectedCurrency)
        

//            coinManager.getCoinPrice(for: selectedCurrency, secondCurrency: secondSelectedCurrency)
        }
        


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
                
    }

    @IBOutlet var coinLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var currencyPicker: UIPickerView!

    @IBOutlet var secondCurrencyLabel: UILabel!
    
}

