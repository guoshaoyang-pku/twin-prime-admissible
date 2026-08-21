import Sound
import lean_certs.cert_42_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_132_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 42) (d := 132) (c := cert_42_132) (by decide)
