import Sound
import lean_certs.cert_38_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_114_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 38) (d := 114) (c := cert_38_114) (by decide)
