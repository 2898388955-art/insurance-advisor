from app.services.compliance_service import DISCLAIMER, ComplianceService


def test_banned_phrase_replaced():
    answer, warnings = ComplianceService().check("这款产品稳赚不赔，一定赔。")
    assert "稳赚不赔" not in answer
    assert warnings
    assert DISCLAIMER in answer


def test_disclaimer_appended_once():
    svc = ComplianceService()
    once, _ = svc.check("等待期为 30 天。")
    twice, _ = svc.check(once)
    assert twice.count(DISCLAIMER) == 1


def test_normal_answer_kept():
    answer, warnings = ComplianceService().check("等待期为 30 天。")
    assert answer.startswith("等待期为 30 天。")
    assert warnings == []
