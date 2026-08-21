import Sound
import lean_certs.cert_43_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_122_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 43) (d := 122) (c := cert_43_122) (by decide)
