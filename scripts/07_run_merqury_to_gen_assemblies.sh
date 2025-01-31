#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=merqury_assembly
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_merqury_%j.o"
#SBATCH --error="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_merqury_%j.e"
#SBATCH --partition=pibu_el8

# Set up Merqury path and variables
MERQURY_CONT="/containers/apptainer/merqury_1.3.sif"
MERYL_CONT="/containers/apptainer/meryl_1.4.1.sif"
FLYE_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Flye/flye_assembly.fasta"
HIFIASM_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa"
HIFIASM_FILE_HAP1="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.hap1.p_ctg.fa"
HIFIASM_FILE_HAP2="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.hap2.p_ctg.fa"
LJA_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/LJA/Rld-2.asm/lja_assembly.fasta"
RAW_READS="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/uncompressed/Rld-2.fastq"
WORK_DIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"

# Use a unique timestamp for each run

OUTPUT_FOLDER="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/MERQURY"
OUTPUT_FILE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/MERQURY/rawreads.meryl"

export MERQURY="/usr/local/share/merqury"

# Step 1: Prepare meryl databases for each genome assembly (Flye, Hifiasm, LJA)
# Meryl db for raw reads
# Uncomment if needed
#apptainer exec --bind "$WORK_DIR" "$MERQURY_CONT" meryl count k=21 output "$OUTPUT_FILE" "$RAW_READS"

# Step 2: Merqury for Flye assembly
mkdir -p $OUTPUT_FOLDER/flye
cd $OUTPUT_FOLDER/flye
apptainer exec  --bind $WORK_DIR "$MERQURY_CONT" sh "$MERQURY/merqury.sh" "$OUTPUT_FILE" "$FLYE_FILE" Flye_out


# Step 3: Merqury for Hifiasm assembly (main assembly with mixed haplotypes)
mkdir -p $OUTPUT_FOLDER/hifiasm_main
cd $OUTPUT_FOLDER/hifiasm_main
apptainer exec --bind $WORK_DIR "$MERQURY_CONT" sh "$MERQURY/merqury.sh" "$OUTPUT_FILE" "$HIFIASM_FILE" Hifiams_main_out

# Step 4: Merqury for Hifiasm assembly (separate haplotypes)
mkdir -p $OUTPUT_FOLDER/hifiasm_hap
cd $OUTPUT_FOLDER/hifiasm_hap
apptainer exec --bind $WORK_DIR "$MERQURY_CONT" sh "$MERQURY/merqury.sh" "$OUTPUT_FILE" "$HIFIASM_FILE_HAP1" Hifiasm_hap_out

# Step 5: Merqury for LJA assembly
mkdir -p $OUTPUT_FOLDER/lja
cd $OUTPUT_FOLDER/lja
apptainer exec --bind $WORK_DIR "$MERQURY_CONT" sh "$MERQURY/merqury.sh" "$OUTPUT_FILE" "$LJA_FILE" LJA_out

echo "Merqury evaluation complete."

#RUN
#sbatch 07_run_merqury_to_gen_assemblies.sh /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/uncompressed/Rld-2.fastq /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Flye/flye_assembly.fasta /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.hap1.p_ctg.fa /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/Hifiasm/Rld-2.asm.bp.hap2.p_ctg.fa /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Assembly/LJA/Rld-2.asm/lja_assembly.fasta /data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Evaluation/MERQURY

