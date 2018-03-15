# KindlyArchive

Archive command line tool and library written in Swift.
It has human readable archive format.
See example. [example/Sources.kiar](example/Source.kiar)

# Usage

## archive

```
$ swift run kiar archive <source directory> [<archive path>]
```

If you not specified archive path, it makes `<source directory>.kiar` in same directory.

## extract

```
$ swift run kiar extract <archive path> [<destination directory>]
```

If you not specified destination directory, it extracts in same directory.
