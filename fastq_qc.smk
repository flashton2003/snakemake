
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

print(f'{results_dir}/multiqc_report.html')

rule all:
    input:
        f'{results_dir}/multiqc_report.html'

rule fastqc:
    input:
        fastqs = expand(['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz'], sample = todo_list, root_dir = root_dir)

    output:
        fastqc_zips = expand(['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip'], sample = todo_list, root_dir = root_dir)

    shell:
        '''
        mkdir {root_dir}/{sample}/fastqc/
        fastqc -o {root_dir}/{sample}/fastqc/ {input.fastqs}
        '''
        

rule multiqc:
    input:
        # change this to something like rules.fastqc.output
        #expand(['{root_dir}/{sample}/fastqc/'], sample = todo_list, root_dir = root_dir)
        rules.fastqc.output.fastqc_zips

    output:
        f'{results_dir}/multiqc_report.html'

    shell:
        'multiqc -o {results_dir} {input}'
