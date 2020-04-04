
root_dir = '/home/ubuntu/tm_data/replimune/raw_data/2020.03.24'
todo_list = ['RH018A_NGS_Sequence_Data', 'RH018_WGSv2-8002-0052CT_page_179', 'RP1_MVSS_NGS_SequenceData-8002-0039ACp30', 'RP1_REP1116M_NGS_Reassembly', 'RP1_REP1116M_NGS_Sequence_Data-8002-0039ACpage24', 'RP1_WVSS_Qualification', 'RP2-BHK-Derived', 'RP2_MVSS-Derived', 'RP3_MVSS_BH', 'RP3_Pre-MVSS_Derived', 'RP3_Pre-MVSS_T80-8002-0056AC_page_106']
#todo_list = ['RH018A_NGS_Sequence_Data']
output_dir = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02'
ref = '/home/ubuntu/tm_data/replimune/reference_genome/2020.03.27/NC_001806.2.fasta'
contig_name = 'NC_001806.2'
threads = 8

assert os.path.exists(root_dir)
assert os.path.exists(ref)

rule all:
    input:
        expand('/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.filtered.vcf', sample = todo_list, output_dir = output_dir)
# need ot have the bam.bai as well as the final vcf?

rule minimap:
    input:
        reads = '/home/ubuntu/tm_data/replimune/raw_data/2020.03.24/{sample}/{sample}.fastq.gz'
    params: 
        reference = ref,
        threads = threads
    output:
        '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.bam'
    shell:
        'minimap2 -H -a -x map-pb -t {params.threads} {params.reference} {input.reads} | samtools sort --threads 8 > {output}' 

rule index_bam:
    input:
        bam = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.bam'
    output:
        '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.bam.bai'
    shell:
        'samtools index {input.bam}'

rule remove_non_primary_aln:
    input:
        bam = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.bam',
        index = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.bam.bai'
    params:
        threads = threads
    output:
        bam = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.primary_aln.bam'
    run:
        shell('samtools view -F 256 -b --threads {params.threads} -o {output.bam} {input.bam}')
        shell('samtools index {output.bam}')
        shell('rm {input.bam}')
        shell('rm {input.bam}.bai')

rule clairvoyante:
    input:
        bam = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.primary_aln.bam'
    params:
        threads = threads,
        reference = ref,
        contig_name = contig_name
    output:
        vcf = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.vcf'
    shell:
        'clairvoyante.py callVarBam --chkpnt_fn /home/ubuntu/tm_data/replimune/variant_calling/2020.03.31/trainedModels/fullv3-pacbio-ngmlr-hg001+hg002+hg003+hg004-hg19/learningRate1e-3.epoch100 --bam_fn {input.bam} --ref_fn {params.reference} --call_fn {output.vcf} --ctgName {params.contig_name} --dcov 10000 --threshold 0.2 --threads {params.threads}'

rule filter_vcf:
    input:
        vcf = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.vcf'
    output:
        vcf = '/home/ubuntu/tm_data/replimune/variant_calling/2020.04.02/{sample}/{sample}.filtered.vcf'
    shell:
        'bcftools filter -Ov -e \'QUAL<999 || AF<0.6\' -o {output.vcf} {input.vcf}'












