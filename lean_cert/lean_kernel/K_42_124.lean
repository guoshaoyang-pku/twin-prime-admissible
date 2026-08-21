import Sound
import lean_certs.cert_42_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_124_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 42) (d := 124) (c := cert_42_124) (by decide)
