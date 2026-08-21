import Sound
import lean_certs.cert_43_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_138_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 43) (d := 138) (c := cert_43_138) (by decide)
