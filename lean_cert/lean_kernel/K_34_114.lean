import Sound
import lean_certs.cert_34_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_114_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 34) (d := 114) (c := cert_34_114) (by decide)
