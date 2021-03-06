#!/usr/bin/env cwl-runner

cwlVersion: "cwl:draft-3"

class: CommandLineTool

requirements:
- $import: envvar-global.yml
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement
  expressionLib:
  - "var new_ext = function() { var ext=inputs.bai?'.bai':inputs.csi?'.csi':'.bai'; return inputs.input.path.split('/').slice(-1)[0]+ext; };"

inputs:
- id: "#input"
  type: File
  description: |
    Input bam file.
  inputBinding:
    position: 2

- id: "#bai"
  type: boolean
  default: false
  description: |
    Generate BAI-format index for BAM files [default]

- id: "#csi"
  type: boolean
  default: false
  description: |
    Generate CSI-format index for BAM files

- id: "#interval"
  type: ["null", int]
  description: |
    Set minimum interval size for CSI indices to 2^INT [14]
  inputBinding:
    position: 1
    prefix: "-m"

outputs:
  - id: "#index"
    type: File
    description: "The index file"
    outputBinding:
      glob: $(new_ext())

baseCommand: ["samtools", "index"]

arguments:
  - valueFrom: $(inputs.bai?'-b':inputs.csi?'-c':[])
    position: 1
  - valueFrom: $(new_ext())
    position: 3

$namespaces:
  s: http://schema.org/

$schemas:
- https://sparql-test.commonwl.org/schema.rdf

s:mainEntity:
  $import: samtools-metadata.yaml

description: |
  samtools-index.cwl is developed for CWL consortium

s:downloadUrl: https://github.com/common-workflow-language/workflows/blob/master/tools/samtools-index.cwl
s:codeRepository: https://github.com/common-workflow-language/workflows
s:license: http://www.apache.org/licenses/LICENSE-2.0

s:isPartOf:
  class: s:CreativeWork
  s:name: "Common Workflow Language"
  s:url: http://commonwl.org/

s:author:
  class: s:Person
  s:name: "Andrey Kartashov"
  s:email: mailto:Andrey.Kartashov@cchmc.org
  s:sameAs:
  - id: http://orcid.org/0000-0001-9102-5681
  s:worksFor:
  - class: s:Organization
    s:name: "Cincinnati Children's Hospital Medical Center"
    s:location: "3333 Burnet Ave, Cincinnati, OH 45229-3026"
    s:department:
    - class: s:Organization
      s:name: "Barski Lab"
