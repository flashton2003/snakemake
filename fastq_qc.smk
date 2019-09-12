
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
        fastqs = expand(['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz'], sample = todo_list)

    output:
        fastqc_zips = expand(['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip'], sample = todo_list)

    shell:
        '''
        mkdir {root_dir}/{wildcards.sample}/fastqc/
        fastqc -o {root_dir}/{wildcards.sample}/fastqc/ {input.fastqs}
        '''
        

rule multiqc:
    # fastqcs = expand('{root_dir}/{sample}/fastqc')
    
    input:
        # change this to something like rules.fastqc.output
        # expand(['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip'], sample = todo_list)
        rules.fastqc.output.fastqc_zips

    output:
        '{results_dir}/multiqc.html'

    shell:
        'multiqc -o {results_dir} {input}'