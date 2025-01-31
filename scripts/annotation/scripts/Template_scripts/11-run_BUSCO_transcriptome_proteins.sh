#!/bin/bash
#SBATCH --time=10-0
#SBATCH --mem=100G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=Busco_transcriptome

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/useID/assembly-annotation-course"
protein=$1
transcript=$2

module load BUSCO/5.4.2-foss-2021a


mkdir -p $WORKDIR/output/annotation_evaluation/busco
cd $WORKDIR/output/annotation_evaluation/busco



# Remember to get the longest isoform from the maker annotation


busco \
    -i $transcript \
    -l brassicales_odb10 \
    -o Maker_transcripts \
    -m transcriptome \
    --cpu 50 \
    --out_path $WORKDIR/output/annotation_evaluation/busco \
    --download_path $WORKDIR/output/annotation_evaluation/busco \
    --force


busco \
    -i $protein \
    -l brassicales_odb10 \
    -o Maker_proteins \
    -m proteins \
    --cpu 50 \
    --out_path $WORKDIR/output/annotation_evaluation/busco \
    --download_path $WORKDIR/output/annotation_evaluation/busco \
    --force


