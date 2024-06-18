//
//  NetworkResult.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkErr
    case failure
}
