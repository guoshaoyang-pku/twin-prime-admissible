import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 126 的可容许 50 元组 -/
def cert_50_126 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
