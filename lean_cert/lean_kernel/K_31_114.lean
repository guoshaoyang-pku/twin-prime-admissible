import Sound
import lean_certs.cert_31_114

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_114_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 31) (d := 114) (c := cert_31_114) (by decide)
