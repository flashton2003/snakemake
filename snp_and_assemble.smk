

'''
Input: 
    * list of sample names to run
    * root directory
    * reference genome
    * phenix config
    * going to be using bbduk'ed reads


Things I want to do:
    * Phenix run snp pipeline
    * phenix vcf to fastq
    * assembly (spades/shovill)

'''

root_dir = '/home/ubuntu/tm_data/ssuis_chickens/test'
todo_list = ['ERR120091']

assert os.path.exists(root_dir)

rule all:
    input:
        expand('{root_dir}/{sample}/shovill/{sample}_contigs.fa', sample = todo_list, root_dir = root_dir)

rule shovill:
    params:
        threads = 2,
        ram = 16
    input:    
            r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
            r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    output:
        '{root_dir}/{sample}/shovill/contigs.fa'
    shell:
        'shovill --outdir {root_dir}/{wildcards.sample}/shovill -R1 {input.r1} -R2 {input.r2} --cpus {params.threads} --ram {params.ram} --force'

rule move_shovill_output:
    input:
        rules.shovill.output
    output:
        '{root_dir}/{sample}/shovill/{sample}_contigs.fa'
    shell:
        'mv {input} {output}'
