import Sound
import lean_certs.cert_43_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_116_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 43) (d := 116) (c := cert_43_116) (by decide)
