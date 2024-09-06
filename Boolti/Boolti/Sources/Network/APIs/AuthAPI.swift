//
//  AuthAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/24/24.
//

import Foundation

import Moya

enum AuthAPI {

    case login(provider: OAuthProvider, requestDTO: LoginRequestDTO)
    case logout
    case signup(requestDTO: SignUpRequestDTO)
    case refresh(requestDTO: TokenRefreshRequestDTO)
    case resign(requestDTO: ResignRequestDTO)
    case user
    case fetchProfile(requestDTO: EditProfileRequestDTO)
    case getUploadImageURL
    case uploadProfileImage(data: UploadProfileImageRequestDTO)
}

extension AuthAPI: ServiceAPI {
    
    var baseURL: URL {
        switch self {
        case .uploadProfileImage(let data):
            return URL(string: data.uploadUrl)!
        default:
            return URL(string: Environment.BASE_URL)!
        }
    }
    
    var path: String {
        switch self {
        case .login(let provider, _):
            return "/papi/v1/login/\(provider.rawValue)"
        case .logout:
            return "/v1/logout"
        case .signup:
            return "/papi/v1/signup/sns"
        case .refresh:
            return "/papi/v1/login/refresh"
        case .resign, .user, .fetchProfile:
            return "/api/v1/user"
        case .getUploadImageURL:
            return "/api/v1/user/profile-images/upload-urls"
        case .uploadProfileImage:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .resign:
            return .delete
        case .user:
            return .get
        case .fetchProfile:
            return .patch
        case .uploadProfileImage:
            return .put
        default:
            return .post
        }
    }

    var headers: [String : String]? {
        switch self {
        case .logout, .user, .getUploadImageURL:
            return nil
        case .login, .refresh, .signup, .resign, .fetchProfile:
            return ["Content-Type": "application/json"]
        case .uploadProfileImage:
            return ["Content-Type": "image/jpeg"]
        }
    }

    var task: Task {
        switch self {
        case .login(let provider, let DTO):
            let params: [String: Any]
            switch provider {
            case .kakao:
                params = ["accessToken": DTO.accessToken]
            case .apple:
                params = ["idToken": DTO.accessToken]
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
        case .logout, .user, .getUploadImageURL:
            return .requestPlain
        case .signup(let DTO):
            return .requestJSONEncodable(DTO)
        case .refresh(let DTO):
            return .requestJSONEncodable(DTO)
        case .resign(let DTO):
            return .requestJSONEncodable(DTO)
        case .fetchProfile(let DTO):
            return .requestJSONEncodable(DTO)
        case .uploadProfileImage(let DTO):
            return .requestData(DTO.imageData.jpegData(compressionQuality: 0.8) ?? Data())
        }
    }
}
