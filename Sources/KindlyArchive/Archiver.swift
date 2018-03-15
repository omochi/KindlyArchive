import Foundation

public class Archiver {
    public init() {}
    
    public func archive(directory dirStr: String, destination: String) throws {
        let dir = Path(URL(fileURLWithPath: dirStr).path)
        let baseDir = dir.parent
        let dirName = dir.name
        let paths = dir.subpaths.map { Path(dirName) + $0 }
        return try archive(baseDir: baseDir,
                           paths: paths,
                           destination: Path(destination))
    }
    
    public func archive(baseDir: String, paths: [String], destination: String) throws {
        return try archive(baseDir: Path(baseDir),
                           paths: paths.map(Path.init),
                           destination: Path(destination))
    }
    
    public func archive(baseDir: Path, paths: [Path], destination: Path) throws {
        let builder = ArchiveBuilder(baseDir: baseDir,
                                     paths: paths,
                                     destination: destination)
        return try builder.build()
    }
}
