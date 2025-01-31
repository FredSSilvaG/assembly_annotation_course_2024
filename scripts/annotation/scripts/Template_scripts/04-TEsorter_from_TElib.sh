#!/bin/bash
#SBATCH --job-name=TEsorter_TElib          # Job name
#SBATCH --partition=pibu_el8              # Partition (queue)
#SBATCH --cpus-per-task=4                # Number of CPUs
#SBATCH --mem=8G                         # Memory (RAM)
#SBATCH --time=01:00:00                 # Max wall time 
#SBATCH --output=logs/TEsorter_TElib_%j.out         # Standard output log
#SBATCH --error=logs/TEsorter_TElib_%j.err          # Standard error log

WORKDIR="/data/users/userID/assembly-annotation-course"


module load SeqKit/2.6.1

seqkit grep -r -p "Copia" assembly.fasta.mod.EDTA.TElib.fa > Copia_sequences.fa
seqkit grep -r -p "Gypsy" assembly.fasta.mod.EDTA.TElib.fa > Gypsy_sequences.fa

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

