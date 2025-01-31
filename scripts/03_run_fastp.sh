#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastp
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/assembly_course_2024/Output/output_fastp_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/assembly_course_2024/Error/error_fastp_%j.e
#SBATCH --partition=pibu_el8


## --------------------------------------------------------------------
## B | Filtering - Fastp
## --------------------------------------------------------------------

#quality control

WORKDIR=/data/users/fsilvagutierrez/assembly_course_2024

# Run FastQC on Rld-2 dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
fastp --thread 4  -i ${WORKDIR}/Raw_data/Rld-2/* --report_title "PacBio HiFi Data Stats" --html ${WORKDIR}/read_QC/Rld-2/pacbio_fastp_report.html --json ${WORKDIR}/read_QC/Rld-2/pacbio_fastp_report.json --disable_quality_filtering  # Disable filtering for PacBio


# Run FastQC on RNAseq_Sha dataset
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
fastp --thread 4 -i ${WORKDIR}/Raw_data/RNAseq_Sha/*_1.fastq.gz -I ${WORKDIR}/Raw_data/RNAseq_Sha/*_2.fastq.gz -o ${WORKDIR}/read_QC/RNAseq_Sha/ERR754081_1_filtered.fastq.gz -O ${WORKDIR}/read_QC/RNAseq_Sha/ERR754081_2_filtered.fastq.gz --html ${WORKDIR}/read_QC/RNAseq_Sha/sample_fastp_report.html --json ${WORKDIR}/read_QC/RNAseq_Sha/sample_fastp_report.json


#running time notification
echo 'fastp processing complete'