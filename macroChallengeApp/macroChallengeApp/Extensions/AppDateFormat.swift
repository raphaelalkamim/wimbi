//
//  AppDateFormat.swift
//  macroChallengeApp
//

import Foundation

enum AppDateFormat {
    static func backendDateString(from date: Date) -> String {
        makeFormatter(dateFormat: "dd/MM/yyyy").string(from: date)
    }

    static func compactBackendDateString(from date: Date) -> String {
        makeFormatter(dateFormat: "d/M/y").string(from: date)
    }

    static func backendDate(from string: String) -> Date? {
        makeFormatter(dateFormat: "dd/MM/yyyy").date(from: string)
    }

    private static func makeFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = dateFormat
        return formatter
    }
}
