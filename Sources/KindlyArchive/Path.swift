import Foundation

public struct Path : CustomStringConvertible {
    public init(_ value: String) {
        self.value = value
    }
    
    public var value: String
    
    public var description: String {
        return value
    }
    
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: value)
    }
    
    public var isDir: Bool {
        var isDir = ObjCBool(false)
        return FileManager.default.fileExists(atPath: value, isDirectory: &isDir) && isDir.boolValue
    }
    
    public var name: String {
        return nsPath.lastPathComponent
    }
    
    public var parent: Path {
        return Path(nsPath.deletingLastPathComponent)
    }
//    
//    public var nameWithoutExtension: String {
//        return (nsPath.lastPathComponent as NSString).deletingPathExtension
//    }
//    
    public var subpaths: [Path] {
        let paths = FileManager.default.subpaths(atPath: value) ?? []
        return paths.map(Path.init)
    }
    
    public func attributes() throws -> [FileAttributeKey: Any] {
        return try FileManager.default.attributesOfItem(atPath: value)
    }
    
    public var standardizing: Path {
        return Path(nsPath.standardizingPath)
    }
    
    public var components: [String] {
        return nsPath.pathComponents
    }
    
    public func delete() throws {
        try FileManager.default.removeItem(atPath: value)
    }
    
    public func createEmptyFile() throws {
        if !FileManager.default.createFile(atPath: value, contents: nil) {
            throw GenericError(message: "create file failed: \(self)")
        }
    }
    
    public func createDirectory() throws {
        try FileManager.default.createDirectory(atPath: value, withIntermediateDirectories: true)
    }
    
    public static func +(a: Path, b: Path) -> Path {
        return Path(a.nsPath.appendingPathComponent(b.value))
    }
    
    private var nsPath: NSString {
        return value as NSString
    }
}
