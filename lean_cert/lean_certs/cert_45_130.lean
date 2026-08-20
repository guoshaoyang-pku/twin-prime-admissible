import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 130 的可容许 45 元组 -/
def cert_45_130 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.leaf, CertVerify.Cert.leaf]]
