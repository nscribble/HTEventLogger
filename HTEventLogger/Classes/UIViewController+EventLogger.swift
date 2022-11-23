//
//  UIViewController+EventLogger.swift
//  TT
//
//  Created by Jason on 2022/7/12.
//  Copyright (c) 2022 nscribble. All rights reserved.
//

import Foundation
import UIKit

public struct EventLogger<Page> {
    public var page: Page

    public init(_ page: Page) {
        self.page = page
    }
}

public protocol EventLoggerCompatible {
    associatedtype Page

    var pel: EventLogger<Page> { get set }
}

extension EventLoggerCompatible {
    public var pel: EventLogger<Self> {
        get {
            return EventLogger(self)
        }
        set {
        }
    }
}

extension UIViewController: EventLoggerCompatible { }
extension EventLogger where Page: PageEventLogging {
    // MARK:
    public func logPageExposure() {
        let logger = HTEventLogger.shared()
        logger.log { builder in
            _ = builder.pageExposureEnter(self.page.pel_pageId)
                .sessionKey(self.page.pel_pageSessionKey)
                .properties(self.page.pel_pageProperties)
                .ext(self.page.pel_pagePropertyExt)
        }
    }
    
    public func logPageQuit() {
        let logger = HTEventLogger.shared()
        logger.log { builder in
            _ = builder.pageExposureQuit(self.page.pel_pageId)
                .sessionKey(self.page.pel_pageSessionKey)
                .properties(self.page.pel_pageProperties)
                .ext(self.page.pel_pagePropertyExt)
        }
    }
    
    public func log(_ buildBlock: @escaping (HTEventLogBuilder)->Void) {
        let logger = HTEventLogger.shared()
        logger.log(builder: buildBlock)
    }
}

// MARK:

@objc public protocol PageEventLogging {// pel_前缀避免冲突
    @objc var pel_pageId: String { get }
    @objc var pel_pageProperties: [String: String] { get }
    @objc var pel_pagePropertyExt: [String: String] { get }
    @objc var pel_pageSessionKey: String { get }
}

extension UIViewController {
    @objc open var pel_pageId: String {
        return ""
    }
    
    static var property_pageSessionKey = "eventlogger_pageSessionKey"
    @objc open var pel_pageSessionKey: String {
        if let key = objc_getAssociatedObject(self, &Self.property_pageSessionKey) as? String {
            return key
        }
        
        let dateString = String(format: "%lld", Int64(Date().timeIntervalSince1970 * 1000))
        objc_setAssociatedObject(self, &Self.property_pageSessionKey, dateString, .OBJC_ASSOCIATION_RETAIN)
        return dateString
    }
    
    @objc open var pel_pageProperties: [String : String] {
        return [:]
    }
    
    @objc open var pel_pagePropertyExt: [String : String] {
        return [:]
    }
}
