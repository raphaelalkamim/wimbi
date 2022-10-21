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
    var currency: DecodedCurrency?
    let baseURL: String = "https://economia.awesomeapi.com.br/last/"
    
    func getCurrency(incomingCurrency: String, outgoingCurrency: String) async -> DecodedCurrency? {
        let convertedIncomingCurrency = convertCurrency(currency: incomingCurrency)
        let convertedOutgoingCurrency = convertCurrency(currency: outgoingCurrency)
        
        let url = URL(string: baseURL + convertedOutgoingCurrency + "-" + convertedIncomingCurrency)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.currency = try JSONDecoder().decode(DecodedCurrency.self, from: data)
        } catch {
            print(String(describing: error.localizedDescription))
        }
        print(self.currency)
        return self.currency
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
