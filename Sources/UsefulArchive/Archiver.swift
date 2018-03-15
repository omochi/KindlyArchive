import Foundation

public class Archiver {
    public init() {}
    
    public func archive(directory: String, destination: String) throws {
        let fm = FileManager.default
        let paths: [String] = fm.subpaths(atPath: directory) ?? []
        try archive(baseDir: directory, paths: paths, destination: destination)
    }
    
    public func archive(baseDir: String, paths: [String], destination: String) throws {
        let builder = ArchiveBuilder(baseDir: baseDir, paths: paths, destination: destination)
        return try builder.build()
    }
}
