


root_dir = '/home/ubuntu/tm_data/ssuis_chickens/test'
todo_list = ['ERR120091']
ref = '/home/ubuntu/tm_data/ssuis_chickens/reference_genome/2019.09.05/AM946016.fasta'
config = '/home/ubuntu/tm_data/references/2018.10.08/phenix_config.yml'
assert os.path.exists(root_dir)

rule all:
    input:
        expand('{root_dir}/{sample}/phenix_bbduk/{sample}.fasta', sample = todo_list, root_dir = root_dir)

rule phenix_snp_pipeline:
	params:
		reference = ref
        phenix_config = config
	input:
        r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    output:
    	'{root_dir}/{sample}/{sample}/phenix_bbduk/{sample}.filtered.vcf'
    conda:
        '../../envs/phenix.yaml'
    shell:
    	'''
    	phenix.py run_snp_pipeline \
    	-r1 {input.r1} \
		-r2 {input.r2} \
		-r {params.reference} \
		-c {params.phenix_config} \
		--keep-temp \
		--sample-name {wildcards.sample}
		-o {root_dir}/{wildcards.sample}/{wildcards.sample}/phenix_bbduk
    	'''
