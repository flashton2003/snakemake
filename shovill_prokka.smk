root_dir = '/home/ubuntu/tm_data/efsa/example_data/2020.01.29'
todo_list = ['ERR022075', 'SRR3674867']
assert os.path.exists(root_dir)

rule all:
    input:
        expand('{root_dir}/{sample}/prokka/{sample}.gbk', sample = todo_list, root_dir = root_dir)

rule shovill:
    params:
        threads = 8,
        ram = 32
    input:    
            r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz',
            r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    output:
        final = '{root_dir}/{sample}/shovill_bbduk/contigs.fa',
        graph = '{root_dir}/{sample}/shovill_bbduk/contigs.gfa',
        spades = '{root_dir}/{sample}/shovill_bbduk/spades.fasta'
    shell:
        'shovill --outdir {root_dir}/{wildcards.sample}/shovill_bbduk -R1 {input.r1} -R2 {input.r2} --cpus {params.threads} --ram {params.ram} --force'

rule move_shovill_output:
    input:
        final = rules.shovill.output.final,
        graph = rules.shovill.output.graph,
        spades = rules.shovill.output.spades
    output:
        final = '{root_dir}/{sample}/shovill_bbduk/{sample}_contigs.fa',
        graph = '{root_dir}/{sample}/shovill_bbduk/{sample}_contigs.gfa',
        spades = '{root_dir}/{sample}/shovill_bbduk/{sample}_spades.fasta'

    shell:
        '''mv {input.final} {output.final}
        mv {input.graph} {output.graph}
        mv {input.spades} {output.spades}
        '''

rule prokka:
    params:
        threads = 8
    input:
        rules.move_shovill_output.output.final
    output:
        '{root_dir}/{sample}/prokka/{sample}.gbk'
    shell:
        'prokka --outdir {root_dir}/{wildcards.sample}/prokka --force --cpus {params.threads} --prefix {wildcards.sample} {input}'

