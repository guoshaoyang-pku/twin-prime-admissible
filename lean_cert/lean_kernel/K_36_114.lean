import Sound
import lean_certs.cert_36_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_114_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 36) (d := 114) (c := cert_36_114) (by decide)
