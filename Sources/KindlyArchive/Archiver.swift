import Foundation
import FilePathFramework

public class Archiver {
    public init() {}
    
    public func archive(directory dirStr: String, destination: String) throws {
        let dir = FilePath(dirStr).absolute()
        let baseDir = dir.parent
        let dirName = dir.lastComponent
        let paths = try dir.subpaths().map { dirName + $0 }
        return try archive(baseDir: baseDir,
                           paths: paths,
                           destination: FilePath(destination))
    }
    
    public func archive(baseDir: String, paths: [String], destination: String) throws {
        return try archive(baseDir: FilePath(baseDir),
                           paths: paths.map { FilePath($0) },
                           destination: FilePath(destination))
    }
    
    public func archive(baseDir: FilePath, paths: [FilePath], destination: FilePath) throws {
        let builder = ArchiveBuilder(baseDir: baseDir,
                                     paths: paths,
                                     destination: destination)
        return try builder.build()
    }
}
