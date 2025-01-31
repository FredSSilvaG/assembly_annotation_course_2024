#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --nodes=1
#SBATCH --job-name=GENESPACE
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_GENESPACE_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_GENESPACE_%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024"

apptainer exec \
    --bind $COURSEDIR \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/annotation/scripts/14_Genespace.R $WORKDIR/Annotation/Rld-2/GENESPACE

# parse the orthofinder output
#apptainer exec --bind $COURSEDIR --bind $WORKDIR --bind $SCRATCH:/temp $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/annotation/scripts/15_parse_Orthofinder.R