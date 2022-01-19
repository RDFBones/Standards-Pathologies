#! /bin/bash

## Merge Core Ontology

robot merge --input ~/gitprojects/RDFBones-O/RDFBones-main.owl \
      --input ~/gitprojects/RDFBones-O/FMA-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/RDFBones-ROIs-EntireBoneOrgan.owl \
      --input ~/gitprojects/RDFBones-O/OBI-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/CIDOC-CRM-RDFBonesSubset.owl \
      --input ~/gitprojects/RDFBones-O/SIO-RDFBonesSubset.owl \
      --output results/Merged_CoreOntology.owl

## CATEGORY LABELS

robot template --template Template_StandardsPatho-CategoryLabels.tsv \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "fma: http://purl.org/sig/ont/fma/" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-si: http://w3id.org/rdfbones/ext/standards-si/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --ontology-iri "http://w3id.org/rdfbones/ext/standards-patho/standards-patho.owl" \
  --output results/StandardsPatho_CategoryLabels.owl

## VALUE SPECIFICATIONS

## Merge category labels into core ontology

robot merge --input results/Merged_CoreOntology.owl \
      --input results/StandardsPatho_CategoryLabels.owl \
      --output results/Merged_CategoryLabels.owl

# Create value specifications

robot template --template Template_StandardsPatho-ValueSpecifications.tsv \
  --input results/Merged_CategoryLabels.owl \
  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
  --prefix "obo: http://purl.obolibrary.org/obo/" \
  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
  --ontology-iri "http://w3id.org/rdfbones/ext/standards-patho/standards-patho.owl" \
  --output results/StandardsPatho_ValueSpecifications.owl

## EXTENSION

robot merge --input results/StandardsPatho_CategoryLabels.owl \
      --input results/StandardsPatho_ValueSpecifications.owl \
      --output results/standards-patho.owl

read -p 'Hit ENTER to exit'
