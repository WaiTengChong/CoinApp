//
//  Coin.swift
//  coinApp
//
//  Created by User on 30/08/2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class CoinAPI{
    
    var mystring : String = "GG"
    var change : String = ""
    var Bo : Bool = true
    struct Weather{
        var Coins : String
       var Price : String
    }
    func weatherFromJSONData(_ data: Data) -> Weather? {
         mystring = "GG"
        change = ""
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["data"] as! JSONDict
        var weatherList = json["data"] as! JSONDict
        var weatherDict = weatherList["quotes"] as! JSONDict
        var usdd = weatherDict["USD"] as! JSONDict

        let tempNumber:NSNumber = usdd["price"]as! NSNumber
        let price_change: NSNumber = usdd["percent_change_24h"] as! NSNumber
        let s:String = String(format:"%g", tempNumber.doubleValue) //formats the string to accept double/float
       let p:String = String(format:"%g", price_change.doubleValue) //formats the string to accept double/float
        let name = mainDict["symbol"]as! String
        
        mystring =  name + ": " + s
        change = p + "%"
        let weather = Weather(
            Coins: mainDict["name"] as! String,
            Price:  s
            
        )
     Bo = false
        return weather
    
    }
    
    func Display()-> String {
        
        
        
        self.fetchData()
       // var int = 1
       
        while Bo == true && mystring == "GG"{
        //   int = int+1
           // print(int)
        }
        
        Bo = true
       
        return mystring + " " + change

    }
    func DisplayXRP()-> String {
        
        
        
        self.fetchDataXRP()
        // var int = 1
        
        while Bo == true && mystring == "GG"{
            //   int = int+1
            // print(int)
        }
        
        Bo = true
        
        return mystring + " " + change
        
    }
    
    
 
    func fetchData(){
        let session = URLSession.shared
        
        // url-escape the query string we're passed
        let url = URL(string: "https://api.coinmarketcap.com/v2/ticker/1/")
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                self.mystring = "Turn on your fking wifi stupid"
                NSLog("CoinMarketCap api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!) {
                        NSLog("\(weather)")
                    }
                case 401: // unauthorized
                    
                    NSLog("coinmarketcap api returned an 'unauthorized' response. Did you set your API key?")
                    
                default:
                    NSLog("coinmarketcap api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                 
                }
            }
        }
        task.resume()
    }
    
    func fetchDataXRP() {
        let session = URLSession.shared
        // url-escape the query string we're passed
        let url = URL(string: "https://api.coinmarketcap.com/v2/ticker/52/")
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("CoinMarketCap api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!) {
                        NSLog("\(weather)")
                    }
                case 401: // unauthorized
                    NSLog("coinmarketcap api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("coinmarketcap api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    
}
