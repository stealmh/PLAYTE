//
//  NetworkHelper.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case responseDataConversionFailed(Error)
    case decodingFailed(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkEndpoint {
    case recipes(_ sortedOption: Sort)      /// 레시피 목록 조회
    case createRecipe                       /// 레시피 생성
    case deleteMyRecipe(_ recipeId: String) /// 나의 레시피 삭제
    case recipeDetail(_ recipeId: String)   /// 레시피 상세 조회
    case recipeLike(_ recipeId: String)     /// 레시피 좋아요
    case recipeUnLike(_ recipeId: String)   /// 레시피 좋아요 취소
    case recipeSave(_ recipeId: String)     /// 레시피 저장
    case recipeUnSave(_ recipeId: String)   /// 레시피 저장 취소
    case mySaveRecipeSearch                 /// 내가 저장한 레시피 조회
    case myWrittenRecipeSearch              /// 내가 작성한 레시피 조회
    case myInfo                             /// 내정보 조회
    case logout                             /// 로그아웃
    case withdrawal                         /// 회원탈퇴
    case myReviewSearch                     /// 내가 작성한 리뷰 조회
    case ingredient                         /// 재료 목록 조회
    
    var url: String {
        switch self {
        case .recipes(let sortedOption):
            return "https://api.rec1pe.store/api/v1/recipes?sort=\(sortedOption.sort)"
        case .createRecipe:
            return "https://api.rec1pe.store/api/v1/recipes"
        case .deleteMyRecipe(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)"
        case .recipeDetail(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/detail"
        case .recipeLike(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/like"
        case .recipeUnLike(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/unlike"
        case .recipeSave(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/save"
        case .recipeUnSave(let recipeId):
            return "https://api.rec1pe.store/api/v1/recipes/\(recipeId)/unsave"
        case .mySaveRecipeSearch:
            return "https://api.rec1pe.store/api/v1/recipes/saved"
        case .myWrittenRecipeSearch:
            return "https://api.rec1pe.store/api/v1/recipes/written"
        case .myInfo:
            return "https://api.rec1pe.store/api/v1/users/me"
        case .logout:
            return "https://api.rec1pe.store/api/v1/auth/logout"
        case .withdrawal:
            return "https://api.rec1pe.store/api/v1/auth/withdrawal"
        case .myReviewSearch:
            return "https://api.rec1pe.store/api/v1/reviews/my"
        case .ingredient:
            return "https://api.rec1pe.store/api/v1/ingredients"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .recipes,
             .recipeDetail,
             .mySaveRecipeSearch,
             .myWrittenRecipeSearch,
             .myInfo,
             .myReviewSearch,
             .ingredient:
            return .get
            
        case .createRecipe,
             .recipeLike,
             .recipeUnLike,
             .recipeSave,
             .recipeUnSave,
             .logout,
             .withdrawal:
            return .post
            
        case .deleteMyRecipe:
            return .delete
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout:
            return ["Authorization": KeyChain.shared.read(account: .accessToken),
                    "Refresh-Token": KeyChain.shared.read(account: .refreshToken),
                    "Content-Type": "application/json"]
        default:
            return ["Authorization": KeyChain.shared.read(account: .accessToken),
                    "Content-Type": "application/json"]
        
        }
    }
}

enum Sort {
    case latest     /// 최신순
    case popular    /// 인기순
    case minium     /// 최소시간순
    
    var sort: String {
        switch self {
        case .latest:
            return "latest"
        case .popular:
            return "popular"
        case .minium:
            return "minium"
        }
    }
}
