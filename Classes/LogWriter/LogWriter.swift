//
//  LogWriter.swift
//  PCCanvasKit
//
//  Created by Pingchen Su on 2018/06/12.
//  Copyright © 2018 Pingchen Su. Licensed under MIT.
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
    
    func `default`(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any])
    func info(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any])
    func debug(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any])
    func error(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any])
    func fault(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: [Any])
}
