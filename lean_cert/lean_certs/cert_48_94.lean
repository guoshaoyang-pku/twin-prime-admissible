import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 94 的可容许 48 元组 -/
def cert_48_94 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
