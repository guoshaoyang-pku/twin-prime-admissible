import Sound
import lean_certs.cert_49_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_114_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 49) (d := 114) (c := cert_49_114) (by decide)
