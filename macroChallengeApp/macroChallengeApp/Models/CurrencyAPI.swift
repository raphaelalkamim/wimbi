//
//  CurrencyAPI.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 06/10/22.
//

import Foundation
import UIKit

class CurrencyAPI {
    public static var shared = CurrencyAPI()
    var currency: Currency?
    let baseURL: String = "https://economia.awesomeapi.com.br/last/"
    
    func getCurrency(incomingCurrency: String, outgoingCurrency: String, _ completion: @escaping ((_ currency: Currency) -> Void)) {
        let session: URLSession = URLSession.shared
        
        let convertedIncomingCurrency = convertCurrency(currency: incomingCurrency)
        let convertedOutgoingCurrency = convertCurrency(currency: outgoingCurrency)
        
        let url = URL(string: baseURL + convertedOutgoingCurrency + "-" + convertedIncomingCurrency)!
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            let resp: String = String(data: data, encoding: .utf8) ?? "Error"
            do {
                self.currency = try JSONDecoder().decode(Currency.self, from: data)
            } catch {
                print("PARSE ERROR")
            }
        }
        task.resume()
        
    }

    private func convertCurrency(currency: String) -> String {
        var currencyConverted = ""
        
        switch currency {
        case "R$":
            currencyConverted = "BRL"
        case "U$":
            currencyConverted = "USD"
        case "€":
            currencyConverted = "EUR"
        case "¥":
            currencyConverted = "JPY"
        case "Fr":
            currencyConverted = "CHF"
        case "元":
            currencyConverted = "CNY"
        default:
            break
        }
        return currencyConverted
    }
}
