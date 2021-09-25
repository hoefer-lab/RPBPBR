# Retrieving _Polylox_ Barcodes from PacBio Reads (RPBPBR) 

## Usage
RPBPBR <input.fasta/fastq> <out.prefix> <type|fasta/fastq> [keep-temp] 

* <input.fasta/fastq>  required, the PacBio read file in fasta or fastq format. 
* <out.prefix>         required, the prefix of output file, and also the name of a temporary directory to be created during the process. 
* <type|fasta/fastq>   required, the format of the PacBio read file, only can be fasta or fastq, other formats not acceptable. 
* [keep-temp]          optional, if not specified or with value 0, the temporary directory created during the process will be removed after the process is done; otherwise, it will be kept. 


## Contact
Xi Wang (xi dot wang at dkfz dot de) OR (xiwang at njmu dot edu dot cn)

## Citation
[1] Weike Pei, Thorsten B. Feyerabend, Jens Roessler, Xi Wang, Daniel Postrach, Katrin Busch, Immanuel Rode, Kay Klapproth, Nikolaus Dietlein, Claudia Quedenau, Wei Chen, Sascha Sauer, Stephan Wolf, Thomas Hoefer, and Hans-Reimer Rodewald. (2017) **_Polylox_ barcoding reveals hematopoietic stem cell fates realized in vivo**. *Nature*, **548**, 456-460.


[2] Weike Pei*, Xi Wang*, Jens Rössler*, Thorsten B Feyerabend, Thomas Höfer, Hans-Reimer Rodewald. (2019) **Using Cre-recombinase-driven _Polylox_ barcoding for in vivo fate mapping in mice**. *Nat Protoc*, **14**, 1820–1840. doi:10.1038/s41596-019-0163-5

