#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00
#SBATCH --job-name=Phylo_Analysis
#SBATCH --mail-user=federico.silvagutierrez@unifr.ch
#SBATCH --mail-type=ALL
#SBATCH --output=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Output/output_Phylo_Analysis_%j.o
#SBATCH --error=/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Error/error_Phylo_Analysis_%j.e
#SBATCH --partition=pibu_el8

# Load necessary modules for Clustal Omega and FastTree
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0
module load  SeqKit/2.6.1

# Define paths to key files and directories
input_pep_file="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/EDTA/extra/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.pep"
brassica_input_dom_file="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/PHYLO/Brassicaceae_repbase_all_march2019.fasta.rexdb-plant.dom.faa"
input_dom_file="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/EDTA/extra/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.dom.faa"
brassicaceae_te_file="/data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta"
brassicaceae_te_folder="/data/courses/assembly-annotation-course/CDS_annotation/data"

output_dir="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/PHYLO"
WORKDIR="/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2"
container_path="/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif"
#mkdir -p "$output_dir"

# Step 1: Extract RT protein sequences for Copia (Ty1-RT) and Gypsy (Ty3-RT) elements

# 1A. Extract Gypsy (Ty3-RT) elements
#grep "Ty3-RT" "$brassica_input_dom_file" > "$output_dir/Gypsy_RT_list.txt"
#sed -i 's/>//' "$output_dir/Gypsy_RT_list.txt"           # Remove ">"
#sed -i 's/ .\+//' "$output_dir/Gypsy_RT_list.txt"        # Remove everything after first space
#seqkit grep -f "$output_dir/Gypsy_RT_list.txt" "$brassica_input_dom_file" -o "$output_dir/Br_Gypsy_RT.fasta"

# 1B. Extract Copia (Ty1-RT) elements
#grep "Ty1-RT" "$brassica_input_dom_file" > "$output_dir/Copia_RT_list.txt"
#sed -i 's/>//' "$output_dir/Copia_RT_list.txt"           # Remove ">"
#sed -i 's/ .\+//' "$output_dir/Copia_RT_list.txt"        # Remove everything after first space
#seqkit grep -f "$output_dir/Copia_RT_list.txt" "$brassica_input_dom_file" -o "$output_dir/Br_Copia_RT.fasta"


# Step 2: Run TEsorter analysis using Brassicaceae TE database as input in the Singularity container
#cd $output_dir
#apptainer exec -C --bind $WORKDIR --bind $brassicaceae_te_folder -H ${pwd}:/work "$container_path" TEsorter "$brassicaceae_te_file" -db rexdb-plant 

#after step 2 I have to repeat to extract the copia and gypsy from the .faa file from bassicae, so in total i should have four files. 2 files from brassicaceae and two files from my .faa

# Extract RT sequences specific to Copia and Gypsy elements (if needed) from TEsorter output
# Adjust extraction commands as needed based on output file structure from TEsorter

# Step 3: Concatenate RT sequences from Brassicaceae and Arabidopsis TEs into one file
#cat "$output_dir/*_RT.fasta" > "$output_dir/Combined_RT_sequences.fasta" #---to fix

# Step 4: Shorten identifiers in RT sequences and replace ":" with "_"
sed -i 's/#.\+//' "$output_dir/Combined_RT_sequences.fasta"  # Remove text after "#"
sed -i 's/:/_/g' "$output_dir/Combined_RT_sequences.fasta"  # Replace ":" with "_"

# Step 5: Align RT sequences with Clustal Omega
clustalo -i "$output_dir/Combined_RT_sequences.fasta" -o "$output_dir/Aligned_RT_sequences.fasta"

# Step 6: Generate a phylogenetic tree using FastTree
FastTree -out "$output_dir/RT_Phylogenetic_tree.tree" "$output_dir/Aligned_RT_sequences.fasta"

# Step 7: Prepare for tree visualization and annotation with iTOL
# Create lists of identifiers and colors for clade annotation using clade names in $.rexdb-plant.cls.tsv
grep -e "Retand RT" $.rexdb-plant.cls.tsv | cut -f 1 | sed 's/:/_/' | sed 's/#.*//' | sed 's/$/ #FF0000 Retand/' > "$output_dir/Retand_ID.txt"

# Append clade annotations to dataset_color_strip_template.txt under "DATA"
#echo -e "#=================================================================#" >> dataset_color_strip_template.txt
#echo -e "# Actual data follows after the \"DATA\" keyword" >> dataset_color_strip_template.txt
#echo -e "#=================================================================#\nDATA" >> dataset_color_strip_template.txt
#cat "$output_dir/Retand_ID.txt" >> dataset_color_strip_template.txt

# Step 8: Add abundance data using dataset_simplebar_template.txt
# Extract abundance data from EDTA output and add it to dataset_simplebar_template.txt
#grep "TE_" "$genome.mod.EDTA.TEanno.sum" | awk '{print $1 "," $2}' >> dataset_simplebar_template.txt

# Instructions to user
#echo "Pipeline complete. For visualization, upload '$output_dir/RT_Phylogenetic_tree.tree' to iTOL (https://itol.embl.de/)"
#echo "Use dataset_color_strip_template.txt for clade annotation and dataset_simplebar_template.txt for abundance visualization."
