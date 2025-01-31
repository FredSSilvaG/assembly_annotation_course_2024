COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

# Download the Orthologs of fragmented and missing genes from OMArk database
conda activate OMArk
$COURSEDIR/softwares/OMArk-0.3.0/utils/omark_contextualize.py fragment -m assembly.all.maker.proteins.fasta.renamed.filtered.fasta.omamer -o omark_output -f fragment_HOGs
$COURSEDIR/softwares/OMArk-0.3.0/utils/omark_contextualize.py missing -m assembly.all.maker.proteins.fasta.renamed.filtered.fasta.omamer -o omark_output -f missing_HOGs 