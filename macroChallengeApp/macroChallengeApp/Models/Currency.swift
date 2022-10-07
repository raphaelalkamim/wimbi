//
//  Currency.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 06/10/22.
//

import Foundation

struct Currency: Decodable {
    var code: String
    var codein: String
    var name: String
    var high: String
    var low: String
    var varBid: String
    var pctChange: String
    var bid: String
    var ask: String
    var timestamp: String
    var createdate: String
    
    var currencyID: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case codein
        case name
        case high
        case low
        case varBid
        case pctChange
        case bid
        case ask
        case timestamp
        case createdate = "create_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try container.decode(String.self, forKey: CodingKeys.code)
        self.codein = try container.decode(String.self, forKey: CodingKeys.codein)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.high = try container.decode(String.self, forKey: CodingKeys.high)
        self.low = try container.decode(String.self, forKey: CodingKeys.low)
        self.varBid = try container.decode(String.self, forKey: CodingKeys.varBid)
        self.pctChange = try container.decode(String.self, forKey: CodingKeys.pctChange)
        self.bid = try container.decode(String.self, forKey: CodingKeys.bid)
        self.ask = try container.decode(String.self, forKey: CodingKeys.ask)
        self.timestamp = try container.decode(String.self, forKey: CodingKeys.timestamp)
        self.createdate = try container.decode(String.self, forKey: CodingKeys.createdate)
        
        self.currencyID = container.codingPath.first!.stringValue
    }
}

struct DecodedCurrency: Decodable {
    var array: [Currency]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var currencyArray = [Currency]()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(Currency.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            currencyArray.append(decodedObject)
        }
        
        array = currencyArray
    }
}
