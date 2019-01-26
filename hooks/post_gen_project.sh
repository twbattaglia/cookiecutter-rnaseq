#!/bin/bash

# - - - - - - - - - - - - - - -
# cookiecutter-rnaseq
# Thomas W Battaglia
# - - - - - - - - - - - - - - -

# Start timer
START=$(date +%s.%N)

# - - - - - - - - - - - - - - - -
# Error for old python version
# - - - - - - - - - - - - - - - -
if [[ $(python -V 2>&1) == "Python 2.6.6" ]];then
  echo "$(python -V) is not compatible, please load Python 2.7 or higher. "
  exit 1
fi

# - - - - - - - - - - - - - - - -
# Check if conda is installed
# - - - - - - - - - - - - - - - -
if [[ -z $(type conda) ]]; then
  echo "Error. Cannot find the conda package!"
  exit 1
fi
echo "Conda package manager detected..."


# - - - - - - - - - - - - - - - -
# Download genome
# - - - - - - - - - - - - - - - -

# Mouse Gencode (vM20)
if [[ '{{ cookiecutter.download_genome }}' == "Mouse (GENCODE)" ]]; then
  echo -e "Downloading Mouse-GENCODE genome...This should take ~5-10 minutes. \n \n \n"
  wget -P genome/ fftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M20/GRCm38.primary_assembly.genome.fa.gz --progress=bar:force
  wget -P annotation/ ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M20/gencode.vM20.annotation.gtf.gz --progress=bar:force
  echo "Decompressing files..."
  gunzip genome/GRCm38.p4.genome.fa.gz
  gunzip annotation/gencode.vM10.annotation.gtf.gz
  echo -e "Genome download/decompress completed..."
fi

# Human Gencode (v29)
if [[ '{{ cookiecutter.download_genome }}' == "Human (GENCODE)" ]]; then
  echo -e "Downloading Human-GENCODE genome...This should take ~10 minutes. \n \n \n"
  wget -P genome/ ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_29/GRCh37_mapping/GRCh37.primary_assembly.genome.fa.gz --progress=bar:force
  wget -P annotation/ ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_29/GRCh37_mapping/gencode.v29lift37.annotation.gtf.gz --progress=bar:force
  echo "Decompressing files..."
  gunzip genome/GRCh38.p7.genome.fa.gz
  gunzip annotation/gencode.v25.annotation.gtf.gz
  echo -e "Genome download/decompress completed..."
fi


# - - - - - - - - - - - - - - - -
# Download example data
# - - - - - - - - - - - - - - - -

if [[ '{{ cookiecutter.use_example_data }}' == "Yes" ]]; then
  echo -e "Downloading Mouse example FASTQ files...This should take ~5 minutes."
  wget -P input/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR137/001/SRR1374921/SRR1374921.fastq.gz --quiet
  wget -P input/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR137/002/SRR1374922/SRR1374922.fastq.gz --quiet
  wget -P input/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR137/003/SRR1374923/SRR1374923.fastq.gz --quiet
  wget -P input/ ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR137/004/SRR1374924/SRR1374924.fastq.gz --quiet
  echo -e "Mouse example FASTQ files download/decompress completed..."
fi

# - - - - - - - - - - - - - - - -
# Finish messages
# - - - - - - - - - - - - - - - -

# Print completed message
echo "Template sucessfully created! You are now ready to analyze!"
echo "1) Place your FASTQ sequences in the 'input' directory."
echo "2) Run the command:   conda create --name rnaseq-env --file rnaseq.env"

# Find total time elapsed
END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo "${DIFF} seconds have elapsed..."
