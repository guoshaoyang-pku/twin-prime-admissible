import Sound
import lean_certs.cert_38_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_138_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 38) (d := 138) (c := cert_38_138) (by decide)
