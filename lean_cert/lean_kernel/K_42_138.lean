import Sound
import lean_certs.cert_42_138

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_138_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 42) (d := 138) (c := cert_42_138) (by decide)
