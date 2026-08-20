import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 120 的可容许 49 元组 -/
def cert_49_120 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
