import Foundation
import KindlyArchive

public class App {
    public func main() {
        do {
            if CommandLine.arguments.count < 2 {
                throw GenericError(message: "no subcommand")
            }
            
            let subcommand = CommandLine.arguments[1]
            switch subcommand {
            case "archive":
                try archive()
            case "extract":
                try extract()
            default:
                throw GenericError(message: "unknown subcommand")
            }
        } catch let error {
            print("\(error)")
        }
    }
    
    private func archive() throws {
        if CommandLine.arguments.count < 3 {
            throw GenericError(message: "file not specified")
        }
        
        let source = CommandLine.arguments[2]
        
        let dest: String
        if CommandLine.arguments.count < 4 {
            dest = source + ".kiar"
        } else {
            dest = CommandLine.arguments[3]
        }
        
        let archiver = Archiver()
        try archiver.archive(directory: source, destination: dest)
    }
    
    private func extract() throws {
        if CommandLine.arguments.count < 3 {
            throw GenericError(message: "archive not specified")
        }
        
        let source = CommandLine.arguments[2]
        let dest: String
        if CommandLine.arguments.count < 4 {
            dest = Path(source).parent.value
        } else {
            dest = CommandLine.arguments[3]
        }
        
        let extractor = Extractor()
        try extractor.extract(archivePath: source, destination: dest)
    }
}

