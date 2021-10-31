//
//  DataHandler.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation

protocol DataHandler: AnyObject {
    associatedtype APIResponse
    associatedtype DataType
    associatedtype IdType
    static func getData() -> [DataType]
    static func getSingle(id: IdType) -> DataType?
    static func saveData(response: APIResponse)
    static func saveAndReturnData(response: APIResponse) -> [DataType]
}
