#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00 
#SBATCH --job-name=hifiasm_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_hifiasm_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_hifiasm_%j.e
#SBATCH --partition=pibu_el8


## --------------------------------------------------------------------
## 05 | Assembly  - Hifiasm
## --------------------------------------------------------------------

# Define working directory
WORKDIR=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024

# Uncompress the FASTQ files into a temporary directory
#zcat $WORKDIR/Raw_data/Rld-2/*.fastq.gz > $WORKDIR/Raw_data/uncompressed/Rld-2.fastq

# Create an output directory for Hifiasm assembly
#mkdir -p $WORKDIR/Assembly/Hifiasm

# Run Hifiasm on Rld-2 dataset
apptainer exec \
  --bind $WORKDIR \
  /containers/apptainer/hifiasm_0.19.8.sif \
  hifiasm -o $WORKDIR/Assembly/Hifiasm/Rld-2.asm \
  -t 16 \
  $WORKDIR/Raw_data/uncompressed/Rld-2.fastq


# Convert GFA output to FASTA
awk '/^S/{print ">"$2;print $3}' $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.gfa > $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.hap1.p_ctg.gfa > $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.hap1.p_ctg.fa
awk '/^S/{print ">"$2;print $3}' $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.hap2.p_ctg.gfa > $WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.hap2.p_ctg.fa

# Running time notification
echo 'Hifiasm assembly complete'

