//
//  Exception.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

struct Exception: Error, Codable {
    
    let code: Int?
    let message: String
    
    init(_ code: Int = 0, message: String) {
        self.code = code
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            // Attempt to decode 'code' as Int
            code = try container.decodeIfPresent(Int.self, forKey: .code)
        } catch DecodingError.typeMismatch {
            // If 'code' is not an Int, try to decode it as String
            let stringValue = try container.decode(String.self, forKey: .code)
            code = Int(stringValue)
        }

        message = try container.decode(String.self, forKey: .message)
    }
    
    private enum CodingKeys: String, CodingKey {
       case code
       case message
   }

}
