#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=Genespace
#Sbatch --output=Genespace_%j.out
#Sbatch --error=Genescpace_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/userID/assembly-annotation-course"

apptainer exec \
    --bind $COURSEDIR \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/17-Genespace.R genespace

# apptainer shell \
#     --bind $COURSEDIR \
#     --bind $WORKDIR \
#     --bind $SCRATCH:/temp \
#     $COURSEDIR/containers/genespace_latest.sif