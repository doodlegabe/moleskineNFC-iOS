//
//  SelinkoTag.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/16/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import Foundation

class SelinkoTag: NSObject, Codable {
    
    var uri: String
    var uuid: String
    var notebookId: Int
    var notebook: MoleskineNotebook
    
    init(uri: String, notebookId: Int, uuid: String) {
        self.uri = uri
        self.notebookId = notebookId
        self.uuid = uuid
        self.notebook = MoleskineNotebook(id: 0, title: "", createdAt: "", updatedAt: "", pages: [], owner: User(id: 0, email: "", firstName: "", lastName: "", createdAt: "", updatedAt: ""))
    }
    
    func createDBRecord(){
        moleskineNFCWebServiceProvider.request(.createTag(uri: self.uri,
                                                          uuid: self.uuid,
                                                          notebookId: self.notebookId)
        ) { result in
            var message = "Couldn't access API"
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                message = jsonString ?? message
            }
           print(message)
            
        }
        
    }
    
    func getCorrespondingNotebook(){
        print("getCorrespondingNotebook")
        moleskineNFCWebServiceProvider.request(.insideNotebook(uri: self.uri)
        ) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    self.notebook = try filteredResponse.map(MoleskineNotebook.self)
                    NotificationCenter.default.post(name: MainViewController.onWebServiceResult, object: nil, userInfo: ["notebook":self.notebook])
                }
                catch let error {
                    // Here we get either statusCode error or jsonMapping error.
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
        
    }
}



