//
//  Coin.swift
//  coinApp
//
//  Created by User on 30/08/2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class CoinAPI{
    
    struct Weather{
        var Coins : String
       var Price : String
        var change: String
    }
    func weatherFromJSONData(_ data: Data, name: String) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        let resultPrice = json["result"] as! JSONDict
        let price = resultPrice["price"] as! JSONDict
        let last = price["last"] as! NSNumber
        
       let change = price["change"] as! JSONDict
        let percentage = change["percentage"] as! NSNumber
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        
        currencyFormatter.maximumFractionDigits = 0
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "es_US")

        // We'll force unwrap with the !, if you've got defined data you may need more error checking

        let priceString = currencyFormatter.string(from: last)!
        
        let s:String = String(format:"%.0f", last.doubleValue) //formats the string to accept double/float
        let p:String = String(format:"%.1f", percentage.doubleValue) //formats the string to accept double/float
     
        let weather = Weather(
            Coins: name,
            Price:  "$" + priceString,
            change: p
        )
        return weather
    
    }
    
    func DisplayAll() -> String {
        var btc = ""
        var eth = ""
        let concurrentQueue = DispatchQueue(label: "com.some.concurrentQueue", attributes: .concurrent)

        concurrentQueue.async {
            //executable code
            btc = self.fetchData()
        }

        concurrentQueue.async {
            //executable code
            eth = self.fetchDataETH()
        }
        while btc == "" || eth == "" {
            
        }
        return   btc +  " " + eth
    }
 
    func fetchData() -> String {
        let session = URLSession.shared
        var result = "btc"
        // url-escape the query string we're passed
        let url = URL(string: "https://api.cryptowat.ch/markets/binance/btcusdc/summary")
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                result = "Turn on your wifi"
                NSLog("CoinMarketCap api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!, name: "B") {
                        NSLog("\(weather)")
                        result = weather.Coins + ": " + weather.Price + " " + weather.change + "%"
                    }
                case 401: // unauthorized
                    
                    NSLog("coinmarketcap api returned an 'unauthorized' response. Did you set your API key?")
                    
                default:
                    NSLog("coinmarketcap api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                 
                }
            }
        }
        task.resume()
        while result == "btc" {
        }
        return result
    }
    
    func fetchDataETH() -> String {
        let session = URLSession.shared
        var result = "eth"
        // url-escape the query string we're passed
        let url = URL(string: "https://api.cryptowat.ch/markets/binance/ethusdc/summary")
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                result = "Turn on your wifi"
                NSLog("CoinMarketCap api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!, name: "E") {
                        NSLog("\(weather)")
                        result = weather.Coins + ": " + weather.Price + " " + weather.change + "%"
                    }
                case 401: // unauthorized
                    NSLog("coinmarketcap api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("coinmarketcap api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                 
                }
            }
        }
        task.resume()
        while result == "eth" {
        }
        return result
    }
    
    
}
