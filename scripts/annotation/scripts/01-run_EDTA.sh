#!/usr/bin/env bash

#SBATCH --cpus-per-task=20
#SBATCH --mem=64G
#SBATCH --time=5-00:00:00 
#SBATCH --job-name=EDTA_TE_annot
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_EDTA_TE_annot_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_EDTA_TE_annot_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"
cd $WORKDIR/Annotation/Rld-2/EDTA
CDS="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Raw_data/TAIR/TAIR10_cds_20110103_representative_gene_model_updated.fa"
CONTAINER_PATH="/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA_v1.9.6.sif"

# If you are using the singularity container, you can run the following command:
 apptainer exec -C --bind $WORKDIR -H ${pwd}:/work --writable-tmpfs -u $CONTAINER_PATH EDTA.pl --genome $WORKDIR/Assembly/Flye/assembly.fasta --species others --step all --cds "$CDS" --anno 1 --threads 20
 

# if you are using conda environment, first install all the required dependencies using EDTA_2.2.x.yml, 
# then clone EDTA from githun in your working directory scripts folder and run the following command:

#perl $WORKDIR/scripts/EDTA/EDTA.pl \
#--genome $WORKDIR/data/assemblies/assembly.fasta \
#--species others \
#--step all \
#--cds TAIR10_cds_20110103_representative_gene_model_updated \
#--anno 1 \
#--threads 20

