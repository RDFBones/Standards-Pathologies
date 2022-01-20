ß#! /bin/bash
cleanup=0
update=0
build=0
function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temp files"
    echo "    -u          initalize/update submodule"
    echo "    -h -?       print this help"
    echo " "
    
    exit
}

while getopts "bcuh?" opt; do
    case "$opt" in
        c)
            cleanup=1

            ;;
	u)  update=1
	    ;;
	b) build=1
	   ;;       
	?)
	usage
	;;
	h)
	    usage
	    ;;
    esac
done
if [ -z "$1" ]; then
    usage
fi
## check if submodule is initialized

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then
    update=1
    echo "Initializing git submodule"
fi

## Initialize and update git submodule
if  [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi

### Build ontologies
if [ $build -eq 1 ]; then
    ## Merge Core Ontology

    robot merge --input ./dependencies/RDFBones/RDFBones-main.owl \
	  --input ./dependencies/RDFBones/FMA-RDFBonesSubset.owl \
	  --input ./dependencies/RDFBones/RDFBones-ROIs-EntireBoneOrgan.owl \
	  --input ./dependencies/RDFBones/OBI-RDFBonesSubset.owl \
	  --input ./dependencies/RDFBones/CIDOC-CRM-RDFBonesSubset.owl \
	  --input ./dependencies/RDFBones/SIO-RDFBonesSubset.owl \
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

    ## MEASUREMENT DATA

    ## Merge value specifications into core ontology

    robot merge --input results/Merged_CategoryLabels.owl \
	  --input results/StandardsPatho_ValueSpecifications.owl \
	  --output results/Merged_ValueSpecifications.owl

    ## Create measurement data

    robot template --template Template_StandardsPatho-MeasurementData.tsv \
	  --input results/Merged_ValueSpecifications.owl \
	  --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
	  --prefix "obo: http://purl.obolibrary.org/obo/" \
	  --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
	  --ontology-iri "http://w3id.org/rdfbones/ext/standards-patho/standards-patho.owl" \
	  --output results/StandardsPatho_MeasurementData.owl

    ## EXTENSION

    robot merge --input results/StandardsPatho_CategoryLabels.owl \
	  --input results/StandardsPatho_ValueSpecifications.owl \
	  --input results/StandardsPatho_MeasurementData.owl \
	  --output results/standards-patho.owl

   
    
fi

if  [ $cleanup -eq 1 ]; then
	rm results/Merged_CoreOntology.owl results/Merged_CategoryLabels.owl results/StandardsPatho_CategoryLabels.owl results/StandardsPatho_ValueSpecifications.owl results/Merged_ValueSpecifications.owl results/StandardsPatho_MeasurementData.owl
fi
