-- 开发用种子数据（幂等，可重复执行）
SET NAMES utf8mb4;

INSERT INTO category (id, parent_id, code, name, level, sort) VALUES
 (1,  0, 'ACCIDENT', '意外险', 1, 10),
 (11, 1, 'ACCIDENT_GENERAL', '综合意外', 2, 11),
 (12, 1, 'ACCIDENT_TRAFFIC', '交通意外', 2, 12),

 (2,  0, 'MEDICAL', '医疗险', 1, 20),
 (21, 2, 'MEDICAL_MILLION', '百万医疗', 2, 21),
 (22, 2, 'MEDICAL_OUTPATIENT', '门急诊医疗', 2, 22),
 (23, 2, 'MEDICAL_SMALL', '小额医疗', 2, 23),

 (3,  0, 'CRITICAL', '重疾险', 1, 30),
 (31, 3, 'CRITICAL_TERM', '定期重疾', 2, 31),
 (32, 3, 'CRITICAL_LIFE', '终身重疾', 2, 32),

 (4,  0, 'LIFE', '寿险', 1, 40),
 (41, 4, 'LIFE_TERM', '定期寿险', 2, 41),
 (42, 4, 'LIFE_WHOLE', '终身寿险', 2, 42),

 (5,  0, 'ANNUITY', '年金/储蓄', 1, 50),
 (51, 5, 'ANNUITY_EDU', '教育金', 2, 51),
 (52, 5, 'ANNUITY_PENSION', '养老金', 2, 52),

 (6,  0, 'TRAVEL', '旅行险', 1, 60),
 (61, 6, 'TRAVEL_DOMESTIC', '境内旅行', 2, 61),
 (62, 6, 'TRAVEL_ABROAD', '境外旅行', 2, 62),

 (7,  0, 'PROPERTY', '家财险', 1, 70),
 (71, 7, 'PROPERTY_HOME', '家财综合', 2, 71)
ON DUPLICATE KEY UPDATE name = VALUES(name), parent_id = VALUES(parent_id),
                        level = VALUES(level), sort = VALUES(sort);

INSERT INTO product
 (id, category_id, name, company, code, min_age, max_age,
  period_desc, waiting_days, guaranteed_renewal, highlights, status)
VALUES
 (1, 22, '太保互联网个人门急诊 D 款医疗保险', '太平洋健康保险股份有限公司',
  'TPY-MED-D-2025', 0, 65, '1年', 30, 0,
  '门急诊医疗；保额3万；限5次；次免赔额500元；第1-3次赔付100%，第4-5次赔付50%', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), company = VALUES(company),
                        category_id = VALUES(category_id), highlights = VALUES(highlights);

INSERT INTO product_clause
 (id, product_id, doc_id, version, file_path, file_hash, page_count, status)
VALUES
 (1, 1, '4ef195533eb264f1', 'v1', 'data/raw/86803.pdf',
  '4ef195533eb264f1758e62fa44d9400e6c88abb3a0c354a4c8f430ca638019fe', 11, 'PENDING')
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id),
                        file_path = VALUES(file_path),
                        file_hash = VALUES(file_hash),
                        page_count = VALUES(page_count);
