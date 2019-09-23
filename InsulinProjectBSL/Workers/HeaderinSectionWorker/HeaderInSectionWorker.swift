//
//  HeaderInSectionWorker.swift
//  InsulinProjectBSL
//
//  Created by PavelM on 05/09/2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import Foundation

protocol HeaderInSectionWorkerProtocol {
  
  var isExpanded:Bool {get set}
}


class HeaderInSectionWorker {
  
  var arraySectionAllProductsExpanded = [Bool]()
  var arraySectionFavoritsExpanded = [Bool]()
  
  var arraySectionMealsExpanded = [Bool]()
  
  var isDefaultListMeal: Bool = true
  
  
//  func updateViewModelByExpandSection(oldViewModel: [HeaderInSectionWorkerProtocol], newViewModel:[HeaderInSectionWorkerProtocol])  -> [HeaderInSectionWorkerProtocol] {
//
//    fillSectionExpandedArray(viewModels: oldViewModel,arraySection: &arraySectionDefault)
//    let updateViewModel = setSectionExpandedInViewModel(viewModels: newViewModel, arraySection: &arraySectionDefault)
//
//    return updateViewModel
//  }
  
  func changeIsDefaultlistByCategory(segment: Segment) {
    
    switch segment {
      
      case .meals:
        self.isDefaultListMeal = !isDefaultListMeal
      
    default: break
      
    }
  }
  
  
  func updateOneSection(section: Int, currentSegment: Segment) {

    switch currentSegment {
      case .allProducts:
        arraySectionAllProductsExpanded[section] =  !arraySectionAllProductsExpanded[section]
      case .favorits:
        arraySectionFavoritsExpanded[section] = !arraySectionFavoritsExpanded[section]
      case .meals:
        arraySectionMealsExpanded[section] = !arraySectionMealsExpanded[section]


    }
  }
  
  // Этот метод иде для foodViewController
  func updateViewModelByExpandSection(newViewModel:[HeaderInSectionWorkerProtocol], with segment: Segment)  -> [HeaderInSectionWorkerProtocol] {
    
    var updateViewModel: [HeaderInSectionWorkerProtocol]
    
    switch segment {
      
      case .allProducts:
        updateViewModel = setSectionExpandedInViewModel(viewModels: newViewModel,arraySection:&arraySectionAllProductsExpanded)
      
      case .favorits:
        updateViewModel = setSectionExpandedInViewModel(viewModels: newViewModel,arraySection: &arraySectionFavoritsExpanded)
      case .meals:
        updateViewModel = setSectionExpandedInViewModel(viewModels: newViewModel,arraySection: &arraySectionMealsExpanded)

    }
   

    return updateViewModel
  }
  
  func fillSectionExpandedArrayBySegment(viewModels: [HeaderInSectionWorkerProtocol],segment: Segment) {
    
    switch segment {
      
      case .allProducts:
        fillSectionExpandedArray(viewModels: viewModels, arraySection: &arraySectionAllProductsExpanded)
      case .favorits:
        fillSectionExpandedArray(viewModels: viewModels, arraySection: &arraySectionFavoritsExpanded)
    case .meals:
      fillSectionExpandedArray(viewModels: viewModels, arraySection: &arraySectionMealsExpanded)
      
    }
    
    
  }
  
  private func fillSectionExpandedArray(viewModels: [HeaderInSectionWorkerProtocol],arraySection: inout [Bool]) {
    
    arraySection.removeAll()
    
    viewModels.forEach { (viewModel) in
      arraySection.append(viewModel.isExpanded)
    }
    
  }
  
  // Изменим переданный массив
  private func setSectionExpandedInViewModel(viewModels: [HeaderInSectionWorkerProtocol],arraySection: inout [Bool]) -> [HeaderInSectionWorkerProtocol] {
    
    var viewModels = viewModels
    
    if !arraySection.isEmpty && arraySection.count == viewModels.count {
      for (index,isExpanded) in arraySection.enumerated() {
        viewModels[index].isExpanded = isExpanded
      }
    }
    return viewModels
    
  }
  
  
}
