//
//  OSLogWriter.swift
//  PCCanvasKit
//
//  Created by Pingchen Su on 2018/06/12.
//  Copyright © 2018 Pingchen Su. Licensed under MIT.
//

import Foundation
import os.log

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public struct OSLogWriter: LogWriter {
    public static let defaultWriter: LogWriter = OSLogWriter()
    
    private let writer: OSLog
    
    private init() {
        if Logger.defaultSubSystem.count > 0 || Logger.defaultCategory.count > 0 {
            writer = OSLog(subsystem: Logger.defaultSubSystem, category: Logger.defaultCategory)
        } else {
            writer = OSLog.default
        }
    }
    
    public init(subsystem: String, category: String) {
        writer = OSLog(subsystem: subsystem, category: category)
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
    
    public func fault(_ message: StaticString, _ dso: UnsafeRawPointer = #dsohandle, _ args: [Any]) {
        log(type: .fault, dso: dso, message, args)
    }
    
    internal func log(type: LogType, dso: UnsafeRawPointer = #dsohandle, _ message: StaticString, _ args: [Any]) {
        let _args: [CVarArg] = args.map({ (arg) -> CVarArg in
            if let ret = (arg as? String) {
                return ret
            }
            else if arg is NSNumber {
                return arg as! CVarArg
            }
            else {
                return String(describing: arg)
            }
        })
        switch args.count {
        case 0:
            os_log(message, dso: dso, log: writer, type: type.osLogType)
        case 1:
            os_log(message, dso: dso, log: writer, type: type.osLogType, _args[0])
        case 2:
            os_log(message, dso: dso, log: writer, type: type.osLogType, _args[0], _args[1])
        case 3:
            os_log(message, dso: dso, log: writer, type: type.osLogType, _args[0], _args[1], _args[2])
        case 4:
            os_log(message, dso: dso, log: writer, type: type.osLogType, _args[0], _args[1], _args[2], _args[3])
        case 5:
            os_log(message, dso: dso, log: writer, type: type.osLogType, _args[0], _args[1], _args[2], _args[3], _args[4])
        default:
            os_log("Too many arguments in a log!", log: writer, type: .error)
        }
    }
}

@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
fileprivate extension LogType {
    var osLogType: OSLogType {
        switch self {
        case .default:
            return .default
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }
}
