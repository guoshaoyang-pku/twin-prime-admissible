import Sound
import lean_certs.cert_33_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_132_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 33) (d := 132) (c := cert_33_132) (by decide)
