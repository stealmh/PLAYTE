//
//  CommentTestViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/07/28.
//

import UIKit

class CommentTestViewModel : NSObject, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate {
    
    var reloadSections: ((_ section: Int, _ indexpaths: [IndexPath], _ isInserting: Bool) -> Void)?
    var model : CategoryModel?
    var dataSourceCollection = [ExpandableCategories]()
    var categories: [String] {
        var collection = [String]()
        for value in CategoryModel.CodingKeys.allCases {
            collection.append(value.rawValue)
        }
        return collection
    }

    override init() {
        super.init()
        readMockData("Category")
        populateDataSourceCollection()
    }
    
    private func populateDataSourceCollection() {
        var collection = [ExpandableCategories]()
        if let model = model {
            collection.append(ExpandableCategories(isExpanded: false,
                                                   categoryHeader: CategoryModel.CodingKeys.actionAdventure.rawValue,
                                                   categoryItems: model.actionAdventure))
            
            collection.append(ExpandableCategories(isExpanded: false,
                                                   categoryHeader: CategoryModel.CodingKeys.actionComedies.rawValue,
                                                   categoryItems: model.actionComedies))
            
            collection.append(ExpandableCategories(isExpanded: false,
                                                   categoryHeader: CategoryModel.CodingKeys.actionSciFiFantasy.rawValue,
                                                   categoryItems: model.actionSciFiFantasy))
            
            collection.append(ExpandableCategories(isExpanded: false,
                                                   categoryHeader: CategoryModel.CodingKeys.actionThrillers.rawValue,
                                                   categoryItems: model.actionThrillers))
        }
        dataSourceCollection = collection
    }
    
    private func readMockData(_ filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            var data =  Data()
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.model = try JSONDecoder().decode(CategoryModel.self, from: data)
            }
            catch {
                // handle error
            }
        }
    }
    
    func toggleSection(header: CustomFirstTableViewHeaderFooterView, section: Int) {
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
        header.nickNameLabel.text = categories[section]
        // Toggle collapse
        let collapsed = !dataSourceCollection[section].isExpanded
        header.setCollapsed(collapsed: collapsed)
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
            headerView.nickNameLabel.text = categories[section]
            headerView.section = section
            headerView.delegate = self
            // Toggle collapse
            let collapsed = !dataSourceCollection[section].isExpanded
            headerView.setCollapsed(collapsed: collapsed)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentTestItemCell.identifier, for: indexPath) as? CommentTestItemCell {
            cell.myTitle.text = dataSourceCollection[indexPath.section].categoryItems[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

struct ExpandableCategories : Equatable {
    var isExpanded: Bool
    let categoryHeader: String
    let categoryItems: [Item]
}
