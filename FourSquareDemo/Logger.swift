//
//  Logger.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import UIKit

class Logger: NSObject {
    // MARK: Internal

    static let shared = Logger()

    // We should add sentry, datadog, crashlytics etc here
    func log(_ error: Error, _ file: String, _ line: UInt, _ info: [String: Any]? = nil) {
        logToSentry(error)
        logToDataDog(error)
        logToCrashLytics(error)
        debugPrint("common log: \(error), \(file), \(line)")
        if let info = info {
            debugPrint("common error info: \(info)")
        }
    }

    // MARK: Private

    private func logToSentry(_ error: Error) {
        //// do sentry stuff
    }

    private func logToDataDog(_ error: Error) {
        //// do logToDataDog stuff
    }

    private func logToCrashLytics(_ error: Error) {
        //// do crashlytics stuff
    }
}
