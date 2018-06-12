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

public protocol LogWriterProtocol {
    
    init(subsystem: String, category: String)
    
    static var defaultWriter: LogWriterProtocol { get }
    
    func `default`(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func info(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func debug(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func error(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
    func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer)
}

public struct NullLogWriter: LogWriterProtocol {
    public static let defaultWriter: LogWriterProtocol = NullLogWriter(subsystem: Logger.defaultSubSystem, category: Logger.defaultCategory)
    
    public init(subsystem: String, category: String) {}
    
    public func `default`(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    public func info(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    public func debug(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    public func error(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
    public func fault(_ message: StaticString, _ args: [CVarArg], _ dso: UnsafeRawPointer) {}
}