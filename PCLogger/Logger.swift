//
//  Logger.swift
//  PCCanvasKit
//
//  Created by PingChen (PC) on 2018/06/12.
//  Copyright © 2018 LINE. All rights reserved.
//

import Foundation
import os.log

public struct Logger {
    
    public enum LoggerMethod {
        case disabled
        @available(iOS, introduced: 10.0, message:"osLog is only available from iOS 10 or later") case osLog
        case nsLog
        case custom
        
        var writerClass: LogWriterProtocol.Type {
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
    private static var customLoggerType: LogWriterProtocol.Type = NullLogWriter.self
    static var defaultSubSystem: String = Bundle.main.bundleIdentifier ?? ""
    static var defaultCategory: String = ""
    static var defaultMethod: LoggerMethod {
        get {
            if _defaultMethod == nil {
                if #available(iOS 10, *) {
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
    public let writer: LogWriterProtocol
    
    init(subsystem: String?, category: String?, method: LoggerMethod = Logger.defaultMethod) {
        self.method = method
        self.writer = method.writerClass.init(subsystem: subsystem ?? Logger.defaultSubSystem, category: category ?? Logger.defaultCategory)
    }
    
    private init() {
        fatalError("Do not init Logger without parameters.")
    }
    
    static func reister(defaultSubsystem: String, defaultCategory: String, customLoggerType: LogWriterProtocol.Type = NullLogWriter.self) {
        Logger.defaultSubSystem = defaultSubsystem
        Logger.defaultCategory = defaultCategory
        Logger.customLoggerType = customLoggerType
    }
}

extension Logger {
    // MARK: Logger methods
    func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.default(message, args, dso)
    }
    
    func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.info(message, args, dso)
    }
    
    func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.debug(message, args, dso)
    }
    
    func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.error(message, args, dso)
    }
    
    func fault(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        writer.fault(message, args, dso)
    }
}

extension Logger {
    // MARK: Default writer for general usage
    
    static func `default`(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.default(message, args, dso)
    }
    
    static func info(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.info(message, args, dso)
    }
    
    static func debug(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.debug(message, args, dso)
    }
    
    static func error(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.error(message, args, dso)
    }
    
    static func fault(_ message: StaticString, _ args: [CVarArg] = [], _ dso: UnsafeRawPointer = #dsohandle) {
        defaultMethod.writerClass.defaultWriter.fault(message, args, dso)
    }
}