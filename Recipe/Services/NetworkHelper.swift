//
//  NetworkHelper.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidDataConversion
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
    case recipes(_ sortedOption: Sort)                           /// 레시피 목록 조회 O
    case createRecipe                                            /// 레시피 생성 O
    case deleteMyRecipe(_ recipeId: String)                      /// 나의 레시피 삭제 O
    case recipeDetail(_ recipeId: String)                        /// 레시피 상세 조회 O
    case recipeLike(_ recipeId: String)                          /// 레시피 좋아요
    case recipeUnLike(_ recipeId: String)                        /// 레시피 좋아요 취소
    case recipeSave(_ recipeId: String)                          /// 레시피 저장 O
    case recipeUnSave(_ recipeId: String)                        /// 레시피 저장 취소 O
    case mySaveRecipeSearch                                      /// 내가 저장한 레시피 조회 O
    case myWrittenRecipeSearch                                   /// 내가 작성한 레시피 조회 O
    case myInfo                                                  /// 내정보 조회 O
    case logout                                                  /// 로그아웃 O
    case withdrawal                                              /// 회원탈퇴 O
    case myReviewSearch                                          /// 내가 작성한 리뷰 조회 O
    case ingredient                                              /// 재료 목록 조회 O
    case imageUpload                                             /// 이미지 업로드 O
    case recipeScores(_ recipeId: String)                        /// 레시피 리뷰 상단 별점 O
    case recipeReviewPhoto(_ recipeId: String)                   /// 레시피 리뷰 사진들 모두 조회 O
    case recipeReview( _ recipdId: String, _ sortedOption: Sort) /// 리뷰 조회 O
    case likeReview(_ reviewId: String)                          /// 리뷰 좋아요 O
    case unlikeReview(_ reviewId: String)                        /// 리뷰 좋아요 취소 O
    case banReview( _ reviewId: String)                          /// 리뷰 신고 O
    case createReview(_ reviewId: String)                        /// 리뷰 등록 O
    case deleteReview(_ reviewId: String)                        /// 리뷰 삭제
    case recipeComment(_ recipeId: String)                       /// 댓글 조회 O
    case searchKeyword                                           /// 인기 검색어 조회(검색창 들어왔을 때 검색어 순위) O
    case searchRecipe(_ keyword: String)                         /// 레시피 검색 O
    case searchShortForm(_ keyword: String)                      /// 숏폼 검색 O
    case recipeTheme(_ themeName: Theme)                         /// 레시피 테마 검색  O
    case nickNameChange                                          /// 닉네임 변경 O
    case verifyNickName                                          /// 닉네임 검증 O
    case shortForms                                              /// 숏폼 조회 O
    case createShortForm                                         /// 숏폼생성 O
    case videoUpload                                             /// 비디오 업로드 O
    case likeShortForm(_ shortformId: String)                    /// 숏폼 좋아요 O
    case unlikeShortForm(_ shortformId: String)                  /// 숏폼 좋아요 취소 O
    case saveShortForm(_ shortformId: String)                    /// 숏폼 저장 O
    case unsaveShortForm(_ shortformId: String)                  /// 숏폼 저장 취소 O
    case shortformComment(_ shortformId: String)                 /// 숏폼 레시피 댓글 조회 O
    case createshortformComment(_ shortformId: String)           /// 숏폼 레시피 댓글 등록 O
    case shortformCommentLike(_ shortformCommentId: String)      /// 숏폼 댓글 좋아요 O
    case shortformCommentUnLike(_ shortformCommentId: String)    /// 숏폼 댓글 좋아요 취소 O
    case shortformCommentReport(_ shortformCommentId: String)    /// 숏폼 레시피 댓글 신고 O
    case createshortformCommentReply(_ shortformCommentId: String) /// 숏폼대댓글 등록 O
    case shortformCommentReplyLike(_ shortformCommentId: String) /// 숏폼 대댓글 좋아요 O
    case shortformCommentReplyUnLike(_ shortformCommentId: String) /// 숏폼 대댓글 좋아요 취소 O
    case shortformCommentReplyReport(_ shortformCommentId: String) /// 숏폼 대댓글 신고 O
    case createRecipeComment(_ recipeId: String)                 /// 레시피 댓글 달기 O
    case recipeCommentReport(_ commentId: String)                /// 레시피 댓글 신고 O
    case recipeCommentLike(_ commentId: String)                  /// 레시피 댓글 좋아요 O
    case recipeCommentUnLike(_ commentId: String)                /// 레시피 댓글 좋아요 취소 O
    case createRecipeCommentChild(_ replyId: String)             /// 레시피 대댓글 달기 O
    case recipeCommentLikeChild(_ replyId: String)               /// 레시피 대댓글 좋아요 O
    case recipeCommentUnLikeChild(_ replyId: String)             /// 레시피 대댓글 좋아요 취소 O
    case recipeCommentReportChild(_ replyId: String)             /// 레시피 대댓글 신고 O
    case recipeReport(_ recipeId: String)                        /// 레시피 신고 O
    case recipeNotInterest(_ recipeId: String)                   /// 레시피 관심없음
    case shortformReport(_ shortformId: String)                  /// 숏폼 신고 O
    case shortformNotInterest(_ shortformId: String)             /// 숏폼 관심 없음 O
    
    
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
        case .imageUpload:
            return "https://api.rec1pe.store/api/v1/file/upload/image"
        case .recipeScores(let recipeId):
            return "https://api.rec1pe.store/api/v1/reviews/recipe/\(recipeId)/scores"
        case .recipeReviewPhoto(let recipeId):
            return "https://api.rec1pe.store/api/v1/reviews/photos/recipe/\(recipeId)"
        case .recipeReview(let recipeId, let sortedOption):
            return "https://api.rec1pe.store/api/v1/reviews/recipe/\(recipeId)?sort=\(sortedOption.sort)"
        case .likeReview(let reviewId):
            return "https://api.rec1pe.store/api/v1/reviews/\(reviewId)/like"
        case .unlikeReview(let reviewId):
            return "https://api.rec1pe.store/api/v1/reviews/\(reviewId)/unlike"
        case .banReview(let reviewId):
            return "https://api.rec1pe.store/api/v1/reviews/\(reviewId)/report"
        case .createReview(let recipeId):
            return "https://api.rec1pe.store/api/v1/reviews/recipe/\(recipeId)"
        case .deleteReview(let reviewId):
            return "https://api.rec1pe.store/api/v1/reviews/\(reviewId)"
        case .recipeComment(let recipeId):
            return "https://api.rec1pe.store/api/v1/comments/recipe/\(recipeId)"
        case .searchKeyword:
            return "https://api.rec1pe.store/api/v1/search/keywords"
        case .searchRecipe(let keyword):
            return "https://api.rec1pe.store/api/v1/search/recipe?keyword=\(keyword)"
        case .searchShortForm(let keyword):
            return "https://api.rec1pe.store/api/v1/search/shortform?keyword=\(keyword)"
        case .recipeTheme(let theme):
            return "https://api.rec1pe.store:443/api/v1/recipes/recipe/theme?themeName=\(theme.rawValue)"
        case .nickNameChange:
            return "https://api.rec1pe.store:443/api/v1/users/change-nickname"
        case .verifyNickName:
            return "https://api.rec1pe.store:443/api/v1/users/verify-nickname"
        case .shortForms:
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform"
        case .createShortForm:
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform"
        case .videoUpload:
            return "https://api.rec1pe.store:443/api/v1/file/upload/video"
        case .likeShortForm(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/\(shortformId)/like"
        case .unlikeShortForm(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/\(shortformId)/unlike"
        case .saveShortForm(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/\(shortformId)/save"
        case .unsaveShortForm(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/\(shortformId)/unsave"
        case .shortformComment(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/comments/shortform/\(shortformId)"
        case .createshortformComment(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/comments/shortform/\(shortformId)"
        case .shortformCommentLike(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/comments/shortform/like/\(shortformCommentId)"
        case .shortformCommentUnLike(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/comments/shortform/unlike/\(shortformCommentId)"
        case .shortformCommentReport(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/comments/shortform/\(shortformCommentId)/report"
        case .shortformCommentReplyLike(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/replies/shortform/like/\(shortformCommentId)"
        case .shortformCommentReplyUnLike(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/replies/shortform/unlike/\(shortformCommentId)"
        case .shortformCommentReplyReport(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/replies/shortform/\(shortformCommentId)/report"
        case .createshortformCommentReply(let shortformCommentId):
            return "https://api.rec1pe.store:443/api/v1/replies/shortform/comment/\(shortformCommentId)"
        case .createRecipeComment(let recipeId):
            return "https://api.rec1pe.store:443/api/v1/comments/recipe/\(recipeId)"
        case .recipeCommentLike(let commentId):
            return "https://api.rec1pe.store:443/api/v1/comments/recipe/like/\(commentId)"
        case .recipeCommentUnLike(let commentId):
            return "https://api.rec1pe.store:443/api/v1/comments/recipe/unlike/\(commentId)"
        case .recipeCommentReport(let commentId):
            return "https://api.rec1pe.store:443/api/v1/comments/recipe/\(commentId)/report"
        case .recipeReport(let recipeId):
            return "https://api.rec1pe.store:443/api/v1/recipes/recipe/\(recipeId)/report"
        case .shortformReport(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/\(shortformId)/report"
        case .shortformNotInterest(let shortformId):
            return "https://api.rec1pe.store:443/api/v1/recipes/shortform/not-interest/\(shortformId)"
        case .recipeCommentLikeChild(let replyId):
            return "https://api.rec1pe.store:443/api/v1/replies/recipe/like/\(replyId)"
        case .recipeCommentUnLikeChild(let replyId):
            return "https://api.rec1pe.store:443/api/v1/replies/recipe/unlike/\(replyId)"
        case .createRecipeCommentChild(let replyId):
            return "https://api.rec1pe.store:443/api/v1/replies/recipe/comment/\(replyId)"
        case .recipeCommentReportChild(let replyId):
            return "https://api.rec1pe.store:443/api/v1/replies/recipe/\(replyId)/report"
        case .recipeNotInterest(let recipeId):
            return "https://api.rec1pe.store:443/api/v1/recipes/recipe/not-interest/\(recipeId)"
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
             .ingredient,
             .recipeScores,
             .recipeReviewPhoto,
             .recipeReview,
             .recipeComment,
             .searchKeyword,
             .searchRecipe,
             .searchShortForm,
             .recipeTheme,
             .shortForms,
             .shortformComment,
             .shortformCommentLike,
             .shortformCommentUnLike,
             .shortformCommentReplyLike,
             .shortformCommentReplyUnLike,
             .recipeCommentLike,
             .recipeCommentUnLike,
             .recipeReport,
             .shortformReport,
             .shortformNotInterest,
             .recipeCommentLikeChild,
             .recipeCommentUnLikeChild,
             .recipeNotInterest:
            return .get
            
        case .createRecipe,
             .recipeLike,
             .recipeUnLike,
             .recipeSave,
             .recipeUnSave,
             .logout,
             .withdrawal,
             .imageUpload,
             .banReview,
             .likeReview,
             .unlikeReview,
             .createReview,
             .nickNameChange,
             .verifyNickName,
             .createShortForm,
             .videoUpload,
             .likeShortForm,
             .unlikeShortForm,
             .saveShortForm,
             .unsaveShortForm,
             .createshortformComment,
             .shortformCommentReport,
             .shortformCommentReplyReport,
             .createshortformCommentReply,
             .recipeCommentReport,
             .createRecipeComment,
             .createRecipeCommentChild,
             .recipeCommentReportChild:
            return .post
            
        case .deleteMyRecipe,
             .deleteReview:
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
            return "shortest"
        }
    }
}
