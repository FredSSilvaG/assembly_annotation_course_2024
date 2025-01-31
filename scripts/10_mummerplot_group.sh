#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=12_mummerplot_group_tree
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_12_mummerplot_group_tree_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_12_mummerplot_group_tree_%j.e
#SBATCH --partition=pibu_el8

# Load necessary modules
module load BCFtools/1.12-GCC-10.3.0  # Load only bcftools module
# Containers for other tools
APPTAINER_CONTAINER=/containers/apptainer/mummer4_gnuplot.sif
BWA_CONTAINER=/containers/apptainer/bwa-0.7.18_samtools-1.12.sif
SAMTOOLS_CONTAINER=/containers/apptainer/samtools-1.19.sif

# Define work directory and paths
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"
OUTPUT_DIR="$WORKDIR/Comparative_Genome_Analysis/Group_comparison_2025"

# Array of FASTA files (change these file names as per your actual data)
FASTA_FILES=(
    "flye_assembly_Co_4.fasta"
    "flye_assembly_Geg_14.fasta"
    "flye_assembly_Kas_1.fasta"
    "flye_assembly_Nemrut_1.fasta"
    "flye_assembly_Rld_2.fasta"
)

# Now proceed with variant calling using bcftools
echo "Starting variant calling using bcftools..."

# Create reference genome (example: using the first accession)
REFERENCE_GENOME="$OUTPUT_DIR/${FASTA_FILES[0]}"

# Ensure the reference genome is indexed (BWA indexing)
echo "Indexing reference genome $REFERENCE_GENOME..."
apptainer exec --bind "$WORKDIR" "$BWA_CONTAINER" bwa index "$REFERENCE_GENOME"

# Loop through each query file to perform variant calling
for ((i=1; i<${#FASTA_FILES[@]}; i++)); do
    QUERY_GENOME="$OUTPUT_DIR/${FASTA_FILES[i]}"
    OUT_PREFIX="$OUTPUT_DIR/variants_${FASTA_FILES[0]%.fasta}_vs_${FASTA_FILES[i]%.fasta}"

    echo "Aligning $QUERY_GENOME to $REFERENCE_GENOME..."
    apptainer exec --bind "$WORKDIR" "$BWA_CONTAINER" bwa mem "$REFERENCE_GENOME" "$QUERY_GENOME" > "$OUT_PREFIX.sam"

    # Check if the SAM file is empty
    if [ ! -s "$OUT_PREFIX.sam" ]; then
        echo "Error: The SAM file is empty. Please check the alignment process for $QUERY_GENOME."
        exit 1
    fi

    echo "Converting SAM to BAM..."
    apptainer exec --bind "$WORKDIR" "$SAMTOOLS_CONTAINER" samtools view -Sb "$OUT_PREFIX.sam" | samtools sort -o "$OUT_PREFIX.sorted.bam"

    # Check if the BAM file is empty
    if [ ! -s "$OUT_PREFIX.sorted.bam" ]; then
        echo "Error: The sorted BAM file is empty. Please check the sorting process for $QUERY_GENOME."
        exit 1
    fi

    echo "Indexing the BAM file..."
    apptainer exec --bind "$WORKDIR" "$SAMTOOLS_CONTAINER" samtools index "$OUT_PREFIX.sorted.bam"

    echo "Calling variants using bcftools..."
    bcftools mpileup -Ou -f "$REFERENCE_GENOME" "$OUT_PREFIX.sorted.bam" | bcftools call -mv -Ov -o "$OUT_PREFIX.vcf"

    # Check if the VCF file is empty
    if [ ! -s "$OUT_PREFIX.vcf" ]; then
        echo "Error: The VCF file is empty. Please check the variant calling process for $QUERY_GENOME."
        exit 1
    fi

    echo "Variant calling for $QUERY_GENOME completed!"
done

echo "All variant calling completed!"

# You can now proceed to your local machine with the VCFs for further analysis in R
# Please remember to transfer all VCF and plot files to your local machine
