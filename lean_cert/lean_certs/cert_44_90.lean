import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 90 的可容许 44 元组 -/
def cert_44_90 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
