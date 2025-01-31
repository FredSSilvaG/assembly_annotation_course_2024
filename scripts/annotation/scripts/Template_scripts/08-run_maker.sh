#!/bin/bash
#SBATCH --time=7-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --job-name=Maker_gene_annotation
#Sbatch --output=logs/Maker_gene_annotation_%j.out
#Sbatch --error=logs/Maker_gene_annotation_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/courses/assembly-annotation-course/CDS_annotation/example_MAKER_data"

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"


module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec \
--bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR \
${COURSEDIR}/containers/MAKER_3.01.03.sif \
maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts_accession.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl

# Merge the gff and fasta files
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.gff
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -n -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.noseq.gff
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/fasta_merge -d assembly.maker.output/assembly_master_datastore_index.log -o assembly

# Now finalize the maker output with AED and IPRScan outputs



