//
//  Forms_Annotation.swift
//  GlidePDFKitDemo
//
//  Created by Qinchao Xu on 2022/8/19.
//

import Foundation
import SwiftUI

struct Forms_Annotation {

    var kind: Forms_Annotation.Kind
    var id: String
    var fieldID: String
    var page: Int32
    var left: Float
    var top: Float
    var height: Float
    var width: Float

    var fieldPart: Int32
    var font: String
    var fontSize: Int32
    var fontColor: String

    var recipientRole: String
    var recipientColor: String

    var formState: String
    var horizontalAlign: String
    var name: String
    var canWrap: Bool
    var optional: Bool
    var source: String

    enum Kind: Hashable {
      typealias RawValue = Int
      case unknown // = 0
      case signatureTab // = 1
      case initialsTab // = 2
      case dateTab // = 3
      case text // = 4
      case checkbox // = 5
      case radio // = 6
      case signatureZone // = 7
      case initialsZone // = 8
      case dateZone // = 9
      case textZone // = 10
      case checkboxZone // = 11
      case sectionZone // = 16
      case pdfStamp // = 12
      case pdfText // = 13
      case pdfRedactArea // = 14
      case pdfRedactText // = 15
      case dropdown // = 17
      case filestackImage // = 18
      case addendumField // = 19
      case pdfCheckbox // = 20
      case pdfStrikeoutText // = 21
      case pdfStrikeoutLine // = 22
      case name // = 23
      case email // = 24
      case phone // = 25
      case company // = 26
      case title // = 27
      case entityName // = 28
      case license // = 29
      case UNRECOGNIZED(Int)

      init() {
        self = .unknown
      }

      init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .unknown
        case 1: self = .signatureTab
        case 2: self = .initialsTab
        case 3: self = .dateTab
        case 4: self = .text
        case 5: self = .checkbox
        case 6: self = .radio
        case 7: self = .signatureZone
        case 8: self = .initialsZone
        case 9: self = .dateZone
        case 10: self = .textZone
        case 11: self = .checkboxZone
        case 12: self = .pdfStamp
        case 13: self = .pdfText
        case 14: self = .pdfRedactArea
        case 15: self = .pdfRedactText
        case 16: self = .sectionZone
        case 17: self = .dropdown
        case 18: self = .filestackImage
        case 19: self = .addendumField
        case 20: self = .pdfCheckbox
        case 21: self = .pdfStrikeoutText
        case 22: self = .pdfStrikeoutLine
        case 23: self = .name
        case 24: self = .email
        case 25: self = .phone
        case 26: self = .company
        case 27: self = .title
        case 28: self = .entityName
        case 29: self = .license
        default: self = .UNRECOGNIZED(rawValue)
        }
      }

      var rawValue: Int {
        switch self {
        case .unknown: return 0
        case .signatureTab: return 1
        case .initialsTab: return 2
        case .dateTab: return 3
        case .text: return 4
        case .checkbox: return 5
        case .radio: return 6
        case .signatureZone: return 7
        case .initialsZone: return 8
        case .dateZone: return 9
        case .textZone: return 10
        case .checkboxZone: return 11
        case .pdfStamp: return 12
        case .pdfText: return 13
        case .pdfRedactArea: return 14
        case .pdfRedactText: return 15
        case .sectionZone: return 16
        case .dropdown: return 17
        case .filestackImage: return 18
        case .addendumField: return 19
        case .pdfCheckbox: return 20
        case .pdfStrikeoutText: return 21
        case .pdfStrikeoutLine: return 22
        case .name: return 23
        case .email: return 24
        case .phone: return 25
        case .company: return 26
        case .title: return 27
        case .entityName: return 28
        case .license: return 29
        case .UNRECOGNIZED(let i): return i
        }
      }

    }
}

extension Forms_Annotation.Kind {
    var label: String {
        switch self {
        case .signatureTab: return "Signature"
        case .dateTab: return "Date"
        case .initialsTab: return "Initials"
        case .radio: return "Radio"
        case .checkbox: return "Checkbox"
        case .text: return "Text"
        case .dropdown: return "Dropdown"
        case .name: return "Name"
        case .phone: return "Phone"
        case .license: return "License"
        case .email: return "Email"
        case .company: return "Company"
        case .pdfStrikeoutLine: return "Line"
        default: return ""
        }
    }

    var pluralLabel: String {
        switch self {
        case .signatureTab: return "Signature"
        case .dateTab: return "Date"
        case .initialsTab: return "Initials"
        case .radio: return "Radios"
        case .checkbox: return "Checkboxes"
        case .text: return "Text"
        case .dropdown: return "Dropdown"
        default: return ""
        }
    }

    var iconName: String {
        switch self {
        case .signatureTab:
            return "signature"
        case .dateTab:
            return "calendar"
        case .initialsTab:
            return "initials"
        case .radio:
            return "radio"
        case .checkbox:
            return "checkbox"
        case .text:
            return "text"
        case .dropdown:
            return "dropdown"
        case .license:
            return "signature-license"
        case .name:
            return "signature-person"
        case .phone:
            return "signature-phone"
        case .company:
            return "signature-company"
        case .email:
            return "signature-email"
        case .pdfStrikeoutLine:
            return "minus"
        default:
            return ""
        }
    }

    var stampName: String {
        switch self {
        case .signatureTab:
            return "signature_stamp"
        case .dateTab:
            return "calendar_stamp"
        case .initialsTab:
            return "initials_stamp"
        case .dropdown:
            return "dropdown_stamp"
        default:
            return ""
        }
    }

    var minSize: CGSize {
        switch self {
        case .signatureTab:
            return CGSize(width: 54, height: 34)
        case .initialsTab:
            return CGSize(width: 34, height: 40)
        case .dateTab:
            return CGSize(width: 66, height: 14)
        case .radio, .checkbox:
            return CGSize(width: 10, height: 10)
        case .text, .dropdown, .name, .license, .company, .phone, .email:
            return CGSize(width: 50, height: 12)
        case .pdfStrikeoutLine:
            return CGSize(width: 80, height: 12)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    var fontSize: CGFloat {
        minSize.height - 2
    }

    var isMultiPartAvailable: Bool {
        switch self {
        case .radio, .checkbox, .text: return true
        default: return false
        }
    }

    var isPairRequired: Bool {
        switch self {
        case .radio: return true
        default: return false
        }
    }

    var isReadOnlyVisible: Bool {
        switch self {
        case .radio, .checkbox, .text, .pdfStrikeoutLine: return true
        default: return false
        }
    }

    var isResizingAvailable: Bool {
        isPartyKind || self == .text || self == .pdfStrikeoutLine
    }

    var isPartyKind: Bool {
        partyKeyPath != nil
    }

//    var partyKeyPath: KeyPath<Transactions_Recipient, String>? {
//        switch self {
//        case .name: return \.party.contact.fullName
//        case .license: return \.party.contact.reAgent.nrdsNumber
//        case .phone: return \.somePhoneNumber
//        case .email: return \.party.contact.email
//        case .company: return \.party.contact.reAgent.companyName
//        default: return nil
//        }
//    }

    var partyKeyPath: String? {
        switch self {
        case .name: return "name"
        case .license: return "license"
        case .phone: return "phone"
        case .email: return "email"
        case .company: return "company"
        default: return nil
        }
    }

    func isReadOnlyEnabled(_ fieldParts: Int) -> Bool {
        switch self {
        case .radio, .text: return true
        case .checkbox: return fieldParts == 1
        default: return false
        }
    }
}
