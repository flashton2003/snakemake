import os

'''
Input: 
    * list of sample names to run
    * root directory

Things I want to do:
    * FASTQC
    * MultiQC
    * bbduk
'''

## from here https://github.com/jakevc/snakemake_multiqc/blob/master/Snakefile

## alternative within conda https://multiqc.info/docs/#snakemake

root_dir = '/home/ubuntu/tm_data/ssuis_chickens/test'
results_dir = '/home/ubuntu/tm_data/ssuis_chickens/test/run_results'
todo_list = ['ERR120091']


# rule all:
#     input:
#         f'{results_dir}/multiqc_report.html'

rule all:
    input:
        expand(['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.html'], sample = todo_list, root_dir = root_dir)


rule fastqc:
    input:
        ['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz']
    output:
        ['{root_dir}/{sample}/{sample}_1_fastqc.zip', '{root_dir}/{sample}/{sample}_2_fastqc.zip', '{root_dir}/{sample}/{sample}_1_fastqc.html', '{root_dir}/{sample}/{sample}_2_fastqc.html']
    shell:
        'fastqc {input}'
        
# separating out the move output bit, as couldn't get the wildcard recognied in output. think about going back to last git commit.
rule move_fastqc_output:
    input:
        rules.fastqc.output
    output:
        ['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.html']
    run:
        cmds = zip(input, output)
        basename = os.path.basename(input[0])
        if not os.path.exists(basename):
            shell('mkdir -p {basename}')
        for c in cmds:
            print(c[0], c[1])
            shell('mv {c[0]} {c[1]}')


# rule multiqc:
#     input:
#         # change this to something like rules.fastqc.output
#         #expand(['{root_dir}/{sample}/fastqc/'], sample = todo_list, root_dir = root_dir)
#         rules.move_fastqc_output.output

#     output:
#         f'{results_dir}/multiqc_report.html'

#     shell:
#         'multiqc -o {results_dir} {input}'
