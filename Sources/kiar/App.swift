import Foundation
import FilePathFramework
import KindlyArchive

public class App {
    public func main() {
        do {
            if CommandLine.arguments.count < 2 {
                throw KindlyArchiveError(message: "no subcommand")
            }
            
            let subcommand = CommandLine.arguments[1]
            switch subcommand {
            case "archive":
                try archive()
            case "extract":
                try extract()
            default:
                throw KindlyArchiveError(message: "unknown subcommand")
            }
        } catch let error {
            print("\(error)")
        }
    }
    
    private func archive() throws {
        if CommandLine.arguments.count < 3 {
            throw KindlyArchiveError(message: "file not specified")
        }
        
        let source = CommandLine.arguments[2]
        
        let dest: String
        if CommandLine.arguments.count > 3 {
            dest = CommandLine.arguments[3]
        } else {
            let absSource = FilePath(source).absolute()
            dest = absSource.asString() + ".kiar"
        }
        
        let archiver = Archiver()
        try archiver.archive(directory: source, destination: dest)
    }
    
    private func extract() throws {
        if CommandLine.arguments.count < 3 {
            throw KindlyArchiveError(message: "archive not specified")
        }
        
        let source = CommandLine.arguments[2]
        let dest: String
        if CommandLine.arguments.count > 3 {
            dest = CommandLine.arguments[3]
        } else {
            dest = FilePath(source).parent.asString()
        }
        
        let extractor = Extractor()
        try extractor.extract(archivePath: source, destination: dest)
    }
}

