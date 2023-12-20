//
//  String+Extension.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

extension String {

    func trim() -> String {
        self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func localized(_ bundle: Bundle = Bundle.main) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func localized(_ bundle: Bundle = Bundle.main, params: CVarArg...) -> String {
        return String(format: self.localized(bundle), arguments: params)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
