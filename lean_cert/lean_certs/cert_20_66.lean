import CertVerify

def cert_20_66 : CertVerify.Cert := CertVerify.Cert.branch 2 [1] [CertVerify.Cert.branch 3 [1, 2] [CertVerify.Cert.branch 5 [1, 2, 3, 4] [CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf], CertVerify.Cert.branch 5 [1, 2, 3, 4] [CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf, CertVerify.Cert.leaf]]]
