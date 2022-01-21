# Standards-Pathologies

An [RDFBones](https://rdfbones.github.io/) ontology extension modelling the acquisition routine for pathological data specified in "Standards For Data Collection From Human Skeletal Remains" (1994).

## State of implementation

We are currently only implementing elements from the Standards that are needed for an [RDFBones ontology extension](https://github.com/RDFBones/Phaleron-Pathologies) which we are developing for the Phaleron Bioarchaeological Project. Full implementation is planned for later in 2022.

## How to build the ontology file

We are using the [ROBOT](https://robot.obolibrary.org/) for developing the first version of the ontology extension. The relevant files are in the [robot branch](https://github.com/RDFBones/Standards-Pathologies/tree/robot) of this repository.

Specifications of ontology elements are in a series of template files in the tab-separated value format (.tsv). From these, the web ontology language (.owl) file is compiled using the script [Script_StandardsPatho-Robot.sh](https://github.com/RDFBones/Standards-Pathologies/blob/robot/Script_StandardsPatho-Robot.sh). To execute, navigate to the directory containing the file and run the scipt as

```./Script_StandardsPatho-Robot.sh -b -c -u```

The output will appear in a newly created directory 'results' and consist of the single file 'standards-patho.owl'.

The scipt generates a series of intermediate files during the compilation process. To obtain these in the 'results' folder, drop the '-c' ('clean-up') option when executing the script.

Compilation relies on [version 0.2 of the RDFBones core ontology](https://github.com/RDFBones/RDFBones-O/tree/v0.2) which is included in a submodule (./dependencies/RDFBones/) within this repository. The script automatically updates the submodule as long as the '-u' (update) option is set.

The '-b' (build) option causes the script to compile the output file. Use the script without this option to update the submodule or clean up a previously compiled output.
