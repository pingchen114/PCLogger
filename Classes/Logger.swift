//
//  Logger.swift
//  PCCanvasKit
//
//  Created by Pingchen Su on 2018/06/12.
//  Copyright © 2018 Pingchen Su. Licensed under MIT.
//

import Foundation
import os.log

/**
 Log object that can be used to send log message to the Apple's logging system. Use either its static method for default logging or create a logger instance for custom class/service/module logging.
 
 When using its static method for logging, it is recommended to use `Logger.reister(subsystem:category:customLoggerType:)` for registering logging information in order to differentiate its logging message from other framework's log you have imported.
 */
public struct Logger {
    
    /// Log method for `Logger`.
    public enum Method {
        /// Disable logging.
        case disabled
        /// Use Apple's OSLog for logging.
        @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) case osLog
        /// Use NSLog for logging.
        case nsLog
        /// Use custom logger writer for logging.
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
    
    private static var _defaultMethod: Method? = nil
    private static var customLoggerType: LogWriter.Type = NullLogWriter.self
    static var defaultSubSystem: String = ""
    static var defaultCategory: String = ""
    static var defaultMethod: Method {
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
    
    /// The selected log method for this logger.
    public let method: Method
    /// The writer class used for this logger.
    public let writer: LogWriter
    
    /**
     Use this method to create a logger for your use.
     
     Please store this logger as a static member of your class. A logger has its unique identifier and can be used to differentiate each other.
     
     Parameters:
     - subsystem: susbsystem name
     - category: use it to mark for different logger. For example, "UI"/"MyTask"/"MyService"...
     - method: `optional`, will use `defaultMethod` if not specified. `defaultMethod` is defined from `Logger.reister(subsystem:category:customLoggerType:)`.
     */
    init(subsystem: String?, category: String?, method: Method = Logger.defaultMethod) {
        self.method = method
        self.writer = method.writerClass.init(subsystem: subsystem ?? Logger.defaultSubSystem, category: category ?? Logger.defaultCategory)
    }
    
    private init() {
        fatalError("Do not init Logger without parameters.")
    }
    
    /**
     Register parameter used for default logger.
     
     Please call this method in app's launching stage, or before the invoking of the first log command.
     
     Parameters:
     - subsystem: subsystem name
     - category: category name
     - customLoggerType: custom logger class for Logger.
     */
    public static func reister(subsystem: String, category: String, customLoggerType: LogWriter.Type?, defaultMethod: Method) {
        Logger.defaultSubSystem = subsystem
        Logger.defaultCategory = category
        if customLoggerType != nil {
            Logger.customLoggerType = customLoggerType!
        }
        Logger.defaultMethod = defaultMethod
    }
}

public extension Logger {
    // MARK: Logger methods
    
    /**
     Default level log method.
     
     When using `osLog` method, messages are always captured to memory or disk.
     */
    public func `default`(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        writer.default(message, dso, args)
    }
    
    /**
     Info level log method.
     
     Used for logging for additional information.
     */
    public func info(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        writer.info(message, dso, args)
    }
    
    /**
     Debug log method.
     
     Debugging messages.
     */
    public func debug(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        writer.debug(message, dso, args)
    }
    
    /**
     Error level log method.
     
     Indicating erro conditions.
     */
    public func error(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        writer.error(message, dso, args)
    }
    
    /**
     Fault level log method.
     
     Indicating unexpected undition is met.
     */
    public func fault(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        writer.fault(message, dso, args)
    }
}

public extension Logger {
    // MARK: Default writer for general usage
    
    /**
     Default level log method. Use default logger for logging.
     
     When using `osLog` method, messages are always captured to memory or disk.
     */
    public static func `default`(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        defaultMethod.writerClass.defaultWriter.default(message, dso, args)
    }
    
    /**
     Info level log method. Use default logger for logging.
     
     Used for logging for additional information.
     */
    public static func info(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        defaultMethod.writerClass.defaultWriter.info(message, dso, args)
    }
    
    /**
     Debug log method. Use default logger for logging.
     
     Debugging messages.
     */
    public static func debug(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        defaultMethod.writerClass.defaultWriter.debug(message, dso, args)
    }
    
    /**
     Error level log method. Use default logger for logging.
     
     Indicating erro conditions.
     */
    public static func error(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        defaultMethod.writerClass.defaultWriter.error(message, dso, args)
    }
    
    /**
     Fault level log method. Use default logger for logging.
     
     Indicating unexpected undition is met.
     */
    public static func fault(_ dso: UnsafeRawPointer = #dsohandle, message: StaticString, _ args: CVarArg...) {
        defaultMethod.writerClass.defaultWriter.fault(message, dso, args)
    }
}
