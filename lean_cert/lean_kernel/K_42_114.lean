import Sound
import lean_certs.cert_42_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_114_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 42) (d := 114) (c := cert_42_114) (by decide)
