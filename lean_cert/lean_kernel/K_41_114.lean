import Sound
import lean_certs.cert_41_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_114_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 41) (d := 114) (c := cert_41_114) (by decide)
