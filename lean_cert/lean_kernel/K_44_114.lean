import Sound
import lean_certs.cert_44_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_114_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 44) (d := 114) (c := cert_44_114) (by decide)
