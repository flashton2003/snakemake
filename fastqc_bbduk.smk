import os

'''
Input:
    * list of sample names to run
    * root directory

Things I want to do:
    * FASTQC
    * MultiQC
    * bbduk
'''

## from here https://github.com/jakevc/snakemake_multiqc/blob/master/Snakefile
## alternative within conda https://multiqc.info/docs/#snakemake

root_dir = '/home/ubuntu/external_tb/oucru_robot'
results_dir = '/home/ubuntu/external_tb/qc/results/2019.10.25'
todo_list = ['16477-ERR3256109', '16478-ERR3256110', '16479-ERR3256111', '16480-ERR3256112', '16481-ERR3256113', '16482-ERR3256114', '16483-ERR3256115', '16484-ERR3256116', '16485-ERR3256117', '16486-ERR3256118', '16487-ERR3256120', '16488-ERR3256121', '16489-ERR3256122', '16490-ERR3256123', '16491-ERR3256124', '16492-ERR3256125', '16493-ERR3256126', '16494-ERR3256127', '16495-ERR3256128', '16496-ERR3256129', '16497-ERR3256130', '16498-ERR3256131', '16499-ERR3256132', '16500-ERR3256133', '16501-ERR3256134', '16502-ERR3256135', '16503-ERR3256136', '16504-ERR3256137', '16505-ERR3256138', '16506-ERR3256139', '16507-ERR3256140', '16508-ERR3256141', '16509-ERR3256142', '16510-ERR3256143', '16511-ERR3256144', '16512-ERR3256145', '16513-ERR3256146', '16514-ERR3256147', '16515-ERR3256148', '16516-ERR3256149', '16517-ERR3256150', '16518-ERR3256151', '16519-ERR3256152', '16520-ERR3256153', '16521-ERR3256154', '16522-ERR3256155', '16523-ERR3256156', '16524-ERR3256157', '16525-ERR3256158', '16526-ERR3256160', '16527-ERR3256161', '16528-ERR3256162', '16529-ERR3256163', '16530-ERR3256164', '16531-ERR3256165', '16532-ERR3256166', '16533-ERR3256167', '16534-ERR3256168', '16535-ERR3256169', '16536-ERR3256170', '16537-ERR3256171', '16538-ERR3256172', '16539-ERR3256173', '16540-ERR3256174', '16541-ERR3256175', '16542-ERR3256176', '16543-ERR3256177', '16544-ERR3256178', '16545-ERR3256179', '16546-ERR3256180', '16547-ERR3256181', '16548-ERR3256182', '16549-ERR3256183', '16550-ERR3256184', '16551-ERR3256185', '16552-ERR3256186', '16553-ERR3256187', '16554-ERR3256188', '16555-ERR3256189', '16556-ERR3256190', '16557-ERR3256191', '16558-ERR3256192', '16559-ERR3256193', '16560-ERR3256194', '16561-ERR3256195', '16562-ERR3256196', '16563-ERR3256197', '16564-ERR3256198', '16565-ERR3256199', '16566-ERR3256200', '16567-ERR3256201', '16568-ERR3256202', '16569-ERR3256203', '16570-ERR3256204', '16571-ERR3256205', '16572-ERR3256206', '16573-ERR3256207', '16574-ERR3256209', '16575-ERR3256210', '16576-ERR3256211', '16577-ERR3256212', '16578-ERR3256213', '16579-ERR3256214', '16580-ERR3256215', '16581-ERR3256216', '16582-ERR3256217', '16583-ERR3256218', '16584-ERR3256219', '16585-ERR3256220', '16586-ERR3256221', '16587-ERR3256222', '16588-ERR3256223', '16589-ERR3256224', '16590-ERR3256225', '16591-ERR3256226', '16592-ERR3256227', '16593-ERR3256229', '16594-ERR3256230', '16595-ERR3256231', '16596-ERR3256232', '16597-ERR3256233', '16598-ERR3256234', '16599-ERR3256235', '16600-ERR3256236', '16601-ERR3256237', '16602-ERR3256239', '16603-ERR3256240', '16604-ERR3256241', '16605-ERR3256242', '16606-ERR3256243', '16607-ERR3256244', '16608-ERR3256245', '16609-ERR3256246', '16610-ERR3256247', '16611-ERR3256249', '16612-ERR3256250', '16613-ERR3256251', '16614-ERR3256252', '16615-ERR3256253', '16616-ERR3256254', '16617-ERR3256255', '16618-ERR3256256', '16619-ERR3256257', '16620-ERR3256259', '16621-ERR3256260', '16622-ERR3256261', '16623-ERR3256262', '16624-ERR3256263', '16625-ERR3256264', '16626-ERR3256265', '16627-ERR3256266', '16628-ERR3256267', '16629-ERR3256269', '16630-ERR3256270', '16631-ERR3256271', '16632-ERR3256272', '16633-ERR3256273', '16634-ERR3256274', '16635-ERR3256275', '16636-ERR3256276', '16637-ERR3256277', '16638-ERR3256278', '16639-ERR3256279', '16640-ERR3256280', '16641-ERR3256281', '16642-ERR3256282', '16643-ERR3256283', '16644-ERR3256284', '16645-ERR3256285', '16646-ERR3256286', '16647-ERR3256287']

assert os.path.exists(root_dir)

if not os.path.exists(results_dir):  
    os.mkdir(results_dir)


## expand statement goes at the end (bottom) of each path in the dag
rule all:
    input:
        f'{results_dir}/multiqc_report.html',
        expand(['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'], sample = todo_list, root_dir = root_dir) 

rule fastqc:
    input:
        ['{root_dir}/{sample}/{sample}_1.fastq.gz', '{root_dir}/{sample}/{sample}_2.fastq.gz']
    output:
        ['{root_dir}/{sample}/{sample}_1_fastqc.zip', '{root_dir}/{sample}/{sample}_2_fastqc.zip', '{root_dir}/{sample}/{sample}_1_fastqc.html', '{root_dir}/{sample}/{sample}_2_fastqc.html']
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
        '{results_dir}/multiqc_report.html'
    shell:
        'multiqc -o {results_dir} {input}'

rule bbduk:
    input:
        r1 = '{root_dir}/{sample}/{sample}_1.fastq.gz',
        r2 = '{root_dir}/{sample}/{sample}_2.fastq.gz'

    output:
        r1 = '{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', 
        r2 = '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'

    run:
        print(input.r1, input.r2)
        print(output.r1, output.r2)
        shell('bbduk.sh ref=/home/ubuntu/external_tb/references/2019.04.22/adapters.fa in={input.r1} in2={input.r2} out={output.r1} out2={output.r2} ktrim=r k=23 mink=11 hdist=1 tbo tpe qtrim=r trimq=20 minlength=50')
