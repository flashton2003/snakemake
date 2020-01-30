todo_list = ['14889-WTCHG_689876_71615137']
root_dir = '/home/ubuntu/external_tb/oucru_robot'
## something about tb_profiler and move_output rules are ambiguous, so have to specify rule order

ruleorder: tb_profiler > move_output

## first rule that runs, checks everything has finished
## somehow (?) propagates todo_list up the DAG
rule all:
    input:
        expand('{root_dir}/{sample}/mykrobe_bbduk/{sample}.mykrobe.v08.csv', root_dir = root_dir, sample = todo_list)
        #expand('{sample}.json', sample = todo_list)

## sample comes from rule all
## in shell, need to use wildcards.sample instead of sample
## wildcards is the thing in the {} in input and output (?)
rule mykrobe:
    input:
        r1 = '/home/ubuntu/external_tb/oucru_robot/{sample}/{sample}_bbduk_1.fastq.gz',
        r2 = '/home/ubuntu/external_tb/oucru_robot/{sample}/{sample}_bbduk_2.fastq.gz'
    output:
        '/home/ubuntu/external_tb/oucru_robot/{sample}/mykrobe_bbduk/{sample}.mykrobe.v08.csv'
    #group:
    #    'run_n_move'
    shell:
        'mykrobe predict {wildcards.sample} tb -1 {r1} {r2} --output {output}'


