//
//  LogWriter.swift
//  PCCanvasKit
//
//  Created by PingChen (PC) on 2018/06/12.
//  Copyright © 2018 LINE. All rights reserved.
//

import Foundation

public enum LogType {
    case `default`
    case info
    case debug
    case error
    case fault
}

public protocol LogWriter {
    
    init(subsystem: String, category: String)
    
    static var defaultWriter: LogWriter { get }
    
    func `default`(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func info(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func debug(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func error(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
}

struct NullLogWriter: LogWriter {
    static let defaultWriter: LogWriter = NullLogWriter(subsystem: Logger.defaultSubSystem, category: Logger.defaultCategory)
    
    init(subsystem: String, category: String) {}
    
    func `default`(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    func info(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    func debug(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    func error(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
}
