
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
        read1 = '{root_dir}/{id}/{id}_1.fastq.gz',
        read2 = '{root_dir}/{id}/{id}_2.fastq.gz'

    output:
        r1_res = '{root_dir}/{id}/fastqc/{id}_1_fastqc.zip',
        r2_res = '{root_dir}/{id}/fastqc/{id}_2_fastqc.zip'

    shell:
        '''
        mkdir {root_dir}/{wildcards.id}/fastqc/
        fastqc -o {root_dir}/{wildcards.id}/fastqc/ {input.read1}
        fastqc -o {root_dir}/{wildcards.id}/fastqc/ {input.read2}
        '''
        

rule multiqc:
    # fastqcs = expand('{root_dir}/{sample}/fastqc')
    
    input:
        rules.fastqc.output.r1_res, rules.fastqc.output.r2_res

    output:
        '{results_dir}/multiqc.html'

    shell:
        'multiqc -o {results_dir} {fastqcs}'