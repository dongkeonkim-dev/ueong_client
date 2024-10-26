//
//  Constants.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/28/24.
//

import Foundation

#if DEBUG
let baseURL = "http://localhost:3000/"
let imageURL = "http://localhost:3000/uploads/images/"
let Model3dURL = "http://localhost:3000/3d-model-files"
let username = "username1"
#else
let baseURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/"
let imageURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/image-files"
let Model3dURL = "http://ec2-43-200-8-246.ap-northeast-2.compute.amazonaws.com:3000/3d-model-files"
#endif

