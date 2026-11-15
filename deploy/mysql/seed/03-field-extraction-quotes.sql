-- field_quotes.sql
-- 字段级原文引用，供 [[cite]] 卡片回溯；含转人工产品（仅存引用，不改 product）。
-- 依赖：V4__field_extraction_trace.sql。
SET NAMES utf8mb4;

INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A01', 'exclusions', 1, '主合同中所有有关的责任免除条款（如适用）均适用于本附加合同', 2, '主合同中所有有关的责任免除条款（如适用）均适用于本附加合同。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A01', 'exclusions', 2, '若任何被保险人因一般身体检查而入住医院，我们不承担本附加合同项下任何赔偿责任', 2, '若任何被保险人因一般身体检查而入住医院，我们不承担本附加合同项下任何赔偿责任。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 1, '任何在下列期间发生的，或由下列原因直接、间接地造成被保险人住院的，或出现下列任一情形时，', 2, '任何在下列期间发生的，或由下列原因直接、间接地造成被保险人住院的，或出现下列任一情形时，', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 2, '战争、军事行动、暴乱，罢工，武装叛乱或任何形式的恐怖活动', 2, '战争、军事行动、暴乱，罢工，武装叛乱或任何形式的恐怖活动。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 3, '任何生物、化学、原子能武器，原子能或核能装置所造成的爆炸、灼伤或辐射', 2, '任何生物、化学、原子能武器，原子能或核能装置所造成的爆炸、灼伤或辐射。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 4, '您的故意行为', 2, '您的故意行为；或无论被保险人当时神志是否清醒，被保险人自致伤害或自杀。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 5, '因被保险人故意行为（见义勇为行为除外）而导致的打斗、被袭击或被谋杀', 2, '因被保险人故意行为（见义勇为行为除外）而导致的打斗、被袭击或被谋杀。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 6, '被保险人因从事违法、犯罪的活动或因拒捕而导致的伤害', 2, '被保险人因从事违法、犯罪的活动或因拒捕而导致的伤害；以及因遭受司法当局拘禁或
被判入狱期间。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 7, '被保险人酗酒或受酒精、毒品、管制药物的影响', 2, '被保险人酗酒或受酒精、毒品、管制药物的影响。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A02', 'exclusions', 8, '被保险人酒后驾车、无照驾驶或驾驶无有效行驶证的机动交通工具', 2, '(7)   被保险人酒后驾车、无照驾驶或驾驶无有效行驶证的机动交通工具。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 1, '2任何在下列期间发生的，或由下列原因直接或间接地造成被保险人住医院，或出现下列任一情形', 2, '2 
任何在下列期间发生的，或由下列原因直接或间接地造成被保险人住医院，或出现下列任一情形', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 2, '战争、军事行动、暴乱，罢工，武装叛乱或任何形式的恐怖活动', 2, '（1） 战争、军事行动、暴乱，罢工，武装叛乱或任何形式的恐怖活动。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 3, '任何生物、化学、原子能武器，原子能或核能装置所造成的爆炸、灼伤或辐射', 2, '（2） 任何生物、化学、原子能武器，原子能或核能装置所造成的爆炸、灼伤或辐射。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 4, '被保险人因遭受司法当局拘禁或被判入狱期间', 2, '（3） 被保险人因遭受司法当局拘禁或被判入狱期间。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 5, '被保险人因酗酒或受酒精、毒品、管制药物的影响而导致的意外', 2, '（4） 被保险人因酗酒或受酒精、毒品、管制药物的影响而导致的意外。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 6, '被保险人罹患艾滋病（AIDS）或感染艾滋病病毒（HIV）期间（上述定义，应按世界', 2, '（6） 被保险人罹患艾滋病（AIDS）或感染艾滋病病毒（HIV）期间（上述定义，应按世界', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 7, '卫生组织所订的定义为准', 2, '卫生组织所订的定义为准。若在被保险人的血液样本中发现上述病毒或其抗体，则认
定病人已受该病毒感染）。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A03', 'exclusions', 8, '受保前已存在的疾病及其并发症及被保险人自其于本附加合同项下获保起九十天内罹患的疾病或出现的症状', 2, '（8） 受保前已存在的疾病及其并发症及被保险人自其于本附加合同项下获保起九十天内
罹患的疾病或出现的症状。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 1, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触之处，则应以本条款', 2, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触
之处，则应以本条款为准。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 2, '任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种', 2, '（1） 任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种；非因意外事故进行的
任何牙科检查、治疗或手术，以及任何进食', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 3, '一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 2, '（3） 一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 4, '任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术', 2, '（7） 任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 5, '任何过敏反应、药物过敏或其他医疗导致的伤害', 2, '（8） 任何过敏反应、药物过敏或其他医疗导致的伤害。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 6, '若被保险人可从其他途径取得补偿，包括但不限于社会福利机构、任何医疗保险给付，我们仅给付剩余的部分', 2, '若被保险人可从其他途径取得补偿，包括但不限于社会福利机构、任何医疗保险给付，我
们仅给付剩余的部分。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 7, '医药费用补偿金=已支出的必需且合理的实际医药费用–任何获得的医药费用补偿（包括被保险人已收到的医', 1, '医药费用补偿金 = 已支出的必需且合理的实际医药费用 – 任何获得的医药费用补偿
（包括被保险人已收到的医药费用补偿或应', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A04', 'exclusions', 8, '药费用补偿，则我们在扣除保险单所载的免赔额（如载有）后，按如下公式补偿该被保险人，但每次事故最高', 1, '药费用补偿，则我们在扣除保险单所载的免赔额（如载有）后，按如下公式补偿该被保
险人，但每次事故最高以保险单所载本附加合同', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 1, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触之处，则应以本条款', 2, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触
之处，则应以本条款为准。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 2, '任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种', 2, '（1） 任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种；非因意外事故进行的
任何牙科检查、治疗或手术，以及任何进食', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 3, '一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 2, '（3） 一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 4, '任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术', 2, '（7） 任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 5, '任何过敏反应、药物过敏或其他医疗导致的伤害', 2, '（8） 任何过敏反应、药物过敏或其他医疗导致的伤害。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 6, '在本附加合同项下，实际的医药费用以当地政府核准的收费标准为限', 2, '在本附加合同项下，实际的医药费用以当地政府核准的收费标准为限。给付范围包括医生诊', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 7, '2无论被保险人有无公费医疗、社会基本医疗保险或其他费用补偿型医疗保险，我们按上述规定补偿被保险人', 2, '2
无论被保险人有无公费医疗、社会基本医疗保险或其他费用补偿型医疗保险，我们按上述
规定补偿被保险人时，若被保险人可从其', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A05', 'exclusions', 8, '医药费用补偿金=已支出的必需且合理的实际医药费用–任何获得的医药费用补偿（包括被保险人已收到的医', 1, '医药费用补偿金 = 已支出的必需且合理的实际医药费用 – 任何获得的医药费用补偿
（包括被保险人已收到的医药费用补偿或应', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 1, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触之处，则应以本条款', 2, '主合同中责任免除条款均适用于本附加合同，若主合同中责任免除条款与本条款有相抵触
之处，则应以本条款为准。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 2, '任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种', 2, '（1） 任何原因进行的牙齿保养、牙齿修复、牙齿整形或牙齿植种；非因意外事故进行的
任何牙科检查、治疗或手术，以及任何进食', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 3, '一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 2, '（3） 一般的身体检查（不包括因意外事故进行的牙科和眼科检查）、疗养、特别护理或静', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 4, '任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术', 2, '（8） 任何妊娠、流产、分娩、不孕不育症、避孕或绝育手术。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 5, '任何过敏反应、药物过敏或其他医疗导致的伤害', 2, '（9） 任何过敏反应、药物过敏或其他医疗导致的伤害。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 6, '的费用，具体费用项目在本附加合同项下给付金额应以保险单所载本附加合同项下该费用项目相应的赔偿限额', 2, '的费用，具体费用项目在本附加合同项下给付金额应以保险单所载本附加合同项下该费用
项目相应的赔偿限额为限。但对于在中国大陆', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 7, '在本附加合同项下，实际的医药费用以当地政府核准的收费标准为限', 2, '在本附加合同项下，实际的医药费用以当地政府核准的收费标准为限。给付范围包括医生诊', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A06', 'exclusions', 8, '2无论被保险人有无公费医疗、社会基本医疗保险或其他费用补偿型医疗保险，我们按上述规定补偿被保险人', 2, '2
无论被保险人有无公费医疗、社会基本医疗保险或其他费用补偿型医疗保险，我们按上述
规定补偿被保险人时，若该被保险人可从', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 1, '除主合同条款第五章第十四条“责任免除”项下第（21）项外，主合同中责任免除条款均适', 1, '除主合同条款第五章第十四条“责任免除”项下第（21）项外，主合同中责任免除条款均适', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 2, '用于本附加合同，若主合同中责任免除条款与本条款有相抵触之处，则应以本条款为准', 1, '用于本附加合同，若主合同中责任免除条款与本条款有相抵触之处，则应以本条款为准。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 3, '任何直接或间接由于下列情形引起的，与之有关的，或可归因于之的危重型传染病，本公司', 1, '任何直接或间接由于下列情形引起的，与之有关的，或可归因于之的危重型传染病，本公司', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 4, '先天性疾病、遗传性疾病、先天性畸形、先天性变形或染色体异常', 1, '（1） 先天性疾病、遗传性疾病、先天性畸形、先天性变形或染色体异常。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 5, '罹患任何性传播疾病、艾滋病（AIDS）或感染艾滋病病毒（HIV）期间（上述定义，', 1, '（3） 罹患任何性传播疾病、艾滋病（AIDS）或感染艾滋病病毒（HIV）期间（上述定义，', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 6, '应按世界卫生组织所订的定义为准', 1, '应按世界卫生组织所订的定义为准。若在被保险人的血液样本中发现上述病毒或其抗体，则', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 7, '任何在中国大陆以外国家或地区发病或确诊的传染病', 1, '（5） 任何在中国大陆以外国家或地区发病或确诊的传染病。', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A07', 'exclusions', 8, '任何在本附加合同生效前或等待期内发病的传染病或者疑似感染或经任何医疗机构诊断感染的细菌或病毒，以', 1, '（6） 任何在本附加合同生效前或等待期内发病的传染病或者疑似感染或经任何医疗机构
诊断感染的细菌或病毒，以及任何在等待期', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'guaranteed_renewal', 1, 0, 3, '本保险为非保证续保产品，本合同保险期间届满前，投保人可向我们申请续保本合同。在
投保人接受续保费率调整并缴纳续保保险费的', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 1, '非被保险人本人就医时发生的牙科治疗医药费用', 4, '（1） 非被保险人本人就医时发生的牙科治疗医药费用；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 2, '被保险人因未遵照医嘱而发生的牙科治疗医药费用', 4, '（2） 被保险人因未遵照医嘱而发生的牙科治疗医药费用；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 3, '参与任何职业或半职业的体育运动、驾驶或搭乘非商业航班运输工具、潜水（仅限深度大于30米）、跳伞、', 4, '（5） 参与任何职业或半职业的体育运动、驾驶或搭乘非商业航班运输工具、潜水
（仅限深度大于30 米）、跳伞、攀岩运动、蹦', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 4, '因在任何国家或国际组织的警察或军队服务期间，或参加战争、内战、入侵、暴动、革命、使用武装力量、篡', 4, '（6） 因在任何国家或国际组织的警察或军队服务期间，或参加战争、内战、入侵、
暴动、革命、使用武装力量、篡夺政权或军权、', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 5, '在监狱、拘留所、任何其它的教养所（包括重返社会过渡教习所或类似的设施）或任何精神病人收容管制院期', 4, '（7） 在监狱、拘留所、任何其它的教养所（包括重返社会过渡教习所或类似的设
施）或任何精神病人收容管制院期间；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 6, '接触任何种类的电离辐射或放射性污染物', 4, '（8） 接触任何种类的电离辐射或放射性污染物；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 7, '对一般牙科治疗、牙齿美容或相关治疗中发生的意外及并发症的治疗', 4, '（15） 对一般牙科治疗、牙齿美容或相关治疗中发生的意外及并发症的治疗；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('A12', 'exclusions', 8, '牙科治疗未发生于意外事故发生之日起三十天内的情形', 4, '（16） 牙科治疗未发生于意外事故发生之日起三十天内的情形；', 'pymupdf_fallback', 0.35)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'entry_age', 1, 'min=0,max=72', 2, '范围为 0 周岁至 72 周岁（含），投保时被保险人为0 周岁的，应为出生满28
            天且已健康出院', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'payment_term', 1, '趸交', 9, '4.1 保险费的支付 本合同的保险费采用趸交（即一次性交付）或限期年交(即在约定的交费期间', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'coverage_term', 1, '终身', 2, '本合同的保险期间为终身，保险期间在保险单上载明。', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'waiting_days', 1, 180, 3, '自本合同生效或最后一次复效（以较迟者为准）之日起的 180 日内（含第 180日）为等待期。被保险人在等待期内因意外伤害', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 5, '## (1)投保人对被保险人的故意杀害、故意伤害；(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 5, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'exclusions', 3, '被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起2年内自', 5, '(3)被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起 2 年内自', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H01', 'exclusions', 4, '被保险人酒后驾驶、无合法有效驾驶证驾驶，或驾驶无合法有效行驶证', 5, '(5)被保险人酒后驾驶<sup>25</sup>、无合法有效驾驶证驾驶<sup>26</sup>，或驾驶无合法有效行驶证', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'entry_age', 1, 'min=0,max=72', 2, '范围为 0 周岁至 72 周岁（含），投保时被保险人为0 周岁的，应为出生满28
            天且已健康出院', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'payment_term', 1, '趸交', 9, '4.1 保险费的支付 本合同的保险费采用趸交（即一次性交付）或限期年交(即在约定的交费期间', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'coverage_term', 1, '终身', 2, '本合同的保险期间为终身，保险期间在保险单上载明。', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'waiting_days', 1, 180, 3, '自本合同生效或最后一次复效（以较迟者为准）之日起的 180 日内（含第 180日）为等待期。被保险人在等待期内因意外伤害', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 5, '## (1)投保人对被保险人的故意杀害、故意伤害；(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 5, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 3, '被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起2年内自', 5, '(3)被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起 2 年内自', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 4, '被保险人酒后驾驶、无合法有效驾驶证驾驶，或驾驶无合法有效行驶证27的机动车', 5, '(5)被保险人酒后驾驶<sup>25</sup>、无合法有效驾驶证驾驶<sup>26</sup>，或驾驶无合法有效行驶证', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 5, '战争、军事冲突、暴乱或武装叛乱', 6, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核爆炸、核辐射或核污染；(8)除特定疾病以外的遗传性疾病<sup>29</s', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H02', 'exclusions', 6, '除特定疾病以外的遗传性疾病，先天性畸形、变形或染色体异常', 6, '(8)除特定疾病以外的遗传性疾病<sup>29</sup>，先天性畸形、变形或染色体异常<sup>30</sup>；发生', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'entry_age', 1, 'min=0,max=65', 2, '范围为 0 周岁至 65 周岁（含），投保时被保险人为0 周岁的，应为出生满28
            天且已健康出院', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'payment_term', 1, '趸交', 6, '保险费的支付 本合同的保险费采用趸交（即一次性交付）或限期年交(即在约定的交费期间内每年支付一次保险费)的方式支付。限期', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'coverage_term', 1, '终身', 2, '本合同的保险期间为终身，保险期间在保险单上载明。', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'waiting_days', 1, 180, 3, '自本合同生效或最后一次复效（以较迟者为准）之日起的 180 日内（含第 180日）为等待期。被保险人在等待期内因意外伤害', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 1, '被保险人身故时本合同累计已交保险费', 4, '(1)被保险人身故时本合同累计已交保险费；(2)被保险人身故时本合同的现金价值。', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 2, '投保人对被保险人的故意杀害、故意伤害', 4, '们不承担保险责任:(1)投保人对被保险人的故意杀害、故意伤害；(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 3, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 4, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起 2', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 4, '被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起2年内自杀，但被保险人自杀时为无民事行为', 4, '(3)被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起 2 年内自杀，但被保险人自杀时为无民事行为能力人的除外；', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 5, '被保险人服用、吸食或注射毒品', 4, '(4)被保险人服用、吸食或注射毒品<sup>9</sup>；(5)被保险人酒后驾驶<sup>10</sup>、无合法有效', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 6, '被保险人酒后驾驶、无合法有效驾驶证驾驶，或驾驶无合法有效行驶证的机动车', 4, '(5)被保险人酒后驾驶<sup>10</sup>、无合法有效驾驶证驾驶<sup>11</sup>，或驾驶无合法有效行驶证', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 7, '战争、军事冲突、暴乱或武装叛乱', 4, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核爆炸、核辐射或核污染；(8)除特定疾病以外的遗传性疾病<sup>14</s', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H03', 'exclusions', 8, '除特定疾病以外的遗传性疾病，先天性畸形、变形或染色体异常', 4, '(8)除特定疾病以外的遗传性疾病<sup>14</sup>，先天性畸形、变形或染色体异常<sup>15</sup>；发生', 'mineru', 0.9)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'entry_age', 1, 'min=0,max=65', 2, '本合同接受的首次投保年龄范围为 0 周岁至 65 周岁（含），投保时被保险人为 0 周岁的，应为出生满 30 天且已健康', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'payment_term', 1, '趸交/分期', 16, '如您选择一次性支付保险费，在每一保险期间内，您应一次性支付该保险期间对应的全部保险费。如您选择分期支付保险费，在每一保险', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，保险期间在保险单上载明。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'waiting_days', 1, 90, 4, '除另有约定外，自本合同生效之日起 90 日内（含第 90 日）为等待期。被保险人在等待期内确诊疾病，无论对该疾病的治疗发', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'guaranteed_renewal', 1, 1, 2, '本产品为费率可调的长期医疗保险产品，在保证续保期间内费率可能调整。“太保互联网银保版长期医疗保险（费率可调）”简称“银保', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 11, '(1)投保人对被保险人的故意杀害、故意伤害；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 2, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 11, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 3, '被保险人故意自伤、自杀，但被保险人自杀时为无民事行为能力人的除外', 11, '(3)被保险人故意自伤、自杀，但被保险人自杀时为无民事行为能力人的除外；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 11, '(4)被保险人醉酒<sup>30</sup>，斗殴<sup>31</sup>，服用、吸食或注射毒品<sup>32</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证', 11, '(5)被保险人酒后驾驶<sup>33</sup>，无合法有效驾驶证驾驶<sup>34</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 6, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高', 11, '(6)被保险人参加潜水<sup>37</sup>、跳伞、攀岩<sup>38</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 7, '战争、军事冲突、暴乱或武装叛乱', 11, '(7)战争、军事冲突、暴乱或武装叛乱；(8)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(9)在本合同生效前被保', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H04', 'exclusions', 8, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 11, '(8)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(9)在本合同生效前被保险人已患有的且已知晓的有关疾病或症状；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'entry_age', 1, 'min=None,max=65', 2, '指您投保时被保险人的年龄，本合同接受的投保年龄范围为出生满28 天至
65 周岁', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'coverage_term', 1, '10年', 2, '本合同的保险期间为10 年，由您在投保时与我们约定。保险期间在保险单上
载明。', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'waiting_days', 1, 90, 2, '除另有约定外，自本合同生效或最后一次复效（以较迟者为准）之日起的90 日
（含第90 日）内为等待期。被保险人在等待期内', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 4, '（1）投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 4, '（2）被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 3, '被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起2年内自杀，但被保险人自杀时为无民事行为', 4, '（3）被保险人故意自伤、或自本合同成立或者本合同效力恢复之日起2 年内
自杀，但被保险人自杀时为无民事行为能力人的除外；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 4, '被保险人服用、吸食或注射毒品10', 4, '（4）被保险人服用、吸食或注射毒品
10；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 5, '被保险人酒后驾驶11、无合法有效驾驶证驾驶', 4, '（5）被保险人酒后驾驶
11、无合法有效驾驶证驾驶', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 6, '被保险人感染艾滋病病毒或患艾滋病15，但若属于本保险条款9.1.35项', 4, '（6）被保险人感染艾滋病病毒或患艾滋病
15，但若属于本保险条款9.1.35 项', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 7, '10毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及', 4, '10毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及国家规定管制的', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H05', 'exclusions', 8, '管理部门依据《中华人民共和国道路交通安全法》的规定认定为饮酒后驾驶或醉酒后驾驶', 4, '管理部门依据《中华人民共和国道路交通安全法》的规定认定为饮酒后驾驶或醉酒后驾驶。', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'entry_age', 1, 'min=None,max=55', 2, '至55 周岁，且须符合我们当时的投保规定。', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'coverage_term', 1, '5年', 4, '①若本附加险合同的保险期间为5 年，则本附加险合同的最高给付期限为
60 个月；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'waiting_days', 1, 90, 3, '起90 日内（含第90 日）为等待期。被保险人在等待期内因意外伤害
3以外的
原因确诊本附加险合同约定的特定疾病，我们不', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 4, '(1)投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 2, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 4, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 3, '被保险人故意自伤、或自本附加险合同成立或者本附加险合同效力恢复之日起2年内自杀，但被保险人自杀时', 4, '(3)被保险人故意自伤、或自本附加险合同成立或者本附加险合同效力恢复之
日起2 年内自杀，但被保险人自杀时为无民事行为能', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 4, '8有资质的鉴定机构：指经中华人民共和国司法行政机关审核登记，依法取得《司法鉴定许可证》，且鉴定业', 4, '8 有资质的鉴定机构：指经中华人民共和国司法行政机关审核登记，依法取得《司法鉴定许可证》，且鉴定业务范围包含法', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 5, '被保险人醉酒9，斗殴10，服用、吸食或注射毒品11', 5, '(4)被保险人醉酒
9，斗殴
10，服用、吸食或注射毒品
11；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 6, '被保险人酒后驾驶12，无合法有效驾驶证驾驶13，或驾驶无合法有效行驶证14的机动车15', 5, '(5)被保险人酒后驾驶
12，无合法有效驾驶证驾驶
13，或驾驶无合法有效行驶证 
14的机动车
15；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 7, '被保险人参加潜水16、跳伞、攀岩', 5, '(6)被保险人参加潜水
16、跳伞、攀岩', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H06', 'exclusions', 8, '战争、军事冲突、暴乱或武装叛乱、恐怖主义', 5, '(7)战争、军事冲突、暴乱或武装叛乱、恐怖主义；', 'pymupdf_fallback', 0.78)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'entry_age', 1, 'min=0,max=70', 2, '3年龄范围为0 周岁至70 周岁（含），投保
时被保险人为0 周岁的，应为出生满30 天且已健康出院的婴儿。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'payment_term', 1, '趸交', 10, '如您选择一次性支付保险费，您应于投保时一次性支付全部保险费。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'coverage_term', 1, '1年', 3, '本附加险合同的保险期间为1 年，不保证续保。保险期间在保险单上载明。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'waiting_days', 1, 90, 3, '除另有约定外，自本附加险合同生效之日起90 日内（含第90 日）为等待
期。若被保险人在等待期内确诊疾病，无论对该疾病的', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'guaranteed_renewal', 1, 0, 3, '不保证续保 
本附加险合同的保险期间为1 年，不保证续保。保险期间在保险单上载明。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'reimbursement', 1, '一般情况下，赔付比例为100%，但若被保险人在投保时选择以有公费医疗或基本医', 5, '一般情况下，赔付比例为100%，但若被保险人在投保时选择以有公费医疗
或基本医疗保险身份投保，但被保险人在购买已纳入《国', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 5, '(1)投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 2, '16其他第三方：指除公费医疗、基本医疗保险和城乡居民大病保险以外的，被保险人的工作单位、本公司在', 5, '16其他第三方：指除公费医疗、基本医疗保险和城乡居民大病保险以外的，被保险人的工作单位、本公司在内的商业保险机', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 3, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 6, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 4, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 6, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除
外；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 5, '被保险人醉酒17，斗殴18，服用、吸食或注射毒品19', 6, '(4)被保险人醉酒
17，斗殴
18，服用、吸食或注射毒品
19；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 6, '被保险人酒后驾驶20，无合法有效驾驶证驾驶21，或驾驶无合法有效行驶证22的机动车23', 6, '(5)被保险人酒后驾驶
20，无合法有效驾驶证驾驶
21，或驾驶无合法有效行驶
证
22的机动车
23；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 7, '战争、军事冲突、暴乱或武装叛乱', 6, '(6)战争、军事冲突、暴乱或武装叛乱；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H07', 'exclusions', 8, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 6, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'entry_age', 1, 'min=0,max=70', 2, '本合同接受的首次投保年龄范围为0 周岁至70 周岁（含），投保时被保险人
为0 周岁的，应为出生满30 天且已健康出院的', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'payment_term', 1, '趸交', 19, '如您选择一次性支付保险费，在每一保险期间内，您应一次性支付该保险期间
对应的全部保险费。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'coverage_term', 1, '1年', 3, '本合同的保险期间为1 年，保险期间在保险单上载明。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'waiting_days', 1, 90, 4, '除另有约定外，自本合同生效之日起90 日内（含第90 日）为等待期。被保险
人在等待期内确诊疾病，无论对该疾病的治疗发生', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'guaranteed_renewal', 1, 1, 2, '本产品为费率可调的长期医疗保险产品，在保证续保期间内费率可能调整。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'reimbursement', 1, '总和之后的余额在本合同保险期间内累计不超过1万元的部分，赔付比例A根据您投保时所选择的计划确定，有30%、50%、80%', 12, '的余额在本合同保险期间内累
计不超过1 万元的部分，赔付比例A 根据您投保时所选择的计划确定，有30%、
50%、80%', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 12, '(1)投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 2, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 12, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 12, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 4, '被保险人醉酒35，斗殴36，服用、吸食或注射毒品37', 12, '(4)被保险人醉酒
35，斗殴
36，服用、吸食或注射毒品
37；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 5, '35醉酒：指因饮酒而表现出动作不协调、意识紊乱、舌重口吃或其他不能清醒地控制自己行为的状态', 12, '35醉酒：指因饮酒而表现出动作不协调、意识紊乱、舌重口吃或其他不能清醒地控制自己行为的状态。醉酒的认定，如有司', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 6, '36斗殴：指双方或多方通过拳脚、器械等武力以求制胜的行为', 12, '36斗殴：指双方或多方通过拳脚、器械等武力以求制胜的行为。斗殴的认定，如有司法机关、公安部门的有关法律文件，则', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 7, '37毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及', 12, '37毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及国家规定管制的', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H08', 'exclusions', 8, '被保险人酒后驾驶38，无合法有效驾驶证驾驶39，或驾驶无合法有效行驶证40的机动车41', 13, '(5)被保险人酒后驾驶
38，无合法有效驾驶证驾驶
39，或驾驶无合法有效行驶证
40的机动车
41；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'entry_age', 1, 'min=0,max=70', 2, '3年龄范围为0 周岁至70 周岁（含）。投保时被保险人
为0 周岁的，应为出生满30 天且已健康出院的婴儿。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'payment_term', 1, '趸交', 14, '如您选择一次性支付保险费，在每一保险期间内，您应一次性支付该保险期间
对应的全部保险费。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'coverage_term', 1, '1年', 3, '本合同的保险期间为1 年，保险期间在保险单上载明。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'waiting_days', 1, 90, 4, '除另有约定外，自本合同生效之日起90 日内（含第90 日）为等待期。若被保
险人在等待期内确诊疾病，无论对该疾病的治疗发', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'guaranteed_renewal', 1, 1, 3, '5）以及各项保险责任的赔付限额、保
证续保期间内赔付限额、赔付比例等内容，详见保险计划表（见附表1，下同）。', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'reimbursement', 1, '总和之后的余额在本合同保险期间内累计不超过1万元的部分，赔付比例A为25%，2)对于被保险人发生的符合保险责任范围内的医', 9, '余额在本合同保
险期间内累计不超过1 万元的部分，赔付比例A 为25%， 
2)对于被保险人发生的符合保险责任范围内的医', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 9, '(1)投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 9, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 9, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 4, '被保险人醉酒31，斗殴32，服用、吸食或注射毒品33', 9, '(4)被保险人醉酒
31，斗殴
32，服用、吸食或注射毒品
33；', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 5, '被保险人酒后驾驶34，无合法有效驾驶证驾驶35，或驾驶无合法有效行驶证', 9, '(5)被保险人酒后驾驶
34，无合法有效驾驶证驾驶
35，或驾驶无合法有效行驶证', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 6, '31醉酒：指因饮酒而表现出动作不协调、意识紊乱、舌重口吃或其他不能清醒地控制自己行为的状态', 9, '31醉酒：指因饮酒而表现出动作不协调、意识紊乱、舌重口吃或其他不能清醒地控制自己行为的状态。醉酒的认定，如有司', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 7, '32斗殴：指双方或多方通过拳脚、器械等武力以求制胜的行为', 9, '32斗殴：指双方或多方通过拳脚、器械等武力以求制胜的行为。斗殴的认定，如有司法机关、公安部门的有关法律文件，则', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H09', 'exclusions', 8, '33毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及', 9, '33毒品：指《中华人民共和国刑法》规定的鸦片、海洛因、甲基苯丙胺（冰毒）、吗啡、大麻、可卡因以及国家规定管制的', 'pymupdf_fallback', 0.87)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 6, '(1)投保人对被保险人的故意杀害、故意伤害；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 2, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 6, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 3, '被保险人自杀，但被保险人自杀时为无民事行为能力人的除外', 6, '(3)被保险人自杀，但被保险人自杀时为无民事行为能力人的除外；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 6, '(4)被保险人醉酒，斗殴，服用、吸食或注射毒品；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或者驾驶无合法有效行驶证的机动车', 6, '(6)被保险人酒后驾驶，无合法有效驾驶证驾驶，或者驾驶无合法有效行驶
证的机动车；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 6, '被保险人违反承运人关于安全乘坐的规定', 6, '(7)被保险人违反承运人关于安全乘坐的规定；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 7, '被保险人驾驶超载机动车，因车辆超载引起的意外事故而遭受的伤害', 6, '(9)被保险人驾驶超载机动车，因车辆超载引起的意外事故而遭受的伤害；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('H10', 'exclusions', 8, '被保险人处于车辆、轮船、飞机中专门用于放置物品的部分所遭受的伤害', 6, '(10)被保险人处于车辆、轮船、飞机中专门用于放置物品的部分所遭受的伤
害；', 'pymupdf_fallback', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('I01', 'exclusions', 1, '事故发生后，被保险人或驾驶人故意破坏、伪造现场，毁灭证据', 1, '（一）事故发生后，被保险人或驾驶人故意破坏、伪造现场，毁灭证据；', 'docx_nopagination', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('I01', 'exclusions', 2, '饮酒、吸食或注射毒品、服用国家管制的精神药品或者麻醉药品', 1, '2、饮酒、吸食或注射毒品、服用国家管制的精神药品或者麻醉药品；', 'docx_nopagination', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('I01', 'exclusions', 3, '被保险人或驾驶人故意或重大过失，导致被保险新能源汽车被利用从事犯罪行为', 1, '4、被保险人或驾驶人故意或重大过失，导致被保险新能源汽车被利用从事犯罪行为。', 'docx_nopagination', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('I02', 'exclusions', 1, '被保险人的损失在相同保障的其他保险项下可获得赔偿的部分', 1, '（一）被保险人的损失在相同保障的其他保险项下可获得赔偿的部分；', 'docx_nopagination', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('I02', 'exclusions', 2, '保险金额由投保人和保险人在投保时协商确定，并在保险单中载明', 1, '保险金额由投保人和保险人在投保时协商确定，并在保险单中载明。', 'docx_nopagination', 0.3)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'entry_age', 1, 'min=0,max=17', 2, '本合同接受的首次投保<sup>3</sup>年龄范围为 0 周岁至 17 周岁（含），投保时被保险人为 0 周岁的，应为', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'payment_term', 1, '趸交/分期', 8, '本合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本合同约定向我们支付保险费。如您选择一次性支', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'waiting_days', 1, 30, 3, '除另有约定外，自本合同生效之日起 30 日内（含第 30 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病的治疗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'guaranteed_renewal', 1, 0, 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'deductible', 1, '次免赔额为500元', 4, '（1）对于符合门急诊保险金约定条件的医疗费用，每次就诊的次免赔额为 500元；（2）对于第 1-3 次符合门急诊保险金约', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'reimbursement', 1, '居民大病保险取得医疗费用补偿的，则赔付比例B为60%', 5, '居民大病保险取得医疗费用补偿的，则赔付比例 B 为 60%。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 5, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 5, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 5, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>17</sup>，斗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 5, '(4)被保险人醉酒<sup>17</sup>，斗殴<sup>18</sup>，服用、吸食或注射毒品<sup>19</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证22的机动车', 5, '(5)被保险人酒后驾驶<sup>20</sup>，无合法有效驾驶证驾驶<sup>21</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 6, '战争、军事冲突、暴乱或武装叛乱', 5, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 7, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 5, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<sup>24</sup>、跳伞、攀岩<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T01', 'exclusions', 8, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高', 5, '(8)被保险人参加潜水<sup>24</sup>、跳伞、攀岩<sup>25</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'entry_age', 1, 'min=0,max=17', 2, '本合同接受的首次投保3年龄范围为 0 周岁至 17 周岁（含），投保时被保险人
            为 0 周岁的，', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'payment_term', 1, '趸交/分期', 13, '本合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本合同约定向我们支付保险费。如您选择一次性支', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，保险期间在保险单上载明。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'waiting_days', 1, 90, 4, '除另有约定外，自本合同生效之日起 90 日内（含第 90 日）为等待期。被保险人在等待期内确诊疾病，无论对该疾病的治疗发', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'guaranteed_renewal', 1, 1, 2, '本产品为费率可调的长期医疗保险产品，在保证续保期间内费率可能调整。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'reimbursement', 1, '疗、基本医疗保险或城乡居民大病保险取得医疗费用补偿的，则赔付比例为60%', 18, '和生育保险药品目录》的特定药品时未从公费医疗、基本医疗保险或城乡居民
大病保险取得医疗费用补偿的，则赔付比例为 60%。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 8, '(1)投保人对被保险人的故意杀害、故意伤害；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 2, '被保险人故意犯罪或抗拒依法采取的刑事强制措施', 8, '(2)被保险人故意犯罪或抗拒依法采取的刑事强制措施；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 8, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 8, '(4)被保险人醉酒<sup>30</sup>，斗殴<sup>31</sup>，服用、吸食或注射毒品<sup>32</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证', 8, '(5)被保险人酒后驾驶<sup>33</sup>，无合法有效驾驶证驾驶<sup>34</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 6, '战争、军事冲突、暴乱或武装叛乱', 8, '(6)战争、军事冲突、暴乱或武装叛乱；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 7, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 8, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T02', 'exclusions', 8, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、', 8, '(8)被保险人参加潜水<sup>37</sup>、跳伞、攀岩<sup>38</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'entry_age', 1, 'min=0,max=60', 2, '本合同接受的首次投保<sup>3</sup>年龄范围为 0 周岁至 60 周岁（含），投保时被保险人为 0 周岁的，应为', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'payment_term', 1, '趸交/分期', 18, '本合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本合同约定向我们支付保险费。如您选择一次性支', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'waiting_days', 1, 30, 3, '除另有约定外，自本合同生效之日起 30 日内（含第 30 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病的治疗', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'guaranteed_renewal', 1, 0, 3, '本合同的保险期间由您在投保时与我们约定，最长不超过 1 年，不保证续保。', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'deductible', 1, '年免赔额1万元', 3, '险期间内，一般医疗保险金年免赔额 1 万元，恶性肿瘤及原位癌医疗保险金、恶性肿瘤——重度质子重离子医疗保险金、特定药品费', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'reimbursement', 1, '对特定疾病的赔付比例A为25%，其他情况赔付比例A为50%', 42, '对特定疾病的赔付比例 A 为 25%，其他情况赔付比例 A 为 50%。', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 13, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 13, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 13, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>38</sup>，斗', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 13, '(4)被保险人醉酒<sup>38</sup>，斗殴<sup>39</sup>，服用、吸食或注射毒品<sup>40</su', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证43的机动车', 13, '(5)被保险人酒后驾驶<sup>41</sup>，无合法有效驾驶证驾驶<sup>42</sup>，或驾驶无合法有效行驶证', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 6, '战争、军事冲突、暴乱或武装叛乱', 13, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 7, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 13, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<sup>45</sup>、跳伞、攀岩<', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T03', 'exclusions', 8, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高', 13, '(8)被保险人参加潜水<sup>45</sup>、跳伞、攀岩<sup>46</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.86)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'entry_age', 1, 'min=16,max=65', 2, '本合同接受的首次投保<sup>3</sup>年龄范围为 16 周岁至 65 周岁（含）。被保险人年满 105 周岁前（含', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'payment_term', 1, '趸交/分期', 18, '如您选择一次性支付保险费，您应于投保时一次性支付全部保险费。如您选择分期支付保险费，您在支付首期保险费后，应当按照约定，', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'waiting_days', 1, 30, 3, '除另有约定外，自本合同生效之日起 30 日内（含第 30 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病的治疗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'guaranteed_renewal', 1, 0, 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'reimbursement', 1, '总和之后的余额在本合同保险期间内累计不超过2万元的部分，赔付比例A为30%，2)对于被保险人发生的符合保险责任范围内的医', 42, '总和之后的余额在本合同保险期间内累计不超过2万元的部分，赔付比例A为30%，2)对于被保险人发生的符合保险责任范围内的医', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 12, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 12, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 12, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>47</sup>，斗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 12, '(4)被保险人醉酒<sup>47</sup>，斗殴<sup>48</sup>，服用、吸食或注射毒品<sup>49</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T04', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证52的机动车', 12, '(5)被保险人酒后驾驶<sup>50</sup>，无合法有效驾驶证驾驶<sup>51</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'entry_age', 1, 'min=18,max=70', 2, '本合同接受的首次投保<sup>4</sup>年龄范围为 18 周岁至 70 周岁（含）。', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，保险期间在保险单上载明。', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'guaranteed_renewal', 1, 1, 3, '保证续保', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'exclusions', 1, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证16的机动车', 5, '(5)被保险人酒后驾驶<sup>14</sup>，无合法有效驾驶证驾驶<sup>15</sup>，或驾驶无合法有效行驶证', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'exclusions', 2, '被保险人感染艾滋病病毒或患艾滋病', 5, '(6)被保险人感染艾滋病病毒或患艾滋病<sup>18</sup>；(7)战争、军事冲突、暴乱或武装叛乱；(8)核爆炸、核', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'exclusions', 3, '战争、军事冲突、暴乱或武装叛乱', 5, '(7)战争、军事冲突、暴乱或武装叛乱；(8)核爆炸、核辐射或核污染；(9)遗传性疾病<sup>19</sup>、先天性畸', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T05', 'exclusions', 4, '遗传性疾病、先天性畸形、变形或染色体异常;', 5, '(9)遗传性疾病<sup>19</sup>、先天性畸形、变形或染色体异常<sup>20</sup>; (10)乳腺癌以外', 'mineru', 0.77)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'entry_age', 1, 'min=0,max=65', 2, '本附加险合同接受的首次投保<sup>3</sup>年龄范围为 0 周岁至 65 周岁（含），投保时被保险人为 0 周岁的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'payment_term', 1, '趸交/分期', 8, '本附加险合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本附加险合同约定向我们支付保险费。如您', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'coverage_term', 1, '1年', 3, '本附加险合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'waiting_days', 1, 30, 3, '除另有约定外，自本附加合同生效之日起 30 日内（含第 30 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'guaranteed_renewal', 1, 0, 3, '本附加险合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'reimbursement', 1, '赔付比例A为30%', 4, '赔付比例 A 为 30%。一般情况下，赔付比例 B 为 100%，但若被保险人在投保时选择以有公费医疗或基本医疗保险身份', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 5, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 5, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 5, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>19</sup>，斗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 5, '(4)被保险人醉酒<sup>19</sup>，斗殴<sup>20</sup>，服用、吸食或注射毒品<sup>21</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证24的机动车', 5, '(5)被保险人酒后驾驶<sup>22</sup>，无合法有效驾驶证驾驶<sup>23</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 6, '战争、军事冲突、暴乱或武装叛乱', 5, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 7, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 5, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<sup>26</sup>、跳伞、攀岩<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T06', 'exclusions', 8, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高', 5, '(8)被保险人参加潜水<sup>26</sup>、跳伞、攀岩<sup>27</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'entry_age', 1, 'min=None,max=65', 2, '指您投保时被保险人的年龄，本附加险合同接受的投保年龄范围为出生满30 天至 65 周岁<sup>1</sup>（含），且', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'payment_term', 1, '趸交/分期', 9, '本附加险合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本附加险合同约定向我们支付保险费。如您', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'coverage_term', 1, '1年', 3, '本附加险合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'waiting_days', 1, 90, 3, '除另有约定外，自本附加险合同生效之日起 90 日内（含第 90 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'guaranteed_renewal', 1, 0, 3, '本附加险合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'reimbursement', 1, '品及外购医疗器械费用医疗保险金保险期间内赔付限额100万赔付比例100%100%100%100%', 13, '<td>赔付比例</td><td>100%</td><td>100%</td><td>100%</td><td>100%', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T07', 'exclusions', 1, '或以舒适性、便利性为主要用途的设备的购买、租赁和置换费用', 5, '或以舒适性、便利性为主要用途的设备的购买、租赁和置换费用；(7)外购药品不包括根据中医药方组合一种或多种中医药材进行内服', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'entry_age', 1, 'min=18,max=80', 2, '本合同接受的首次投保<sup>3</sup>年龄范围为 18 周岁至 80 周岁（含）。被保险人年满 100 周岁前（含', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'payment_term', 1, '趸交/分期', 15, '本合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本合同约定向我们支付保险费。如您选择一次性支', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'waiting_days', 1, 30, 3, '除另有约定外，自本合同生效之日起 30 日内（含第 30 日）为等待期。若被保险人在等待期内确诊疾病，无论对该疾病的治疗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'guaranteed_renewal', 1, 0, 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'reimbursement', 1, '医疗、基本医疗保险或城乡居民大病保险取得医疗费用补偿，则赔付比例B为60%', 10, '和生育保险药品目录》的特定药品时未从公费医疗、基本医疗保险或城乡居民大病保险取得医疗费用补偿，则赔付比例 B 为 60%', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 10, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 10, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 10, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>33</sup>，斗', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 10, '(4)被保险人醉酒<sup>33</sup>，斗殴<sup>34</sup>，服用、吸食或注射毒品<sup>35</su', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证38的机动车', 10, '(5)被保险人酒后驾驶<sup>36</sup>，无合法有效驾驶证驾驶<sup>37</sup>，或驾驶无合法有效行驶证', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 6, '战争、军事冲突、暴乱或武装叛乱', 10, '(6)战争、军事冲突、暴乱或武装叛乱；(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 7, '核武器、核爆炸、核辐射、核污染或化学武器、生物武器', 10, '(7)核武器、核爆炸、核辐射、核污染或化学武器、生物武器；(8)被保险人参加潜水<sup>40</sup>、跳伞、攀岩<', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T08', 'exclusions', 8, '被保险人参加潜水、跳伞、攀岩、驾驶滑翔机或滑翔伞、探险、摔跤、武术比赛、特技表演、赛马、赛车等高', 10, '(8)被保险人参加潜水<sup>40</sup>、跳伞、攀岩<sup>41</sup>、驾驶滑翔机或滑翔伞、探险<sup', 'mineru', 0.92)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'entry_age', 1, 'min=0,max=60', 3, '本合同接受的首次投保<sup>3</sup>年龄范围为 0 周岁至 60 周岁（含），投保时被保险人为 0 周岁的，应为', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'guaranteed_renewal', 1, 0, 4, '本合同的保险期间最长不超过 1 年，不保证续保。保险期间在保险单上载明。', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 7, '1.因下列情形之一导致被保险人支出医疗费用的，我们不承担赔付保险金的责任:(1)投保人对被保险人的故意杀害、故意伤害；(', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 7, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 7, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>24</sup>，斗', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 7, '(4)被保险人醉酒<sup>24</sup>，斗殴<sup>25</sup>，服用、吸食或注射毒品<sup>26</su', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T09', 'exclusions', 5, '被保险人酒后驾驶，无合法有效驾驶证驾驶，或驾驶无合法有效行驶证', 8, '(5)被保险人酒后驾驶<sup>27</sup>，无合法有效驾驶证驾驶<sup>28</sup>，或驾驶无合法有效行驶证', 'mineru', 0.45)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'entry_age', 1, 'min=0,max=60', 2, '本合同接受的首次投保<sup>3</sup>年龄范围为 0 周岁至 60 周岁（含），投保时被保险人为 0 周岁的，应为', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'payment_term', 1, '趸交/分期', 10, '本合同的保险费及支付方式由您在投保时与我们约定，并在保险单上载明。您应当按照本合同约定向我们支付保险费。如您选择一次性支', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'coverage_term', 1, '1年', 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'guaranteed_renewal', 1, 0, 3, '本合同的保险期间为 1 年，不保证续保。保险期间在保险单上载明。保险期间届满，您需要重新向我们申请投保本产品，并经我们同', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'exclusions', 1, '投保人对被保险人的故意杀害、故意伤害', 6, '## 任:(1)投保人对被保险人的故意杀害、故意伤害；(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'exclusions', 2, '被保险人故意犯罪或者抗拒依法采取的刑事强制措施', 6, '(2)被保险人故意犯罪或者抗拒依法采取的刑事强制措施；(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'exclusions', 3, '被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外', 6, '(3)被保险人故意自伤或自杀，但被保险人自杀时为无民事行为能力人的除外；(4)被保险人醉酒<sup>24</sup>，斗', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);
INSERT INTO product_field_quote (external_id, field_name, ref_seq, field_value, page_no, quote_text, parser, confidence) VALUES ('T10', 'exclusions', 4, '被保险人醉酒，斗殴，服用、吸食或注射毒品', 6, '(4)被保险人醉酒<sup>24</sup>，斗殴<sup>25</sup>，服用、吸食或注射毒品<sup>26</su', 'mineru', 0.84)
ON DUPLICATE KEY UPDATE field_value=VALUES(field_value), page_no=VALUES(page_no),
  quote_text=VALUES(quote_text), parser=VALUES(parser), confidence=VALUES(confidence);

-- 回填 product_id，便于按产品查询引用
UPDATE product_field_quote q JOIN product p ON p.external_id=q.external_id
SET q.product_id=p.id WHERE q.product_id IS NULL;
