import Sound
import lean_certs.cert_46_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_114_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 46) (d := 114) (c := cert_46_114) (by decide)
