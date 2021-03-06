# tldr 命令手册

<https://tldr.sh/> 安装请参考此文档。

TLDR是社区努力通过实际示例来简化的命令手册页

例：tar命令的用法
```sh
$ tldr tar

tar

Archiving utility.
Often combined with a compression method, such as gzip or bzip.
More information: <https://www.gnu.org/software/tar>.

- Create an archive from files:
    tar cf target.tar file1 file2 file3

- Create a gzipped archive:
    tar czf target.tar.gz file1 file2 file3

- Extract a (compressed) archive into the current directory:
    tar xf source.tar[.gz|.bz2|.xz]

- Extract an archive into a target directory:
    tar xf source.tar -C directory

- Create a compressed archive, using archive suffix to determine the compression program:
    tar caf target.tar.xz file1 file2 file3

- List the contents of a tar file:
    tar tvf source.tar

- Extract files matching a pattern:
    tar xf source.tar --wildcards "*.html"
```
