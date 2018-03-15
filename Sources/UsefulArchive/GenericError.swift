import Foundation

public struct GenericError : Error, CustomStringConvertible {
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var description: String {
        return message
    }
}
