//
//  NSLogWriter.swift
//  PCCanvasKit
//
//  Created by PingChen (PC) on 2018/06/12.
//  Copyright © 2018 LINE. All rights reserved.
//

import Foundation

struct NSLogWriter: LogWriter {
    static let defaultWriter: LogWriter = NSLogWriter()
    
    let subsystem: String
    let category: String
    
    private init() {
        self.subsystem = Logger.defaultSubSystem
        self.category = Logger.defaultCategory
    }
    
    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }
    
    func log(type: LogType, dso: UnsafeRawPointer = #dsohandle, _ message: StaticString, _ args: [CVarArg]) {
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
    
    func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .default, dso: dso, message, args)
    }
    
    func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .info, dso: dso, message, args)
    }
    
    func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .debug, dso: dso, message, args)
    }
    
    func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .error, dso: dso, message, args)
    }
    
    func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {
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
