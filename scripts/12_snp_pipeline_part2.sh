#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=13_snp_pipeline_group
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_13_snp_pipeline_group_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_13_snp_pipeline_group_%j.e
#SBATCH --partition=pibu_el8

# Load required modules (for HPC environments)
module load BCFtools/1.12-GCC-10.3.0
module load VCFtools/0.1.16-GCC-10.3.0

# Set paths
REFERENCE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/TAIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"  # Uncompressed reference
ASSEMBLY_FOLDER="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/SNP_results_group"  # Folder containing BAM files
OUTDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/SNP_results_group"  # Output directory

# Create output directory
mkdir -p "$OUTDIR"

# Find all BAM files in the folder
BAM_FILES=($(ls "$ASSEMBLY_FOLDER"/*.sorted.bam))

# Check if any BAM files are found
if [ ${#BAM_FILES[@]} -eq 0 ]; then
    echo "No BAM files found in $ASSEMBLY_FOLDER!"
    exit 1
fi

# Step 1: Call SNPs using bcftools (joint variant calling on all BAMs)
echo "Running bcftools for SNP calling..."

# Generate a pileup file and call variants
bcftools mpileup -f "$REFERENCE" "${BAM_FILES[@]}" | bcftools call -mv -Oz -o "$OUTDIR/raw_variants.vcf.gz"

# Index the VCF file
bcftools index "$OUTDIR/raw_variants.vcf.gz"

# Step 2: Verify VCF file before processing with vcftools
if [ ! -s "$OUTDIR/raw_variants.vcf.gz" ]; then
    echo "Error: VCF file is empty or not created properly."
    exit 1
fi

# Step 3: Filter SNPs using VCFtools
echo "Filtering SNPs..."
vcftools --gzvcf "$OUTDIR/raw_variants.vcf.gz" --remove-indels --minQ 30 --minDP 5 --recode --out "$OUTDIR/high_quality_SNPs"

echo "SNP pipeline completed successfully!"
