#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --job-name=TE_Age_Estimation
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_TE_age_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_TE_age_%j.e
#SBATCH --partition=pibu_el8

# Load necessary modules
module load BioPerl/1.7.8-GCCcore-10.3.0

# Define variables
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2"
GENOME_MOD_OUT="$WORKDIR/EDTA/assembly.fasta.mod.EDTA.anno/assembly.fasta.mod.out"  
PARSE_RM_SCRIPT="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/scripts/annotation/scripts/04-parseRM.pl"  

# Move to the working directory
cd $WORKDIR

# Step 1: Parse RepeatMasker Output
# Run the parseRM.pl script to process RepeatMasker output and calculate divergence
perl $PARSE_RM_SCRIPT -i $GENOME_MOD_OUT -l 50,1 -v

# Notes:
# - The input file ($GENOME_MOD_OUT) should be located in the EDTA output directory, e.g., genome.mod.EDTA.anno if needed
# - Adjust paths as required to ensure they align with actual directories on the system

echo "TE Age Estimation Workflow completed."
