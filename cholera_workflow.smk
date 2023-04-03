import os

## from here https://github.com/jakevc/snakemake_multiqc/blob/master/Snakefile
## alternative within conda https://multiqc.info/docs/#snakemake


def read_todo_list(todo_list):
    with open(todo_list) as fi:
        lines = fi.readlines()
        lines = [x.strip() for x in lines]
    return lines

#configfile: "/home/ubuntu/scripts/snakemake/configs/salmonella.yaml"
#configfile: "/home/ubuntu/.config/snakemake/salmonella_slurm/config.yaml"

todo_list = read_todo_list(config['todo_list'])
root_dir = config['root_dir']
amrfinder_db = '/home/phil/miniconda3/envs/amrfinderplus/share/amrfinderplus/data/2022-10-11.2'
path_to_adapters_fasta = '/home/phil/salmonella/references/2022.11.29/adapters.fa'
qc_results_dir = config['qc_results_dir']

kraken_threads = 8

assert os.path.exists(root_dir)
if not os.path.exists(qc_results_dir):  
    os.makedirs(qc_results_dir)

## expand statement goes at the end (bottom) of each path in the dag
rule all:
    input:
        f'{qc_results_dir}/multiqc_report.untrimmed.html',
        f'{qc_results_dir}/multiqc_report.trimmed.html',
        #expand(['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'], sample = todo_list, root_dir = root_dir),
        expand(['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'], sample = todo_list, root_dir = root_dir),
        expand('{root_dir}/{sample}/mlst/{sample}.mlst.tsv', sample = todo_list, root_dir = root_dir),
        expand('{root_dir}/{sample}/shovill_bbduk/{sample}_contigs.assembly_stats.tsv', sample = todo_list, root_dir = root_dir),
        expand('{root_dir}/{sample}/amr_finder_plus/{sample}.amr_finder_plus.tsv', sample = todo_list, root_dir = root_dir)
        #expand('{root_dir}/{sample}/kraken2/{sample}.kraken_report.txt', sample = todo_list, root_dir = root_dir)
        #'/home/ubuntu/smk_slrm/.snakemake/conda/62c554cd/share/amrfinderplus/data/2020-03-20.1/AMR_DNA-Salmonella'


rule fastqc:
    input:
        ['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz']
    output:
        ['{root_dir}/{sample}/{sample}_1_fastqc.zip', '{root_dir}/{sample}/{sample}_2_fastqc.zip', '{root_dir}/{sample}/{sample}_1_fastqc.html', '{root_dir}/{sample}/{sample}_2_fastqc.html']
    conda:
        '../../envs/fastqc.yaml'
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
        '{qc_results_dir}/multiqc_report.untrimmed.html'
    conda:
        '../../envs/multiqc.yaml'
    shell:
        #shell('conda activate multiqc')
        'multiqc -o {qc_results_dir} --filename multiqc_report.untrimmed.html {input}'


rule bbduk:
    input:
        r1 = '{root_dir}/{sample}/{sample}_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_2.fastq.gz'

    output:
        r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', 
        r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'
    conda:
        '../../envs/bbmap.yaml'
    #run:
        # print(input.r1, input.r2)
        # print(output.r1, output.r2)
    shell:
        'bbduk.sh threads=8 ref={path_to_adapters_fasta} in={input.r1} in2={input.r2} out={output.r1} out2={output.r2} ktrim=r k=23 mink=11 hdist=1 tbo tpe qtrim=r trimq=20 minlength=50'


rule fastqc_bbduk:
    input:
        ['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz']
    output:
        ['{root_dir}/{sample}/{sample}_bbduk_1_fastqc.zip', '{root_dir}/{sample}/{sample}_bbduk_2_fastqc.zip', '{root_dir}/{sample}/{sample}_bbduk_1_fastqc.html', '{root_dir}/{sample}/{sample}_bbduk_2_fastqc.html']
    conda:
        '../../envs/fastqc.yaml'
    shell:
        'fastqc {input}'


rule move_fastqc_bbduk_output:
    input:
        rules.fastqc_bbduk.output
    output:
        ['{root_dir}/{sample}/fastqc/{sample}_bbduk_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_bbduk_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_bbduk_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_bbduk_2_fastqc.html']
    run:
        cmds = zip(input, output)
        dirname = os.path.dirname(input[0])
        if not os.path.exists(dirname):
            shell('mkdir -p {dirname}')
        for c in cmds:
            print(c[0], c[1])
            shell('mv {c[0]} {c[1]}')


rule multiqc_bbduk:
    input:
        expand(['{root_dir}/{sample}/fastqc/{sample}_bbduk_1_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_bbduk_2_fastqc.zip', '{root_dir}/{sample}/fastqc/{sample}_bbduk_1_fastqc.html', '{root_dir}/{sample}/fastqc/{sample}_bbduk_2_fastqc.html'], sample = todo_list, root_dir = root_dir)
    output:
        '{qc_results_dir}/multiqc_report.trimmed.html'
    conda:
        '../../envs/multiqc.yaml'
    shell:
        #shell('conda activate multiqc')
        'multiqc -o {qc_results_dir} --filename multiqc_report.trimmed.html {input}'


rule shovill:
    params:
        threads = 8,
        ram = 32
    input:
        r1 = rules.bbduk.output.r1,
        r2 = rules.bbduk.output.r2
    output:
        final = '{root_dir}/{sample}/shovill_bbduk/contigs.fa',
        graph = '{root_dir}/{sample}/shovill_bbduk/contigs.gfa',
        spades = '{root_dir}/{sample}/shovill_bbduk/spades.fasta'
    conda:
        '../../envs/shovill.yaml'
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

rule assembly_stats:
    input:
        assembly = rules.move_shovill_output.output.final
    output:
        stats = '{root_dir}/{sample}/shovill_bbduk/{sample}_contigs.assembly_stats.tsv',
    conda:
        '../../envs/assembly_stats.yaml'
    shell:
        'assembly-stats -t {input.assembly} > {output.stats}'


rule mlst:
    input:
        assembly = rules.move_shovill_output.output.final
    output:
        mlst_results = '{root_dir}/{sample}/mlst/{sample}.mlst.tsv'
    conda:
        '../../envs/mlst.yaml'
    shell:
        'mlst --nopath {input.assembly} > {output.mlst_results}'


rule amr_finder_plus:
    input:
        assembly = rules.move_shovill_output.output.final
    output:
        amr_finder_plus_results = '{root_dir}/{sample}/amr_finder_plus/{sample}.amr_finder_plus.tsv'
    conda:
        '../../envs/amrfinderplus.yaml'
    shell:
        'amrfinder -n {input.assembly} -O Salmonella --output {output.amr_finder_plus_results} --threads 4 --name {wildcards.sample} -d {amrfinder_db}'

