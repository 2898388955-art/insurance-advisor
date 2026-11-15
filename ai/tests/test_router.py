from app.agents.graph import InsuranceAgent


def test_route_compare():
    assert InsuranceAgent.route("这款和另一款哪个好") == "compare"
    assert InsuranceAgent.route("帮我比较一下区别") == "compare"


def test_route_advisor():
    assert InsuranceAgent.route("我 30 岁，有推荐吗") == "advisor"
    assert InsuranceAgent.route("预算 3000 买什么") == "advisor"


def test_route_chitchat():
    assert InsuranceAgent.route("你好") == "chitchat"


def test_route_defaults_to_rag():
    assert InsuranceAgent.route("等待期是多久") == "rag"
    assert InsuranceAgent.route("哪些情况不赔") == "rag"


def test_detect_occupation_low_risk():
    label, categories = InsuranceAgent.detect_occupation("我是程序员，30 岁")
    assert label == "低风险室内职业"
    assert categories == [2, 3]


def test_detect_occupation_high_risk():
    label, categories = InsuranceAgent.detect_occupation("我是货车司机")
    assert label == "高风险体力/外勤职业"
    assert categories == [1, 41]


def test_detect_occupation_unknown():
    label, categories = InsuranceAgent.detect_occupation("想了解一下")
    assert label is None
    assert categories == []
