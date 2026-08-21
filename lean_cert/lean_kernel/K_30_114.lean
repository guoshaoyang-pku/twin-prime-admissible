import Sound
import lean_certs.cert_30_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_114_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 30) (d := 114) (c := cert_30_114) (by decide)
