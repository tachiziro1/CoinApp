//
//  CoinManager.swift
//  CoinApp
//
//  Created by たっくん on 2020/09/13.
//  Copyright © 2020 tatsuya.com. All rights reserved.
//

import Foundation

protocol CoinManagerDelegete {
    func didUpdatePrice(price: String,currency: String, secondCurrency: String)
    func didFailWhithError(error: Error)
    
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "E36808F8-357D-4273-9D05-2722F41F6FB6"
    let currencyArray = ["BTC","BCH","ETH","XRP","XEM",]
    let secondlCurrencyArray = ["USD","JPY","HKD","CNY","EUR",]
    
    //プロトコルにアクセスする
    var delegate:CoinManagerDelegete?
    
    //値を取得する
    func getCoinPrice(for currency:String,secondCurrency:String){
        //currencyに値が入っている
//        print(currency,"これこれ")
        
        let urlString = "\(baseURL)\(currency)/\(secondCurrency)?apikey=\(apiKey)"
    
        print(urlString)
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data,responce,error)in
            if error != nil{
                self.delegate?.didFailWhithError(error: error!)
                return
                }
                
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData){
                        //小数点第二位まで表示する
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency, secondCurrency: secondCurrency)
                        
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
//            print(lastPrice)
            return lastPrice
        
        } catch  {
            delegate?.didFailWhithError(error: error)
            return nil
        }
    }
    
    
}
