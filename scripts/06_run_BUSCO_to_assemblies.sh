#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00  # Increased time limit to account for multiple BUSCO runs
#SBATCH --job-name=busco_assembly_evaluation
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_busco_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_busco_%j.e
#SBATCH --partition=pibu_el8

## --------------------------------------------------------------------
## Assembly Evaluation - BUSCO for Flye, Hifiasm, and LJA Genome Assemblies
## --------------------------------------------------------------------

# Load necessary modules
module load BUSCO/5.4.2-foss-2021a  # Load the BUSCO module (adjust the name as necessary)

# Define paths to assemblies
FLYE_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Flye/assembly.fasta"
HIFIASM_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa"
LJA_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/LJA/Rld-2.asm/assembly.fasta"
TRINITY_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Trinity/Trinity.Trinity.fasta"

# Define output directories for BUSCO results
FLYE_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Flye/BUSCO"
HIFIASM_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Hifiasm/BUSCO"
LJA_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/LJA/BUSCO"
TRINITY_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Trinity/BUSCO"


# Number of CPUs to use for BUSCO
CPU=16


# Run BUSCO for Flye assembly
busco \
    --mode genome \
    --lineage brassicales_odb10 \
    --cpu "$CPU" \
    --in "$FLYE_ASSEMBLY" \
    --out "Flye" \
    --out_path "$FLYE_OUTPUT_DIR" --force
echo "BUSCO analysis for Flye assembly completed."

# Run BUSCO for Hifiasm assembly
busco \
    --mode genome \
    --lineage brassicales_odb10 \
    --cpu "$CPU" \
    --in "$HIFIASM_ASSEMBLY" \
    --out "Hifiasm" \
    --out_path "$HIFIASM_OUTPUT_DIR" --force
echo "BUSCO analysis for Hifiasm assembly completed."

# Run BUSCO for LJA assembly
busco \
    --mode genome \
    --lineage brassicales_odb10 \
    --cpu "$CPU" \
    --in "$LJA_ASSEMBLY" \
    --out "LJA" \
    --out_path "$LJA_OUTPUT_DIR" --force
echo "BUSCO analysis for LJA assembly completed."

# Run BUSCO for Trinity assembly
busco \
    --mode genome \
    --lineage brassicales_odb10 \
    --cpu "$CPU" \
    --in "$TRINITY_ASSEMBLY" \
    --out "Trinity" \
    --out_path "$TRINITY_OUTPUT_DIR" --force
echo "BUSCO analysis for Trinity assembly completed."

# Notify user of job completion
echo "BUSCO evaluation completed for all assemblies: Flye, Hifiasm, LJA, and Trinity."


#Extra Step Get busco lineage to my directory:
#cd /data/users/fsilvagutierrez/busco_lineages/
#wget https://busco-data.ezlab.org/v4/data/lineages/brassicales_odb10.2020-08-05.tar.gz 
#tar -xzf brassicales_odb10.2020-08-05.tar.gz

#BUSCO/5.4.2-foss-2021a

