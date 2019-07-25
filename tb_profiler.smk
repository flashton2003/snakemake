todo_list = ['14034-ERR400386', '14108-ERR400460']

ruleorder: tb_profiler > move_output

rule all:
    input:
        expand('/home/ubuntu/external_tb/oucru_robot/{sample}/tb_profiler/{sample}.json', sample = todo_list)
        #expand('{sample}.json', sample = todo_list)

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
