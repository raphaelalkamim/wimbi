//
//  Currency.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 06/10/22.
//

import Foundation

class Currency: Codable {
    
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
    
    init(code: String, codein: String, name: String, high: String, low: String, varBid: String, pctChange: String, bid: String, ask: String, timestamp: String, createdate: String) {
        self.code = code
        self.codein = codein
        self.name = name
        self.high = high
        self.low = low
        self.varBid = varBid
        self.pctChange = pctChange
        self.bid = bid
        self.ask = ask
        self.timestamp = timestamp
        self.createdate = createdate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.codein = try container.decode(String.self, forKey: .codein)
        self.name = try container.decode(String.self, forKey: .name)
        self.high = try container.decode(String.self, forKey: .high)
        self.low = try container.decode(String.self, forKey: .low)
        self.varBid = try container.decode(String.self, forKey: .varBid)
        self.pctChange = try container.decode(String.self, forKey: .pctChange)
        self.bid = try container.decode(String.self, forKey: .bid)
        self.ask = try container.decode(String.self, forKey: .ask)
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.createdate = try container.decode(String.self, forKey: .createdate)
    }
}

extension Currency: CustomStringConvertible {
    var description: String {
        return "{code:\(code), codein:\(codein), name:\(name), high:\(high), low:\(low), varBid:\(varBid), pctChange:\(pctChange), bid:\(bid), ask:\(ask), timestamp:\(timestamp)}"
    }
}
