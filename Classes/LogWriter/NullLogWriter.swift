//
//  NullLogWriter.swift
//  PCLogger-iOS
//
//  Created by Pingchen Su on 2018/6/13.
//  Copyright © 2018 Pingchen Su. Licensed under MIT.
//

import Foundation

public struct NullLogWriter: LogWriter {
    public static let defaultWriter: LogWriter = NullLogWriter()
    
    private init() {}
    
    public init(subsystem: String, category: String) {}
    
    public func `default`(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: CVarArg...) {}
    public func info(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: CVarArg...) {}
    public func debug(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: CVarArg...) {}
    public func error(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: CVarArg...) {}
    public func fault(_ message: StaticString, _ dso: UnsafeRawPointer, _ args: CVarArg...) {}
}
