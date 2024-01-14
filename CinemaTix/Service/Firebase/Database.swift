//
//  Database.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import FirebaseFirestore

class FireDatabase {
    
    let db = Firestore.firestore()
    
    func addUser(user: UserModel, onSuccess: @escaping ((String?) -> Void), onError: ((AppError) -> Void)? = nil) {
        let usersCollection = db.collection("users")
        var ref: DocumentReference?
        
        ref = usersCollection.addDocument(data: user.toDict()) { error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            } else {
                onSuccess(ref?.documentID)
            }
        }
    }
    
    func updateWallet(wallet: WalletModel, onSuccess: @escaping (() -> Void), onError: ((AppError) -> Void)? = nil) {
        let walletsCollection = db.collection("wallets")
        var ref: DocumentReference?
        
        if let walletId = wallet.id {
            ref = walletsCollection.document(walletId)
            ref?.getDocument { snapshot, error  in
                if let _error = error {
                    onError?(AppError(message: _error.localizedDescription))
                } else {
                    ref?.updateData(wallet.toDict()) { error in
                        if let _error = error {
                            onError?(AppError(message: _error.localizedDescription))
                        } else {
                            onSuccess()
                        }
                    }
                }
            }
        } else {
            onError?(AppError(message: "Wallet ID is not found"))
        }
    }
    
    func addWallet(wallet: WalletModel, onSuccess: @escaping ((String?) -> Void), onError: ((AppError) -> Void)? = nil) {
        let walletsCollection = db.collection("wallets")
        var ref: DocumentReference?
        
        ref = walletsCollection.addDocument(data: wallet.toDict()) { error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            } else {
                onSuccess(ref?.documentID)
            }
        }
    }
    
    func addTransaction(trans: Transaction, onSuccess: @escaping ((String?) -> Void), onError: ((AppError) -> Void)? = nil) {
        let walletsCollection = db.collection("transactions")
        var ref: DocumentReference?
        
        ref = walletsCollection.addDocument(data: trans.toDict()) { error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            } else {
                onSuccess(ref?.documentID)
            }
        }
    }
    
    func getUserBy(email: String, onSuccess: @escaping ((UserModel) -> Void), onError: ((AppError) -> Void)? = nil) {
        let usersCollection = db.collection("users")
        usersCollection.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            }
            if let _documents = snapshot?.documents {
                let user = _documents.first
                if let data = user?.data() {
                    let user = UserModel.fromDict(data)
                    onSuccess(user)
                } else {
                    onError?(AppError(message: "User data is not found"))
                }
            } else {
                onError?(AppError(message: "Wallet Documents is not found"))
            }
        }
    }
    
    func getWalletBy(id: String, onSuccess: @escaping ((WalletModel) -> Void), onError: ((AppError) -> Void)? = nil) {
        let walletsCollection = db.collection("wallets")
        walletsCollection.document(id).getDocument { document, error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            }
            if let _document = document, _document.exists {
                if let data = _document.data() {
                    var wallet = WalletModel.fromDict(data)
                    wallet.id = id
                    onSuccess(wallet)
                } else {
                    onError?(AppError(message: "Wallet data is not found"))
                }
            } else {
                onError?(AppError(message: "Wallet Documents is not found"))
            }
        }
    }
    
    func getTransactionsBy(wallet: WalletModel, onSuccess: @escaping (([Transaction]) -> Void), onError: ((AppError) -> Void)? = nil) {
        let walletTrans = wallet.transactions
        let transCollection = db.collection("transactions")
        
        let dispatchGroup = DispatchGroup()
        var newTrans: [Transaction] = []
        
        for wallTranId in walletTrans ?? [] {
            dispatchGroup.enter()
            
            transCollection.document(wallTranId).getDocument { document, error in
                defer {
                    dispatchGroup.leave()
                }
                
                if let _error = error {
                    onError?(AppError(message: _error.localizedDescription))
                }
                if let _document = document, _document.exists {
                    
                    if let data = _document.data() {
                        let trans = Transaction.fromDict(data)
                        newTrans.append(trans)
                    } else {
                        onError?(AppError(message: "Transaction data is not found"))
                        return
                    }
                } else {
                    onError?(AppError(message: "Transaction Documents is not found"))
                    return
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            onSuccess(newTrans)
        }
    }
}
