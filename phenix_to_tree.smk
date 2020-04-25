from Bio import SeqIO

'''

1. take phenix consensus fastas and assert that they are all the same length
2. take the consensus fastas and make a bed file with right masking co-ordinates
3. gather all the consensus fastas
4. run iqtree with special Leo params

'''

def read_todo_list(todo_list):
    with open(todo_list) as fi:
        lines = fi.readlines()
        lines = [x.strip() for x in lines]
    return lines

def check_fasta_lengths(root_dir, todo_list, ref_genome):
    ref_len = len(SeqIO.read(ref_genome, 'fasta').seq)
    for sample in todo_list:
        fasta_handle = f'{root_dir}/{sample}/phenix_bbduk/{sample}.fasta'
        assert len(SeqIO.read(fasta_handle, 'fasta').seq) == ref_len

def read_excluded_positions(excluded_positions_handle):
    excluded_positions = []
    with open(excluded_positions_handle) as fi:
        lines = fi.readlines()
        lines = [x.strip() for x in lines]
        for l in lines:
            split_l = l.split()
            excluded_positions.append((split_l[0], split_l[1]))
    return excluded_positions

todo_list = read_todo_list(config['todo_list'])
root_dir = config['root_dir']
output_dir = config['output_dir']
output_handle = config['output_handle']
ref_genome = config['ref_genome']
excluded_positions_handle = config['excluded_positions']

check_fasta_lengths(root_dir, todo_list, ref_genome)
excluded_positions = read_excluded_positions(excluded_positions_handle)

for sample in todo_list:
    with open(f'{root_dir}/{sample}/phenix_bbduk/{sample}.masking.bed', 'w') as fo:
        for x in excluded_positions:
            fo.write(f'{sample}\t{x[0]}\t{x[1]}\n')

#rule all:
#    input:
#        f'{output_dir}/{output_handle}.treefile'



# rule make_bedfile:
#     input:
#         todo_list = todo_list,
#         excluded_positions = excluded_positions
#     output:
#         expand('{root_dir}/{sample}/phenix_bbduk/{sample}.masking.bed', sample = todo_list, root_dir = root_dir)
#     run:
#         #print(output)
#         with open(output) as fo:
#             for x in excluded_positions:
#                 fo.write(f'{sample}\t{x[0]}\t{x[1]}\n')


rule mask_fastas:
    input:
        consensus = expand('{root_dir}/{sample}/phenix_bbduk/{sample}.fasta', sample = todo_list, root_dir = root_dir),
        bedfile = expand('{root_dir}/{sample}/phenix_bbduk/{sample}.masking.bed', sample = todo_list, root_dir = root_dir)
        #bedfile = rules.make_bedfile.output
    output:
        expand('{root_dir}/{sample}/phenix_bbduk/{sample}.masked.fasta', sample = todo_list, root_dir = root_dir)
    run:
        shell('bedtools maskfasta -fi {input.consensus} -bed {input.bedfile} -fo {output}')

ruleorder: gather_fastas > run_iqtree

rule gather_fastas:
    input:
        rules.mask_fastas.output
    output:
        '{output_dir}/{output_handle}'
    run:
        s = ' '.join(todo_list)
        shell(f'cat {s} > {output}')

#rule run_iqtree:
#    input:
#        rules.gather_fastas.output
#    output:
#        '{output_dir}/{output_handle}.treefile'
#    conda:
#        '../../envs/iqtree.yaml'
#    shell:
#        'iqtree -s {input} -nt AUTO -t PARS -ninit 2'
        



    




