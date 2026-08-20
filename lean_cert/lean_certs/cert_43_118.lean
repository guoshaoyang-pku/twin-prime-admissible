import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 118 的可容许 43 元组 -/
def cert_43_118 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
