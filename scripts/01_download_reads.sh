#!/bin/bash

#SBATCH --time=24:00:00
#SBATCH --mem=40G
#SBATCH --output=/data/users/fsilvagutierrez/assembly_course_2024/Out/download_Rld-2_%J.out
#SBATCH --error=/data/users/fsilvagutierrez/assembly_course_2024/Error/download_read_Rld-2_%J.error
#SBATCH --job-name=download_reads
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --partition=pibu_el8


# Set variables
SRC_DIR="/data/courses/assembly-annotation-course/raw_data/Rld-2"        # Path to the source folder
DEST_DIR="/data/users/fsilvagutierrez/assembly_course_2024/raw_data"  # Path to the destination folder

# Access the folder
cd ${SRC_DIR}

# Use ln -s to create a soft copy of the files
ln -s ${SRC_DIR}/Rld-2 ${DEST_DIR}/
ln -s ${SRC_DIR}/RNAseq_Sha ${DEST_DIR}/

echo "Download complete."