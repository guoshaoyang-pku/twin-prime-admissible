import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 106 的可容许 45 元组 -/
def cert_45_106 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
