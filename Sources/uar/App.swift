import UsefulArchive

public class App {
    public func main() {
        let archiver = Archiver()
        try! archiver.archive(directory: "/Users/omochi/github/omochi/UsefulArchive",
                              destination: "/Users/omochi/github/omochi/UsefulArchive.uar")
    }
}

