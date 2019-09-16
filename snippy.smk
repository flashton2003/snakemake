
root_dir = '/home/ubuntu/tm_data/ssuis_chickens/oucru_robot'
todo_list = ['15335-0014']
ref = '/home/ubuntu/tm_data/ssuis_chickens/reference_genome/2019.09.05/AM946016.fasta'

assert os.path.exists(root_dir)
assert os.path.exists(ref)

rule all:
    input:
        #expand('{root_dir}/{sample}/phenix_bbduk/{sample}.fasta', sample = todo_list, root_dir = root_dir)
        expand('{root_dir}/{sample}/{sample}/snippy_bbduk/{sample}.snps.consensus.subs.fa', sample = todo_list, root_dir = root_dir)

rule snippy:
    input:
        r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    params: 
        reference = ref
    output:
        '{root_dir}/{sample}/snippy_bbduk/{sample}.snps.consensus.subs.fa'
    conda:
        '../../envs/phenix.yaml'
    shell:
        'snippy --outdir {root_dir}/{wildcards.sample}/snippy_bbduk --ref {params.ref} --R1 {input.r1} --R2 {input.r2} --cpus 8 --force --prefix {wildcards.sample}'
        
