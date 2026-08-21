import Sound
import lean_certs.cert_43_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_158_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 43) (d := 158) (c := cert_43_158) (by decide)
