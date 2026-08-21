import Sound
import lean_certs.cert_40_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_114_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 40) (d := 114) (c := cert_40_114) (by decide)
