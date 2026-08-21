import Sound
import lean_certs.cert_35_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_114_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 35) (d := 114) (c := cert_35_114) (by decide)
