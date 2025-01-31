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
module load minimap2/2.20-GCCcore-10.3.0
module load SAMtools/1.13-GCC-10.3.0
module load BCFtools/1.12-GCC-10.3.0  # Load bcftools instead of freebayes
module load VCFtools/0.1.16-GCC-10.3.0

# Set paths
REFERENCE="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/TAIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"  # Uncompressed reference
ASSEMBLY_FOLDER="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Comparative_Genome_Analysis/group_comparison"  # Folder containing FASTA files
OUTDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/SNP_results_group"  # Output directory

# Create output directory
mkdir -p "$OUTDIR"

# Index reference genome (if not already indexed)
if [ ! -f "$REFERENCE.fai" ]; then
    echo "Indexing reference genome..."
    samtools faidx "$REFERENCE"
fi

# Find all FASTA files in the folder
ACCESSIONS=($(ls "$ASSEMBLY_FOLDER"/*.fasta))

# Check if any FASTA files are found
if [ ${#ACCESSIONS[@]} -eq 0 ]; then
    echo "No FASTA files found in $ASSEMBLY_FOLDER!"
    exit 1
fi

# Step 1: Align each accession to TAIR10
for ACCESSION in "${ACCESSIONS[@]}"; do
    BASENAME=$(basename "$ACCESSION" .fasta)  # Extract accession name without extension
    echo "Aligning $BASENAME to TAIR10..."

    minimap2 -ax asm5 "$REFERENCE" "$ACCESSION" > "$OUTDIR/${BASENAME}.sam"

    # Step 2: Convert SAM to BAM, sort, and index
    echo "Processing BAM files for $BASENAME..."
    samtools view -bS "$OUTDIR/${BASENAME}.sam" | samtools sort -o "$OUTDIR/${BASENAME}.sorted.bam"
    samtools index "$OUTDIR/${BASENAME}.sorted.bam"

    # Remove intermediate SAM files to save space
    rm "$OUTDIR/${BASENAME}.sam"
done

# Step 3: Call SNPs using bcftools (joint variant calling on all BAMs)
echo "Running bcftools for SNP calling..."

# Generate a pileup file
bcftools mpileup -f "$REFERENCE" "$OUTDIR"/*.sorted.bam | bcftools call -mv -Oz -o "$OUTDIR/raw_variants.vcf.gz"

# Index the VCF file
bcftools index "$OUTDIR/raw_variants.vcf.gz"

# Step 4: Filter SNPs using VCFtools
echo "Filtering SNPs..."
vcftools --vcf "$OUTDIR/raw_variants.vcf.gz" --remove-indels --minQ 30 --minDP 5 --recode --out "$OUTDIR/high_quality_SNPs"

echo "SNP pipeline completed successfully!"
