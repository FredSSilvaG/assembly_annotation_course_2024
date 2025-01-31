#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00 
#SBATCH --job-name=trinity_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_trinity_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_trinity_%j.e
#SBATCH --partition=pibu_el8

## --------------------------------------------------------------------
## 05 | Assembly  - Trinity
## --------------------------------------------------------------------

WORKDIR=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024
READS_DIR=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/RNAseq_Sha

# Load the Trinity module
module load Trinity/2.15.1-foss-2021a

# Create output directory if it doesn't exist
# mkdir -p $WORKDIR/Assembly/Trinity

# Run the assembly
# Maybe --SS-lib-type RF if the data is stranded?
Trinity --seqType fq \
        --left $READS_DIR/ERR754081_1_filtered.fastq.gz \
        --right $READS_DIR/ERR754081_2_filtered.fastq.gz \
        --CPU 16 \
        --max_memory 64G \
        --output $WORKDIR/Assembly/Trinity

# Running time notification
echo 'Trinity assembly complete'
