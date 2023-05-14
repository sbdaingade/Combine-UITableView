//
//  ErrorHandler.swift
//  CombineUiTableView
//
//  Created by Sachin Daingade on 14/05/23.
//

import Foundation
public enum CustomError: Error, CustomStringConvertible {
    case unknownError
    case errorWithDesc(Error)
    
    public var description: String {
        switch self {
        case .unknownError:
            return "Unknown error"
        case .errorWithDesc(let error):
            return error.localizedDescription
        }
    }
}
