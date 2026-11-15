from app.rag.fusion import weighted_rrf


def hit(i: int) -> dict:
    return {"id": i, "entity": {"heading_path": f"h{i}", "text": f"t{i}"}}


def test_dense_only_keeps_order():
    fused = weighted_rrf([hit(1), hit(2), hit(3)], [], limit=3)
    assert [x["id"] for x in fused] == [1, 2, 3]


def test_sparse_only_keeps_order():
    fused = weighted_rrf([], [hit(3), hit(2)], limit=2)
    assert [x["id"] for x in fused] == [3, 2]


def test_dense_weight_dominates():
    dense = [hit(1), hit(2)]
    sparse = [hit(3), hit(1)]
    fused = weighted_rrf(dense, sparse, k=60, dense_weight=0.9,
                         sparse_weight=0.1, limit=3)
    assert fused[0]["id"] == 1


def test_equal_weight_merges_two_lists():
    dense = [hit(1), hit(2)]
    sparse = [hit(2), hit(1)]
    fused = weighted_rrf(dense, sparse, dense_weight=0.5,
                         sparse_weight=0.5, limit=2)
    assert {x["id"] for x in fused} == {1, 2}


def test_limit_is_respected():
    fused = weighted_rrf([hit(i) for i in range(10)], [], limit=3)
    assert len(fused) == 3
