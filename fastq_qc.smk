
'''
Input: 
    * list of sample names to run
    * root directory

Things I want to do:
    * FASTQC
    * MultiQC
    * bbduk
'''

root_dir = '/home/ubuntu/tm_data/ssuis_chickens/test'
results_dir = '/home/ubuntu/tm_data/ssuis_chickens/run_results'
todo_list = ['ERR120091']

rule all:
    input:
        '{results_dir}/multiqc.html'



rule fastqc:
    input:
        expand('{root_dir}/{sample}_{1,2}.fastq.gz')

    output:
        '{sample}_1.fastqc.zip', '{sample}_2.fastqc.zip'

    shell:
        'fastqc {input}'
        

rule multiqc:
    fastqcs = expand('{root_dir}/{sample}/fastqc')
    input:
        expand('{root_dir}/{sample}/fastqc')

    output:
        '{results_dir}/multiqc.html'

    shell:
        'multiqc -o {results_dir} {fastqcs}'