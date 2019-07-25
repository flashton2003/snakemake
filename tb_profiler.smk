todo_list = ['14034-ERR400386', '14108-ERR400460']

## something about tb_profiler and move_output rules are ambiguous, so have to specify rule order
ruleorder: tb_profiler > move_output

## first rule that runs, checks everything has finished
## somehow (?) propagates todo_list up the DAG
rule all:
    input:
        expand('/home/ubuntu/external_tb/oucru_robot/{sample}/tb_profiler/{sample}.json', sample = todo_list)
        #expand('{sample}.json', sample = todo_list)

## sample comes from rule all
## in shell, need to use wildcards.sample instead of sample
## wildcards is the thing in the {} in input and output (?)
rule tb_profiler:
    input:
        bam = '/home/ubuntu/external_tb/oucru_robot/{sample}/phenix_bbduk/{sample}.bam'
    output:
        '{sample}.json'
    shell:
        'tb-profiler lineage -a {input.bam} -p {wildcards.sample}'


rule move_output:
    input:
        '{sample}.json'
    output:
        '/home/ubuntu/external_tb/oucru_robot/{sample}/tb_profiler/{sample}.json'
    shell:
        'mv {wildcards.sample}.json /home/ubuntu/external_tb/oucru_robot/{wildcards.sample}/tb_profiler/{wildcards.sample}.json'
