//
//  MathCatSwift.swift
//  MathCatSwift
//
//  Created by Your Name on Date.
//
import CMathCat
import Foundation
public enum MathCatError: Error {
    case genericError(String)
}

public struct NavigationLocation {
    public let id: String
    public let offset: UInt32

    internal init(cLocation: CMathCat.NavigationLocation) {
        self.id = String(cString: cLocation.id!) // Assuming id is never NULL in valid cases, but handle nil in robust code
        self.offset = cLocation.offset
    }
}


public class MathCat {
    // Helper function to handle C string conversion and freeing
    private static func swiftString(fromCString cString: UnsafePointer<Int8>?) throws -> String {
        guard let cString = cString else {
            throw MathCatError.genericError("Unexpected null C string from MathCAT")
        }
        defer { CMathCat.FreeMathCATString(UnsafeMutablePointer(mutating: cString)) }
        return String(cString: cString)
    }

    private static func checkStatus(_ status: UnsafePointer<Int8>?) throws {
        if status == nil || String(cString: status!) == "" {
            let errorMessage = try? swiftString(fromCString: CMathCat.GetError())
            if let message = errorMessage {
                throw MathCatError.genericError("MathCAT Error: \(message)")
            } else {
                throw MathCatError.genericError("MathCAT Error: Unknown error")
            }
        }
        CMathCat.FreeMathCATString(UnsafeMutablePointer(mutating: status))
    }


    public static func getMathCATVersion() -> String {
        let versionC = CMathCat.GetMathCATVersion()! // Force unwrap here for example, handle nil in real app
        defer { CMathCat.FreeMathCATString(UnsafeMutablePointer(mutating: versionC)) }
        return String(cString: versionC)
    }

    public static func setRulesDir(rulesDirLocation: String) throws {
        let cRulesDir = rulesDirLocation.cString(using: .utf8)
        let status = CMathCat.SetRulesDir(cRulesDir)
        try checkStatus(status)
    }

    public static func setMathML(mathmlString: String) throws -> String {
        let cMathML = mathmlString.cString(using: .utf8)
        let annotatedMathMLC = CMathCat.SetMathML(cMathML)
        return try swiftString(fromCString: annotatedMathMLC)
    }

    public static func getSpokenText() throws -> String {
        let spokenTextC = CMathCat.GetSpokenText()
        return try swiftString(fromCString: spokenTextC)
    }

    public static func setPreference(pref: String, value: String) throws {
        let cPref = pref.cString(using: .utf8)
        let cValue = value.cString(using: .utf8)
        let status = CMathCat.SetPreference(cPref, cValue)
        try checkStatus(status)
    }

    public static func getPreference(pref: String) throws -> String {
        let cPref = pref.cString(using: .utf8)
        let valueC = CMathCat.GetPreference(cPref)
        return try swiftString(fromCString: valueC)
    }

    public static func getBraille(navNodeId: String = "") throws -> String {
        let cNavNodeId = navNodeId.cString(using: .utf8)
        let brailleC = CMathCat.GetBraille(cNavNodeId)
        return try swiftString(fromCString: brailleC)
    }

    public static func getNavigationBraille() throws -> String {
        let brailleC = CMathCat.GetNavigationBraille()
        return try swiftString(fromCString: brailleC)
    }

    public static func doNavigateCommand(command: String) throws -> String {
        let cCommand = command.cString(using: .utf8)
        let speechC = CMathCat.DoNavigateCommand(cCommand)
        return try swiftString(fromCString: speechC)
    }

    public static func getNavigationMathML() throws -> String {
        let mathMLC = CMathCat.GetNavigationMathML()
        return try swiftString(fromCString: mathMLC)
    }

    @available(*, deprecated, message: "Use getNavigationLocation() instead")
    public static func getNavigationMathMLId() throws -> String {
        let idC = CMathCat.GetNavigationMathMLId()
        return try swiftString(fromCString: idC)
    }

    @available(*, deprecated, message: "Use getNavigationLocation() instead")
    public static func getNavigationMathMLOffset() -> UInt32 {
        return CMathCat.GetNavigationMathMLOffset()
    }

    public static func setNavigationLocation(location: NavigationLocation) throws {
        guard let idCString = location.id.cString(using: .utf8) else {
            throw MathCatError.genericError("Failed to convert location.id to C string")
        }
        let cLocation = CMathCat.NavigationLocation(id: strdup(idCString), offset: location.offset)
        defer { free(UnsafeMutablePointer(mutating: cLocation.id)) }
        let status = CMathCat.SetNavigationLocation(cLocation)
        try checkStatus(status)
    }


    public static func getNavigationLocation() throws -> NavigationLocation {
        let cLocation = CMathCat.GetNavigationLocation()
        if cLocation.id == nil || String(cString: cLocation.id!) == "" { // Check for error condition
            let errorMessage = try? swiftString(fromCString: CMathCat.GetError())
            if let message = errorMessage {
                throw MathCatError.genericError("MathCAT Error getting NavigationLocation: \(message)")
            } else {
                throw MathCatError.genericError("MathCAT Error getting NavigationLocation: Unknown error")
            }
        }
        return NavigationLocation(cLocation: cLocation)
    }


    public static func getNavigationLocationFromBraillePosition(position: UInt32) throws -> NavigationLocation {
        let cLocation = CMathCat.GetNavigationLocationFromBraillePosition(position)
        if cLocation.id == nil || String(cString: cLocation.id!) == "" { // Check for error condition
            let errorMessage = try? swiftString(fromCString: CMathCat.GetError())
            if let message = errorMessage {
                throw MathCatError.genericError("MathCAT Error getting NavigationLocation from Braille Position: \(message)")
            } else {
                throw MathCatError.genericError("MathCAT Error getting NavigationLocation from Braille Position: Unknown error")
            }
        }
        return NavigationLocation(cLocation: cLocation)
    }
}

