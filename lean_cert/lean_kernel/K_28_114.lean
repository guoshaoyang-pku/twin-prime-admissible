import Sound
import lean_certs.cert_28_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_114_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 28) (d := 114) (c := cert_28_114) (by decide)
