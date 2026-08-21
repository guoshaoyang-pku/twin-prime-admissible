import Sound
import lean_certs.cert_42_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_142_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 42) (d := 142) (c := cert_42_142) (by decide)
