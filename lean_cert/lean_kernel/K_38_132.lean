import Sound
import lean_certs.cert_38_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_132_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 38) (d := 132) (c := cert_38_132) (by decide)
