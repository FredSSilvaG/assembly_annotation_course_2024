#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00 
#SBATCH --job-name=lja_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_lja_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_lja_%j.e
#SBATCH --partition=pibu_el8


## --------------------------------------------------------------------
## 05 | Assembly  - LJA
## --------------------------------------------------------------------

# Define working directory
WORKDIR=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024

# Uncompress the FASTQ files into a temporary directory
#mkdir -p $WORKDIR/Raw_data/uncompressed
#zcat $WORKDIR/Raw_data/Rld-2/*.fastq.gz > $WORKDIR/Raw_data/uncompressed/Rld-2.fastq

# Create an output directory for LJA assembly
#mkdir -p $WORKDIR/Assembly/LJA

# Run LJA on Rld-2 dataset
apptainer exec \
  --bind $WORKDIR \
  /containers/apptainer/lja-0.2.sif \
  lja \
  --reads $WORKDIR/Raw_data/uncompressed/Rld-2.fastq --diploid \
  -o $WORKDIR/Assembly/LJA/Rld-2.asm \
  -t 16


# Running time notification
echo 'LJA assembly complete'
