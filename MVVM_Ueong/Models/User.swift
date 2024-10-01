//
//  User.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

struct User: Decodable {
    var username: String
    var nickname: String
    var email: String
    var profilePhotoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case nickname
        case email
        case profilePhotoUrl = "profile_photo_url"
    }
    
    //디코더에서 쓰는 생성자
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        username = try container.decode(String.self, forKey: .username)
        nickname = try container.decode(String.self, forKey: .nickname)
        email = try container.decode(String.self, forKey: .email)
        profilePhotoUrl = try container.decodeIfPresent(String.self, forKey: .profilePhotoUrl)
    }
    
    // 목업데이터를 위한 생성자
    init() {
        self.username = "userMockUp"
        self.nickname = "목업유저"
        self.email = "user@mockUp.com"
        self.profilePhotoUrl = "image-files/cycle.jpeg"
    }
}


struct EditedUserData: Encodable {
    var username: String
    var password: String
    var confirmPassword: String
    var email: String
    var nickname: String
    var profilePhoto: Data?
    
    init(username: String = "",
         password: String = "",
         confirmPassword: String = "",
         email: String = "",
         nickname: String = "",
         profilePhoto: Data? = nil) {
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
        self.email = email
        self.nickname = nickname
        self.profilePhoto = profilePhoto
    }
}
