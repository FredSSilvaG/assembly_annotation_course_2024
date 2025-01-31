### 1) Summarize Orthofinder statistics per species

## load packages
library(tidyverse)
library(data.table)
library(cowplot)
library(RColorBrewer)

## Import dataset (Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv)

dat <- fread("/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/GENESPACE/orthof
inder/Results_Nov19/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv")
ids=names(dat)
dat <- gather(dat, species, perc, ids[ids!="V1"], factor_key = TRUE)

## Parse Dataset 
o_ratio <- dat %>%
  filter( V1 %in% c("Number of genes", "Number of genes in orthogroups", "Number of unassigned genes",
                    "Number of orthogroups containing species", "Number of species-specific orthogroups", 
                    "Number of genes in species-specific orthogroups"
  ))

o_percent <- dat %>%
  filter( V1 %in% c(
    "Percentage of genes in orthogroups", "Percentage of unassigned genes", "Percentage of orthogroups containing species",
    "Percentage of genes in species-specific orthogroups"
  ))


## Plot

p <- ggplot(o_ratio, aes(x =  V1, y = perc, fill = species)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Paired") +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Count")
ggsave("plots/orthogroup_number_plot.pdf")

p <- ggplot(o_percent, aes(x =  V1, y = perc, fill = species)) +
  geom_col(position = "dodge") +
  ylim(c(0, 100)) +
  scale_fill_brewer(palette = "Paired") +
  theme_cowplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y = "Count")
ggsave("plots/orthogroup_percentage_plot.pdf")



### 2) PLot co-occurrence of Orthogroups

library(UpSetR)

## import dataset (Orthogroups/Orthogroups.GeneCount.tsv)
ogroups <- fread("/data/users/fsilvagutierrez/03_Semester/assembly_course_2024/Annotation/Rld-2/GENESPACE/orthof
inder/Results_Nov19/Orthogroups/Orthogroups.GeneCount.tsv")

## parse dataset
ogroups <- ogroups %>% select(-Total)
ogroups_presence_absence <- ogroups
rownames(ogroups_presence_absence) <- ogroups_presence_absence$Orthogroup
ogroups_presence_absence[ogroups_presence_absence > 0] <- 1
ogroups_presence_absence$Orthogroup <- rownames(ogroups_presence_absence)

str(ogroups_presence_absence)
ogroups_presence_absence$Orthogroup

ogroups_presence_absence <- ogroups_presence_absence %>%
  rowwise() %>%
  mutate(SUM = sum(c_across(ends_with("proteins"))))


genomes <- names(ogroups_presence_absence)[grepl("proteins",names(ogroups_presence_absence))]
ogroups_presence_absence <- data.frame(ogroups_presence_absence)
ogroups_presence_absence[genomes] <- ogroups_presence_absence[genomes] == 1


## plot data using the ComplexUpset package
library(ComplexUpset)

pdf("one-to-one_orthogroups_plot.complexupset.pdf", height = 5, width = 10, useDingbats = FALSE)
upset(ogroups_presence_absence, genomes, name = "genre", width_ratio = 0.1, wrap = TRUE, set_sizes = FALSE)
dev.off()