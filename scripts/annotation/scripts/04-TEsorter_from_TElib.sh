#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00  # Adjust time as necessary
#SBATCH --job-name=TEsorter_TElib
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/TEsorter_TElib_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/TEsorter_TElib_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/EDTA"


module load SeqKit/2.6.1

#seqkit grep -r -p "Copia" assembly.fasta.mod.EDTA.TElib.fa > Copia_sequences.fa
#seqkit grep -r -p "Gypsy" assembly.fasta.mod.EDTA.TElib.fa > Gypsy_sequences.fa

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Copia_sequences.fa -db rexdb-plant

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Gypsy_sequences.fa -db rexdb-plant

# Also run TEsorter on the Brassicaceae-specific TE library, 
# you will need Brassicaceae TEs for phylogenetic analysis

seqkit grep -r -p "Copia" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Copia_Brassicaceae_sequences.fa
seqkit grep -r -p "Gypsy" /data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta > Gypsy_Brassicaceae_sequences.fa

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Copia_Brassicaceae_sequences.fa -db rexdb-plant

apptainer exec --bind $WORKDIR -H ${pwd}:/work /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif \
TEsorter Gypsy_Brassicaceae_sequences.fa -db rexdb-plant

