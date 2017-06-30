# Retrieving Polylox Barcodes from PacBio Reads (RPBPBR) 

## Usage
RPBPBR <input.fasta/fastq> <out.prefix> <type:fasta/fastq> [keep-temp] 
'''
<input.fasta/fastq>  required, the PacBio read file in fasta or fastq format. 
<out.prefix>         required, the prefix of output file, and also the name of a temporary directory to be created during the process. 
<type:fasta/fastq>   required, the format of the PacBio read file, only can be fasta or fastq, other formats not acceptable. 
[keep-temp]          optional, if not specified or with value 0, the temporary directory created during the process will removed after the process is done; otherwise, it will be kept. 
'''

## Contact
Xi Wang (xi dot wang at dkfz dot de)

## Citation
[1] Weike Pei, Thorsten B. Feyerabend, Jens Rossler, Xi Wang, Daniel Postrach, Katrin Busch, Immanuel Rode, Kay Klapproth, Nikolaus Dietlein, Claudia Quedenau, Wei Chen, Sascha Sauer, Stephan Wolf, Thomas Hofer, and Hans-Reimer Rodewald. (2017) **Endogenous barcoding reveals hematopoietic stem cell fates realized in vivo**. *Nature*, AIP.

