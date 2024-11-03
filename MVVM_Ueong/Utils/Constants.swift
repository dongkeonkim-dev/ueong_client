//
//  Constants.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/28/24.
//

import Foundation

struct Constants {
  static let serviceName = "ueong"
  static let accessTokenHeader = "Authorization"
  
  struct Keychain {
//    static let accessToken = "com.\(Constants.serviceName).accessToken"
//    static let refreshToken = "com.\(Constants.serviceName).refreshToken"
      static let accessToken = "com.\(Constants.serviceName).accessToken"
      static let refreshToken = "com.\(Constants.serviceName).refreshToken"
  }
}

#if DEBUG
//let baseURL = "http://localhost:3000/"
//let imageURL = "http://localhost:3000/uploads/images/"
//let Model3dURL = "http://localhost:3000/3d-model-files"
//let mockedUsername = "username2"
let baseURL = "http://43.202.83.112:3000/"
let imageURL = "http://43.202.83.112/uploads/images/"
let Model3dURL = "http://43.202.83.112/uploads/models"
let mockedUsername = "username2"
#else
let baseURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/"
let imageURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/image-files"
let Model3dURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/3d-model-files"
#endif

