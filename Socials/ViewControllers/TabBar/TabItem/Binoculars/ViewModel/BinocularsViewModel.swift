//
//  BinocularsViewModel.swift
//  Jivys
//
//  Created by Aisana on 10.07.2020.
//  Copyright © 2020 aisana. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BinocularsViewModel: BinocularsViewModelType {
  
    var resultsUser: BehaviorRelay<[ItemResultModel]> = BehaviorRelay(value: [])
    var page = 0
    var size = 4
    var total: Int = 0
    
    var maxPage = 0
    
    var currentItem: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var sizeImage: CGSize
    var indexPhoto: Int = 0
    
    init(sizeImage: CGSize){
        self.sizeImage = sizeImage
    }
    
    func initNumberPages(){
        page = 0
        size = 4
        total = 0
        maxPage = 0
    }
    
    var nameAndAge: String?{
        if let ind = currentItem.value, ind < resultsUser.value.count{
            if let name = resultsUser.value[ind].name, let age = resultsUser.value[ind].age{
                return "\(name), \(age)"
            }
        }
        return nil
    }
    
    var miles: String?{
        guard let ind = currentItem.value, ind < resultsUser.value.count, let dist = resultsUser.value[ind].distance else {
            return nil
        }
        
        return "\(dist) \(NSLocalizedString("miles from you", comment: "miles from you"))"
    }
    
    var ofMatch: String?{
        guard let ind = currentItem.value, ind < resultsUser.value.count, let match = resultsUser.value[ind].matchPercentage else {
            return nil
        }
        
        return "\(match)% \(NSLocalizedString("of match", comment: "of match"))"
    }
    
    var userID: String?{
        guard let ind = currentItem.value, ind < resultsUser.value.count else {
            return nil
        }
        
        return resultsUser.value[ind].id
    }
    
    func numberOfItemsInSection() -> Int {
        if let index = currentItem.value, index < resultsUser.value.count{
            return resultsUser.value[index].photosS3Keys?.count ?? 0
        }
        return 0
    }
    
    func cellForRow(at indexPath: IndexPath) -> BinocularsCellViewModelType {
        return BinocularsCellViewModel(photosS3Keys: resultsUser.value[currentItem.value!].photosS3Keys![indexPath.row], size: sizeImage)
    }
    
    func nextCurentItem() -> NextData{
        if currentItem.value != resultsUser.value.count - 1{
            indexPhoto = 0
            let newValue = (currentItem.value ?? -1) + 1
            currentItem.accept(newValue)
            return .next
        }else{
            page += 1
            if page <= maxPage{
                return .download
            }else{
                page -= 1
                return .end
            }
        }
    }
    
    func previousCurrentItem(){
        if currentItem.value != 0{
            indexPhoto = 0
            let newValue = (currentItem.value ?? 1) - 1
            currentItem.accept(newValue)
        }
    }
    
    func getMaxPage(){
        var t = (CGFloat(total) / CGFloat(size))
        t.round(.up)
        if t != 0 {
            maxPage = Int(t) - 1
        }
    }
    
    func addNewResultUsers(items: [ItemResultModel]){
        var temp = resultsUser.value
        for i in items{
            temp.append(i)
        }
        resultsUser.accept(temp)
        
        if currentItem.value != resultsUser.value.count - 1{
            indexPhoto = 0
            let newValue = (currentItem.value ?? -1) + 1
            currentItem.accept(newValue)
        }
    }
}


