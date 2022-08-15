
//  FirestoreServices.swift
//  FSTeslaChat(MVVM)
//
//  Created by Isiah Parra on 6/19/22.



import FirebaseFirestore
import UIKit
import FirebaseStorage

enum FirebaseError: Error {
    case firebaseError(Error)
    case failedToUnwrapData
    case noDataFound
}

protocol FirebaseSyncable {
    func post(_ message: Message)
    func loadMessages(completion: @escaping (Result<[Message], FirebaseError>) -> Void)
    func addListneres(_ viewModel: HomeTBVCModel)
    func decodeMessageSnap(_ snapshot: QuerySnapshot?, _ error: Error?) -> [Message]
    func delete(message: Message)
//    func saveImage(_ image: UIImage, to message: Message, completion: @escaping () -> Void)
    func fetchImage(from message: Message, completion: @escaping (Result<UIImage, FirebaseError>) -> Void)
}

class FirestoreService: FirebaseSyncable {
    let ref = Firestore.firestore()
    let storage = Storage.storage().reference()
    func post(_ message: Message) {
        ref.collection(Message.Key.collectionType).addDocument(data: message.messageData)
        }
    
    func loadMessages(completion: @escaping (Result<[Message], FirebaseError>) -> Void) {
        ref.collection(Message.Key.collectionType).getDocuments { snapshot, error in
            completion(.success(self.decodeMessageSnap(snapshot,error)))
        }
    }
    func addListneres(_ viewModel: HomeTBVCModel) {
        ref.collection(Message.Key.collectionType).addSnapshotListener { snapshot, error in
            guard let newMessage = self.decodeMessageSnap(snapshot, error).last else {return}
            viewModel.messages.append(newMessage)
        }
    }
    func decodeMessageSnap(_ snapshot: QuerySnapshot?, _ error: Error?) -> [Message] {
        if let error = error {
            print(error)
            return []
        }
        guard let data = snapshot?.documents else {
            return []
        }
        return data.compactMap({ $0.data() })
            .compactMap({Message(fromDictionary: $0)})
            .sorted(by: { $0.timeStamp < $1.timeStamp })
            
        }
    func delete(message: Message) {
        ref.collection(Message.Key.collectionType).document(message.id).delete()
    }
//    func saveImage(_ image: UIImage, to message: Message, completion: @escaping () -> Void) {
//        guard let imageData = image.pngData() else {return}
//        storage.child("images").child(message.id).putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion()
//                return
//            }
//            self.storage.child("images").child(message.id).downloadURL { url, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion()
//                    return
//                }
//                guard let url = url else {
//                    return
//                }
//                message.imageURL = url
//                completion()
//            }
//        }
//    }
    
    func fetchImage(from message: Message, completion: @escaping (Result<UIImage, FirebaseError>) -> Void) {
        storage.child("images").child(message.id).getData(maxSize: 1024 * 1024) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.failedToUnwrapData))
                    return
                }
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    func deleteImage(from message: Message) {
        storage.child("images").child(message.id).delete(completion: nil)
    }
}// end of class
