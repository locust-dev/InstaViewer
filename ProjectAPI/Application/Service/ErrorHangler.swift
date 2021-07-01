//
//  ErrorHangler.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 29.06.2021.
//

import Foundation

enum ErrorHangler: Error {
    case jsonDecodingError
    case downloadImageError
    case urlCreateError
    case createDataError
}

extension ErrorHangler {
    public var errorDescription: String? {
        switch self {
        case .jsonDecodingError:
            return "JSON decoding error"
        case .downloadImageError:
            return "Image download error"
        case .urlCreateError:
            return "Error url create"
        case .createDataError:
            return "Error to create data"
        }
    }
}
