import os

## from here https://github.com/jakevc/snakemake_multiqc/blob/master/Snakefile
## alternative within conda https://multiqc.info/docs/#snakemake

root_dir = '/home/ubuntu/hao_shigella/salmonella/oucru_robot'
results_dir = '/home/ubuntu/hao_shigella/salmonella/qc/results/2020.04.16'
todo_list = ['17736-33892_1_105', '17737-33892_1_111', '17738-33892_1_113', '17739-33892_1_119', '17740-33892_1_122', '17741-33892_1_128', '17742-33892_1_130', '17743-33892_1_136', '17744-33892_1_138', '17745-33892_1_13', '17746-33892_1_142', '17747-33892_1_148', '17748-33892_1_19', '17749-33892_1_1', '17750-33892_1_21', '17751-33892_1_27', '17752-33892_1_29', '17753-33892_1_35', '17754-33892_1_38', '17755-33892_1_42', '17756-33892_1_48', '17757-33892_1_50', '17758-33892_1_56', '17759-33892_1_58', '17760-33892_1_64', '17761-33892_1_65', '17762-33892_1_71', '17763-33892_1_73', '17764-33892_1_77', '17765-33892_1_7', '17766-33892_1_83', '17767-33892_1_85', '17768-33892_1_91', '17769-33892_1_93', '17770-33892_1_99', '17771-33892_1_9', '17772-32639_1_104', '17773-32639_1_105', '17774-32639_1_112', '17775-32639_1_113', '17776-32639_1_120', '17777-32639_1_124', '17778-32639_1_125', '17779-32639_1_132', '17780-32639_1_133', '17781-32639_1_140', '17782-32639_1_141', '17783-32639_1_148', '17784-32639_1_152', '17785-32639_1_153', '17786-32639_1_160', '17787-32639_1_161', '17788-32639_1_168', '17789-32639_1_169', '17790-32639_1_176', '17791-32639_1_177', '17792-32639_1_184', '17793-32639_1_188', '17794-32639_1_189', '17795-32639_1_196', '17796-32639_1_197', '17797-32639_1_204', '17798-32639_1_205', '17799-32639_1_212', '17800-32639_1_216', '17801-32639_1_217', '17802-32639_1_224', '17803-32639_1_225', '17804-32639_1_232', '17805-32639_1_233', '17806-32639_1_240', '17807-32639_1_241', '17808-32639_1_248', '17809-32639_1_252', '17810-32639_1_253', '17811-32639_1_260', '17812-32639_1_261', '17813-32639_1_68', '17814-32639_1_69', '17815-32639_1_76', '17816-32639_1_77', '17817-32639_1_84', '17818-32639_1_88', '17819-32639_1_89', '17820-32639_1_96', '17821-32639_1_97', '17822-32640_3_203', '17823-32640_3_207', '17824-32640_3_211', '17825-32640_3_215', '17826-32640_3_220', '17827-32640_3_221', '17828-32640_3_226', '17829-32640_3_229', '17830-32640_3_233', '17831-32640_3_237', '17832-32640_3_241', '17833-32640_3_245', '17834-32640_3_250', '17835-32640_3_255', '17836-32640_3_258', '17837-32640_3_262', '17838-32640_3_266', '17839-32640_3_270', '17840-32640_3_274', '17841-32640_3_279', '17842-32640_3_284', '17843-32640_3_287', '17844-32640_3_292', '17845-32640_3_295', '17846-32640_3_299', '17847-32640_3_301', '17848-32640_3_305', '17849-32640_3_309', '17850-32640_3_313', '17851-32640_3_318', '17852-32640_3_321', '17853-32640_3_325', '17854-32640_3_330', '17855-32640_3_334', '17856-32640_3_338', '17857-32640_3_342', '17858-32640_3_347', '17859-32708_1_102', '17860-32708_1_106', '17861-32708_1_10', '17862-32708_1_110', '17863-32708_1_115', '17864-32708_1_119', '17865-32708_1_123', '17866-32708_1_127', '17867-32708_1_131', '17868-32708_1_136', '17869-32708_1_140', '17870-32708_1_141', '17871-32708_1_145', '17872-32708_1_149', '17873-32708_1_14', '17874-32708_1_153', '17875-32708_1_157', '17876-32708_1_161', '17877-32708_1_165', '17878-32708_1_170', '17879-32708_1_174', '17880-32708_1_178', '17881-32708_1_182', '17882-32708_1_186', '17883-32708_1_18', '17884-32708_1_190', '17885-32708_1_195', '17886-32708_1_199', '17887-32708_1_203', '17888-32708_1_207', '17889-32708_1_211', '17890-32708_1_216', '17891-32708_1_220', '17892-32708_1_221', '17893-32708_1_225', '17894-32708_1_227', '17895-32708_1_229', '17896-32708_1_22', '17897-32708_1_231', '17898-32708_1_233', '17899-32708_1_235', '17900-32708_1_237', '17901-32708_1_239', '17902-32708_1_241', '17903-32708_1_243', '17904-32708_1_245', '17905-32708_1_247', '17906-32708_1_250', '17907-32708_1_252', '17908-32708_1_254', '17909-32708_1_256', '17910-32708_1_259', '17911-32708_1_262', '17912-32708_1_265', '17913-32708_1_268', '17914-32708_1_26', '17915-32708_1_271', '17916-32708_1_272', '17917-32708_1_275', '17918-32708_1_278', '17919-32708_1_281', '17920-32708_1_285', '17921-32708_1_287', '17922-32708_1_290', '17923-32708_1_293', '17924-32708_1_296', '17925-32708_1_299', '17926-32708_1_2', '17927-32708_1_302', '17928-32708_1_306', '17929-32708_1_308', '17930-32708_1_312', '17931-32708_1_315', '17932-32708_1_318', '17933-32708_1_31', '17934-32708_1_321', '17935-32708_1_324', '17936-32708_1_327', '17937-32708_1_330', '17938-32708_1_334', '17939-32708_1_335', '17940-32708_1_338', '17941-32708_1_341', '17942-32708_1_344', '17943-32708_1_347', '17944-32708_1_350', '17945-32708_1_35', '17946-32708_1_39', '17947-32708_1_43', '17948-32708_1_47', '17949-32708_1_52', '17950-32708_1_56', '17951-32708_1_57', '17952-32708_1_61', '17953-32708_1_65', '17954-32708_1_69', '17955-32708_1_6', '17956-32708_1_73', '17957-32708_1_77', '17958-32708_1_81', '17959-32708_1_86', '17960-32708_1_90', '17961-32708_1_94', '17962-32708_1_98']

assert os.path.exists(root_dir)

if not os.path.exists(results_dir):  
    os.mkdir(results_dir)


## expand statement goes at the end (bottom) of each path in the dag
rule all:
    input:
        f'{results_dir}/multiqc_report.html',
        expand(['{root_dir}/{sample}/{sample}_bbduk_1.fastq.gz', '{root_dir}/{sample}/{sample}_bbduk_2.fastq.gz'], sample = todo_list, root_dir = root_dir),
        expand('{root_dir}/{sample}/mlst/{sample}.mlst.tsv', sample = todo_list, root_dir = root_dir)

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
        '{results_dir}/multiqc_report.html'
    conda:
        '../../envs/multiqc.yaml'
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
rule mlst:
    input:
        assembly = rules.move_shovill_output.output.final
    output:
        mlst_results = '{root_dir}/{sample}/mlst/{sample}.mlst.tsv'
    conda:
        '../../envs/mlst.yaml'
    shell:
        'mlst --scheme senterica --nopath {input.assembly} > {output.mlst_results}'



