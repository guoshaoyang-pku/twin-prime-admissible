import CertVerify

/-- UNSAT 证书: 不存在直径 ≤ 160 的可容许 45 元组 -/
def cert_45_160 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.branch 5 [1, 2, 3, 4] [CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf], CertVerify.Cert.branch 5 [1, 2, 3, 4] [CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf]]]
