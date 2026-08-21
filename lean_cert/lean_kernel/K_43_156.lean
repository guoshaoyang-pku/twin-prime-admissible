import Sound
import lean_certs.cert_43_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_156_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 43) (d := 156) (c := cert_43_156) (by decide)
