//
//  Logger.swift
//  PCCanvasKit
//
//  Created by Pingchen Su on 2018/06/12.
//  Copyright © 2016 Pingchen Su. Licensed under MIT.
//

import Foundation
import os.log

public struct Logger {
    
    public enum LoggerMethod {
        case disabled
        @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) case osLog
        case nsLog
        case custom
        
        var writerClass: LogWriter.Type {
            switch self {
            case .disabled:
                return NullLogWriter.self
            case .osLog:
                if #available(iOS 10, *) {
                    return OSLogWriter.self
                } else {
                    fatalError("OSLogWriter is not available until iOS 10 or later.")
                }
            case .nsLog:
                return NSLogWriter.self
            case .custom:
                return Logger.customLoggerType.self
            }
        }
    }
    
    private static var _defaultMethod: LoggerMethod? = nil
    private static var customLoggerType: LogWriter.Type = NullLogWriter.self
    static var defaultSubSystem: String = ""
    static var defaultCategory: String = ""
    static var defaultMethod: LoggerMethod {
        get {
            if _defaultMethod == nil {
                if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                    _defaultMethod = .osLog
                } else {
                    _defaultMethod = .nsLog
                }
            }
            return _defaultMethod!
        }
        set {
            _defaultMethod = newValue
        }
    }
    
    public let method: LoggerMethod
    public let writer: LogWriter
    
    init(subsystem: String?, category: String?, method: LoggerMethod = Logger.defaultMethod) {
        self.method = method
        self.writer = method.writerClass.init(subsystem: subsystem ?? Logger.defaultSubSystem, category: category ?? Logger.defaultCategory)
    }
    
    private init() {
        fatalError("Do not init Logger without parameters.")
    }
    
    public static func reister(subsystem: String, category: String, customLoggerType: LogWriter.Type?) {
        Logger.defaultSubSystem = subsystem
        Logger.defaultCategory = category
        if customLoggerType != nil {
            Logger.customLoggerType = customLoggerType!
        }
    }
}

public extension Logger {
    // MARK: Logger methods
    public func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.default(message, args, dso)
    }
    
    public func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.info(message, args, dso)
    }
    
    public func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.debug(message, args, dso)
    }
    
    public func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.error(message, args, dso)
    }
    
    public func fault(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.fault(message, args, dso)
    }
}

public extension Logger {
    // MARK: Default writer for general usage
    
    public static func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.default(message, args, dso)
    }
    
    public static func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.info(message, args, dso)
    }
    
    public static func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.debug(message, args, dso)
    }
    
    public static func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.error(message, args, dso)
    }
    
    public static func fault(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.fault(message, args, dso)
    }
}
