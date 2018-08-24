//
//  WebConnectionProvider.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/15/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

let moleskineNFCWebServiceProvider = MoyaProvider<MoleskineNFCWebProvider>()

public enum MoleskineNFCWebProvider {
    case pulse
    case createTag(uri:String, uuid:String, notebookId: Int)
    case insideNotebook(uri:String)
}

extension MoleskineNFCWebProvider: TargetType {
 
    public var baseURL: URL {
        return URL(string: "http://192.168.1.10:8000")!
    }
    
    public var path: String {
        switch self {
        case .pulse:
            return "/api"
        case .createTag:
            return "/api/tag/create"
        case .insideNotebook:
            return "/api/notebook/inside-my-notebook"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .pulse:
            return .get
        case .createTag( _, _, _ ):
            return .post
        case .insideNotebook( _ ):
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .pulse:
             return .requestPlain
        case .createTag(let uri, let uuid, let notebookId):
            return .requestParameters(parameters: ["uri": uri, "uuid": uuid, "notebookId": notebookId], encoding: JSONEncoding.default)
        case .insideNotebook(let uri):
            return .requestParameters(parameters: ["uri": uri], encoding: JSONEncoding.default)
        }
    }

    public var validationType: ValidationType {
        switch self {
        case .pulse:
            return .successCodes
        case .createTag( _, _, _):
            return .successCodes
        case .insideNotebook( _ ):
            return .successCodes
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .pulse:
                return "ok".data(using: String.Encoding.utf8)!
        case .createTag(let uri, let uuid, let notebookId):
            do{
                let tag = SelinkoTag(uri: uri, notebookId: notebookId, uuid: uuid)
                let jsonData = try JSONEncoder().encode(tag)
                return jsonData
            }catch{
                print(error)
            }
            return "error".data(using: String.Encoding.utf8)!
        case .insideNotebook(let uri):
            print(uri)
            do{
                let aDate : String = "01/01/2001"
                let aPicture : String  = "http://www.placekitten.io/100/100"
                let sampleNotebook = MoleskineNotebook(id: 1,
                                                       title: "Notebook Title",
                                                       createdAt: aDate,
                                                       updatedAt: aDate,
                                                       pages: [
                                                            Page(id: 1,
                                                                 number: 1,
                                                                 notebookId: 1,
                                                                 createdAt: aDate,
                                                                 updatedAt: aDate,
                                                                 pageItems: [
                                                                    PageItem(id: 1,
                                                                             createdAt: aDate,
                                                                             updatedAt: aDate,
                                                                             pageId: 1,
                                                                             body: "body",
                                                                             image: aPicture),
                                                                    PageItem(id: 2,
                                                                             createdAt: aDate,
                                                                             updatedAt: aDate,
                                                                             pageId: 1,
                                                                             body: "body",
                                                                             image: aPicture),
                                                                ]),
                                                            Page(id: 2,
                                                                 number: 2,
                                                                 notebookId: 1,
                                                                 createdAt: aDate,
                                                                 updatedAt: aDate,
                                                                 pageItems: [
                                                                    PageItem(id: 3,
                                                                             createdAt: aDate,
                                                                             updatedAt: aDate,
                                                                             pageId: 2,
                                                                             body: "body",
                                                                             image: aPicture),
                                                                    PageItem(id: 4,
                                                                             createdAt: aDate,
                                                                             updatedAt: aDate,
                                                                             pageId: 2,
                                                                             body: "body",
                                                                             image: aPicture),
                                                                    ]),
                                                        ],
                                                       owner:User(id: 1,
                                                                  email: "user@user.com",
                                                                  firstName: "John",
                                                                  lastName: "Dow",
                                                                  createdAt: aDate,
                                                                  updatedAt: aDate)
                                                        )
                let jsonData = try JSONEncoder().encode(sampleNotebook)
                return jsonData
            }catch{
                print(error)
            }
            return "error".data(using: String.Encoding.utf8)!
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
        
}
