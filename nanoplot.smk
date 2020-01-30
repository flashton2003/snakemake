

root_dir = '/home/ubuntu/tm_data/crypto_pacbio/working_data'
output_dir = '/home/ubuntu/tm_data/crypto_pacbio/qc/results/2019.09.18'
todo_list = ['04CN-03-050', '04CN_64_006', '04CN_64_037', '04CN_64_090', '04CN_64_101', '04CN_64_164', '04CN_65_072', 'BK08', 'BK139', 'BK143', 'BK145', 'BK150', 'BK224', 'BK226', 'BK35', 'BK42', 'BK46', 'BK80-T1', 'BK95', 'BMD1646', 'BMD494', 'BMD761', 'BMD854-T1', 'BMD973', 'LD2', 'LD2_BMD761', 'NT7533']
#todo_list = ['04CN-03-050']

rule all:
    input:
	    expand('{output_dir}/{sample}NanoPlot-report.html', output_dir = output_dir, sample = todo_list)

rule nanoplot:
	input:
		'/home/ubuntu/tm_data/crypto_pacbio/working_data/{sample}/{sample}.pacbio.fasta'
	output:
		'{output_dir}/{sample}NanoPlot-report.html'
	shell:
		'NanoPlot --fasta {input} -o {output_dir} -p {wildcards.sample}'
