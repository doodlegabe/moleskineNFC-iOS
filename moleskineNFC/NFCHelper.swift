//
//  NFCHelper.swift
//  TagReader
//
//  Created by Jameson Quave on 6/16/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import Foundation
import CoreNFC
import VYNFCKit

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate{
    var onNFCResult: ((Bool, String) -> ())?
    func restartSession() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
    session.begin()
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    guard let onNFCResult = onNFCResult else { return }
    onNFCResult(false, error.localizedDescription)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    guard onNFCResult != nil else { return }
    for message in messages {
      for record in message.records {
        guard let parsedPayload = VYNFCNDEFPayloadParser.parse(record) else {
            continue
        }
        var isSelinko: Bool = false
        var text: String = ""
        if let parsedPayload = parsedPayload as? VYNFCNDEFTextPayload {
            text = "[Text payload]\n"
            text = String(format: "%@%@", text, parsedPayload.text)
        } else if let parsedPayload = parsedPayload as? VYNFCNDEFURIPayload {
            
            //FIXME: check for curt.li
            let aSelinkoTag = SelinkoTag(uri: parsedPayload.uriString, notebookId: 1, uuid: "")
            aSelinkoTag.getCorrespondingNotebook()
            isSelinko = true
            
        } else if let parsedPayload = parsedPayload as? VYNFCNDEFTextXVCardPayload {
            
            text = "[TextXVCard payload]\n"
            text = String(format: "%@%@", text, parsedPayload.text)
            
        } else if let sp = parsedPayload as? VYNFCNDEFSmartPosterPayload {
            
            text = "[SmartPoster payload]\n"
            for textPayload in sp.payloadTexts {
                if let textPayload = textPayload as? VYNFCNDEFTextPayload {
                    text = String(format: "%@%@\n", text, textPayload.text)
                }
            }
            text = String(format: "%@%@", text, sp.payloadURI.uriString)
        } else if let wifi = parsedPayload as? VYNFCNDEFWifiSimpleConfigPayload {
            for case let credential as VYNFCNDEFWifiSimpleConfigCredential in wifi.credentials {
                text = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                              text, credential.ssid, credential.networkKey, credential.macAddress,
                              VYNFCNDEFWifiSimpleConfigCredential.authTypeString(credential.authType),
                              VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(credential.encryptType)
                )
            }
            if let version2 = wifi.version2 {
                text = String(format: "%@\nVersion2: %@", text, version2.version)
            }
        } else {
            text = "Parsed but unhandled payload type"
        }
        if !isSelinko {
            //FIXME: Display Tag properties to user
            print(text)
        }
      }
    }
  }
}
