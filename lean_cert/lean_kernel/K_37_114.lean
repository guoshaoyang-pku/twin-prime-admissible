import Sound
import lean_certs.cert_37_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_114_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 37) (d := 114) (c := cert_37_114) (by decide)
