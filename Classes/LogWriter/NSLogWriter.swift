//
//  NSLogWriter.swift
//  PCCanvasKit
//
//  Created by Pingchen Su on 2018/06/12.
//  Copyright © 2018 Pingchen Su. Licensed under MIT.
//

import Foundation

public struct NSLogWriter: LogWriter {
    public static let defaultWriter: LogWriter = NSLogWriter()
    
    let subsystem: String
    let category: String
    
    private init() {
        self.subsystem = Logger.defaultSubSystem
        self.category = Logger.defaultCategory
    }
    
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }
    
    func log(type: LogType, dso: UnsafeRawPointer = #dsohandle, _ message: StaticString, _ args: [Any]) {
        let formattedString: String
        switch (subsystem.count, category.count) {
        case (0, 0):
            formattedString = "[\(type.toString())] - \(message)"
        case (_, 0):
            formattedString = "\(subsystem) [\(type.toString())] - \(message)"
        case (0, _):
            formattedString = "(\(category)) [\(type.toString())] - \(message)"
        default:
            formattedString = "\(subsystem) (\(category)) [\(type.toString())] - \(message)"
        }
        NSLog(formattedString, args)
    }
    
    public func `default`(_ message: StaticString, _ dso: UnsafeRawPointer = #dsohandle, _ args: [Any]) {
        log(type: .default, dso: dso, message, args)
    }
    
    public func info(_ message: StaticString, _ dso: UnsafeRawPointer = #dsohandle, _ args: [Any]) {
        log(type: .info, dso: dso, message, args)
    }
    
    public func debug(_ message: StaticString, _ dso: UnsafeRawPointer = #dsohandle, _ args: [Any]) {
        log(type: .debug, dso: dso, message, args)
    }
    
    public func error(_ message: StaticString, _ dso: UnsafeRawPointer = #dsohandle, _ args: [Any]) {
        log(type: .error, dso: dso, message, args)
    }
    
    public func fault(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any]) {
        log(type: .fault, dso: dso, message, args)
    }
}

fileprivate extension LogType {
    func toString() -> String {
        switch self {
        case .debug:
            return "debug"
        case .default:
            return "default"
        case .error:
            return "error"
        case .fault:
            return "fault"
        case .info:
            return "info"
        }
    }
}
