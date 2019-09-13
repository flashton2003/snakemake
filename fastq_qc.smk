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

assert os.path.exists(root_dir)

if not os.path.exists(results_dir):
    os.makedir(results_dir)

rule all:
    input:
        f'{results_dir}/multiqc_report.html',
        expand(['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'], sample = todo_list, root_dir = root_dir)

rule fastqc:
    input:
        ['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz']
    output:
        ['{root_dir}/{sample}/{sample}_1_fastqc.zip', '{root_dir}/{sample}/{sample}_2_fastqc.zip', '{root_dir}/{sample}/{sample}_1_fastqc.html', '{root_dir}/{sample}/{sample}_2_fastqc.html']
    shell:
        'fastqc {input}'
        
rule move_fastqc_output:
    input:
        rules.fastqc.output
    output:
        ['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.html']
    run:
        cmds = zip(input, output)
        dirname = os.path.dirname(input[0])
        if not os.path.exists(dirname):
            shell('mkdir -p {dirname}')
        for c in cmds:
            print(c[0], c[1])
            shell('mv {c[0]} {c[1]}')

## do the expand bit in the multiqc as this is the last section which requires all these, and snakemake works by 'pulling'
rule multiqc:
    input:
        expand(['{root_dir}/{sample}/fastqc/{sample}_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_2_fastqc.html'], sample = todo_list, root_dir = root_dir)
    output:
        '{results_dir}/multiqc_report.html'
    shell:
        'multiqc -o {results_dir} {input}'

rule bbduk:
    input:
        r1 = '{root_dir}/{sample}/{sample}_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_2.fastq.gz'

    output:
        ['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz']

    run:
        for x in input:
            print(input.r1, input.r2)
        # 'bbduk.sh ref=/home/ubuntu/external_tb/references/2019.04.22/adapters.fa in=!{forward} in2=!{reverse} out=!{pair_id}_bbduk_1.fastq.gz out2=!{pair_id}_bbduk_2.fastq.gz ktrim=r k=23 mink=11 hdist=1 tbo tpe qtrim=r trimq=20 minlength=50'


