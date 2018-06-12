//
//  NSLogWriter.swift
//  PCCanvasKit
//
//  Created by PingChen (PC) on 2018/06/12.
//  Copyright © 2018 LINE. All rights reserved.
//

import Foundation

public struct NSLogWriter: LogWriterProtocol {
    public static let defaultWriter: LogWriterProtocol = NSLogWriter(subsystem: Logger.defaultSubSystem, category: Logger.defaultCategory)
    
    let subsystem: String
    let category: String
    
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }
    
    func log(type: LogType, dso: UnsafeRawPointer = #dsohandle, _ message: StaticString, _ args: [CVarArg]) {
        let formattedString = "\(subsystem) (\(category)) [\(type.toString())] - \(message)"
        NSLog(formattedString, args)
    }
    
    public func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .default, dso: dso, message, args)
    }
    
    public func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .info, dso: dso, message, args)
    }
    
    public func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .debug, dso: dso, message, args)
    }
    
    public func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        log(type: .error, dso: dso, message, args)
    }
    
    public func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {
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
