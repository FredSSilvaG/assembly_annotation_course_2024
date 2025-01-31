#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00 
#SBATCH --job-name=flye_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_flye_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_flye_%j.e
#SBATCH --partition=pibu_el8


## --------------------------------------------------------------------
## 05 | Assembly  - Flye
## --------------------------------------------------------------------

# Define working directory
WORKDIR=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024

# Uncompress the FASTQ files into a temporary directory
mkdir -p $WORKDIR/Raw_data/uncompressed
zcat $WORKDIR/Raw_data/Rld-2/*.fastq.gz > $WORKDIR/Raw_data/uncompressed/Rld-2.fastq

# Run Assembly on Rld-2 dataset
apptainer exec \
  --bind $WORKDIR \
  /containers/apptainer/flye_2.9.5.sif \
  flye --pacbio-hifi $WORKDIR/Raw_data/uncompressed/Rld-2.fastq \
  --out-dir $WORKDIR/Assembly/Flye_2 \
  --threads 16

# Running time notification
echo 'Flye assembly complete'