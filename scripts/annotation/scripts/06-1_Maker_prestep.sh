#!/bin/bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00
#SBATCH --job-name=Maker_Config
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_Maker_Config_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_Maker_Config_%j.e
#SBATCH --partition=pibu_el8


WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/MAKER"

cd $WORKDIR

apptainer exec --bind $WORKDIR \
/data/courses/assembly-annotation-course/containers2/MAKER_3.01.03.sif maker -CTL \