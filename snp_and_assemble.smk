

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
bbduk = True

assert os.path.exists(root_dir)

rule all:
    input:
        expand('{root_dir}/{sample}/shovill/{sample}_contigs.fasta', sample = todo_list, root_dir = root_dir)

rule shovill:
    params:
        threads = 8
        ram = 32
    input:
        if bbduk == True:
            r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
            r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
        if bbduk == False:
            r1 = '{root_dir}/{sample}/{sample}_1.fastq.gz',
            r2 = '{root_dir}/{sample}/{sample}_2.fastq.gz'
    output:
        '{root_dir}/{sample}/shovill/contigs.fasta'
    shell:
        'shovill --outdir {root_dir}/{sample}/shovill -R1 {input.r1} -R2 {input.r2} --cpus {params.threads} --ram {params.ram}'
