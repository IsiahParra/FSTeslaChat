
//  HomeTableViewModel.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/19/22.


import Foundation

protocol HomeTBVCModelDelegate: AnyObject {
    func messageRecieved()
}

class HomeTBVCModel {
    var messages: [Message] = [] {
        didSet {
            delegate?.messageRecieved()
        }
    }
    
    private weak var delegate: HomeTBVCModelDelegate?
    private let fireStoreServices: FirebaseSyncable
    
    init(delegate: HomeTBVCModelDelegate, firestoreService: FirebaseSyncable = FirestoreService()) {
        self.delegate = delegate
        self.fireStoreServices = firestoreService
        loadMessages()
        firestoreService.addListneres(self)
    }
    
    func postMessage(text: String) {
        let newMessage = Message(id: "id", text: text, sender: "NewBot", imageURL: "https://firebasestorage.googleapis.com:443/v0/b/traveldiarylectureios2.appspot.com/o/images%2FC562D16D-5948-442B-974C-A6FA737DA3D2?alt=media&token=33dd52ad-bf07-4240-a307-b08910effce4")
        DispatchQueue.main.async {
            self.fireStoreServices.post(newMessage)
            self.delegate?.messageRecieved()
        }
    }
    
    private func loadMessages() {
        fireStoreServices.loadMessages { result in
            switch result {
            case .success(let messages):
                    self.messages = messages
//                    self.delegate?.messageRecieved()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
