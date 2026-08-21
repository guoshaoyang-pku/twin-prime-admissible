import Sound
import lean_certs.cert_45_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_114_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 45) (d := 114) (c := cert_45_114) (by decide)
