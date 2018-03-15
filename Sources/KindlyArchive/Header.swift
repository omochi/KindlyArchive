import Foundation

public struct Header : Codable {
    public struct Entry : Codable {
        public enum EntryType : String, Codable {
            case directory
            case file
        }
        
        public var path: String
        public var type: EntryType
        public var size: Int64?
        public var offset: Int64?
    }
    
    public var entries: [Entry]    
}
