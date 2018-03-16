import Foundation

public struct Path : CustomStringConvertible, Equatable {
    public init(_ value: String) {
        self.value = value
    }
    
    public init(url: URL) {
        precondition(url.isFileURL)
        self.init(url.path)
    }
    
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
    
    public var name: Path {
        return Path(nsPath.lastPathComponent)
    }
    
    public var parent: Path {
        return Path(nsPath.deletingLastPathComponent)
    }
    
    public var `extension`: String {
        return nsPath.pathExtension
    }
    
    public var nameWithoutExtension: Path {
        return Path((name.value as NSString).deletingPathExtension)
    }
    
    public func children() throws -> [Path] {
        let contents = try FileManager.default.contentsOfDirectory(atPath: value)
        return contents.map(Path.init)
    }
    
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
    
    public var components: [Path] {
        return nsPath.pathComponents.map(Path.init)
    }
    
    public func delete() throws {
        try FileManager.default.removeItem(atPath: value)
    }
    
    
    public func copy(to path: Path) throws {
        try FileManager.default.copyItem(atPath: value, toPath: path.value)
    }
    
    public func move(to path: Path) throws {
        try FileManager.default.moveItem(atPath: value, toPath: path.value)
    }
    
    public func createEmptyFile() throws {
        if !FileManager.default.createFile(atPath: value, contents: nil) {
            throw GenericError(message: "create file failed: \(self)")
        }
    }
    
    public func createDirectory() throws {
        try FileManager.default.createDirectory(atPath: value, withIntermediateDirectories: true)
    }
    
    public func asString() -> String {
        return value
    }
    
    public func asURL() -> URL {
        return URL(fileURLWithPath: value)
    }
    
    public static func +(a: Path, b: Path) -> Path {
        return Path(a.nsPath.appendingPathComponent(b.value))
    }
    
    public static func ==(a: Path, b: Path) -> Bool {
        return a.nsPath == b.nsPath
    }
    
    private var nsPath: NSString {
        return value as NSString
    }
    
    private var value: String
    
}
