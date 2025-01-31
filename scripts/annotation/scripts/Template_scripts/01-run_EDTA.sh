#!/bin/bash
#SBATCH --job-name=EDTA_TE_annot          # Job name
#SBATCH --partition=pibu_el8              # Partition (queue)
#SBATCH --cpus-per-task=20                # Number of CPUs
#SBATCH --mem=64G                         # Memory (RAM)
#SBATCH --time=5-00:00:00                 # Max wall time (5 day)
#SBATCH --output=logs/EDTA_%j.out         # Standard output log
#SBATCH --error=logs/EDTA_%j.err          # Standard error log


WORKDIR="/path/to/working/directory"
cd $WORKDIR
mkdir -p output/EDTA
cd output/EDTA

# If you are using the singularity container, you can run the following command:
# apptainer exec -C --bind $WORKDIR -H ${pwd}:/work \
# --writable-tmpfs -u $WORKDIR/containers/EDTA_v1.9.6.sif \
# EDTA.pl \
# --genome $WORKDIR/data/assemblies/flye/assembly.fasta \  # The genome FASTA file
# --species others \  # Specify 'others' if not Rice|Maize]
# --step all \        # Run all steps of TE annotation
# --cds TAIR10_cds_20110103_representative_gene_model_updated \  # CDS file for gene masking
# --anno 1 \          # Perform whole-genome TE annotation
# --threads 20        # Number of threads for multi-core processing (default: 4)

# if you are using conda environment, first install all the required dependencies using EDTA_2.2.x.yml, 
# then clone EDTA from github in your working directory scripts folder and run the following command:

perl $WORKDIR/scripts/EDTA/EDTA.pl \
--genome $WORKDIR/data/assemblies/assembly.fasta \
--species others \
--step all \
--cds TAIR10_cds_20110103_representative_gene_model_updated \
--anno 1 \
--threads 20

