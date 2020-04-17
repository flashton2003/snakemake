
root_dir = '/home/ubuntu/tm_data/S_pneumo/oucru_robot'
todo_list = ['16648-ERR065309','16649-ERR065333','16650-ERR065963','16651-ERR067965','16652-ERR067987','16653-ERR068025','16654-ERR068044','16655-ERR069689','16656-ERR069723','16657-ERR069732','16658-ERR069733','16659-ERR069761','16660-ERR069812','16661-ERR069821','16662-ERR069841','16663-ERR124223','16664-ERR124225','16665-ERR124246','16666-ERR124300','16667-ERR124303','16668-ERR124335','16669-ERR129031','16670-ERR129070','16671-ERR129081','16672-ERR129109']
ref = '/home/ubuntu/tm_data/S_pneumo/refs/NC_003098.fa'

assert os.path.exists(root_dir)
assert os.path.exists(ref)

rule all:
    input:
        expand('{root_dir}/{sample}/snippy_bbduk/{sample}.consensus.subs.fa', sample = todo_list, root_dir = root_dir)

rule snippy:
    input:
        r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    params: 
        reference = ref
    output:
        '{root_dir}/{sample}/snippy_bbduk/{sample}.consensus.subs.fa'
    conda:
        '../../envs/phenix.yaml'
    shell:
        'snippy --outdir {root_dir}/{wildcards.sample}/snippy_bbduk --reference {params.reference} --R1 {input.r1} --R2 {input.r2} --cpus 8 --force --prefix {wildcards.sample}'
        
