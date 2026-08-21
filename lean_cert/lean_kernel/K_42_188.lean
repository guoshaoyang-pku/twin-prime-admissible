import Sound
import lean_certs.cert_42_188

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H42_gt_188_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 42) (d := 188) (c := cert_42_188) (by decide)
