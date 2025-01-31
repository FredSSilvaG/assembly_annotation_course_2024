#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=blast
#Sbatch --output=OMArk_%j.out
#Sbatch --error=OMArk_%j.err

conda activate OMArk

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/useID/assembly-annotation-course"

protein="assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
splice="isoform_list.txt"

OMArk="/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/"

wget https://omabrowser.org/All/LUCA.h5
omamer search --db  LUCA.h5 --query ${protein}.renamed.fasta --out ${protein}.renamed.fasta.omamer

omark -f ${protein}.renamed.fasta.omamer -of ${protein}.renamed.fasta -i isoform_list.txt -d LUCA.h5 -o omark_output