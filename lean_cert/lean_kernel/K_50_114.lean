import Sound
import lean_certs.cert_50_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_114_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 50) (d := 114) (c := cert_50_114) (by decide)
