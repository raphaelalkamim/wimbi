//
//  CoreDataSendable.swift
//  macroChallengeApp
//

import CoreData

// Existing networking callbacks pass generated Core Data objects across closure boundaries.
extension ActivityLocal: @unchecked Sendable {}
extension DayLocal: @unchecked Sendable {}
extension RoadmapLocal: @unchecked Sendable {}
extension UserLocal: @unchecked Sendable {}
