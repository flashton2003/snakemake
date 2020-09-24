
root_dir = '/home/ubuntu/tm_data/replimune/raw_data/2020.03.24'
todo_list = ['RH018_WGSv2-8002-0052CT_page_179', 'RP1_MVSS_NGS_SequenceData-8002-0039ACp30', 'RP1_REP1116M_NGS_Reassembly', 'RP1_REP1116M_NGS_Sequence_Data-8002-0039ACpage24', 'RP1_WVSS_Qualification', 'RP2-BHK-Derived', 'RP2_MVSS-Derived', 'RP3_MVSS_BH', 'RP3_Pre-MVSS_Derived', 'RP3_Pre-MVSS_T80-8002-0056AC_page_106']
todo_list = ['RP2_MVSS-Derived']
output_dir = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.10'
ref = '/home/ubuntu/tm_data/replimune/reference_genome/2020.03.27/NC_001806.2.fasta'
contig_name = 'NC_001806.2'
threads = 8

assert os.path.exists(root_dir)
assert os.path.exists(ref)

rule all:
    input:
        expand('{output_dir}/{sample}/{sample}.filtered.vcf', sample = todo_list, output_dir = output_dir), expand('{output_dir}/{sample}/{sample}.mixed.vcf', sample = todo_list, output_dir = output_dir)
# need ot have the bam.bai as well as the final vcf?

rule minimap:
    input:
        reads = '%s/{sample}/{sample}.fastq.gz' % root_dir
    params: 
        reference = ref,
        threads = threads
    output:
        '{output_dir}/{sample}/{sample}.bam'
    shell:
        'minimap2 -H -a -x map-pb -t {params.threads} {params.reference} {input.reads} | samtools sort --threads 8 > {output}' 

rule index_bam:
    input:
        bam = '{output_dir}/{sample}/{sample}.bam'
    output:
        '{output_dir}/{sample}/{sample}.bam.bai'
    shell:
        'samtools index {input.bam}'

rule remove_non_primary_aln:
    input:
        bam = '{output_dir}/{sample}/{sample}.bam',
        index = '{output_dir}/{sample}/{sample}.bam.bai'
    params:
        threads = threads
    output:
        bam = '{output_dir}/{sample}/{sample}.primary_aln.bam'
    run:
        shell('samtools view -F 256 -b --threads {params.threads} -o {output.bam} {input.bam}')
        shell('samtools index {output.bam}')
        shell('rm {input.bam}')
        shell('rm {input.bam}.bai')

rule clair:
    input:
        bam = '{output_dir}/{sample}/{sample}.primary_aln.bam'
    params:
        threads = threads,
        reference = ref,
        contig_name = contig_name
    output:
        vcf = '{output_dir}/{sample}/{sample}.vcf'
    shell:
        'clair.py callVarBam --chkpnt_fn /home/ubuntu/tm_data/replimune/variant_calling/2020.04.09/model-000008 --bam_fn {input.bam} --ref_fn {params.reference} --call_fn {output.vcf} --ctgName {params.contig_name} --dcov 100000 --threshold 0.05 --threads {params.threads} --sampleName {wildcards.sample} --haploid'

rule extract_high_quality_positions:
    input:
        vcf = '{output_dir}/{sample}/{sample}.vcf'
    output:
        vcf = '{output_dir}/{sample}/{sample}.filtered.vcf'
    shell:
        'bcftools filter -Ov -e \'QUAL<100 | AF<0.6\' -o {output.vcf} {input.vcf}'

rule extract_mixed_positions:
    input:
        vcf = '{output_dir}/{sample}/{sample}.vcf'
    output:
        vcf = '{output_dir}/{sample}/{sample}.mixed.vcf'
    shell:
        'bcftools filter -Ov -e \'AF<0.1 | AF>=0.6\' {input.vcf} | bcftools filter -Ov -i \'TYPE=\"SNP\"\' -o {output.vcf}'










