#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00 
#SBATCH --nodes=1
#SBATCH --job-name=Maker_annot
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_Maker_annot_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_Maker_annot_%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/maker"

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"


module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec --bind $WORKDIR\
--bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR \
${COURSEDIR}/containers/MAKER_3.01.03.sif \
maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl

# Merge the gff and fasta files
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.gff
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/gff3_merge -n -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.noseq.gff
$COURSEDIR/softwares/Maker_v3.01.03/src/bin/fasta_merge -d assembly.maker.output/assembly_master_datastore_index.log -o assembly

#keep in mind, add the workdir flag, and change the script to the directory where the ctl files are, because it will start making the files there and they need to read where the files are