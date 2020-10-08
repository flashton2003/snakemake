# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


todo_list = ['18080-1-FR10242277']
root_dir = '/home/ubuntu/hao_shigella/salmonella/oucru_robot/'

# Allow users to fix the underlying OS via singularity.
# singularity: "docker://continuumio/miniconda3"

rule all:
    input:
        expand('{root_dir}/{sample}/phenix_bbduk/{sample}.depth', sample = todo_list, root_dir = root_dir)
        # The first rule should define the default target files
        # Subsequent target rules can be specified below. They should start with all_*.

rule samtools_depth:
    input:
        bam = '{root_dir}/{sample}/phenix_bbduk/{sample}.bam'
    output:
        depth = '{root_dir}/{sample}/phenix_bbduk/{sample}.depth'
    shell:
        'samtools depth -aa {input.bam} |  awk \'{sum+=$3} END { print "{input.bam} average depth", sum/NR}\' > {output.depth}'


