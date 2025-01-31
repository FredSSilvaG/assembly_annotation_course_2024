#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=nucmer_mummerplot
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_nucmer_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_nucmer_%j.e
#SBATCH --partition=pibu_el8

# Load necessary modules or containers
APPTAINER_CONTAINER=/containers/apptainer/mummer4_gnuplot.sif

# Define work directory and paths
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"
REFERENCE_GENOME="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
OUTPUT_DIR="$WORKDIR/Comparative_Genome_Analysis/mummer_results"

# Define assemblies
FLYE_ASSEMBLY="$WORKDIR/Assembly/Flye/flye_assembly.fasta"
HIFIASM_ASSEMBLY="$WORKDIR/Assembly/Hifiasm/Rld-2.asm.bp.p_ctg.fa"
LJA_ASSEMBLY="$WORKDIR/Assembly/LJA/Rld-2.asm/lja_assembly.fasta"

# Define delta files
FLYE_DELTA="$OUTPUT_DIR/Flye.delta"
HIFIASM_DELTA="$OUTPUT_DIR/Hifiasm.delta"
LJA_DELTA="$OUTPUT_DIR/LJA.delta"
FLYE_VS_HIFIASM_DELTA="$OUTPUT_DIR/Flye_vs_Hifiasm.delta"
FLYE_VS_LJA_DELTA="$OUTPUT_DIR/Flye_vs_LJA.delta"
HIFIASM_VS_LJA_DELTA="$OUTPUT_DIR/Hifiasm_vs_LJA.delta"

# Run nucmer and mummerplot for Flye assembly
# echo "Running nucmer for Flye assembly against the reference genome..."
# apptainer exec --bind "$WORKDIR"  \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/Flye" --breaklen 1000 --mincluster 1000 "$REFERENCE_GENOME" "$FLYE_ASSEMBLY"

#echo "Running mummerplot for Flye assembly..."
#apptainer exec --bind "$WORKDIR" \
#    --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" mummerplot \
#    -Q "$FLYE_ASSEMBLY" -R "$REFERENCE_GENOME" --filter -t png --layout --fat -p "$OUTPUT_DIR/Flye.delta" "$FLYE_DELTA"

# Run nucmer and mummerplot for Hifiasm assembly
# echo "Running nucmer for Hifiasm assembly against the reference genome..."
# apptainer exec --bind "$WORKDIR" \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/Hifiasm" --breaklen 1000 --mincluster 1000 "$REFERENCE_GENOME" "$HIFIASM_ASSEMBLY"

#echo "Running mummerplot for Hifiasm assembly..."
#apptainer exec --bind "$WORKDIR" \
#    --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" mummerplot \
#    -Q "$HIFIASM_ASSEMBLY" -R "$REFERENCE_GENOME" --filter -t png --large --layout --fat -p "$OUTPUT_DIR/Hifiasm.delta" "$HIFIASM_DELTA"

# Run nucmer and mummerplot for LJA assembly
# echo "Running nucmer for LJA assembly against the reference genome..."
# apptainer exec --bind "$WORKDIR" \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/LJA" --breaklen 1000 --mincluster 1000 "$REFERENCE_GENOME" "$LJA_ASSEMBLY"

#echo "Running mummerplot for LJA assembly..."
#apptainer exec --bind "$WORKDIR" \
#    --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" mummerplot \
#    -Q "$LJA_ASSEMBLY" -R "$REFERENCE_GENOME" --filter -t png --large --layout --fat -p "$OUTPUT_DIR/LJA.delta" "$LJA_DELTA"

# Compare Flye to Hifiasm
# echo "Running nucmer to compare Flye to Hifiasm..."
# apptainer exec --bind "$WORKDIR" \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/Flye_vs_Hifiasm" --breaklen 1000 --mincluster 1000 "$FLYE_ASSEMBLY" "$HIFIASM_ASSEMBLY"


echo "Running mummerplot for Flye vs Hifiasm..."
apptainer exec --bind "$WORKDIR" "$APPTAINER_CONTAINER" mummerplot \
    -Q "$HIFIASM_ASSEMBLY"  -R "$FLYE_ASSEMBLY" --filter -t png --large --layout --fat -p "$OUTPUT_DIR/Flye_vs_Hifiasm.delta" "$FLYE_VS_HIFIASM_DELTA"

# Compare Flye to LJA
# echo "Running nucmer to compare Flye to LJA..."
# apptainer exec --bind "$WORKDIR" \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/Flye_vs_LJA" --breaklen 1000 --mincluster 1000 "$FLYE_ASSEMBLY" "$LJA_ASSEMBLY"

echo "Running mummerplot for Flye vs LJA..."
apptainer exec --bind "$WORKDIR" "$APPTAINER_CONTAINER" mummerplot \
    -R "$FLYE_ASSEMBLY" -Q "$LJA_ASSEMBLY" --filter -t png --large --layout --fat -p "$OUTPUT_DIR/Flye_vs_LJA.delta" "$FLYE_VS_LJA_DELTA"

# Compare Hifiasm to LJA
# echo "Running nucmer to compare Hifiasm to LJA..."
# apptainer exec --bind "$WORKDIR" \
#     --bind "/data/courses/assembly-annotation-course/references" "$APPTAINER_CONTAINER" nucmer \
#     --prefix="$OUTPUT_DIR/Hifiasm_vs_LJA" --breaklen 1000 --mincluster 1000 "$HIFIASM_ASSEMBLY" "$LJA_ASSEMBLY"

echo "Running mummerplot for Hifiasm vs LJA..."
apptainer exec --bind "$WORKDIR" "$APPTAINER_CONTAINER" mummerplot \
    -R "$HIFIASM_ASSEMBLY" -Q "$LJA_ASSEMBLY" --filter -t png --large --layout --fat -p "$OUTPUT_DIR/Hifiasm_vs_LJA.delta" "$HIFIASM_VS_LJA_DELTA"

echo "Nucmer and mummerplot processing complete!"
