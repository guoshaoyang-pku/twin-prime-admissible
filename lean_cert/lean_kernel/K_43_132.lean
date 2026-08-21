import Sound
import lean_certs.cert_43_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_132_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 43) (d := 132) (c := cert_43_132) (by decide)
