//
//  CurrencyController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 27/10/22.
//

import Foundation
import UIKit

class CurrencyController {
    func getCurrencyFromAPI(userCurrency: String, outgoinCurrency: String) async -> Double {
        var total: Double = 0
        let currency = await CurrencyAPI.shared.getCurrency(incomingCurrency: userCurrency, outgoingCurrency: outgoinCurrency)
        
        if let currency = currency {
            let value = currency.array[0].high
            let currencyToDouble = Double(value) ?? 0
            total = currencyToDouble
        }
        return total
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        if currencySymbol == "$" {
            return "U$"
        } else {
            return currencySymbol ?? "U$"
        }
    }
    
    func updateBudget(activites: [ActivityLocal], userCurrency: String) async -> Double {
        var budgetDay: Double = 0
        var totalReal: Double = 0
        var totalDollar: Double = 0
        var totalEuro: Double = 0
        var totalYen: Double = 0
        var totalSwiss: Double = 0
        var totalRenminbi: Double = 0
        
        for activite in activites {
            switch activite.currencyType {
            case "R$":
                totalReal += activite.budget
                if userCurrency == "R$" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "U$":
                totalDollar += activite.budget
                if userCurrency == "U$" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "€":
                totalEuro += activite.budget
                if userCurrency == "€" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "¥":
                totalYen += activite.budget
                if userCurrency == "¥" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "Fr":
                totalSwiss += activite.budget
                if userCurrency == "Fr" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "元":
                totalRenminbi += activite.budget
                if userCurrency == "元" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            default:
                break
            }
        }
        return budgetDay
    }
    
    func updateBudgetTotal(userCurrency: String, days: [DayLocal]) async -> Double {
        var budgetTotal = 0.0
        for day in days {
            for activite in day.activity?.allObjects as [ActivityLocal] {
                switch activite.currencyType {
                case "R$":
                    if userCurrency == "R$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "U$":
                    if userCurrency == "U$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "€":
                    if userCurrency == "€" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "¥":
                    if userCurrency == "¥" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "Fr":
                    if userCurrency == "Fr" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "元":
                    if userCurrency == "元" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                default:
                    break
                }
            }
        }
        return budgetTotal
    }
    func updateBudgetBackend(activites: [Activity], userCurrency: String) async -> Double {
        var budgetDay: Double = 0
        var totalReal: Double = 0
        var totalDollar: Double = 0
        var totalEuro: Double = 0
        var totalYen: Double = 0
        var totalSwiss: Double = 0
        var totalRenminbi: Double = 0
        
        for activite in activites {
            switch activite.currency {
            case "R$":
                totalReal += activite.budget
                if userCurrency == "R$" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            case "U$":
                totalDollar += activite.budget
                if userCurrency == "U$" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            case "€":
                totalEuro += activite.budget
                if userCurrency == "€" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            case "¥":
                totalYen += activite.budget
                if userCurrency == "¥" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            case "Fr":
                totalSwiss += activite.budget
                if userCurrency == "Fr" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            case "元":
                totalRenminbi += activite.budget
                if userCurrency == "元" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                    budgetDay += activite.budget * value
                }
                
            default:
                break
            }
        }
        return budgetDay
    }
    
    func updateBudgetTotal(userCurrency: String, days: [Day]) async -> Double {
        var budgetTotal = 0.0
        for day in days {
            for activite in day.activity {
                switch activite.currency {
                case "R$":
                    if userCurrency == "R$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                case "U$":
                    if userCurrency == "U$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                case "€":
                    if userCurrency == "€" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                case "¥":
                    if userCurrency == "¥" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                case "Fr":
                    if userCurrency == "Fr" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                case "元":
                    if userCurrency == "元" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currency )
                        budgetTotal += activite.budget * value
                    }
                    
                default:
                    break
                }
            }
        }
        return budgetTotal
    }
}
