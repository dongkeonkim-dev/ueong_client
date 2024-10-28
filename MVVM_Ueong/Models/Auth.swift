//
//  Auth.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/27/24.
//

import Foundation

struct SignupResponse: Decodable {
  let isSuccess: Bool
}

struct LoginResponse: Decodable {
  let accessToken: String
}

struct ValidationResponse: Decodable {
  let isValid: Bool
}

enum AuthError: Error, LocalizedError {
  case invalidToken
  case invalidURL
  case invalidResponse
  case decodingError
  case serverError(statusCode: Int, message: String)
  
  var errorDescription: String? {
    switch self {
      case .invalidToken:
        return "유효하지 않은 토큰입니다."
      case .invalidURL:
        return "잘못된 URL입니다."
      case .invalidResponse:
        return "유효하지 않은 응답입니다."
      case .decodingError:
        return "데이터 디코딩에 실패했습니다."
      case .serverError(let statusCode, let message):
        return "서버 오류 (\(statusCode)): \(message)"
    }
  }
}
