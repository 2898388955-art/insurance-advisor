-- 审核修正版：H05 min_age=0（出生满28天）、H06 min_age=18、T07 min_age=0（出生满30天）
-- field_updates.sql
-- 只覆盖校验通过且 confidence >= 0.5 的产品；按 external_id 幂等。
-- 注意：null 字段显式置 NULL，会清掉 seed 里的演示值，执行前请先备份。
-- 依赖：先执行 V4__field_extraction_trace.sql。
SET NAMES utf8mb4;

-- H01 | parser=mineru | confidence=0.9
UPDATE product SET
    min_age = 0,
    max_age = 72,
    period_desc = '终身',
    coverage_term = '终身',
    payment_term = '趸交',
    waiting_days = 180,
    guaranteed_renewal = NULL,
    verified_from = 'clause_pdf',
    field_confidence = 0.9,
    field_extracted_at = NOW()
WHERE external_id = 'H01';

-- H02 | parser=mineru | confidence=0.9
UPDATE product SET
    min_age = 0,
    max_age = 72,
    period_desc = '终身',
    coverage_term = '终身',
    payment_term = '趸交',
    waiting_days = 180,
    guaranteed_renewal = NULL,
    verified_from = 'clause_pdf',
    field_confidence = 0.9,
    field_extracted_at = NOW()
WHERE external_id = 'H02';

-- H03 | parser=mineru | confidence=0.9
UPDATE product SET
    min_age = 0,
    max_age = 65,
    period_desc = '终身',
    coverage_term = '终身',
    payment_term = '趸交',
    waiting_days = 180,
    guaranteed_renewal = NULL,
    verified_from = 'clause_pdf',
    field_confidence = 0.9,
    field_extracted_at = NOW()
WHERE external_id = 'H03';

-- H04 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 0,
    max_age = 65,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 90,
    guaranteed_renewal = 1,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'H04';

-- H05 | parser=pymupdf_fallback | confidence=0.78
UPDATE product SET
    min_age = 0,
    max_age = 65,
    period_desc = '10年',
    coverage_term = '10年',
    payment_term = NULL,
    waiting_days = 90,
    guaranteed_renewal = NULL,
    verified_from = 'clause_pdf',
    field_confidence = 0.78,
    field_extracted_at = NOW()
WHERE external_id = 'H05';

-- H06 | parser=pymupdf_fallback | confidence=0.78
UPDATE product SET
    min_age = 18,
    max_age = 55,
    period_desc = '5年',
    coverage_term = '5年',
    payment_term = NULL,
    waiting_days = 90,
    guaranteed_renewal = NULL,
    verified_from = 'clause_pdf',
    field_confidence = 0.78,
    field_extracted_at = NOW()
WHERE external_id = 'H06';

-- H07 | parser=pymupdf_fallback | confidence=0.87
UPDATE product SET
    min_age = 0,
    max_age = 70,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交',
    waiting_days = 90,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.87,
    field_extracted_at = NOW()
WHERE external_id = 'H07';

-- H08 | parser=pymupdf_fallback | confidence=0.87
UPDATE product SET
    min_age = 0,
    max_age = 70,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交',
    waiting_days = 90,
    guaranteed_renewal = 1,
    verified_from = 'clause_pdf',
    field_confidence = 0.87,
    field_extracted_at = NOW()
WHERE external_id = 'H08';

-- H09 | parser=pymupdf_fallback | confidence=0.87
UPDATE product SET
    min_age = 0,
    max_age = 70,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交',
    waiting_days = 90,
    guaranteed_renewal = 1,
    verified_from = 'clause_pdf',
    field_confidence = 0.87,
    field_extracted_at = NOW()
WHERE external_id = 'H09';

-- T01 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 0,
    max_age = 17,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 30,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T01';

-- T02 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 0,
    max_age = 17,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 90,
    guaranteed_renewal = 1,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T02';

-- T03 | parser=mineru | confidence=0.86
UPDATE product SET
    min_age = 0,
    max_age = 60,
    period_desc = NULL,
    coverage_term = NULL,
    payment_term = '趸交/分期',
    waiting_days = 30,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.86,
    field_extracted_at = NOW()
WHERE external_id = 'T03';

-- T04 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 16,
    max_age = 65,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 30,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T04';

-- T05 | parser=mineru | confidence=0.77
UPDATE product SET
    min_age = 18,
    max_age = 70,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = NULL,
    waiting_days = NULL,
    guaranteed_renewal = 1,
    verified_from = 'clause_pdf',
    field_confidence = 0.77,
    field_extracted_at = NOW()
WHERE external_id = 'T05';

-- T06 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 0,
    max_age = 65,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 30,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T06';

-- T07 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 0,
    max_age = 65,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 90,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T07';

-- T08 | parser=mineru | confidence=0.92
UPDATE product SET
    min_age = 18,
    max_age = 80,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = 30,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.92,
    field_extracted_at = NOW()
WHERE external_id = 'T08';

-- T10 | parser=mineru | confidence=0.84
UPDATE product SET
    min_age = 0,
    max_age = 60,
    period_desc = '1年',
    coverage_term = '1年',
    payment_term = '趸交/分期',
    waiting_days = NULL,
    guaranteed_renewal = 0,
    verified_from = 'clause_pdf',
    field_confidence = 0.84,
    field_extracted_at = NOW()
WHERE external_id = 'T10';
