
//  DetailViewModel.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/24/22.


import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func commentLoadedSuccessfully()
}

class DetailViewModel {
    var message: Message?
    private let service: FirebaseSyncable
    private weak var delegate: DetailViewModelDelegate?

    init(message: Message? = nil, service: FirebaseSyncable = FirestoreService(), delegate: DetailViewModelDelegate) {
        self.message = message
        self.service = service
    }
    func saveComment(withPost text: String, sender: String) {
        
    }
}

