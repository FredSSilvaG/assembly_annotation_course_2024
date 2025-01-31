#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=quast_multi_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_quast_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_quast_%j.e
#SBATCH --partition=pibu_el8

## --------------------------------------------------------------------
## Assembly Evaluation - QUAST for Flye, Hifiasm, LJA, and Trinity Genome Assemblies
## --------------------------------------------------------------------

# Load necessary modules (if applicable)
# module load apptainer  # Uncomment if Apptainer/Singularity needs to be loaded

# Define paths to assemblies
FLYE_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Flye/assembly.fasta"
HIFIASM_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa"
LJA_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/LJA/Rld-2.asm/assembly.fasta"
TRINITY_ASSEMBLY="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Trinity/Trinity.Trinity.fasta"

# Define paths to reference genome (Arabidopsis thaliana)
REFERENCE_GENOME="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz"
REFERENCE_ANNOTATION="/data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff"

# Define the output directories for QUAST results
OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation"
FLYE_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Flye/QUAST"
HIFIASM_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Hifiasm/QUAST"
LJA_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/LJA/QUAST"
TRINITY_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/Trinity/QUAST"
MULTIASSEMBLY_OUTPUT_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/QUAST"

# Path to the QUAST container
CONTAINER_PATH="/containers/apptainer/quast_5.2.0.sif"

# Number of CPUs to use for QUAST
CPU=16

# Define work directory
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"


# QUAST options for eukaryote genome
QUAST_OPTIONS="--eukaryote --threads $CPU --est-ref-size 135000000 --features $REFERENCE_ANNOTATION"

# Run QUAST separately for each assembly (with reference genome)
apptainer exec --bind "$WORKDIR" \
    --bind "/data/courses/assembly-annotation-course/references/" \
    "$CONTAINER_PATH" quast.py \
    -o "$FLYE_OUTPUT_DIR" \
    -r "$REFERENCE_GENOME" \
    $QUAST_OPTIONS \
    "$FLYE_ASSEMBLY"

apptainer exec --bind "$WORKDIR" \
    --bind "/data/courses/assembly-annotation-course/references/" \
    "$CONTAINER_PATH" quast.py \
    -o "$HIFIASM_OUTPUT_DIR" \
    -r "$REFERENCE_GENOME" \
    $QUAST_OPTIONS \
    "$HIFIASM_ASSEMBLY"

apptainer exec --bind "$WORKDIR" \
    --bind "/data/courses/assembly-annotation-course/references/" \
    "$CONTAINER_PATH" quast.py \
    -o "$LJA_OUTPUT_DIR" \
    -r "$REFERENCE_GENOME" \
    $QUAST_OPTIONS \
    "$LJA_ASSEMBLY"

apptainer exec --bind "$WORKDIR" \
    --bind "/data/courses/assembly-annotation-course/references/" \
    "$CONTAINER_PATH" quast.py \
    -o "$TRINITY_OUTPUT_DIR" \
    -r "$REFERENCE_GENOME" \
    $QUAST_OPTIONS \
    "$TRINITY_ASSEMBLY"

# Run QUAST for multi-assembly comparison (Flye, Hifiasm, and LJA) with reference genome
apptainer exec --bind "$WORKDIR" \
    --bind "/data/courses/assembly-annotation-course/references/" \
    "$CONTAINER_PATH" quast.py \
    -o "$MULTIASSEMBLY_OUTPUT_DIR" \
    -r "$REFERENCE_GENOME" \
    $QUAST_OPTIONS \
    --labels Flye,Hifiasm,LJA \
    "$FLYE_ASSEMBLY" "$HIFIASM_ASSEMBLY" "$LJA_ASSEMBLY"

echo "QUAST analysis completed for all assemblies."
