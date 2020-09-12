//
//  AccountDetailsTransformer.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

class Section: Hashable {
  var id = UUID()
    
  var title: String?
  var items: [TransactionPresentationItem]
  
  init(title: String?, items: [TransactionPresentationItem]) {
    self.title = title
    self.items = items
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}

struct AccountDetailsTransformer: DataTransforming {

    func transform(input: FullAccountDetailsResponse) -> [Section] {
        
        let items = input.clearedTransactions.map {  return TransactionPresentationItem($0) }
        
        return [Section(title: "12th Aug 2020", items: items)]
    }
}

