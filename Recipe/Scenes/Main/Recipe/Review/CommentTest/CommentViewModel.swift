//
//  CommentViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/28.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewModel : NSObject, UITableViewDataSource, UITableViewDelegate, CommentFooterViewDelegate {
    
    /// 댓글용(숏츠)
    var replyRelay = PublishRelay<(String, Int)>()
    var likeRelay = PublishRelay<(Int,Int)>()
    var reportRelay = PublishRelay<(Int,Int)>()
    
    /// 대댓글용(숏츠)
    var replyForChildRelay = PublishRelay<(String, Int, Int, Int)>()
    var likeForChildRelay = PublishRelay<(Int,Int, Int)>()
    var reportForChildRelay = PublishRelay<(Int,Int, Int)>()
    
    var reloadData = PublishRelay<RecipeComment>()
    var reloadSections: ((_ section: Int, _ indexpaths: [IndexPath], _ isInserting: Bool) -> Void)?
    var model : CategoryModel?
    var dataSourceCollection = [ExpandableCategories]()
    var disposeBag = DisposeBag()
    var categories: [String] {
        var collection = [String]()
        for value in CategoryModel.CodingKeys.allCases {
            collection.append(value.rawValue)
        }
        return collection
    }
    
    override init() {
        super.init()
        //        readMockData("Category")
        //        populateDataSourceCollection()
    }
    
    var recipeComment: RecipeComment?
    
    init(recipeComment: RecipeComment) {
        self.recipeComment = recipeComment
        super.init()
        populateDataSourceCollection(with: recipeComment)
    }
    
    private func populateDataSourceCollection(with comment: RecipeComment) {
        var collection = [ExpandableCategories]()
        for info in comment.data.content {
            let header = info.comment_writtenby
            let items = info.replyList.map { Item(name: $0.created_at) }  // ReplyList를 Item으로 변환
            let uploadTime = info.created_at
            let content = info.comment_content
            let is_liked = info.is_liked
            let likeCount = info.comment_likes
            let commentID = info.comment_id
            
            let expandableCategory = ExpandableCategories(isExpanded: false, categoryHeader: header, uploadTime: uploadTime,is_liked: is_liked,comment_id: commentID,cooment_likes: likeCount ,content: content, categoryItems: info.replyList)
            collection.append(expandableCategory)
        }
        dataSourceCollection = collection
        print(dataSourceCollection)
    }
    
    func toggleSection(header: CommentFooterView, section: Int) {
        let expandedSectionCollection = dataSourceCollection.filter({ $0.isExpanded == true })
        // count == 1, when a section is already expanded
        if expandedSectionCollection.count == 1 {
            if let expandedSection = expandedSectionCollection.first {
                // Get index of selected section
                if let expandedSectionIndex = dataSourceCollection.firstIndex(of: expandedSection) {
                    expandOrShrinkSection(isExpanding: false, selectedSection: expandedSectionIndex)
                    if expandedSectionIndex != section {
                        expandOrShrinkSection(isExpanding: true, selectedSection: section)
                    }
                }
            }
        } else {
            expandOrShrinkSection(isExpanding: true, selectedSection: section)
        }
        // Set  title
        //        header.nickNameLabel.text = categories[section]
        // Toggle collapse
        let collapsed = !dataSourceCollection[section].isExpanded
        header.setCollapsed(collapsed: collapsed, applyCount: dataSourceCollection.count)
    }
    
    private func expandOrShrinkSection(isExpanding: Bool, selectedSection: Int) {
        
        if isExpanding {
            dataSourceCollection[selectedSection].isExpanded = true
            if let reloadSections = reloadSections {
                reloadSections(selectedSection, getIndexPathsOfSection(selectedSection), true)
            }
        } else {
            dataSourceCollection[selectedSection].isExpanded = false
            if let reloadSections = reloadSections {
                reloadSections(selectedSection, getIndexPathsOfSection(selectedSection), false)
            }
        }
    }
    
    private func getIndexPathsOfSection(_ selectedSection: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in dataSourceCollection[selectedSection].categoryItems.indices {
            let indexPath = IndexPath(row: row, section: selectedSection)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFirstTableViewHeaderFooterView") as? CustomFirstTableViewHeaderFooterView {
            headerView.configure(dataSourceCollection[section], section: section)
            headerView.delegate = self
            reloadData.subscribe(onNext: { data in
                print("== reloadData Subscribe ==")
                self.dataSourceCollection = []
                self.populateDataSourceCollection(with: data)
                headerView.configure(self.dataSourceCollection[section], section: section)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }).disposed(by: disposeBag)
            // Toggle collapse
            let collapsed = !dataSourceCollection[section].isExpanded
            headerView.setCollapsed(collapsed: collapsed)
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentFooterView") as? CommentFooterView {
            headerView.section = section
            headerView.delegate = self
//            if dataSourceCollection[section].categoryItems.count < 2 {
//                headerView.isHidden = true
//                headerView.setCollapsed(collapsed: false, applyCount: 0)
//            }
            // Toggle collapse
            let collapsed = !dataSourceCollection[section].isExpanded
            headerView.setCollapsed(collapsed: collapsed, applyCount: dataSourceCollection[section].categoryItems.count)
            return headerView
        }
        return UIView()
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 32
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceCollection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dataSourceCollection[section].isExpanded {
            return 0
        }
        return dataSourceCollection[section].categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentItemCell.identifier, for: indexPath) as? CommentItemCell {
            cell.delegate = self
            let item = dataSourceCollection[indexPath.section].categoryItems[indexPath.row]
            let section = indexPath.section
            let index = indexPath.row
            cell.configure(item, index: index, section: section)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK: - Header Action
extension CommentViewModel: HeaderViewDelegate {
    func didTappedLikeButton(id: Int, section: Int) {
        likeRelay.accept((id,section))
    }
    
    func didTappedReportButton(id: Int, section: Int) {
        reportRelay.accept((id,section))
    }
    
    func toggleSection(header: CustomFirstTableViewHeaderFooterView, section: Int) {
        //
    }
    
    func didTappedReplyButton(_ nickName: String, id: Int) {
        replyRelay.accept((nickName, id))
    }
}

//MARK: - Cell Action
extension CommentViewModel: CommentCellDelegate {
    func didTappedReplyButton(_ id: Int, _ nickName: String, _ index: Int, _ section: Int) {
        replyForChildRelay.accept((nickName, id, index, section))
//        replyRelay.accept((nickName, section))
    }
    
    func didTappedLikeButton(_ id: Int, _ index: Int, _ section: Int) {
        likeForChildRelay.accept((id, index, section))
    }
    
    func didTappedReportButton(_ id: Int, _ index: Int, _ section: Int) {
        reportForChildRelay.accept((id, index, section))
    }
}

//MARK: - 댓글용
extension CommentViewModel {
    /// 댓글용
    func registerComment(id: Int, parameter: [String: Any]) async -> Bool {
        do {
            let data1: DefaultReturnID = try await NetworkManager.shared.get(.createshortformComment("\(id)"),parameters: parameter)
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    /// 댓글용
    func likeComment(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentLike("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    
    
    /// 댓글용
    func unlikeComment(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentUnLike("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    /// 댓글용
    func reportComment(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentReport("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
}

//MARK: - 대댓글용
extension CommentViewModel {
    /// 댓글용
    func registerCommentReply(id: Int, parameter: [String: Any]) async -> Bool {
        do {
            let data1: DefaultReturnID = try await NetworkManager.shared.get(.createshortformCommentReply("\(id)"),parameters: parameter)
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    /// 댓글용
    func likeCommentReply(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentReplyLike("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    
    
    /// 댓글용
    func unlikeCommentReply(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentReplyUnLike("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    /// 댓글용
    func reportCommentReply(id: Int) async -> Bool {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformCommentReplyReport("\(id)"))
            if data1.code == "SUCCESS" {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
}



struct ExpandableCategories : Equatable {
    var isExpanded: Bool
    let categoryHeader: String /// nickName
    let uploadTime: String
    let is_liked: Bool
    let comment_id: Int
    let cooment_likes: Int
    let content: String       /// 댓글내용
    let categoryItems: [ReplyList] /// 대댓글 reply
}
