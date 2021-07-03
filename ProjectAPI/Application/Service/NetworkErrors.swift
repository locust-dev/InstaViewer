//
//  NetworkErrors.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 29.06.2021.
//

import Foundation

enum NetworkErrors: Error {
    case createUrlError
    case createRequestError
    case createImageFromDataError
    case emptyDataFromRequest
    case loadDataFromRequestError
    case jsonDecodeError
    case createObjectError
}

extension NetworkErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .createUrlError:
            return NSLocalizedString("URL does not exist", comment: "")
        case .createRequestError:
            return NSLocalizedString("Failed to create request", comment: "")
        case .createImageFromDataError:
            return NSLocalizedString("Failed to create image from data", comment: "")
        case .emptyDataFromRequest:
            return NSLocalizedString("Null data & error after created request", comment: "")
        case .loadDataFromRequestError:
            return NSLocalizedString("Failed to load data from super request", comment: "")
        case .jsonDecodeError:
            return NSLocalizedString("Failed to decode JSON. Please make sure API key is valid or data model doesn't have any mistakes", comment: "")
        case .createObjectError:
            return NSLocalizedString("Failed to create entity from sucessed JSON data", comment: "")
            
        }
    }
}
