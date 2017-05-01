//
//  ViewController.swift
//  WhatsMyWeather
//
//  Created by sashidhar kalluri on 4/30/17.
//  Copyright © 2017 sashidhar kalluri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherInfo: UITextView!
    @IBOutlet weak var city: UITextField!
    @IBAction func search(_ sender: Any) {
        var message = ""
        if let location = city.text {
            let cityEntered = NSString(string: location)
            let url = URL(string: "http://www.weather-forecast.com/locations/"+(cityEntered.replacingOccurrences(of: " ", with: "-") as String)+"/forecasts/latest")
            let request = NSMutableURLRequest(url: url!)
            
            let session = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    //self.weatherInfo.text = "Something went wrong!"
                    print(error!)
                }
                else{
                    if let unwrappedData = data {                        let dataString  = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let sourceArray = dataString?.components(separatedBy: stringSeparator){
                            print(sourceArray)
                            if !sourceArray[0].contains("404") && sourceArray.count > 0 {
                                stringSeparator = "</span>"
                                var newSourceArray = sourceArray[1].components(separatedBy: stringSeparator)
                                if newSourceArray.count > 0 {
                                    let result = newSourceArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(result)
                                    message = result
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.sync {
                    // Update UI
                    if message == ""{
                        self.weatherInfo.text = "There was some problem. Please try again."
                    }else{
                        self.weatherInfo.text = message
                    }
                }
            }
            session.resume()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

